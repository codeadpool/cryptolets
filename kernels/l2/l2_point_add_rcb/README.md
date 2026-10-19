# `l2_point_add_rcb` - Point Addition (Short Weierstrass, Complete)

## Description
Addition of two points on a short Weierstrass curve with $a = 0$, $y^2 = x^3 + b$. bn254 and bls12-381 are curves of this type. The kernel uses the complete formulas of Renes, Costello and Batina [1]. The same formula adds two points and doubles a point, so the hardware has no doubling branch.

The points are in homogeneous projective coordinates $(X : Y : Z)$, which represent the affine point $(X/Z, Y/Z)$. `padd_rcb_form` selects one of two formulas from the paper.

| port | direction | width |
|------|-----------|-------|
| `P0` | in        | `PointProj`, three `FIELD::W` coordinates |
| `P1` | in        | `PointProj`, three `FIELD::W` coordinates. `padd_rcb_alg8` reads only `X` and `Y` |
| `q`  | in        | `FIELD::W`, only with `var_q` |
| `rc` | in        | `FIELD::W`, only with `var_rc` |
| `b3` | in        | `FIELD::W`, only with `var_coef` |
| `R`  | out       | `PointProj`, three `FIELD::W` coordinates |

Sweep design parameters:

- `bitwidth` — the width of the field elements. The `field` sets it
- `field` — the curve's base field, for example `bn254_base`. The sweep skips curves with $a \neq 0$
- `padd_rcb_form` — the addition formula: `padd_rcb_alg7` or `padd_rcb_alg8`
- `mred` — the reduction algorithm: `mred_mont` or `mred_bar`
- `q_type` — `fixed_q` or `var_q`
- `rc_type` — `fixed_rc` or `var_rc`
- `coef_type` — `fixed_coef` bakes $b_3 = 3b$ into the hardware as a constant multiplication. `var_coef` takes $b_3$ as a port and multiplies with a modmul, so one design can serve other $a = 0$ curves of the same width. Without `coef_type`, $b_3$ is fixed
- `mul_type` — the multiplier structure: `mul_nor`, `mul_sb` or `mul_kar`
- `base_mul_width` — the operand width at which the recursion stops and a native multiplier is used
- `kar_base_mul_width` — the operand width at which Karatsuba switches to schoolbook
- `period` — the target clock period, in ns
- `tech_type` — the target technology node or FPGA part
- `ii` — the initiation interval, the number of cycles between two accepted inputs
- `dep_period_ratio` — the clock period of a blackboxed child, as a ratio of `period`
- `dep_io_ratio` — the share of a blackboxed child's period kept for the parent's logic at each port

### Projective addition

`padd_rcb_alg7` is Algorithm 7 of the paper. It adds two projective points with 12 modmuls, 2 multiplications by $b_3$ and 19 additions. In an MSM, this form fits the stages that add two partial sums, for example the bucket reduction and the window combination.

### Mixed addition

`padd_rcb_alg8` is Algorithm 8 of the paper. The second point is affine, so its $Z$ is 1 and the formula needs one modmul less: 11 modmuls, 2 multiplications by $b_3$ and 13 additions. In an MSM, this form fits the bucket accumulation, which adds affine input points to the buckets.

Both formulas have the same depth: the longest chain has 2 modmuls and 1 multiplication by $b_3$.

## Dependencies

- `l0_int_add` with parameters `bitwidth = FIELD::W` and `FIELD::W + 1` — through `l1_mod_add` and `l1_mod_sub`
- `l0_int_sub` with parameters `bitwidth = FIELD::W` and `FIELD::W + 1` — through `l1_mod_add` and `l1_mod_sub`
- `l0_int_mul` with parameters `bitwidth = FIELD::W` — through `l1_mod_mul` and `l1_mod_cmul`
- `l0_int_cmul` with parameters `bitwidth = FIELD::W` — through `l1_mod_mul` and `l1_mod_cmul`
- `l1_mod_add` with parameters `field` — the sums
- `l1_mod_sub` with parameters `field` — the differences
- `l1_mod_mul` with parameters `field`, `mred` — every product of two variables, and the products by $b_3$ with `var_coef`
- `l1_mod_cmul` with parameters `field`, `mred`, `cmul_const = b3` — the products by $b_3$ with `fixed_coef`

## Test Sample Generation Strategy

Every sample is a pair of points that lie on the curve. The reference library generates each point from a random $x$ in $\mathbb{F}_q$ and solves the curve equation for $y$. The same formula doubles a point, so about 20% of the samples are a point plus itself. Pairs whose sum is the point at infinity are skipped.

Each projective input has its own random $Z$, so the kernel cannot rely on $Z = 1$. For `padd_rcb_alg8`, `P1` stays affine. The golden output is the affine sum, which the reference library computes with the group law. The testbench converts the result to affine to compare it. For Montgomery designs, the testbench converts each coordinate into and out of the Montgomery domain.

## HLS RTL Generation and Simulation

Verifies the C++, generates the RTL with HLS, then verifies the RTL with the same testbench.

```
python -m tessera run l2_point_add_rcb -s sweeps/l2_point_add_rcb.yaml --to rtl
```

## Running Logic Synthesis

Synthesizes the generated RTL to a gate netlist and reports its area, delay and power estimate.

```
python -m tessera run l2_point_add_rcb -s sweeps/l2_point_add_rcb.yaml --only syn
```

## Authors

Gaurav Kuwar

## References

[1] Joost Renes, Craig Costello, and Lejla Batina. 2016. Complete addition formulas for prime order elliptic curves. Cryptology ePrint Archive, Paper 2015/1060. https://eprint.iacr.org/2015/1060
