#ifndef MSM_COMMON_H
#define MSM_COMMON_H
#include <ac_int.h>
#include "params.h"
#include "msm_point.h"
#define REDC_TYPE RC_TYPE
#define MODMUL_TYPE MRED
#define MODMUL_TYPE_MONT MRED_MONT
#define MSM_SZKP 0
#define MSM_ZKSPEED 1
#define MSM_PADD_RCB 0
#define MSM_PADD_JAC 1
#define MSM_SCHED_LQ 0
#define MSM_SCHED_RR 1
typedef ac_int<BITWIDTH,false> wide_t;
static const wide_t Q = FIELD::Q::VALUE();
static const wide_t Q_PRIME = FIELD::Q_PRIME::VALUE();
typedef ac_int<2*BITWIDTH,false> wide_2x_t;
typedef PointProj<FIELD> EC_point_P;
typedef PointProj<FIELD> msm_point_t;
typedef PointAff<FIELD> EC_point_A;
struct ModOps {
    wide_t q, rc;
    ModOps(wide_t modulus=Q,wide_t constant=Q_PRIME):q(modulus),rc(constant) {}
};
#ifndef MSM_LOG_POINTS
#define MSM_LOG_POINTS 14          // points per MSM (bank capacity) = 2^MSM_LOG_POINTS
#endif
#ifndef MSM_WINDOW
#define MSM_WINDOW 8               // window width W; buckets per window = 2^W - 1
#endif
#ifndef MSM_SCALAR_BITS
#define MSM_SCALAR_BITS 255        // BLS12-381 scalar field width
#endif
#ifndef MSM_QDEPTH
#define MSM_QDEPTH 4               // per-bucket point-address FIFO depth (power of two)
#endif
#ifndef MSM_VARIANT
#define MSM_VARIANT MSM_SZKP       // MSM_SZKP | MSM_ZKSPEED
#endif
#ifndef MSM_PADD
#define MSM_PADD MSM_PADD_RCB      // MSM_PADD_RCB | MSM_PADD_JAC
#endif
#ifndef MSM_SCHED
#define MSM_SCHED MSM_SCHED_LQ     // MSM_SCHED_LQ | MSM_SCHED_RR
#endif
#ifndef MSM_GROUP
#define MSM_GROUP 16               // zkSpeed grouped-aggregation group size (power of two)
#endif
#ifndef MSM_PIPE_DELAY
#define MSM_PIPE_DELAY 48          // static design: cycles from PADD issue to bucket busy release
#endif

#define MSM_N           (1 << MSM_LOG_POINTS)
#define MSM_NUM_BUCKETS ((1 << MSM_WINDOW) - 1)
#define MSM_NUM_WINDOWS ((MSM_SCALAR_BITS + MSM_WINDOW - 1) / MSM_WINDOW)

typedef ac_int<MSM_SCALAR_BITS, false>    msm_scalar_t;
typedef ac_int<MSM_LOG_POINTS + 1, false> msm_count_t;   // 0 .. MSM_N
typedef ac_int<MSM_LOG_POINTS, false>     msm_addr_t;
typedef ac_int<MSM_WINDOW, false>         msm_digit_t;


#if MSM_PADD != MSM_PADD_RCB || MRED != MRED_MONT
#error "v4 MSM uses the Tessera Montgomery RCB datapath"
#endif
#define MSM_FIELD_ONE msm_mont_one<FIELD>()
#define MONT_ONE MSM_FIELD_ONE
inline msm_point_t msm_point_inf() { return {0,MSM_FIELD_ONE,0}; }
inline bool msm_is_inf(const msm_point_t &p) { return p.Z==0; }
#endif
