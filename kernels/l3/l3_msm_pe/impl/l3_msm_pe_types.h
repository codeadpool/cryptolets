#ifndef _L3_MSM_PE_TYPES_H_
#define _L3_MSM_PE_TYPES_H_

// SystemC / Connections first: the Tessera headers define short macros.
#include <mc_connections.h>
#include <ac_int.h>
#include "params.h"
#include "ec_helper.h"

#if MRED != MRED_MONT || Q_TYPE != FIXED_Q || RC_TYPE != FIXED_RC
#error "l3_msm_pe needs a Montgomery PADD with q and rc baked in"
#endif

// MSM geometry. These are candidates for sweep parameters.
#ifndef MSM_LOG_POINTS
#define MSM_LOG_POINTS 14          // host input capacity, 2^MSM_LOG_POINTS points
#endif
#ifndef MSM_WINDOW
#define MSM_WINDOW 8               // window width; 2^W - 1 buckets per window
#endif
#ifndef MSM_SCALAR_BITS
#define MSM_SCALAR_BITS 255        // BLS12-381 scalar field
#endif
#ifndef MSM_QDEPTH
#define MSM_QDEPTH 4               // per-bucket point-address FIFO depth, a power of two
#endif
#ifndef MSM_NUM_PES
#define MSM_NUM_PES 4              // PEs in the full system; sets the context count
#endif
#ifndef MSM_BANK_LOG_POINTS
#define MSM_BANK_LOG_POINTS (MSM_LOG_POINTS - (MSM_NUM_PES == 4 ? 2 : 1))
#endif
#ifndef MSM_PENDING_DEPTH
#define MSM_PENDING_DEPTH 8        // resolve-stage FIFO depth, a power of two
#endif

#define MSM_SCHED_LQ 0
#define MSM_SCHED_RR 1
#ifndef MSM_SCHED
#define MSM_SCHED MSM_SCHED_LQ
#endif
// Two-stage longest-queue select, needed to meet timing at wide windows
#ifndef MSM_SC_LQ2
#define MSM_SC_LQ2 (MSM_WINDOW > 4)
#endif

// The C++ model's PADD depth. HLS uses the blackboxed child's latency.
#ifndef MSM_SIM_PADD_LATENCY
#define MSM_SIM_PADD_LATENCY 32
#endif

namespace msm {

typedef ac_int<BITWIDTH, false> Field;
typedef PointProj<FIELD> Point;

// Montgomery form of 1. A field constant, so it folds in synthesis.
inline Field mont_one() {
  ac_int<BITWIDTH + 1, false> r = 0; r[BITWIDTH] = 1;
  return r % FIELD::Q::VALUE();
}
// Projective identity (0 : 1 : 0); RCB adds it without a special case.
inline Point point_inf() { Point p; p.X = 0; p.Y = mont_one(); p.Z = 0; return p; }

template<unsigned int N> struct AddressBits {
  enum { value = 1 + AddressBits<(N >> 1)>::value };
};
template<> struct AddressBits<0> { enum { value = 0 }; };

enum {
  FB         = BITWIDTH,
  SB         = MSM_SCALAR_BITS,
  W          = MSM_WINDOW,
  NB         = (1 << MSM_WINDOW) - 1,
  NWIN       = (MSM_SCALAR_BITS + MSM_WINDOW - 1) / MSM_WINDOW,
  QDEPTH     = MSM_QDEPTH,
  LOG_QDEPTH = AddressBits<MSM_QDEPTH>::value - 1,
  LOGN       = MSM_LOG_POINTS,
  NPTS       = 1 << MSM_LOG_POINTS,
  // Bucket RAM map per context: NB buckets, then reduction scratch
  ADDR_SR    = NB,                 // running sum
  ADDR_ST    = NB + 1,             // total sum, the window result
  ADDR_INF   = NB + 4,             // never written, reads as the identity
  BRAM_SIZE  = NB + 5,
  LOG_BRAM   = AddressBits<BRAM_SIZE - 1>::value,
  SUM_ADDR   = ADDR_ST,
  K          = MSM_NUM_PES,
  BANK_N     = 1 << MSM_BANK_LOG_POINTS,
  TILE_N     = K * BANK_N,
  GROUPS     = (NWIN + K - 1) / K, // window contexts resident in one PE
  CONTEXT_WORDS = GROUPS * BRAM_SIZE
};

static_assert(K == 2 || K == 4, "two or four PEs");
static_assert(MSM_BANK_LOG_POINTS >= 1 && MSM_BANK_LOG_POINTS <= LOGN, "bank must fit the point address");
static_assert(TILE_N <= NPTS, "tile must fit the host input");
static_assert((MSM_QDEPTH & (MSM_QDEPTH - 1)) == 0, "MSM_QDEPTH must be a power of two");
static_assert(MSM_PENDING_DEPTH >= 2 && (MSM_PENDING_DEPTH & (MSM_PENDING_DEPTH - 1)) == 0,
              "MSM_PENDING_DEPTH must be a power of two >= 2");

typedef ac_int<SB, false>                  Scalar;
typedef ac_int<LOGN + 1, false>            Count;
typedef ac_int<LOGN, false>                PtAddr;
typedef ac_int<LOG_BRAM, false>            BAddr;
typedef ac_int<LOG_BRAM, false>            Tag;
typedef ac_int<W, false>                   Digit;
typedef ac_int<W, false>                   Bucket;
typedef ac_int<LOG_QDEPTH + 1, false>      QCount;
typedef ac_int<(LOG_QDEPTH > 0 ? LOG_QDEPTH : 1), false> QPtr;
typedef ac_int<AddressBits<CONTEXT_WORDS - 1>::value, false> ContextAddr;
typedef ac_int<(GROUPS > 1 ? AddressBits<GROUPS - 1>::value : 1), false> Context;

// Digit of window w: bits [W*w, W*w + W) of the zero-extended scalar
inline Digit digit(const Scalar &s, ac_int<8, false> w) {
  ac_int<NWIN * W, false> ext = s;
  Digit d = 0;
  #pragma hls_unroll yes
  DIGIT_MUX: for (int j = 0; j < NWIN; j++) {
    if (j == w) d = ext.template slc<W>(j * W);
  }
  return d;
}

#define MSM_MARSHAL(T, WIDTH)                                                     \
  static const unsigned int width = WIDTH;                                        \
  inline friend void sc_trace(sc_trace_file *, const T &, const std::string &) {} \
  inline friend std::ostream &operator<<(std::ostream &os, const T &) { return os; }

struct ScPoint {
  Field X, Y, Z;
  MSM_MARSHAL(ScPoint, 3 * FB)
  template<unsigned int S> void Marshall(Marshaller<S> &m) { m & X; m & Y; m & Z; }
  bool operator==(const ScPoint &o) const { return X == o.X && Y == o.Y && Z == o.Z; }
};
inline Point sc2pt(const ScPoint &s) { Point p; p.X = s.X; p.Y = s.Y; p.Z = s.Z; return p; }
inline ScPoint pt2sc(const Point &p) { ScPoint s; s.X = p.X; s.Y = p.Y; s.Z = p.Z; return s; }
inline ScPoint sc_inf() { return pt2sc(point_inf()); }

// Window digits of scalars 2k and 2k+1; v2 says the second one exists
struct DigitPair {
  Digit d1, d2; bool v2;
  MSM_MARSHAL(DigitPair, 2 * W + 1)
  template<unsigned int S> void Marshall(Marshaller<S> &m) { m & d1; m & d2; m & v2; }
  bool operator==(const DigitPair &o) const { return d1 == o.d1 && d2 == o.d2 && v2 == o.v2; }
};

// The tag is the bucket RAM address the sum goes back to
struct PaddReq {
  ScPoint a, b; Tag tag;
  MSM_MARSHAL(PaddReq, 6 * FB + LOG_BRAM)
  template<unsigned int S> void Marshall(Marshaller<S> &m) { m & a; m & b; m & tag; }
  bool operator==(const PaddReq &o) const { return a == o.a && b == o.b && tag == o.tag; }
};
struct PaddResp {
  ScPoint p; Tag tag;
  MSM_MARSHAL(PaddResp, 3 * FB + LOG_BRAM)
  template<unsigned int S> void Marshall(Marshaller<S> &m) { m & p; m & tag; }
  bool operator==(const PaddResp &o) const { return p == o.p && tag == o.tag; }
};

// One round: accumulate n points into window win, or reduce a context
struct RoundCmd {
  Count n; ac_int<8, false> win; Context context; bool clear, reduce;
  MSM_MARSHAL(RoundCmd, Count::width + 10 + Context::width)
  template<unsigned int S> void Marshall(Marshaller<S> &m) { m & n; m & win; m & context; m & clear; m & reduce; }
  bool operator==(const RoundCmd &o) const {
    return n == o.n && win == o.win && context == o.context && clear == o.clear && reduce == o.reduce;
  }
};

struct ScalarReq {
  PtAddr pair;
  MSM_MARSHAL(ScalarReq, PtAddr::width)
  template<unsigned int S> void Marshall(Marshaller<S> &m) { m & pair; }
  bool operator==(const ScalarReq &o) const { return pair == o.pair; }
};
struct ScalarResp {
  Scalar a, b;
  MSM_MARSHAL(ScalarResp, 2 * SB)
  template<unsigned int S> void Marshall(Marshaller<S> &m) { m & a; m & b; }
  bool operator==(const ScalarResp &o) const { return a == o.a && b == o.b; }
};

struct PointReq {
  PtAddr addr; Tag tag;
  MSM_MARSHAL(PointReq, PtAddr::width + Tag::width)
  template<unsigned int S> void Marshall(Marshaller<S> &m) { m & addr; m & tag; }
  bool operator==(const PointReq &o) const { return addr == o.addr && tag == o.tag; }
};
// Affine x, y in request order; the PE builds projective Z
struct PointResp {
  Field x, y; Tag tag;
  MSM_MARSHAL(PointResp, 2 * FB + Tag::width)
  template<unsigned int S> void Marshall(Marshaller<S> &m) { m & x; m & y; m & tag; }
  bool operator==(const PointResp &o) const { return x == o.x && y == o.y && tag == o.tag; }
};

// A PADD to issue; external means operand b still has to be fetched
struct Work {
  PaddReq add; PtAddr addr; bool external;
  MSM_MARSHAL(Work, PaddReq::width + PtAddr::width + 1)
  template<unsigned int S> void Marshall(Marshaller<S> &m) { m & add; m & addr; m & external; }
  bool operator==(const Work &o) const { return add == o.add && addr == o.addr && external == o.external; }
};

}  // namespace msm

#endif /* _L3_MSM_PE_TYPES_H_ */
