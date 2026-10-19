"""
Expand a sweep config into concrete designs.

A sweep is the cartesian product of its parameters, then:
  - derivations rewrite a design when one parameter decides another
  - filters drop designs that are invalid or duplicate another design

Add a rule by writing a function and listing it in DERIVATIONS or FILTERS.
"""
import json
import logging
from itertools import product

from tessera.models.common import load_curves
from tessera.structs.field import get_field
from tessera.models.design import Design
from tessera.const import ARB_FIELD


# --- derivations: (design) -> None, edited in place ---

def derive_field_width(design):
    """
    A named field fixes the bitwidth to its own. An arb_field follows the
    bitwidth, and carries it in its name so a child of the design, whose
    own bitwidth may differ, still names the same prime.
    """
    field = design.get("field")
    if not field:
        return
    if field == ARB_FIELD:
        design["field"] = f"{ARB_FIELD}_{design['bitwidth']}"
    else:
        design["bitwidth"] = load_curves()[field]["bitwidth"]


def drop_default_deps(design):
    "No port share is the default, so naming it must not make a new design"
    # With a dep_io_ratio, io_delay 0 turns the share off, so it is not a no-op
    if design.get("dep_io_ratio"):
        return
    for key in [k for k in design if k.startswith("deps.") and k.endswith(".io_delay")]:
        if not design[key]:
            del design[key]


DERIVATIONS = [derive_field_width, drop_default_deps]

# --- filters: (design) -> reason to skip, or None to keep ---

def filter_arb_field_fixed_q(design):
    """
    An arb_field prime is random, so we only use it to test
    variable parameters, and no point in fixing it.
    """
    if design.get("field", "").startswith(ARB_FIELD) and design.get("q_type") == "fixed_q":
        return "arb_field has no meaningful fixed modulus"
    return None


def filter_arb_field_fixed_rc(design):
    "The reduction constant follows from the random prime, so fixing it tests nothing more"
    if design.get("field", "").startswith(ARB_FIELD) and design.get("rc_type") == "fixed_rc":
        return "arb_field has no meaningful fixed reduction constant"
    return None


def filter_arb_field_fixed_coef(design):
    "arb_field's curve coefficients are placeholders, so baking them in describes no curve"
    if (design.get("field", "").startswith(ARB_FIELD) and "padd_te_form" in design
            and design.get("coef_type") != "var_coef"):
        return "arb_field has no meaningful fixed curve coefficients; use var_coef"
    return None


def filter_cyclone_field(design):
    "The CycloneMSM formula is written for one curve, BLS12-377 in TE form"
    if design.get("padd_te_form") == "padd_te_cyclone" and design.get("field") != "bls12_377_on_te_base":
        return "padd_te_cyclone is for bls12_377_on_te only"
    return None


def filter_point_scalar_field(design):
    "Only a curve's base field carries the coefficients a point formula needs"
    point = "pdbl_form" in design or "padd_te_form" in design
    if point and design.get("field", "").endswith("_scalar"):
        return "point kernels need the curve's base field"
    return None


def filter_pdbl_form(design):
    """
    A doubling formula for one a computes the wrong point on any other curve.
    pdbl_avar multiplies by a, which Catapult cannot build for a = 0, so it
    only runs where a has no dedicated formula.
    """
    form, field = design.get("pdbl_form"), design.get("field")
    if form is None or not field or field.endswith("_scalar"):
        return None
    f = get_field(field)
    q, a = int(f["q"]["val"], 16), int(f["a"]["val"], 16)
    dedicated = {"pdbl_a0": 0, "pdbl_a2": 2, "pdbl_a3": q - 3}
    if form == "pdbl_avar":
        if a in dedicated.values():
            return "pdbl_avar is for curves without a dedicated formula; use pdbl_a0/a2/a3"
        return None
    if a != dedicated[form]:
        return f"{form} does not match the curve's a"
    return None


def filter_var_coef(design):
    "Only the TE add formulas read a curve coefficient, so var_coef means nothing elsewhere"
    if design.get("coef_type") == "var_coef" and "padd_te_form" not in design:
        return "var_coef is only for the TE add, whose formulas read a coefficient"
    return None


def _reads_fixed_coef(design):
    "A curve constant baked into the hardware ties it to its field"
    if "cmul_const" in design:
        return True
    # pdbl_avar always multiplies by the field's a as a constant
    if design.get("pdbl_form") == "pdbl_avar":
        return True
    return "padd_te_form" in design and design.get("coef_type") != "var_coef"


def filter_generic_named_field(design):
    """
    With q and rc as ports and no curve constant baked in, a named field
    builds the same hardware as an arb_field of its width. Kept when that
    arb_field design is itself invalid, e.g. pdbl_a2 on arb_field's a = 0,
    since then nothing else covers it.
    """
    field = design.get("field")
    if not field or field.startswith(ARB_FIELD):
        return None
    if design.get("q_type") != "var_q" or design.get("rc_type") != "var_rc":
        return None
    if _reads_fixed_coef(design):
        return None
    twin = dict(design, field=f"{ARB_FIELD}_{design['bitwidth']}")
    if any(f(twin) for f in FILTERS if f is not filter_generic_named_field):
        return None
    return "named field with var_q and var_rc is generic; the arb_field design of its width covers it"


FILTERS = [filter_arb_field_fixed_q, filter_arb_field_fixed_rc, filter_arb_field_fixed_coef,
           filter_cyclone_field,
           filter_point_scalar_field, filter_pdbl_form, filter_var_coef,
           filter_generic_named_field]

# Params keyed by n rather than swept directly
WIDTH_MAPS = ("base_mul_width", "kar_base_mul_width")

def _apply_width_maps(sweep, design):
    "Expand the n-keyed width maps into one design per combination."
    n = design["bitwidth"]
    lists = [(sweep.get(name) or {}).get(n, [None]) for name in WIDTH_MAPS]

    for values in product(*lists):
        out = dict(design)
        for name, value in zip(WIDTH_MAPS, values):
            if value is not None:
                out[name] = value

        # A multiplier that never splits down to a width does not sweep it, so
        # pinning it to the full width collapses those designs onto one
        mul_type = out.get("mul_type")
        if mul_type in ("mul_nor", "mul_sb") and "kar_base_mul_width" in out:
            out["kar_base_mul_width"] = n
        if mul_type == "mul_nor" and "base_mul_width" in out:
            out["base_mul_width"] = n

        # Karatsuba recurses down to its base width, then schoolbook takes over
        # and recurses to its own. Stopping karatsuba below that does nothing.
        kar, base = out.get("kar_base_mul_width"), out.get("base_mul_width")
        if kar is not None and base is not None and kar < base:
            continue

        yield out


def flatten_sweep(sweeps, path, reuse=False):
    """
    Expand the sweeps of a sweep config into a list of designs
    """

    # Reuse an existing flattened sweep stored in json file
    if reuse:
        if not path.exists():
            raise Exception(f"No stored sweep at {path}. "
                            f"Run from the first stage to create it.")
        stored = json.loads(path.read_text())["sweep"]
        return [Design(d) for d in stored]

    designs, seen, skipped = [], set(), {}
    # A sweep file gives one sweep per variant; each is crossed on its own
    for sweep in sweeps:
        # Each per-kernel setting is one more axis, as <block>.<kernel>.<setting>
        sweep = dict(sweep)
        for block in ("deps", "catapult"):
            for kernel, settings in (sweep.pop(block, None) or {}).items():
                for name, values in settings.items():
                    sweep[f"{block}.{kernel}.{name}"] = values

        # A parameter the sweep leaves out is not part of any design, so a kernel
        # that has no use for it carries nothing for it either
        keys = [k for k in sweep if k not in WIDTH_MAPS and sweep[k] is not None]

        for combo in product(*(sweep[k] for k in keys)):
            design = dict(zip(keys, combo))

            for derive in DERIVATIONS:
                derive(design)

            reason = next((r for f in FILTERS if (r := f(design))), None)
            if reason:
                skipped[reason] = skipped.get(reason, 0) + 1
                continue

            for out in _apply_width_maps(sweep, design):
                # Derivations, and two variants, can give the same design twice
                key = tuple(sorted(out.items()))
                if key not in seen:
                    seen.add(key)
                    designs.append(Design(out))

    for reason, count in skipped.items():
        logging.warning(f"Skipped {count} design(s): {reason}")

    path.write_text(json.dumps({"sweep": [d.design for d in designs]}, indent=2))
    return designs


def unflatten_sweep(flattened_sweep):
    sweep_config = {}
    for design in flattened_sweep:
        for k, v in design.items():
            sweep_config.setdefault(k, [])
            if v not in sweep_config[k]:
                sweep_config[k].append(v)
    return sweep_config
