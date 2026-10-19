#ifndef _L2_POINT_ADD_RCB_ALG8_H_
#define _L2_POINT_ADD_RCB_ALG8_H_

#include <ac_int.h>
#include "params.h"
#include "ec_helper.h"
#include "l1_mod_mul_impl.h"
#include "l1_mod_cmul_impl.h"
#include "l1_mod_add_impl.h"
#include "l1_mod_sub_impl.h"

// Complete mixed addition for a = 0, Algorithm 8 of eprint 2015/1060,
// 11M + 2m3b + 13a.
template<class _FIELD, int _MRED, int _COEF_TYPE>
class l2_point_add_rcb_alg8 {
    l1_mod_mul_impl<_FIELD, _MRED>          modmul_inst;
    l1_mod_add_impl<_FIELD>                 modadd_inst;
    l1_mod_sub_impl<_FIELD>                 modsub_inst;
    l1_mod_cmul_impl<_FIELD, typename _FIELD::B3_MONT, _MRED> cmul_b3_mont_inst;
    l1_mod_cmul_impl<_FIELD, typename _FIELD::B3, _MRED>      cmul_b3_inst;

    typedef ac_int<_FIELD::W, false> fe;
    typedef ac_int<l1_mod_mul_consts<_FIELD,_MRED>::RC, false> rc_t;

public:
    void run(
        const PointProj<_FIELD> P0,
        const PointProj<_FIELD> P1,
        const fe q, const rc_t rc,
        const fe b3,
        PointProj<_FIELD> &R
    ) {
        // P1 is affine with Z = 1, so P1.Z is never read
        fe t0, t1, t2, t3, t4, t5, t6;
        modmul_inst.run(P0.X, P1.X, q, rc, t0);      // t0 = X1*X2
        modmul_inst.run(P0.Y, P1.Y, q, rc, t1);      // t1 = Y1*Y2
        modadd_inst.run(P1.X, P1.Y, q, t2);          // t2 = X2+Y2
        modadd_inst.run(P0.X, P0.Y, q, t3);          // t3 = X1+Y1
        modmul_inst.run(t2, t3, q, rc, t4);          // t4 = t2*t3
        modadd_inst.run(t0, t1, q, t5);              // t5 = t0+t1
        modsub_inst.run(t4, t5, q, t6);              // t6 = t4-t5

        fe t7, t8, t9, t10;
        modmul_inst.run(P1.Y, P0.Z, q, rc, t7);      // t7 = Y2*Z1
        modadd_inst.run(t7, P0.Y, q, t8);            // t8 = t7+Y1
        modmul_inst.run(P1.X, P0.Z, q, rc, t9);      // t9 = X2*Z1
        modadd_inst.run(t9, P0.X, q, t10);           // t10 = t9+X1

        fe t11, t12, t13, t14, t15, t16;
        modadd_inst.run(t0, t0, q, t11);             // t11 = t0+t0
        modadd_inst.run(t11, t0, q, t12);            // t12 = t11+t0
        if constexpr (_COEF_TYPE == VAR_COEF) {      // t13 = b3*Z1
            modmul_inst.run(P0.Z, b3, q, rc, t13);
        } else if constexpr (_MRED == MRED_MONT) {
            cmul_b3_mont_inst.run(P0.Z, q, rc, t13);
        } else {
            cmul_b3_inst.run(P0.Z, q, rc, t13);
        }
        modadd_inst.run(t1, t13, q, t14);            // t14 = t1+t13
        modsub_inst.run(t1, t13, q, t15);            // t15 = t1-t13
        if constexpr (_COEF_TYPE == VAR_COEF) {      // t16 = b3*t10
            modmul_inst.run(t10, b3, q, rc, t16);
        } else if constexpr (_MRED == MRED_MONT) {
            cmul_b3_mont_inst.run(t10, q, rc, t16);
        } else {
            cmul_b3_inst.run(t10, q, rc, t16);
        }

        fe t17, t18, t19, t20, t21, t22;
        modmul_inst.run(t8, t16, q, rc, t17);        // t17 = t8*t16
        modmul_inst.run(t6, t15, q, rc, t18);        // t18 = t6*t15
        modsub_inst.run(t18, t17, q, R.X);           // X3 = t18-t17
        modmul_inst.run(t16, t12, q, rc, t19);       // t19 = t16*t12
        modmul_inst.run(t15, t14, q, rc, t20);       // t20 = t15*t14
        modadd_inst.run(t20, t19, q, R.Y);           // Y3 = t20+t19
        modmul_inst.run(t12, t6, q, rc, t21);        // t21 = t12*t6
        modmul_inst.run(t14, t8, q, rc, t22);        // t22 = t14*t8
        modadd_inst.run(t22, t21, q, R.Z);           // Z3 = t22+t21
    }
};

#endif /* _L2_POINT_ADD_RCB_ALG8_H_ */
