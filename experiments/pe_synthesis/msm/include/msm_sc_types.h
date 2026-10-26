// msm_sc_types.h -- geometry constants and Connections channel payloads of the
// latency-insensitive SystemC MSM kernel `msm_sc` (see lvl2/msm/DESIGN.md).
//
// All field values are in the ModOps backend domain (Montgomery for MODMUL_TYPE_MONT).
// Points are msm_point_t (EC_point_P for MSM_PADD_RCB, EC_point_J for MSM_PADD_JAC); on the
// channels they travel as ScPoint (same three coordinates, plus Connections marshalling).
#ifndef MSM_SC_TYPES_H
#define MSM_SC_TYPES_H

// SystemC / Connections first: the cryptolets headers define short macros (A0, FIXED_Q, ...).
#include <mc_connections.h>
#include "msm_common.h"

#if (Q_TYPE != FIXED_Q) || (REDC_TYPE != FIXED_RC)
#error "msm_sc supports Q_TYPE FIXED_Q and REDC_TYPE FIXED_RC only (the PADD [CCORE] folds q)"
#endif

#ifndef MSM_SIM_PADD_LATENCY
#define MSM_SIM_PADD_LATENCY 32     // pre-HLS (OSCI) simulation only: modelled PADD depth
#endif

namespace msmsc {

enum {
  FB          = BITWIDTH,                       // field bits (381)
  SB          = MSM_SCALAR_BITS,                // scalar bits (255)
  W           = MSM_WINDOW,
  NB          = MSM_NUM_BUCKETS,                // buckets per window (2^W - 1)
  NWIN        = MSM_NUM_WINDOWS,                // windows; the top one may be narrower
  QDEPTH      = MSM_QDEPTH,
  LOG_QDEPTH  = (MSM_QDEPTH == 1 ? 0 : MSM_QDEPTH == 2 ? 1 : MSM_QDEPTH == 4 ? 2 :
                 MSM_QDEPTH == 8 ? 3 : MSM_QDEPTH == 16 ? 4 : 5),
  LOGN        = MSM_LOG_POINTS,
  NPTS        = MSM_N,
#if MSM_VARIANT == MSM_ZKSPEED
  ZK          = 1,
#else
  ZK          = 0,
#endif
  GROUP       = MSM_GROUP,
  LOG_GROUP   = (MSM_GROUP == 2 ? 1 : MSM_GROUP == 4 ? 2 : MSM_GROUP == 8 ? 3 :
                 MSM_GROUP == 16 ? 4 : MSM_GROUP == 32 ? 5 : MSM_GROUP == 64 ? 6 : 7),
  NUM_GROUPS  = ZK ? (NB + MSM_GROUP - 1) / MSM_GROUP : 0,
  // Extended bucket register file ("bucket RAM") address map.
  ADDR_T0     = NB,                             // zkSpeed: T_g, g in [0, M)
  ADDR_R0     = NB + NUM_GROUPS,                // zkSpeed: R_g
  ADDR_SR     = NB + 2 * NUM_GROUPS,            // SZKP running sum   | zkSpeed Y1T
  ADDR_ST     = ADDR_SR + 1,                    // SZKP total sum     | zkSpeed Y1R
  ADDR_WIN    = ADDR_SR + 2,                    // zkSpeed window sum
  ADDR_ACC    = ADDR_SR + 3,                    // Horner accumulator across windows
  ADDR_INF    = ADDR_SR + 4,                    // never written: reads as the identity
  BRAM_SIZE   = ADDR_SR + 5,
  LOG_BRAM    = (BRAM_SIZE <= 16 ? 4 : BRAM_SIZE <= 32 ? 5 : BRAM_SIZE <= 64 ? 6 :
                 BRAM_SIZE <= 128 ? 7 : BRAM_SIZE <= 256 ? 8 : BRAM_SIZE <= 512 ? 9 : 10),
  SUM_ADDR    = ZK ? ADDR_WIN : ADDR_ST,        // where the reduction leaves the window sum
  SIM_PADD_LATENCY = MSM_SIM_PADD_LATENCY
};

typedef wide_t                             Field;
typedef msm_scalar_t                       Scalar;
typedef ac_int<LOGN + 1, false>            Count;      // 0 .. NPTS
typedef ac_int<LOGN, false>                PtAddr;
typedef ac_int<LOG_BRAM, false>            BAddr;
typedef ac_int<LOG_BRAM, false>            Tag;
typedef ac_int<W, false>                   Digit;
typedef ac_int<W, false>                   Bucket;
typedef ac_int<LOG_QDEPTH + 1, false>      QCount;
typedef ac_int<(LOG_QDEPTH > 0 ? LOG_QDEPTH : 1), false> QPtr;

#define MSM_SC_MARSHAL_COMMON(T, WIDTH)                                                     \
  static const unsigned int width = WIDTH;                                                  \
  inline friend void sc_trace(sc_trace_file *, const T &, const std::string &) {}           \
  inline friend std::ostream &operator<<(std::ostream &os, const T &) { return os; }

struct ScPoint {
  Field X, Y, Z;
  MSM_SC_MARSHAL_COMMON(ScPoint, 3 * FB)
  template <unsigned int Size> void Marshall(Marshaller<Size> &m) { m & X; m & Y; m & Z; }
  inline bool operator==(const ScPoint &o) const { return X == o.X && Y == o.Y && Z == o.Z; }
};

inline msm_point_t sc2pt(const ScPoint &s) { msm_point_t p; p.X = s.X; p.Y = s.Y; p.Z = s.Z; return p; }
inline ScPoint pt2sc(const msm_point_t &p) { ScPoint s; s.X = p.X; s.Y = p.Y; s.Z = p.Z; return s; }
inline ScPoint sc_inf() { return pt2sc(msm_point_inf()); }

// Host command: one MSM over the next n point tokens.
struct Cmd {
  Count n;
  MSM_SC_MARSHAL_COMMON(Cmd, Count::width)
  template <unsigned int Size> void Marshall(Marshaller<Size> &m) { m & n; }
  inline bool operator==(const Cmd &o) const { return n == o.n; }
};

// One input point with its scalar. SZKP: msm_point_t coordinates. zkSpeed: affine (x, y),
// (0, 0) = infinity, only two coordinates cross the interface (z is not transported).
struct InPoint {
  Scalar s; Field x, y;
#if MSM_VARIANT == MSM_ZKSPEED
  MSM_SC_MARSHAL_COMMON(InPoint, SB + 2 * FB)
  template <unsigned int Size> void Marshall(Marshaller<Size> &m) { m & s; m & x; m & y; }
  inline bool operator==(const InPoint &o) const { return s == o.s && x == o.x && y == o.y; }
#else
  Field z;
  MSM_SC_MARSHAL_COMMON(InPoint, SB + 3 * FB)
  template <unsigned int Size> void Marshall(Marshaller<Size> &m) { m & s; m & x; m & y; m & z; }
  inline bool operator==(const InPoint &o) const { return s == o.s && x == o.x && y == o.y && z == o.z; }
#endif
};

// Point forwarded from the fetch thread (which keeps the scalar) to the scheduler's banks.
struct PtFwd {
  Field x, y;
#if MSM_VARIANT == MSM_ZKSPEED
  MSM_SC_MARSHAL_COMMON(PtFwd, 2 * FB)
  template <unsigned int Size> void Marshall(Marshaller<Size> &m) { m & x; m & y; }
  inline bool operator==(const PtFwd &o) const { return x == o.x && y == o.y; }
#else
  Field z;
  MSM_SC_MARSHAL_COMMON(PtFwd, 3 * FB)
  template <unsigned int Size> void Marshall(Marshaller<Size> &m) { m & x; m & y; m & z; }
  inline bool operator==(const PtFwd &o) const { return x == o.x && y == o.y && z == o.z; }
#endif
};

// Window digits of the scalar pair (2k, 2k+1); v2 = the second scalar exists.
struct DigitPair {
  Digit d1, d2; bool v2;
  MSM_SC_MARSHAL_COMMON(DigitPair, 2 * W + 1)
  template <unsigned int Size> void Marshall(Marshaller<Size> &m) { m & d1; m & d2; m & v2; }
  inline bool operator==(const DigitPair &o) const { return d1 == o.d1 && d2 == o.d2 && v2 == o.v2; }
};

// Tagged PADD request / response: the tag is the bucket-RAM destination address.
struct PaddReq {
  ScPoint a, b; Tag tag;
  MSM_SC_MARSHAL_COMMON(PaddReq, 6 * FB + LOG_BRAM)
  template <unsigned int Size> void Marshall(Marshaller<Size> &m) { m & a; m & b; m & tag; }
  inline bool operator==(const PaddReq &o) const { return a == o.a && b == o.b && tag == o.tag; }
};
struct PaddResp {
  ScPoint p; Tag tag;
  MSM_SC_MARSHAL_COMMON(PaddResp, 3 * FB + LOG_BRAM)
  template <unsigned int Size> void Marshall(Marshaller<Size> &m) { m & p; m & tag; }
  inline bool operator==(const PaddResp &o) const { return p == o.p && tag == o.tag; }
};

// Affine result (backend domain, infinity = (0, 0)).
struct Result {
  Field x, y;
  MSM_SC_MARSHAL_COMMON(Result, 2 * FB)
  template <unsigned int Size> void Marshall(Marshaller<Size> &m) { m & x; m & y; }
  inline bool operator==(const Result &o) const { return x == o.x && y == o.y; }
};

// Backend with the compile-time modulus (FIXED_Q / FIXED_RC).
inline ModOps msm_sc_backend() {
#if MODMUL_TYPE == MODMUL_TYPE_MONT
  ModOps be(Q, Q_PRIME);
#else
  ModOps be(Q, MU);
#endif
  return be;
}

}  // namespace msmsc
#endif
