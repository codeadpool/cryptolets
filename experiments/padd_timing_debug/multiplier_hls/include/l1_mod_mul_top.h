#ifndef _L1_MOD_MUL_TOP_H_
#define _L1_MOD_MUL_TOP_H_

#include <ac_int.h>
#include <mc_scverify.h>
#include "l1_mod_mul_impl.h"

class l1_mod_mul {
    l1_mod_mul_impl<FIELD, MRED> inst;

public:
    l1_mod_mul() {}

    #pragma hls_design interface top
    void CCS_BLOCK(l1_mod_mul, run)(
        const ac_int<FIELD::W, false> x,
        const ac_int<FIELD::W, false> y,
        ac_int<FIELD::W, false> &z
    ) {
        inst.run(x, y, FIELD::Q::VALUE(), FIELD::Q_PRIME::VALUE(), z);
    }
};

// The RTL module takes the class name, 
// so the top is named after the kernel in both flows. 
// But, the testbench always instantiates the _top name,
// so we typedef the kernel with the _top suffix.
typedef l1_mod_mul l1_mod_mul_top;

#endif /* _L1_MOD_MUL_TOP_H_ */
