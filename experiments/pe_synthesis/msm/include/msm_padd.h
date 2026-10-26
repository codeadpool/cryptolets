#ifndef MSM_PADD_H
#define MSM_PADD_H
#include "msm_common.h"
#include "l2_msm_padd_rcb_impl.h"
#include "l2_msm_normalize_impl.h"
typedef l2_msm_padd_rcb_impl<FIELD,MRED> MsmPadd;
typedef l2_msm_normalize_impl<FIELD,MRED> MsmNormalize;
inline msm_point_t msm_padd_dispatch(MsmPadd &inst,const msm_point_t &a,const msm_point_t &b,const ModOps &) {
    msm_point_t r;
    inst.run(a.X,a.Y,a.Z,b.X,b.Y,b.Z,Q,Q_PRIME,r.X,r.Y,r.Z); return r;
}
inline EC_point_A msm_to_affine(MsmNormalize &inst,const msm_point_t &p,const ModOps &) {
    EC_point_A r;
    inst.run(p.X,p.Y,p.Z,Q,Q_PRIME,r.x,r.y); return r;
}
#endif
