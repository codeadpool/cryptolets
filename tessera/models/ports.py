"""
A run parameter is a port, unless the design fixes it: then its value is
baked into the hardware, read from the field struct.
"""


# One coef_type sets all curve coefficients. A formula that does not read one
# leaves that port unconnected.
COEF_PORTS = ("a", "d", "k", "b3")


def is_fixed(port, design):
    if port in COEF_PORTS:
        return design.get("coef_type") != "var_coef"
    return design.get(f"{port}_type") == f"fixed_{port}"


# What a fixed port bakes in, per reduction. A multiplier operand is in the
# Montgomery domain when the reduction is; q is only compared, so it is not.
FIXED_VALUE = {
    "q":  {"mred_mont": "q",       "mred_bar": "q"},
    "rc": {"mred_mont": "q_prime", "mred_bar": "mu"},
    "a":  {"mred_mont": "a_mont",  "mred_bar": "a"},
    "d":  {"mred_mont": "d_mont",  "mred_bar": "d"},
    "k":  {"mred_mont": "k_mont",  "mred_bar": "k"},
    "b3": {"mred_mont": "b3_mont", "mred_bar": "b3"},
}


def fixed_member(port, design):
    "The field member a fixed port reads"
    return FIXED_VALUE[port][design["mred"]]
