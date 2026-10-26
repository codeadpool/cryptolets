#ifndef _L1_MOD_MUL_BLACKBOX_H_
#define _L1_MOD_MUL_BLACKBOX_H_

#if defined(__SYNTHESIS__) && defined(BLACKBOX_FLOW)

#include <ac_int.h>
#include <ac_blackbox.h>
#include "params.h"

// The implementation itself, which a design that was not packaged still uses
#include "/home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l1/l1_mod_mul/impl/l1_mod_mul_impl.h"

// One packaged design, standing in for the implementation at these arguments
template<>
class l1_mod_mul_impl<BLS12_381_BASE, MRED_MONT> {
    // The template params under their own names, so run is copied as written
    using _FIELD = BLS12_381_BASE;
    static constexpr int _MRED = MRED_MONT;

public:
    l1_mod_mul_impl() {}

    // A constant the design bakes in is not a port, so it stops here
    void run(
        const ac_int<_FIELD::W, false> x,
        const ac_int<_FIELD::W, false> y,
        const ac_int<_FIELD::W, false> q,
        const ac_int<l1_mod_mul_consts<_FIELD, _MRED>::RC, false> rc,
        ac_int<_FIELD::W, false> &z
    ) {
        rtl(x, y, z);
    }

    // The packaged RTL, with the ports it was built with
    #pragma hls_design interface ccore blackbox
    void rtl(
        const ac_int<_FIELD::W, false> x,
        const ac_int<_FIELD::W, false> y,
        ac_int<_FIELD::W, false> &z
    ) {
        ac_blackbox()
            .entity("l1_mod_mul_d7267ca0d90c7363_regin")
            .verilog_files("/home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/blackbox/rtl/l1_mod_mul_d7267ca0d90c7363.v")
            .outputs("z")
            .area(289451.1340772)
            .input_delay(0.03).delay(0.75).min_clock_period(1.0)
            .clock_name("clk").latency(6).init_delay(1)
            .sync_reset_name("rst").active_high_sync_reset(true)
            .end();
    }
};
#else
#include "/home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l1/l1_mod_mul/impl/l1_mod_mul_impl.h"
#endif

#endif /* _L1_MOD_MUL_BLACKBOX_H_ */
