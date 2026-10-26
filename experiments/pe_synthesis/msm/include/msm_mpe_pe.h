#ifndef MSM_MPE_PE_H
#define MSM_MPE_PE_H
#include "msm_mpe_sched.h"
#include "msm_sc_fetch.h"
#include "msm_padd.h"
#ifndef MSM_PENDING_DEPTH
#define MSM_PENDING_DEPTH 8
#endif
static_assert(MSM_PENDING_DEPTH >= 2 && (MSM_PENDING_DEPTH & (MSM_PENDING_DEPTH - 1)) == 0,
              "Pending FIFO depth must be a power of two >= 2");

class msm_mpe_pe : public sc_module {
public:
  sc_in<bool> CCS_INIT_S1(clk), CCS_INIT_S1(rst);
  Connections::In<msmmpe::RoundCmd> CCS_INIT_S1(cmd_in);
  Connections::Out<msmsc::ScPoint> CCS_INIT_S1(done_out);
  Connections::Out<msmmpe::ScalarReq> CCS_INIT_S1(sreq);
  Connections::In<msmmpe::ScalarResp> CCS_INIT_S1(sresp);
  Connections::Out<msmmpe::PointReq> CCS_INIT_S1(preq);
  Connections::In<msmmpe::PointResp> CCS_INIT_S1(presp);
  Connections::Combinational<msmmpe::RoundCmd> CCS_INIT_S1(sched_cmd), CCS_INIT_S1(fetch_cmd), CCS_INIT_S1(decode_cmd);
  Connections::Combinational<msmsc::DigitPair> CCS_INIT_S1(digits);
  Connections::Combinational<msmmpe::Work> CCS_INIT_S1(work);
  Connections::Combinational<msmsc::PaddReq> CCS_INIT_S1(req);
  Connections::Combinational<msmsc::PaddResp> CCS_INIT_S1(resp);
  msmmpe::RoundSched sched_core;
  MsmPadd padd_core;  // Persistent Tessera blackbox instance for this PE.

  SC_CTOR(msm_mpe_pe) {
    SC_THREAD(command_thread); sensitive << clk.pos(); reset_signal_is(rst, true);
    SC_THREAD(fetch_thread); sensitive << clk.pos(); reset_signal_is(rst, true);
    SC_THREAD(decode_thread); sensitive << clk.pos(); reset_signal_is(rst, true);
    SC_THREAD(sched_thread); sensitive << clk.pos(); reset_signal_is(rst, true);
    SC_THREAD(resolve_thread); sensitive << clk.pos(); reset_signal_is(rst, true);
    SC_THREAD(padd_thread); sensitive << clk.pos(); reset_signal_is(rst, true);
  }
  void command_thread() {
    cmd_in.Reset(); sched_cmd.ResetWrite(); fetch_cmd.ResetWrite(); wait();
    while (1) {
      msmmpe::RoundCmd c = cmd_in.Pop();
      sched_cmd.Push(c);
      if (!c.reduce) fetch_cmd.Push(c);
      wait();
    }
  }
  void fetch_thread() {
    fetch_cmd.ResetRead(); decode_cmd.ResetWrite(); sreq.Reset(); wait();
    while (1) {
      msmmpe::RoundCmd c = fetch_cmd.Pop(); decode_cmd.Push(c);
      msmsc::Count np = (c.n + 1) >> 1;
      #pragma hls_pipeline_init_interval 1
      #pragma pipeline_stall_mode flush
      for (msmsc::Count i = 0; i < np; ++i) {
        msmmpe::ScalarReq q; q.pair = (msmsc::PtAddr)i; sreq.Push(q); wait();
      }
    }
  }
  void decode_thread() {
    decode_cmd.ResetRead(); sresp.Reset(); digits.ResetWrite(); wait();
    while (1) {
      msmmpe::RoundCmd c = decode_cmd.Pop();
      msmsc::Count np = (c.n + 1) >> 1;
      #pragma hls_pipeline_init_interval 1
      #pragma pipeline_stall_mode flush
      for (msmsc::Count i = 0; i < np; ++i) {
        msmmpe::ScalarResp r = sresp.Pop(); msmsc::DigitPair d;
        d.d1 = msmsc::FetchCore::digit(r.a, c.win); d.d2 = msmsc::FetchCore::digit(r.b, c.win);
        d.v2 = ((msmsc::Count)((i << 1) + 1) < c.n);
        digits.Push(d); wait();
      }
    }
  }
  void sched_thread() {
    sched_cmd.ResetRead(); digits.ResetRead(); resp.ResetRead(); work.ResetWrite();
    preq.Reset(); done_out.Reset(); sched_core.reset();
    msmmpe::RoundCmd c; msmsc::DigitPair d; bool cv = false, dv = false;
    wait();
    #pragma hls_pipeline_init_interval 1
    #pragma pipeline_stall_mode flush
    while (1) {
      msmsc::PaddResp r; bool rv = resp.PopNB(r);
      if (!cv) cv = sched_cmd.PopNB(c);
      if (!dv) dv = digits.PopNB(d);
      bool ct, dt, wv, done; msmmpe::Work w; msmsc::ScPoint sum;
      sched_core.step(cv, c, ct, dv, d, dt, rv, r, wv, w, done, sum);
      if (ct) cv = false;
      if (dt) dv = false;
      if (wv) {
        if (w.external) { msmmpe::PointReq p; p.addr = w.addr; p.tag = w.add.tag; preq.Push(p); }
        work.Push(w);
      }
      if (done) done_out.Push(sum);
      wait();
    }
  }
  void resolve_thread() {
    work.ResetRead(); presp.Reset(); req.ResetWrite();
    // Decouple bucket operand capture from the variable-latency point response.
    // The FIFO accepts a new pop every cycle while older reads are in flight.
    msmmpe::Work pending[MSM_PENDING_DEPTH];
    ac_int<msmmpe::AddressBits<MSM_PENDING_DEPTH - 1>::value,false> head = 0, tail = 0;
    ac_int<msmmpe::AddressBits<MSM_PENDING_DEPTH>::value,false> count = 0; bool pv = false; msmmpe::PointResp point;
#if !defined(__SYNTHESIS__) && defined(MSM_STATS)
    unsigned int peak = 0; unsigned long long full_cycles = 0, cycles = 0;
#endif
    wait();
    #pragma hls_pipeline_init_interval 1
    #pragma pipeline_stall_mode flush
    while (1) {
#if !defined(__SYNTHESIS__) && defined(MSM_STATS)
      ++cycles;
      if (count == MSM_PENDING_DEPTH) ++full_cycles;
      if (count.to_uint() > peak) {
        peak = count.to_uint();
        fprintf(stderr, "MSM_PENDING pe=%s depth=%d peak=%u full_cycles=%llu resolver_cycles=%llu\n",
                name(), MSM_PENDING_DEPTH, peak, full_cycles, cycles);
      }
      if (count == 1 && full_cycles != 0) {
        fprintf(stderr, "MSM_PENDING_FULL pe=%s depth=%d full_cycles=%llu resolver_cycles=%llu\n",
                name(), MSM_PENDING_DEPTH, full_cycles, cycles);
        full_cycles = 0;
      }
#endif
      msmmpe::Work front = pending[head];
      if (!pv) pv = presp.PopNB(point);
      const bool issue = count != 0 && (!front.external || pv);
      msmmpe::Work incoming; const bool take = count < MSM_PENDING_DEPTH && work.PopNB(incoming);
      if (issue) {
        if (front.external) {
#ifndef __SYNTHESIS__
          sc_assert(point.tag == front.add.tag);
#endif
          front.add.b.X = point.x;
          front.add.b.Y = point.y;
          front.add.b.Z = MSM_FIELD_ONE;
          // Reserved affine (0,0) represents infinity for both supported curves.
          if (point.x == 0 && point.y == 0) front.add.b = msmsc::sc_inf();
          pv = false;
        }
        req.Push(front.add); head = head + 1;
      }
      if (take) { pending[tail] = incoming; tail = tail + 1; }
      count = count + (take ? 1 : 0) - (issue ? 1 : 0);
      wait();
    }
  }
  void padd_thread() {
    req.ResetRead(); resp.ResetWrite(); const ModOps be = msmsc::msm_sc_backend();
#ifndef __SYNTHESIS__
    msmsc::PaddResp delay[MSM_SIM_PADD_LATENCY]; bool valid[MSM_SIM_PADD_LATENCY]; int wr = 0;
    for (int i = 0; i < MSM_SIM_PADD_LATENCY; ++i) valid[i] = false;
#endif
    wait();
    #pragma hls_pipeline_init_interval 1
    #pragma pipeline_stall_mode flush
    while (1) {
#ifndef __SYNTHESIS__
      msmsc::PaddReq q; bool v = req.PopNB(q); msmsc::PaddResp r;
      if (v) { r.p = msmsc::pt2sc(msm_padd_dispatch(padd_core, msmsc::sc2pt(q.a), msmsc::sc2pt(q.b), be)); r.tag = q.tag; }
      bool ov = valid[wr]; msmsc::PaddResp o = delay[wr]; valid[wr] = v; delay[wr] = r;
      wr = (wr + 1) % MSM_SIM_PADD_LATENCY;
      if (ov) resp.Push(o);
#else
      msmsc::PaddReq q = req.Pop(); msmsc::PaddResp r;
      r.p = msmsc::pt2sc(msm_padd_dispatch(padd_core, msmsc::sc2pt(q.a), msmsc::sc2pt(q.b), be)); r.tag = q.tag;
      resp.Push(r);
#endif
      wait();
    }
  }
};
#endif
