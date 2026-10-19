#ifndef _L2_POINT_ADD_RCB_ALG7_H_
#define _L2_POINT_ADD_RCB_ALG7_H_

#include <ac_int.h>
#include "params.h"
#include "ec_helper.h"
#include "l1_mod_mul_impl.h"
#include "l1_mod_cmul_impl.h"
#include "l1_mod_add_impl.h"
#include "l1_mod_sub_impl.h"

// Complete projective addition for a = 0, Algorithm 7 of eprint 2015/1060,
// 12M + 2m3b + 19a.
template<class _FIELD, int _MRED, int _COEF_TYPE>
class l2_point_add_rcb_alg7 {
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
        fe t0, t1, t2, t3, t4, t5, t6, t7;
        modmul_inst.run(P0.X, P1.X, q, rc, t0);      // t0 = X1*X2
        modmul_inst.run(P0.Y, P1.Y, q, rc, t1);      // t1 = Y1*Y2
        modmul_inst.run(P0.Z, P1.Z, q, rc, t2);      // t2 = Z1*Z2
        modadd_inst.run(P0.X, P0.Y, q, t3);          // t3 = X1+Y1
        modadd_inst.run(P1.X, P1.Y, q, t4);          // t4 = X2+Y2
        modmul_inst.run(t3, t4, q, rc, t5);          // t5 = t3*t4
        modadd_inst.run(t0, t1, q, t6);              // t6 = t0+t1
        modsub_inst.run(t5, t6, q, t7);              // t7 = t5-t6

        fe t8, t9, t10, t11, t12;
        modadd_inst.run(P0.Y, P0.Z, q, t8);          // t8 = Y1+Z1
        modadd_inst.run(P1.Y, P1.Z, q, t9);          // t9 = Y2+Z2
        modmul_inst.run(t8, t9, q, rc, t10);         // t10 = t8*t9
        modadd_inst.run(t1, t2, q, t11);             // t11 = t1+t2
        modsub_inst.run(t10, t11, q, t12);           // t12 = t10-t11

        fe t13, t14, t15, t16, t17;
        modadd_inst.run(P0.X, P0.Z, q, t13);         // t13 = X1+Z1
        modadd_inst.run(P1.X, P1.Z, q, t14);         // t14 = X2+Z2
        modmul_inst.run(t13, t14, q, rc, t15);       // t15 = t13*t14
        modadd_inst.run(t0, t2, q, t16);             // t16 = t0+t2
        modsub_inst.run(t15, t16, q, t17);           // t17 = t15-t16

        fe t18, t19, t20, t21, t22, t23;
        modadd_inst.run(t0, t0, q, t18);             // t18 = t0+t0
        modadd_inst.run(t18, t0, q, t19);            // t19 = t18+t0
        if constexpr (_COEF_TYPE == VAR_COEF) {      // t20 = b3*t2
            modmul_inst.run(t2, b3, q, rc, t20);
        } else if constexpr (_MRED == MRED_MONT) {
            cmul_b3_mont_inst.run(t2, q, rc, t20);
        } else {
            cmul_b3_inst.run(t2, q, rc, t20);
        }
        modadd_inst.run(t1, t20, q, t21);            // t21 = t1+t20
        modsub_inst.run(t1, t20, q, t22);            // t22 = t1-t20
        if constexpr (_COEF_TYPE == VAR_COEF) {      // t23 = b3*t17
            modmul_inst.run(t17, b3, q, rc, t23);
        } else if constexpr (_MRED == MRED_MONT) {
            cmul_b3_mont_inst.run(t17, q, rc, t23);
        } else {
            cmul_b3_inst.run(t17, q, rc, t23);
        }

        fe t24, t25, t26, t27, t28, t29;
        modmul_inst.run(t12, t23, q, rc, t24);       // t24 = t12*t23
        modmul_inst.run(t7, t22, q, rc, t25);        // t25 = t7*t22
        modsub_inst.run(t25, t24, q, R.X);           // X3 = t25-t24
        modmul_inst.run(t23, t19, q, rc, t26);       // t26 = t23*t19
        modmul_inst.run(t22, t21, q, rc, t27);       // t27 = t22*t21
        modadd_inst.run(t27, t26, q, R.Y);           // Y3 = t27+t26
        modmul_inst.run(t19, t7, q, rc, t28);        // t28 = t19*t7
        modmul_inst.run(t21, t12, q, rc, t29);       // t29 = t21*t12
        modadd_inst.run(t29, t28, q, R.Z);           // Z3 = t29+t28
    }
};

#endif /* _L2_POINT_ADD_RCB_ALG7_H_ */
