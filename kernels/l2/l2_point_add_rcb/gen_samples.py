import random

from tessera.samples import get_rng, get_q, get_rc, get_coef, write_csvs
from reference.ec import ShortWeierstrass
from reference.coordinates import PointInfinity


def projective(P, q):
    "A random scaling of P, so the formula cannot rely on Z = 1"
    Z = random.randrange(1, q)
    return (P.x * Z % q, P.y * Z % q, Z)


def generate(design, sweep_flags):
    num_samples = sweep_flags.get("num_test_samples", 10)
    rng = get_rng()
    random.seed(rng.randint(0, 1 << 30)) # random_point draws from the random module

    q = get_q(design)
    rc = get_rc(design)
    b3 = get_coef(design, "b3")
    affine_p1 = design.design["padd_rcb_form"] == "padd_rcb_alg8"

    field = design.structs[design.design["field"]]
    curve = ShortWeierstrass(q, int(field["a"]["val"], 16), int(field["b"]["val"], 16))

    samples, goldens = [], []
    for _ in range(num_samples):
        P = curve.random_point()
        # The same formula doubles, so equal pairs are tested too
        Q = P if rng.random() < 0.2 else curve.random_point()
        R = curve.add(P, Q)
        if R is PointInfinity:
            continue

        # alg8 reads P1 as affine, so its Z is 1. The goldens stay affine;
        # the testbench normalizes the output to compare.
        P1 = (Q.x, Q.y, 1) if affine_p1 else projective(Q, q)
        samples.append((*projective(P, q), *P1, q, rc, b3))
        goldens.append((R.x, R.y))

    write_csvs(samples, goldens, design.build_dir)
