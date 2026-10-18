import random

from tessera.samples import get_rng, get_q, get_rc, get_coef, write_csvs
from reference.ec import TwistedEdwards
from reference.coordinates import PointInfinity, affine_to_extended_projective


def generate(design, sweep_flags):
    num_samples = sweep_flags.get("num_test_samples", 10)
    rng = get_rng()
    random.seed(rng.randint(0, 1 << 30)) # random_point draws from the random module

    q = get_q(design)
    rc = get_rc(design)
    coefs = [get_coef(design, name) for name in ("a", "d", "k")]

    field = design.structs[design.design["field"]]
    curve = TwistedEdwards(q, int(field["a"]["val"], 16), int(field["d"]["val"], 16))

    samples, goldens = [], []
    for _ in range(num_samples):
        P, Q = curve.random_point(), curve.random_point()
        R = curve.add(P, Q)
        if R is PointInfinity:
            continue

        # The goldens stay affine; the testbench normalizes the output to compare.
        P0 = affine_to_extended_projective(P, q)
        P1 = affine_to_extended_projective(Q, q)
        samples.append((*P0.as_tuple(), *P1.as_tuple(), q, rc, *coefs))
        goldens.append((R.x, R.y))

    write_csvs(samples, goldens, design.build_dir)
