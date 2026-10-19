#ifndef _L2_POINT_ADD_RCB_H_
#define _L2_POINT_ADD_RCB_H_

#include <ac_int.h>
#include "params.h"

// A sweep without coef_type bakes the coefficients in
#ifndef COEF_TYPE
#define COEF_TYPE FIXED_COEF
#endif

#include "ec_helper.h"
#include "l2_point_add_rcb_alg7.h"
#include "l2_point_add_rcb_alg8.h"

// Complete addition for short Weierstrass curves with a = 0, from Renes,
// Costello and Batina, eprint 2015/1060. The same formula also doubles,
// so the hardware has no doubling branch.
template<class _FIELD,
         int _MRED = MRED,
         int _PADD_RCB_FORM = PADD_RCB_FORM,
         int _COEF_TYPE = COEF_TYPE>
class l2_point_add_rcb_impl {
    l2_point_add_rcb_alg7<_FIELD, _MRED, _COEF_TYPE> alg7_inst;
    l2_point_add_rcb_alg8<_FIELD, _MRED, _COEF_TYPE> alg8_inst;

    typedef ac_int<_FIELD::W, false> fe;

public:
    typedef ac_int<l1_mod_mul_consts<_FIELD,_MRED>::RC, false> rc_t;

    void run(
        const PointProj<_FIELD> P0,
        const PointProj<_FIELD> P1,
        const ac_int<_FIELD::W, false> q,
        const ac_int<l1_mod_mul_consts<_FIELD,_MRED>::RC, false> rc,
        const ac_int<_FIELD::W, false> b3,
        PointProj<_FIELD> &R
    ) {
        if constexpr (_PADD_RCB_FORM == PADD_RCB_ALG7) {
            alg7_inst.run(P0, P1, q, rc, b3, R);
        } else { // PADD_RCB_ALG8
            alg8_inst.run(P0, P1, q, rc, b3, R);
        }
    }
};

#endif /* _L2_POINT_ADD_RCB_H_ */
