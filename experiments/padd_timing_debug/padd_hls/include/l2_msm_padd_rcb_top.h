#ifndef _L2_MSM_PADD_RCB_TOP_H_
#define _L2_MSM_PADD_RCB_TOP_H_

#include <ac_int.h>
#include <mc_scverify.h>
#include "l2_msm_padd_rcb_impl.h"

class l2_msm_padd_rcb {
    l2_msm_padd_rcb_impl<FIELD, MRED> inst;

public:
    l2_msm_padd_rcb() {}

    #pragma hls_design interface top
    void CCS_BLOCK(l2_msm_padd_rcb, run)(
        const ac_int<FIELD::W,false> P0_X,
        const ac_int<FIELD::W,false> P0_Y,
        const ac_int<FIELD::W,false> P0_Z,
        const ac_int<FIELD::W,false> P1_X,
        const ac_int<FIELD::W,false> P1_Y,
        const ac_int<FIELD::W,false> P1_Z,
        ac_int<FIELD::W,false> &R_X,
        ac_int<FIELD::W,false> &R_Y,
        ac_int<FIELD::W,false> &R_Z
    ) {
        inst.run(P0_X, P0_Y, P0_Z, P1_X, P1_Y, P1_Z, FIELD::Q::VALUE(), FIELD::Q_PRIME::VALUE(), R_X, R_Y, R_Z);
    }
};

// The RTL module takes the class name, 
// so the top is named after the kernel in both flows. 
// But, the testbench always instantiates the _top name,
// so we typedef the kernel with the _top suffix.
typedef l2_msm_padd_rcb l2_msm_padd_rcb_top;

#endif /* _L2_MSM_PADD_RCB_TOP_H_ */
