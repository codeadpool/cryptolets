# `l3_msm_pe` - MSM Processing Element

## Description

One processing element (PE) of a multi-scalar multiplication (MSM), Q = s_1 P_1 + ... + s_n P_n, with the Pippenger bucket method [1]. The PE finds one window sum. For each point, it reads the digit of the scalar in the window and adds the point to the bucket of that digit. Then it reduces the buckets to the window sum with a running sum.

The PE has one pipelined point adder, `l2_point_add_rcb`. Each bucket has a queue of point addresses. A scheduler sends the longest queue whose bucket is not busy to the adder. As a result, the adder can accept a new addition each cycle.

The PE is a SystemC module with Connections channels, not a `run()` function. The scalars, the input points and the bucket memory are outside the PE. The PE reads them through ports.


| port       | direction | width                                                   |
| ---------- | --------- | ------------------------------------------------------- |
| `cmd_in`   | in        | `RoundCmd`: point count, window, context, clear, reduce |
| `done_out` | out       | `ScPoint`: the window sum, three `FIELD::W` coordinates |
| `sreq`     | out       | `ScalarReq`: the address of a scalar pair               |
| `sresp`    | in        | `ScalarResp`: two scalars of `MSM_SCALAR_BITS`          |
| `preq`     | out       | `PointReq`: a point address and a bucket tag            |
| `presp`    | in        | `PointResp`: affine x and y of `FIELD::W`, and the tag  |


Synthesis exports the bucket memories `br_x`, `br_y` and `br_z` as synchronous 1R1W ports. Each memory has `GROUPS * BRAM_SIZE` words of `FIELD::W` bits.

A command does one of three things:

- Accumulate: add `n` points into the buckets of a context. With `clear`, the PE clears the context first.
- Accumulate again: a second command without `clear` adds the next tile of points to the same buckets.
- Reduce: add up the buckets of a context and send the window sum to `done_out`.

Sweep design parameters:

- `bitwidth` — the width of the field elements. The `field` sets it
- `field` — the curve base field. Only `bls12_381_base` is tested
- `padd_rcb_form` — must be `padd_rcb_alg7`, because the buckets hold projective points
- `coef_type` — must be `fixed_coef`
- `mred` — must be `mred_mont`
- `q_type` — must be `fixed_q`
- `rc_type` — must be `fixed_rc`
- `mul_type`, `base_mul_width`, `kar_base_mul_width` — the multiplier structure of the point adder
- `period` — the target clock period, in ns
- `tech_type` — the target technology node or FPGA part
- `ii` — the initiation interval of the point adder
- `dep_period_ratio` — the clock period of a blackboxed child, as a ratio of `period`

The MSM geometry is set with macros in `l3_msm_pe_types.h`, not with sweep parameters:

- `MSM_WINDOW` — the window width W. A window has 2^W - 1 buckets. The default is 8
- `MSM_SCALAR_BITS` — the scalar width. The default is 255
- `MSM_NUM_PES` — the number of PEs in the full system. It sets the number of contexts. The default is 4, which gives 8 contexts
- `MSM_QDEPTH` — the depth of each bucket queue. The default is 4
- `MSM_PENDING_DEPTH` — the depth of the queue for the point fetches. The default is 8



## Dependencies

- `l2_point_add_rcb` with parameters `field`, `mred`, `padd_rcb_form = padd_rcb_alg7`, `coef_type = fixed_coef` — every bucket addition and every step of the reduction



## Test Sample Generation Strategy

Each sample is one window sum. A row has the context, the window, the point count `n`, and then x, y and the scalar for up to 16 points. The rows have the same width, so short rows are padded with zeros.

The testbench does three commands for each row: accumulate the first half of the points with `clear`, accumulate the second half, then reduce. Each row clears its context, so the rows are independent. The testbench also stands in for the scalar and point memories, with a latency and stalls on each. It makes sure that the PE reads each scalar pair once, and only the points with a nonzero digit.

The first samples are edge cases:

- No points, and points with all digits zero
- P and -P in one bucket, and P and P in one bucket
- Infinity inputs, as affine (0, 0)
- 9 points in one bucket, more than its queue holds
- The top window, which is narrower than the others
- 16 points and 15 points

Random samples fill the rest, with random points, scalars, contexts and windows. The golden output is the affine window sum. The reference library computes it with the group law. For the Montgomery domain, the testbench converts each input into it and the output out of it.

## HLS RTL Generation and Simulation

Verifies the C++, generates the RTL with HLS, then verifies the RTL with the same testbench.

```
python -m tessera run l3_msm_pe -s sweeps/l3_msm_pe.yaml --to rtl
```



## Running Logic Synthesis

Synthesizes the generated RTL to a gate netlist and reports its area, delay and power estimate. The bucket memories are outside the netlist.

```
python -m tessera run l3_msm_pe -s sweeps/l3_msm_pe.yaml --only syn
```



## Authors

## References

[1] Nicholas Pippenger. 1976. On the evaluation of powers and related problems. In 17th Annual Symposium on Foundations of Computer Science (SFCS 1976). IEEE, 258-263. [https://doi.org/10.1109/SFCS.1976.21](https://doi.org/10.1109/SFCS.1976.21)