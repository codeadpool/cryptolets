import random

from tessera.samples import get_rng, get_q, write_csvs
from reference.ec import ShortWeierstrass
from reference.coordinates import PointAffine, PointInfinity

# Must match the defaults in l3_msm_pe_types.h
WINDOW = 8
SCALAR_BITS = 255
NUM_WINDOWS = (SCALAR_BITS + WINDOW - 1) // WINDOW
NUM_CONTEXTS = 8
QDEPTH = 4
MAX_POINTS = 16  # every row is padded to this, so all rows have the same width


def digit(s, win):
    return (s >> (WINDOW * win)) & ((1 << WINDOW) - 1)


def xy(P):
    "Infinity is affine (0, 0), which is not on a curve with b != 0"
    return (0, 0) if P is PointInfinity else (P.x, P.y)


def generate(design, sweep_flags):
    """
    Each sample is one window sum: context, window, n, then x, y, s for up
    to 16 points. The golden is the sum of digit(s) * P over the points.
    """
    num_samples = sweep_flags.get("num_test_samples", 10)
    rng = get_rng()
    random.seed(rng.randint(0, 1 << 30)) # random_point draws from the random module

    q = get_q(design)
    field = design.structs[design.design["field"]]
    curve = ShortWeierstrass(q, int(field["a"]["val"], 16), int(field["b"]["val"], 16))

    def at(d, win):
        "A random scalar whose digit in window win is d"
        s = rng.getrandbits(SCALAR_BITS) & ~(((1 << WINDOW) - 1) << (WINDOW * win))
        return (s | (d << (WINDOW * win))) & ((1 << SCALAR_BITS) - 1)

    samples, goldens = [], []

    def add_sample(context, win, points, scalars):
        R = PointInfinity
        for P, s in zip(points, scalars):
            R = curve.add(R, curve.mul(digit(s, win), P))
        row = [context, win, len(points)]
        for i in range(MAX_POINTS):
            row.extend((*xy(points[i]), scalars[i]) if i < len(points) else (0, 0, 0))
        samples.append(row)
        goldens.append(xy(R))

    def ctx():
        "Edge cases rotate through the contexts"
        return len(samples) % NUM_CONTEXTS

    P = curve.random_point()
    neg_P = PointAffine(P.x, -P.y % q)
    pts = [curve.random_point() for _ in range(MAX_POINTS)]

    # No points, so the sum is infinity
    add_sample(ctx(), 5, [], [])
    # Every digit is zero, so no point is read
    add_sample(ctx(), 5, pts[:4], [at(0, 5) for _ in range(4)])
    # P + -P in one bucket gives infinity
    add_sample(ctx(), 9, [P, neg_P, pts[0]], [at(7, 9), at(7, 9), at(3, 9)])
    # P + P in one bucket is a doubling
    add_sample(ctx(), 9, [P, P], [at(200, 9), at(200, 9)])
    # Infinity inputs with nonzero digits
    add_sample(ctx(), 2, [PointInfinity, pts[1], PointInfinity], [at(1, 2), at(9, 2), at(255, 2)])
    # More points in one bucket than its queue holds
    add_sample(ctx(), 0, pts[:2 * QDEPTH + 1], [at(255, 0) for _ in range(2 * QDEPTH + 1)])
    # The top window is narrower than the others
    add_sample(ctx(), NUM_WINDOWS - 1, pts[:3], [(1 << SCALAR_BITS) - 1, at(1, NUM_WINDOWS - 1), 0])
    # Full and odd point counts
    add_sample(ctx(), 17, pts, [rng.getrandbits(SCALAR_BITS) for _ in pts])
    add_sample(ctx(), 17, pts[1:], [rng.getrandbits(SCALAR_BITS) for _ in pts[1:]])

    # Random fill
    while len(samples) < num_samples:
        n = rng.randint(1, MAX_POINTS)
        points = [curve.random_point() for _ in range(n)]
        scalars = [rng.getrandbits(SCALAR_BITS) for _ in range(n)]
        add_sample(rng.randrange(NUM_CONTEXTS), rng.randrange(NUM_WINDOWS), points, scalars)

    write_csvs(samples, goldens, design.build_dir)
