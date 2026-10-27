#ifndef _L3_MSM_PE_IMPL_H_
#define _L3_MSM_PE_IMPL_H_

#include "l3_msm_pe_types.h"
#include "l3_msm_pe_sched.h"
#include "l3_msm_pe_padd.h"

// One MSM processing element: Pippenger bucket accumulation and reduction
// around a single pipelined PADD. Scalars, input points and the bucket SRAM
// are outside the PE. Unlike the other kernels this is a SystemC module, so
// the top is the module itself, not a generated wrapper around run().
class l3_msm_pe_impl : public sc_module {
public:
  sc_in<bool> CCS_INIT_S1(clk), CCS_INIT_S1(rst);
  Connections::In<msm::RoundCmd>    CCS_INIT_S1(cmd_in);
  Connections::Out<msm::ScPoint>    CCS_INIT_S1(done_out);
  Connections::Out<msm::ScalarReq>  CCS_INIT_S1(sreq);
  Connections::In<msm::ScalarResp>  CCS_INIT_S1(sresp);
  Connections::Out<msm::PointReq>   CCS_INIT_S1(preq);
  Connections::In<msm::PointResp>   CCS_INIT_S1(presp);

  Connections::Combinational<msm::RoundCmd>  CCS_INIT_S1(sched_cmd), CCS_INIT_S1(fetch_cmd), CCS_INIT_S1(decode_cmd);
  Connections::Combinational<msm::DigitPair> CCS_INIT_S1(digits);
  Connections::Combinational<msm::Work>      CCS_INIT_S1(work);
  Connections::Combinational<msm::PaddReq>   CCS_INIT_S1(req);
  Connections::Combinational<msm::PaddResp>  CCS_INIT_S1(resp);

  msm::RoundSched sched_core;
  msm::Padd padd_core;  // the blackboxed l2_point_add_rcb child

  SC_CTOR(l3_msm_pe_impl) {
    SC_THREAD(command_thread); sensitive << clk.pos(); reset_signal_is(rst, true);
    SC_THREAD(fetch_thread);   sensitive << clk.pos(); reset_signal_is(rst, true);
    SC_THREAD(decode_thread);  sensitive << clk.pos(); reset_signal_is(rst, true);
    SC_THREAD(sched_thread);   sensitive << clk.pos(); reset_signal_is(rst, true);
    SC_THREAD(resolve_thread); sensitive << clk.pos(); reset_signal_is(rst, true);
    SC_THREAD(padd_thread);    sensitive << clk.pos(); reset_signal_is(rst, true);
  }

  // Fans a round out to the scheduler and, for accumulation, the scalar fetch
  void command_thread() {
    cmd_in.Reset(); sched_cmd.ResetWrite(); fetch_cmd.ResetWrite(); wait();
    while (1) {
      msm::RoundCmd c = cmd_in.Pop();
      sched_cmd.Push(c);
      if (!c.reduce) fetch_cmd.Push(c);
      wait();
    }
  }

  // Requests the scalars two at a time
  void fetch_thread() {
    fetch_cmd.ResetRead(); decode_cmd.ResetWrite(); sreq.Reset(); wait();
    while (1) {
      msm::RoundCmd c = fetch_cmd.Pop(); decode_cmd.Push(c);
      msm::Count np = (c.n + 1) >> 1;
      #pragma hls_pipeline_init_interval 1
      #pragma pipeline_stall_mode flush
      for (msm::Count i = 0; i < np; ++i) {
        msm::ScalarReq q; q.pair = (msm::PtAddr)i; sreq.Push(q); wait();
      }
    }
  }

  // Cuts the window digit out of each scalar pair
  void decode_thread() {
    decode_cmd.ResetRead(); sresp.Reset(); digits.ResetWrite(); wait();
    while (1) {
      msm::RoundCmd c = decode_cmd.Pop();
      msm::Count np = (c.n + 1) >> 1;
      #pragma hls_pipeline_init_interval 1
      #pragma pipeline_stall_mode flush
      for (msm::Count i = 0; i < np; ++i) {
        msm::ScalarResp r = sresp.Pop(); msm::DigitPair d;
        d.d1 = msm::digit(r.a, c.win); d.d2 = msm::digit(r.b, c.win);
        d.v2 = ((msm::Count)((i << 1) + 1) < c.n);
        digits.Push(d); wait();
      }
    }
  }

  void sched_thread() {
    sched_cmd.ResetRead(); digits.ResetRead(); resp.ResetRead(); work.ResetWrite();
    preq.Reset(); done_out.Reset(); sched_core.reset();
    msm::RoundCmd c; msm::DigitPair d; bool cv = false, dv = false;
    wait();
    #pragma hls_pipeline_init_interval 1
    #pragma pipeline_stall_mode flush
    while (1) {
      msm::PaddResp r; bool rv = resp.PopNB(r);
      if (!cv) cv = sched_cmd.PopNB(c);
      if (!dv) dv = digits.PopNB(d);
      bool ct, dt, wv, done; msm::Work w; msm::ScPoint sum;
      sched_core.step(cv, c, ct, dv, d, dt, rv, r, wv, w, done, sum);
      if (ct) cv = false;
      if (dt) dv = false;
      if (wv) {
        if (w.external) { msm::PointReq p; p.addr = w.addr; p.tag = w.add.tag; preq.Push(p); }
        work.Push(w);
      }
      if (done) done_out.Push(sum);
      wait();
    }
  }

  // Holds work until its input point returns, so the point latency can vary
  void resolve_thread() {
    work.ResetRead(); presp.Reset(); req.ResetWrite();
    msm::Work pending[MSM_PENDING_DEPTH];
    ac_int<msm::AddressBits<MSM_PENDING_DEPTH - 1>::value, false> head = 0, tail = 0;
    ac_int<msm::AddressBits<MSM_PENDING_DEPTH>::value, false> count = 0;
    bool pv = false; msm::PointResp point;
    wait();
    #pragma hls_pipeline_init_interval 1
    #pragma pipeline_stall_mode flush
    while (1) {
      msm::Work front = pending[head];
      if (!pv) pv = presp.PopNB(point);
      const bool issue = count != 0 && (!front.external || pv);
      msm::Work incoming; const bool take = count < MSM_PENDING_DEPTH && work.PopNB(incoming);
      if (issue) {
        if (front.external) {
#ifndef __SYNTHESIS__
          sc_assert(point.tag == front.add.tag);
#endif
          front.add.b.X = point.x;
          front.add.b.Y = point.y;
          front.add.b.Z = msm::mont_one();
          // Affine (0, 0) is not on either curve, so it encodes infinity
          if (point.x == 0 && point.y == 0) front.add.b = msm::sc_inf();
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
    req.ResetRead(); resp.ResetWrite();
#ifndef __SYNTHESIS__
    // The C++ model has no PADD pipeline, so a delay line stands in for it
    msm::PaddResp delay[MSM_SIM_PADD_LATENCY]; bool valid[MSM_SIM_PADD_LATENCY]; int wr = 0;
    for (int i = 0; i < MSM_SIM_PADD_LATENCY; ++i) valid[i] = false;
#endif
    wait();
    #pragma hls_pipeline_init_interval 1
    #pragma pipeline_stall_mode flush
    while (1) {
#ifndef __SYNTHESIS__
      msm::PaddReq q; bool v = req.PopNB(q); msm::PaddResp r;
      if (v) { r.p = msm::pt2sc(padd_core.run(msm::sc2pt(q.a), msm::sc2pt(q.b))); r.tag = q.tag; }
      bool ov = valid[wr]; msm::PaddResp o = delay[wr]; valid[wr] = v; delay[wr] = r;
      wr = (wr + 1) % MSM_SIM_PADD_LATENCY;
      if (ov) resp.Push(o);
#else
      msm::PaddReq q = req.Pop(); msm::PaddResp r;
      r.p = msm::pt2sc(padd_core.run(msm::sc2pt(q.a), msm::sc2pt(q.b))); r.tag = q.tag;
      resp.Push(r);
#endif
      wait();
    }
  }
};

#endif /* _L3_MSM_PE_IMPL_H_ */
