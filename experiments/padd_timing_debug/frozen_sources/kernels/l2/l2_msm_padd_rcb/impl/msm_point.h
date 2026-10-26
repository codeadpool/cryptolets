#ifndef TESSERA_MSM_POINT_H
#define TESSERA_MSM_POINT_H
#include <ac_int.h>
#include "params.h"
#include "ec_helper.h"
// Homogeneous projective: x=X/Z, y=Y/Z. Distinct from PointJac.
template<class _FIELD> struct PointProj {
    ac_int<_FIELD::W, false> X, Y, Z;
};
template<class _FIELD> ac_int<_FIELD::W,false> msm_mont_one() {
    // Fixed field constant; folds to a literal in synthesis.
    ac_int<_FIELD::W+1,false> r = 0; r[_FIELD::W] = 1;
    return r % _FIELD::Q::VALUE();
}
#endif
