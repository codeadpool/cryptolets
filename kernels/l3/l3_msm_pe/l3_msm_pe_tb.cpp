#include "l3_msm_pe_impl.h"
#include "tb_helper.h"
#include "ec_helper.h"
#include <deque>
#include <memory>

// The PE is a SystemC module, so one instance runs all rows in a single
// simulation. Each row clears its context first, so rows do not depend on
// each other. The testbench stands in for the scalar and point memories.

struct PeInput { msm::Scalar s; msm::Field x, y; };

enum { COL_CONTEXT, COL_WIN, COL_N, COL_POINTS };

SC_MODULE(l3_msm_pe_tb) {
  sc_clock clk;
  sc_signal<bool> rst;
  Connections::Combinational<msm::RoundCmd>   CCS_INIT_S1(cmd);
  Connections::Combinational<msm::ScPoint>    CCS_INIT_S1(done);
  Connections::Combinational<msm::ScalarReq>  CCS_INIT_S1(sreq);
  Connections::Combinational<msm::ScalarResp> CCS_INIT_S1(sresp);
  Connections::Combinational<msm::PointReq>   CCS_INIT_S1(preq);
  Connections::Combinational<msm::PointResp>  CCS_INIT_S1(presp);
  CCS_DESIGN(l3_msm_pe_impl) CCS_INIT_S1(dut);

  csv_t samples;
  string output_file;
  bool ok = false;

  // The points of the command in flight, which the memories serve
  vector<PeInput> tile;
  long scalar_reads = 0, point_reads = 0, scalar_pending = 0, point_pending = 0;

  SC_CTOR(l3_msm_pe_tb) : clk("clk", 1.0, SC_NS, 0.5, 0, SC_NS, true) {
    dut.clk(clk); dut.rst(rst); dut.cmd_in(cmd); dut.done_out(done);
    dut.sreq(sreq); dut.sresp(sresp); dut.preq(preq); dut.presp(presp);
    SC_THREAD(reset); sensitive << clk.posedge_event();
    SC_THREAD(driver); sensitive << clk.posedge_event(); reset_signal_is(rst, true);
    SC_THREAD(scalars); sensitive << clk.posedge_event(); reset_signal_is(rst, true);
    SC_THREAD(points); sensitive << clk.posedge_event(); reset_signal_is(rst, true);
  }

  void reset() { rst.write(true); wait(5); rst.write(false); wait(); }

  // Scalar memory: one cycle latency, then stalls 2 of every 11 cycles
  void scalars() {
    sreq.ResetRead(); sresp.ResetWrite();
    deque<pair<long, msm::ScalarResp>> pending; long cycle = 0; wait();
    while (1) {
      msm::ScalarReq q;
      if (sreq.PopNB(q)) {
        int a = q.pair.to_int() * 2;
        sc_assert(a >= 0 && a < (int)tile.size());
        msm::ScalarResp r; r.a = tile[a].s;
        r.b = a + 1 < (int)tile.size() ? tile[a + 1].s : msm::Scalar(0);
        pending.emplace_back(cycle + 1, r); ++scalar_pending; ++scalar_reads;
      }
      if (!pending.empty() && pending.front().first <= cycle && cycle % 11 >= 2) {
        sresp.Push(pending.front().second); pending.pop_front(); --scalar_pending;
      }
      ++cycle; wait();
    }
  }

  // Point memory: three cycle latency, then stalls 2 of every 7 cycles
  void points() {
    preq.ResetRead(); presp.ResetWrite();
    deque<pair<long, msm::PointResp>> pending; long cycle = 0; wait();
    while (1) {
      msm::PointReq q;
      if (preq.PopNB(q)) {
        int a = q.addr.to_int();
        sc_assert(a >= 0 && a < (int)tile.size());
        msm::PointResp r; r.x = tile[a].x; r.y = tile[a].y; r.tag = q.tag;
        pending.emplace_back(cycle + 3, r); ++point_pending; ++point_reads;
      }
      if (!pending.empty() && pending.front().first <= cycle && cycle % 7 >= 2) {
        presp.Push(pending.front().second); pending.pop_front(); --point_pending;
      }
      ++cycle; wait();
    }
  }

  // One command. Each scalar pair is read once, and only the points with a nonzero digit.
  msm::ScPoint issue(msm::RoundCmd c, const vector<PeInput> &pts) {
    sc_assert(scalar_pending == 0 && point_pending == 0);
    tile = pts; c.n = pts.size(); scalar_reads = point_reads = 0;
    cmd.Push(c);
    msm::ScPoint r = done.Pop();
    sc_assert(scalar_pending == 0 && point_pending == 0);

    long want_points = 0;
    if (!c.reduce)
      for (const auto &p : pts)
        if (((p.s >> (c.win.to_uint() * msm::W)) & ((1 << msm::W) - 1)) != 0) ++want_points;
    const long want_scalars = c.reduce ? 0 : ((long)pts.size() + 1) / 2;
    sc_assert(scalar_reads == want_scalars && point_reads == want_points);
    return r;
  }

  // Clear the context, add the points in two tiles, then reduce to the window sum
  vector<string> run_per_row(const vector<string> &row) {
    const msm::Field q = FIELD::Q::VALUE();
    int n = stoi(row[COL_N]);
    vector<PeInput> pts;
    for (int i = 0; i < n; ++i) {
      PeInput p;
      // to_mont keeps (0, 0), so infinity stays (0, 0)
      p.x = to_mont<FIELD>(parse_ac_int<msm::FB>(row[COL_POINTS + 3 * i]), q);
      p.y = to_mont<FIELD>(parse_ac_int<msm::FB>(row[COL_POINTS + 3 * i + 1]), q);
      p.s = parse_ac_int<msm::SB>(row[COL_POINTS + 3 * i + 2]);
      pts.push_back(p);
    }

    msm::RoundCmd c;
    c.context = stoi(row[COL_CONTEXT]); c.win = stoi(row[COL_WIN]);
    c.clear = true; c.reduce = false;
    issue(c, vector<PeInput>(pts.begin(), pts.begin() + (n + 1) / 2));
    c.clear = false;
    if (n > 1) issue(c, vector<PeInput>(pts.begin() + (n + 1) / 2, pts.end()));
    c.reduce = true;
    msm::ScPoint r = issue(c, {});

    PointAff<FIELD> a = proj_to_aff<FIELD>(from_mont<FIELD>(msm::sc2pt(r), q), q);
    return {a.x.to_string(AC_DEC), a.y.to_string(AC_DEC)};
  }

  void driver() {
    cmd.ResetWrite(); done.ResetRead(); wait();
    csv_t samples_out;
    for (auto &row : samples) samples_out.push_back(run_per_row(row));
    ok = WriteCSV_Samples(output_file, samples_out);
    sc_stop();
  }
};

// required for sc verify flow in Catapult
int sc_main(int argc, char **argv) {
  sc_report_handler::set_actions("/IEEE_Std_1666/deprecated", SC_DO_NOTHING);
  unique_ptr<l3_msm_pe_tb> tb(new l3_msm_pe_tb("tb"));
  if (ReadCSV_Samples(argv[1], tb->samples) <= 0) return 1;
  tb->output_file = argv[2]; // samples_file, output_file
  // A deadlocked PE never stops the clock, so bound the run. A row takes
  // about 6k cycles, most of it the serial reduction.
  sc_start(100000.0 * tb->samples.size(), SC_NS);
  if (!tb->ok || sc_report_handler::get_count(SC_ERROR) > 0) {
    cout << "Simulation FAILED" << endl;
    return 1;
  }
  cout << "Simulation PASSED" << endl;
  return 0;
}
