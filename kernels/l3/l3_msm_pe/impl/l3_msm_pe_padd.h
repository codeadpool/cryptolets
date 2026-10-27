#ifndef _L3_MSM_PE_PADD_H_
#define _L3_MSM_PE_PADD_H_

#include "l3_msm_pe_types.h"

// The PE adds two projective points, so it always uses alg7 with b3 baked in
#ifndef PADD_RCB_FORM
#define PADD_RCB_FORM PADD_RCB_ALG7
#endif
#ifndef COEF_TYPE
#define COEF_TYPE FIXED_COEF
#endif
#include "l2_point_add_rcb_impl.h"

namespace msm {

class Padd {
  l2_point_add_rcb_impl<FIELD, MRED_MONT, PADD_RCB_ALG7, FIXED_COEF> inst;

public:
  Point run(const Point &a, const Point &b) {
    Point r;
    // q, rc and b3 are fixed, so the blackboxed child takes no ports for them
    inst.run(a, b, FIELD::Q::VALUE(), FIELD::Q_PRIME::VALUE(), FIELD::B3_MONT::VALUE(), r);
    return r;
  }
};

}  // namespace msm

#endif /* _L3_MSM_PE_PADD_H_ */
