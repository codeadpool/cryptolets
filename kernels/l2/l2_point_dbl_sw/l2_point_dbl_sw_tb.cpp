#include "l2_point_dbl_sw_top.h"
#include "tb_helper.h"
#include "ec_helper.h"

#if MRED == MRED_BAR
static constexpr int RC_W = 2*BITWIDTH;
#else
static constexpr int RC_W = BITWIDTH;
#endif

vector<string> run_per_row(vector<string>& samples_row) {
  // The sample is a Jacobian point with a random Z
  PointJac<FIELD> P0;
  P0.X = parse_ac_int<BITWIDTH>(samples_row[0]);
  P0.Y = parse_ac_int<BITWIDTH>(samples_row[1]);
  P0.Z = parse_ac_int<BITWIDTH>(samples_row[2]);
  ac_int<BITWIDTH, false> q = parse_ac_int<BITWIDTH>(samples_row[3]);
  ac_int<RC_W, false> rc = parse_ac_int<RC_W>(samples_row[4]);

#if MRED == MRED_MONT
  P0 = to_mont<FIELD>(P0, q);
#endif

  PointJac<FIELD> R;
  CCS_DESIGN(l2_point_dbl_sw_top) dut;

  // q and rc are ports only when they are variable
  dut.run(P0,
#if Q_TYPE != FIXED_Q
          q,
#endif
#if RC_TYPE != FIXED_RC
          rc,
#endif
          R);

#if MRED == MRED_MONT
  R = from_mont<FIELD>(R, q);
#endif

  PointAff<FIELD> A = jac_to_aff<FIELD>(R, q);
  return {A.x.to_string(AC_DEC), A.y.to_string(AC_DEC)};
}

// required for sc verify flow in Catapult
CCS_MAIN(int argc, char** argv) {
  run_tb(run_per_row, argv[1], argv[2]); // samples_file, output_file
  CCS_RETURN(0);
}
