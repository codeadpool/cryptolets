#ifndef TESSERA_L2_MSM_PADD_RCB_H
#define TESSERA_L2_MSM_PADD_RCB_H
#include "msm_point.h"
#include "l1_mod_mul_impl.h"
#include "l1_mod_add_impl.h"
#include "l1_mod_sub_impl.h"
// BLS12-381 G1 (b=4) or BN254 G1 (b=3), full projective RCB Algorithm 7.
// Coordinates are Montgomery encoded; prime is fixed by the selected FIELD.
// Exactly 12 modular multiplies; 3*b*x is a compile-time add/double chain.
template<class _FIELD, int _MRED = MRED>
class l2_msm_padd_rcb_impl {
    l1_mod_mul_impl<_FIELD,_MRED> modmul_inst;
    l1_mod_add_impl<_FIELD> modadd_inst;
    l1_mod_sub_impl<_FIELD> modsub_inst;
    typedef ac_int<_FIELD::W,false> fe;
    fe add(fe a, fe b, fe q) { fe z; modadd_inst.run(a,b,q,z); return z; }
    fe sub(fe a, fe b, fe q) { fe z; modsub_inst.run(a,b,q,z); return z; }
    fe mul(fe a, fe b, fe q, ac_int<l1_mod_mul_consts<_FIELD,_MRED>::RC,false> rc) {
        fe z; modmul_inst.run(a,b,q,rc,z); return z;
    }
    fe b3(fe a, fe q) { fe a2=add(a,a,q), a4=add(a2,a2,q), a8=add(a4,a4,q); if constexpr (_FIELD::W == 254) return add(a8,a,q);
        else return add(a8,a4,q); }
public:
    void run(const ac_int<_FIELD::W,false> P0_X,
             const ac_int<_FIELD::W,false> P0_Y,
             const ac_int<_FIELD::W,false> P0_Z,
             const ac_int<_FIELD::W,false> P1_X,
             const ac_int<_FIELD::W,false> P1_Y,
             const ac_int<_FIELD::W,false> P1_Z,
             const ac_int<_FIELD::W,false> q,
             const ac_int<l1_mod_mul_consts<_FIELD,_MRED>::RC,false> rc,
             ac_int<_FIELD::W,false> &R_X,
             ac_int<_FIELD::W,false> &R_Y,
             ac_int<_FIELD::W,false> &R_Z) {
        // Scalar ports keep packaged RTL names identical to CCORE argument names.
        const PointProj<_FIELD> P0{P0_X,P0_Y,P0_Z}, P1{P1_X,P1_Y,P1_Z};
        PointProj<_FIELD> R;
        static_assert(_FIELD::W == 381 || _FIELD::W == 254, "BLS12-381 or BN254 only");
        static_assert(_MRED == MRED_MONT, "Montgomery only");
        fe t0=mul(P0.X,P1.X,q,rc), t1=mul(P0.Y,P1.Y,q,rc), t2=mul(P0.Z,P1.Z,q,rc);
        fe t3=add(P0.X,P0.Y,q), t4=add(P1.X,P1.Y,q);
        t3=mul(t3,t4,q,rc); t4=add(t0,t1,q); t3=sub(t3,t4,q);
        t4=add(P0.Y,P0.Z,q); R.X=add(P1.Y,P1.Z,q);
        t4=mul(t4,R.X,q,rc); R.X=add(t1,t2,q); t4=sub(t4,R.X,q);
        R.X=add(P0.X,P0.Z,q); R.Y=add(P1.X,P1.Z,q);
        R.X=mul(R.X,R.Y,q,rc); R.Y=add(t0,t2,q); R.Y=sub(R.X,R.Y,q);
        R.X=add(t0,t0,q); t0=add(R.X,t0,q); t2=b3(t2,q);
        R.Z=add(t1,t2,q); t1=sub(t1,t2,q); R.Y=b3(R.Y,q);
        R.X=mul(t4,R.Y,q,rc); t2=mul(t3,t1,q,rc); R.X=sub(t2,R.X,q);
        R.Y=mul(R.Y,t0,q,rc); t1=mul(t1,R.Z,q,rc); R.Y=add(t1,R.Y,q);
        t0=mul(t0,t3,q,rc); R.Z=mul(R.Z,t4,q,rc); R.Z=add(R.Z,t0,q);
        R_X=R.X; R_Y=R.Y; R_Z=R.Z;
    }
};
#endif
