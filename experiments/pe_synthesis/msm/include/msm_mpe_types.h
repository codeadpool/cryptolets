#ifndef MSM_MPE_TYPES_H
#define MSM_MPE_TYPES_H
#include "msm_sc_types.h"
#ifndef MSM_NUM_PES
#define MSM_NUM_PES 4
#endif
#ifndef MSM_BANK_LOG_POINTS
#define MSM_BANK_LOG_POINTS (MSM_LOG_POINTS - (MSM_NUM_PES == 4 ? 2 : 1))
#endif
namespace msmmpe {
using namespace msmsc;
enum { K = MSM_NUM_PES, BANK_N = 1 << MSM_BANK_LOG_POINTS,
       TILE_N = K * BANK_N, GROUPS = (NWIN + K - 1) / K,
       CONTEXT_WORDS = GROUPS * BRAM_SIZE };
// Physical bucket addresses include the persistent window context. PADD tags
// remain logical bucket addresses: a context can change only after full drain.
template<unsigned int N> struct AddressBits {
  enum { value = 1 + AddressBits<(N >> 1)>::value };
};
template<> struct AddressBits<0> { enum { value = 0 }; };
typedef ac_int<AddressBits<CONTEXT_WORDS - 1>::value, false> ContextAddr;
typedef ac_int<(GROUPS > 1 ? AddressBits<GROUPS - 1>::value : 1), false> Context;
static_assert(K == 2 || K == 4, "msm_mpe supports two or four PEs");
static_assert(MSM_BANK_LOG_POINTS >= 1 && MSM_BANK_LOG_POINTS <= LOGN,
              "bank capacity must be even and fit the point-address type");
static_assert(TILE_N <= NPTS, "tile capacity must not exceed host input capacity");
static_assert(MSM_VARIANT == MSM_SZKP, "msm_mpe implements dense SZKP");
// Zero occupancy requests the full physical bank capacity; nonzero must be even.
struct HostCmd {
  Count n, bank_points;
  MSM_SC_MARSHAL_COMMON(HostCmd, 2 * Count::width)
  template<unsigned int S> void Marshall(Marshaller<S>& m) { m & n; m & bank_points; }
  bool operator==(const HostCmd& o) const { return n == o.n && bank_points == o.bank_points; }
};
struct AffineInput { Scalar s; wide_t x, y; };
struct PointResp {
  wide_t x, y; Tag tag;
  MSM_SC_MARSHAL_COMMON(PointResp, 2 * FB + Tag::width)
  template<unsigned int S> void Marshall(Marshaller<S>& m) { m & x; m & y; m & tag; }
  bool operator==(const PointResp& o) const { return x == o.x && y == o.y && tag == o.tag; }
};
struct RoundCmd {
  Count n; ac_int<8, false> win; Context context; bool clear, reduce;
  MSM_SC_MARSHAL_COMMON(RoundCmd, Count::width + 10 + Context::width)
  template<unsigned int S> void Marshall(Marshaller<S>& m) { m & n; m & win; m & context; m & clear; m & reduce; }
  bool operator==(const RoundCmd& o) const { return n == o.n && win == o.win && context == o.context && clear == o.clear && reduce == o.reduce; }
};
// Acquire a prefilled input-buffer slot. The provider activates this slot and
// acknowledges readiness before any reads. Acquiring the next tile also releases
// the previous slot: every PE and all memory traffic have drained at that point.
struct TileReq {
  Count tile; ac_int<1, false> buffer;
  MSM_SC_MARSHAL_COMMON(TileReq, Count::width + 1)
  template<unsigned int S> void Marshall(Marshaller<S>& m) { m & tile; m & buffer; }
  bool operator==(const TileReq& o) const { return tile == o.tile && buffer == o.buffer; }
};
struct ScalarReq {
  PtAddr pair;
  MSM_SC_MARSHAL_COMMON(ScalarReq, PtAddr::width)
  template<unsigned int S> void Marshall(Marshaller<S>& m) { m & pair; }
  bool operator==(const ScalarReq& o) const { return pair == o.pair; }
};
struct ScalarResp {
  Scalar a, b;
  MSM_SC_MARSHAL_COMMON(ScalarResp, 2 * SB)
  template<unsigned int S> void Marshall(Marshaller<S>& m) { m & a; m & b; }
  bool operator==(const ScalarResp& o) const { return a == o.a && b == o.b; }
};
struct PointReq {
  PtAddr addr; Tag tag;
  MSM_SC_MARSHAL_COMMON(PointReq, PtAddr::width + Tag::width)
  template<unsigned int S> void Marshall(Marshaller<S>& m) { m & addr; m & tag; }
  bool operator==(const PointReq& o) const { return addr == o.addr && tag == o.tag; }
};
// XY-only point responses preserve request order; projective Z is constructed in each PE.
struct Work {
  PaddReq add; PtAddr addr; bool external;
  MSM_SC_MARSHAL_COMMON(Work, PaddReq::width + PtAddr::width + 1)
  template<unsigned int S> void Marshall(Marshaller<S>& m) { m & add; m & addr; m & external; }
  bool operator==(const Work& o) const { return add == o.add && addr == o.addr && external == o.external; }
};
}
#endif
