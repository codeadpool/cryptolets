// Round scheduler derived from msm_sc: two-stage start-of-cycle LQ selection,
// synchronous reset, one write site per register bank and one bucket RAM read/write.
#ifndef MSM_MPE_SCHED_H
#define MSM_MPE_SCHED_H
#include "msm_mpe_types.h"
#ifndef MSM_SC_LQ2
#define MSM_SC_LQ2 (MSM_WINDOW > 4)
#endif
namespace msmmpe {
class RoundSched {
public:
  enum { LQ_GB = W / 2, NG = 1 << LQ_GB, GS = 1 << (W - LQ_GB) };
  void reset() {
    state = IDLE; context = 0; pairs = 0; pair_cnt = 0; queued = 0; inflight = 0;
    clear_window = false; init_addr = 0; ph2 = false; clr_pending = false; clr_addr = 0;
    p2_dst = 0; p2_sb = 0; sel_reg = 0; sel_reg_v = false;
    lq_excl = 0; lq_excl_v = false; lqa_v = false; rr_ptr = 0;
    red_i = 0; red_par = false; red_finished = false;
    #pragma hls_unroll yes
    for (int i = 0; i < BRAM_SIZE; ++i) { busy[i] = false; }
    #pragma hls_unroll yes
    for (int i = 0; i < (1 << W); ++i) { q_cnt[i] = 0; q_head[i] = 0; }
    #pragma hls_unroll yes
    for (int i = 0; i < NG; ++i) { ga_c1[i] = 0; ga_c2[i] = 0; ga_i1[i] = 0; ga_i2[i] = 0; }
  }
  void step(bool cv, const RoundCmd& cmd, bool& ct,
            bool dv, const DigitPair& dig, bool& dt,
            bool rv, const PaddResp& resp,
            bool& wv, Work& work, bool& done, ScPoint& sum) {
    const bool idle = state == IDLE;
    const bool init = state == INIT;
    // Initialize this window once per host MSM, through the normal SRAM port.
    // Include reduction scratch and the reserved identity entry. Later tiles
    // reuse the stored sums without any per-context validity state or copies.
    const bool init_write = init && clear_window;
    const bool init_done = init && (!clear_window || init_addr == BRAM_SIZE - 1);
    const bool acc = state == ACC;
    const bool red = state == RED && !ph2;
    const bool start_cmd = idle && cv;
    const BAddr wb_addr = (BAddr)resp.tag;
    // Only change context between drained commands. Logical tags therefore
    // refer unambiguously to this context throughout point fetch and write-back.
    const ContextAddr base = (ContextAddr)context * (ContextAddr)BRAM_SIZE;
    const ContextAddr wr_phys = base + (ContextAddr)(init_write ? init_addr : wb_addr);
    const bool can_take = acc && dv && pair_cnt < pairs;
    const bool q1 = can_take && dig.d1 != 0;
    const bool q2 = can_take && dig.v2 && dig.d2 != 0;
    const Bucket b1 = (Bucket)(dig.d1 - 1), b2 = (Bucket)(dig.d2 - 1);
    const QCount c1 = q_cnt[b1], c2 = q_cnt[b2];
    const QPtr h1 = q_head[b1], h2 = q_head[b2];
    const bool same = q1 && q2 && b1 == b2;
    const bool stall = (q1 && c1 == QDEPTH) || (q2 && c2 == QDEPTH) ||
                       (same && (QCount)(c1 + 2) > QDEPTH);
    const bool push = can_take && !stall;
    const bool pop = acc && sel_reg_v;
    const Bucket sel = sel_reg;
    const QPtr hs = q_head[sel];
    const PtAddr pa = addr_q[sel][hs];
    const bool acc_end = acc && pair_cnt == pairs && queued == 0 && inflight == 0 &&
                         !sel_reg_v && !rv && !clr_pending;
    lq_excl = sel; lq_excl_v = pop;
    Bucket nsel; bool nsel_v;
#if MSM_SCHED == MSM_SCHED_RR
    select_rr(nsel, nsel_v);
#elif MSM_SC_LQ2
    Cand gb = LQB<0, NG>::best(*this);
    nsel = gb.id; nsel_v = lqa_v && gb.c != 0;
    Cand2 ga[NG]; LQA_ALL<0>::run(*this, ga);
#else
    select_lq(nsel, nsel_v);
#endif
    const BAddr dst = red_par ? ADDR_ST : ADDR_SR;
    const BAddr sa = dst;
    const BAddr sb = red_par ? (BAddr)ADDR_SR : (BAddr)(NB - 1 - red_i);
    const bool red_go = red && !red_finished && !busy[dst] && !busy[sa] && !busy[sb];
    const bool red_end = red && red_finished && inflight == 0 && !clr_pending;
    const bool output = state == OUT;
    const BAddr ra = ph2 ? p2_sb : red_go ? sa : output ? (BAddr)SUM_ADDR : (BAddr)sel;
    const ContextAddr rd_phys = base + (ContextAddr)ra;
    ScPoint a; a.X = br_x[rd_phys]; a.Y = br_y[rd_phys]; a.Z = br_z[rd_phys];
    const ScPoint av = a;
    work.add.a = ph2 ? opA_hold : av;
    work.add.b = ph2 ? av : sc_inf();
    work.add.tag = ph2 ? p2_dst : (Tag)sel;
    work.addr = pa; work.external = pop;
    wv = ph2 || pop; ct = start_cmd; dt = push;
    done = acc_end || output; sum = output ? av : sc_inf();
    if (red_go) opA_hold = av;
    const ScPoint wr_point = init_write ? sc_inf() : resp.p;
#ifndef __SYNTHESIS__
    sc_assert(!(init_write && rv));
#endif
    if (init_write || rv) {
      br_x[wr_phys] = wr_point.X; br_y[wr_phys] = wr_point.Y; br_z[wr_phys] = wr_point.Z;
    }
    const bool set_busy = pop || red_go;
    const BAddr set_addr = red_go ? dst : (BAddr)sel;
    #pragma hls_unroll yes
    WR_BANKS: for (int i = 0; i < BRAM_SIZE; ++i) {
      bool b = busy[i];
      if (clr_pending && clr_addr == i) b = false;
      if (set_busy && set_addr == i) b = true;
      busy[i] = b;
    }
    const bool inc1 = push && q1, inc2 = push && q2;
    #pragma hls_unroll yes
    WR_QUEUES: for (int b = 0; b < (1 << W); ++b) {
      QPtr h = q_head[b]; QCount c = q_cnt[b];
      if (pop && sel == b) { h = hs + 1; c = c - 1; }
      if (inc1 && b1 == b) c = c + 1;
      if (inc2 && b2 == b) c = c + 1;
      if (init) { h = 0; c = 0; }
      q_head[b] = h; q_cnt[b] = c;
    }
    if (inc1) { QPtr t = h1 + (QPtr)c1; addr_q[b1][t] = (PtAddr)(pair_cnt << 1); }
    if (inc2) { QPtr t = h2 + (QPtr)c2 + (QPtr)(same ? 1 : 0); addr_q[b2][t] = (PtAddr)((pair_cnt << 1) + 1); }
#if MSM_SC_LQ2 && MSM_SCHED != MSM_SCHED_RR
    #pragma hls_unroll yes
    WR_GROUPS: for (int g = 0; g < NG; ++g) {
      ga_c1[g] = ga[g].c1; ga_c2[g] = ga[g].c2; ga_i1[g] = ga[g].i1; ga_i2[g] = ga[g].i2;
    }
#endif
    lqa_v = acc && !acc_end;
    sel_reg = nsel; sel_reg_v = acc && !acc_end && nsel_v;
    const ac_int<3, false> ns =
      (start_cmd ? (ac_int<3,false>)(cmd.reduce ? RED : INIT) : (ac_int<3,false>)0) |
      (init_done ? (ac_int<3,false>)ACC : (ac_int<3,false>)0) |
      (red_end ? (ac_int<3,false>)OUT : (ac_int<3,false>)0);
    if (start_cmd || init_done || acc_end || red_end || output) state = ns;
    if (start_cmd) {
#ifndef __SYNTHESIS__
      sc_assert(cmd.context < GROUPS);
      sc_assert(inflight == 0 && !clr_pending && !rv && queued == 0);
#endif
      context = cmd.context;
      pairs = (cmd.n + 1) >> 1; pair_cnt = 0; queued = 0; clear_window = cmd.clear;
      init_addr = 0;
      red_i = 0; red_par = false; red_finished = false;
    }
    if (init_write && !init_done) init_addr = init_addr + 1;
    if (acc) { queued = queued + (inc1 ? 1 : 0) + (inc2 ? 1 : 0) - (pop ? 1 : 0); }
    if (push) pair_cnt = pair_cnt + 1;
    if (red_go) {
      if (red_par) { if (red_i == NB - 1) red_finished = true; else red_i = red_i + 1; }
      red_par = !red_par;
      p2_dst = (Tag)dst; p2_sb = sb;
    }
    ph2 = red_go;
    clr_pending = rv; clr_addr = wb_addr;
    // Count point reads as in flight, starting at pop, including arbitrary port delay.
    inflight = inflight + (wv ? 1 : 0) - (rv ? 1 : 0);
  }
private:
  enum { IDLE, INIT, ACC, RED, OUT };
  ac_int<3,false> state;
  Context context;
  bool clear_window, ph2, clr_pending; BAddr init_addr, clr_addr, p2_sb; Tag p2_dst; ScPoint opA_hold;
  Field br_x[CONTEXT_WORDS], br_y[CONTEXT_WORDS], br_z[CONTEXT_WORDS];
  // Only active-window hazards are tracked: NB buckets plus reduction scratch.
  bool busy[BRAM_SIZE];
  ac_int<10,false> inflight;
  PtAddr addr_q[1 << W][QDEPTH]; QPtr q_head[1 << W]; QCount q_cnt[1 << W];
  ac_int<LOGN+2,false> queued; Count pairs, pair_cnt;
  Bucket rr_ptr, sel_reg, lq_excl; bool sel_reg_v, lq_excl_v, lqa_v;
  QCount ga_c1[NG], ga_c2[NG]; Bucket ga_i1[NG], ga_i2[NG];
  ac_int<W+1,false> red_i; bool red_par, red_finished;
public:
  // Longest-queue dispatch: comparator trees over (count, index), ties -> lower index.
  // Compile-time recursion (no local arrays): pure comparator/mux trees between registers.
  struct Cand { QCount c; Bucket id; };
  struct Cand2 { QCount c1, c2; Bucket i1, i2; };
  Cand lq_leaf(int b) const {
    Cand r; r.id = b;
    bool ok = (b < NB) && !busy[b] && !(lq_excl_v && lq_excl == b);
    r.c = ok ? q_cnt[b] : (QCount)0;
    return r;
  }
  Cand2 lq_leaf2(int b) const {
    Cand l = lq_leaf(b); Cand2 r; r.c1 = l.c; r.i1 = l.id; r.c2 = 0; r.i2 = l.id; return r;
  }
  // stage-B leaf: group g's winner, or its runner-up when the winner is issued this cycle
  Cand lqb_leaf(int g) const {
    Cand r;
    bool rep = lq_excl_v && (ga_i1[g] == lq_excl);
    r.c  = rep ? ga_c2[g] : ga_c1[g];
    r.id = rep ? ga_i2[g] : ga_i1[g];
    return r;
  }
private:
  static Cand cmax(const Cand &a, const Cand &b) { return (b.c > a.c) ? b : a; }  // a: lower ids
  template<int LO, int N> struct LQTree {
    static Cand best(const RoundSched &s) {
      return cmax(LQTree<LO, N / 2>::best(s), LQTree<LO + N / 2, N / 2>::best(s));
    }
  };
  template<int LO> struct LQTree<LO, 1> {
    static Cand best(const RoundSched &s) { return s.lq_leaf(LO); }
  };
  void select_lq(Bucket &sel, bool &sel_v) {
    Cand best = LQTree<0, (1 << W)>::best(*this);
    sel = best.id; sel_v = (best.c != 0);
  }
  // best + runner-up tree (stage A)
  template<int LO, int N> struct LQ2Tree {
    static Cand2 best(const RoundSched &s) {
      Cand2 a = LQ2Tree<LO, N / 2>::best(s), b = LQ2Tree<LO + N / 2, N / 2>::best(s), r;
      if (b.c1 > a.c1) { r.c1 = b.c1; r.i1 = b.i1;
                         if (a.c1 >= b.c2) { r.c2 = a.c1; r.i2 = a.i1; } else { r.c2 = b.c2; r.i2 = b.i2; } }
      else             { r.c1 = a.c1; r.i1 = a.i1;
                         if (b.c1 > a.c2)  { r.c2 = b.c1; r.i2 = b.i1; } else { r.c2 = a.c2; r.i2 = a.i2; } }
      return r;
    }
  };
  template<int LO> struct LQ2Tree<LO, 1> {
    static Cand2 best(const RoundSched &s) { return s.lq_leaf2(LO); }
  };
  template<int G, bool END = (G >= NG)> struct LQA_ALL {
    static void run(const RoundSched &s, Cand2 ga[NG]) {
      ga[G] = LQ2Tree<G * GS, GS>::best(s);
      LQA_ALL<G + 1>::run(s, ga);
    }
  };
  template<int G> struct LQA_ALL<G, true> {
    static void run(const RoundSched &, Cand2 *) {}
  };
  // stage B tree over the NG group results
  template<int LO, int N> struct LQB {
    static Cand best(const RoundSched &s) { return cmax(LQB<LO, N / 2>::best(s), LQB<LO + N / 2, N / 2>::best(s)); }
  };
  template<int LO> struct LQB<LO, 1> {
    static Cand best(const RoundSched &s) { return s.lqb_leaf(LO); }
  };
  // Round-robin dispatch: next eligible bucket after rr_ptr.
  void select_rr(Bucket &sel, bool &sel_v) {
    enum { NP = 1 << W };
    sel_v = false; sel = 0;
    #pragma hls_unroll yes
    RR_SCAN: for (int k = 1; k <= NP; k++) {
      Bucket b = rr_ptr + k;
      if (!sel_v && b < NB && (q_cnt[b] != 0) && !busy[b] && !(lq_excl_v && lq_excl == b)) { sel = b; sel_v = true; }
    }
    if (sel_v) rr_ptr = sel;
  }


};
}
#endif
