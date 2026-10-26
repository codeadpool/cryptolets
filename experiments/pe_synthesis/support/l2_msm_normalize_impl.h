#ifndef TESSERA_L2_MSM_NORMALIZE_H
#define TESSERA_L2_MSM_NORMALIZE_H
#include "msm_point.h"
#include "l1_mod_mul_impl.h"
// Fermat inversion, fixed 381 iterations. Output remains Montgomery.
template<class _FIELD, int _MRED = MRED>
class l2_msm_normalize_impl {
    l1_mod_mul_impl<_FIELD,_MRED> modmul_inst;
public:
    void run(const ac_int<_FIELD::W,false> P_X,
             const ac_int<_FIELD::W,false> P_Y,
             const ac_int<_FIELD::W,false> P_Z,
             const ac_int<_FIELD::W,false> q,
             const ac_int<l1_mod_mul_consts<_FIELD,_MRED>::RC,false> rc,
             ac_int<_FIELD::W,false> &A_x,
             ac_int<_FIELD::W,false> &A_y) {
        const PointProj<_FIELD> P{P_X,P_Y,P_Z};
        static_assert(_MRED == MRED_MONT, "Montgomery only");
        ac_int<_FIELD::W,false> acc=msm_mont_one<_FIELD>();
        const ac_int<_FIELD::W,false> e=q-2;
        INV: for (int i=_FIELD::W-1;i>=0;--i) {
            ac_int<_FIELD::W,false> sq,m;
            modmul_inst.run(acc,acc,q,rc,sq);
            modmul_inst.run(sq,P.Z,q,rc,m);
            acc=e[i]?m:sq;
        }
        ac_int<_FIELD::W,false> x,y;
        modmul_inst.run(P.X,acc,q,rc,x); modmul_inst.run(P.Y,acc,q,rc,y);
        A_x=P.Z==0?ac_int<_FIELD::W,false>(0):x;
        A_y=P.Z==0?ac_int<_FIELD::W,false>(0):y;
    }
};
#endif
