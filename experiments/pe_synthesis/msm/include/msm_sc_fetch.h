// msm_sc_fetch.h -- "fetch scalars" front end of the SZKP PE (one call of step() per cycle).
// Loads the scalars of the n input tokens into an even/odd pair of banks (so two scalars are
// read per cycle), forwards the points to the scheduler, then streams the window digits of
// scalar pairs, window NWIN-1 (MSB) first.
#ifndef MSM_SC_FETCH_H
#define MSM_SC_FETCH_H

#include "msm_sc_types.h"

namespace msmsc {

class FetchCore {
public:
  FetchCore() { reset(); }
  void reset() { state = F_IDLE; n = 0; idx = 0; win = 0; k = 0; pairs = 0; }

  // Digit of window w: bits [W*w, W*w + W) of the zero-extended scalar.
  static Digit digit(const Scalar &s, ac_int<8, false> w) {
    ac_int<NWIN * W, false> ext = s;
    Digit d = 0;
    #pragma hls_unroll yes
    DIGIT_MUX: for (int j = 0; j < NWIN; j++) {
      if (j == w) d = ext.template slc<W>(j * W);
    }
    return d;
  }

  void step(bool cmd_v, const Cmd &cmd, bool &cmd_take,
            bool pt_v, const InPoint &pt, bool &pt_take,
            bool &cmdf_v, Cmd &cmdf,
            bool &ptf_v, PtFwd &ptf,
            bool &dig_v, DigitPair &dig) {
    cmd_take = false; pt_take = false; cmdf_v = false; ptf_v = false; dig_v = false;
    switch (state) {
    case F_IDLE:
      if (cmd_v) {
        cmd_take = true; cmdf_v = true; cmdf = cmd;
        n = cmd.n; idx = 0; pairs = (cmd.n + 1) >> 1;
        state = (cmd.n == 0) ? F_IDLE : F_LOAD;
      }
      break;
    case F_LOAD:
      if (pt_v) {
        pt_take = true;
        if (idx[0]) sc_odd[idx >> 1] = pt.s; else sc_even[idx >> 1] = pt.s;
        ptf_v = true; ptf.x = pt.x; ptf.y = pt.y;
#if MSM_VARIANT != MSM_ZKSPEED
        ptf.z = pt.z;
#endif
        idx++;
        if (idx == n) { state = F_GEN; win = NWIN - 1; k = 0; }
      }
      break;
    case F_GEN: {
      Scalar s1 = sc_even[k];
      Scalar s2 = sc_odd[k];
      dig_v = true;
      dig.d1 = digit(s1, win);
      dig.d2 = digit(s2, win);
      dig.v2 = ((Count)((k << 1) + 1) < n);
      k++;
      if (k == pairs) {
        k = 0;
        if (win == 0) state = F_IDLE; else win--;
      }
      break; }
    }
  }

private:
  enum { F_IDLE, F_LOAD, F_GEN };
  ac_int<2, false> state;
  Count n, idx;
  ac_int<8, false> win;
  Count k, pairs;
  Scalar sc_even[NPTS / 2];
  Scalar sc_odd[NPTS / 2];
};

}  // namespace msmsc
#endif
