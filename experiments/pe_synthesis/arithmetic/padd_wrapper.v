module l2_msm_padd_rcb_d7267ca0d90c7363 (clk, rst, P0_X, P0_Y, P0_Z, P1_X, P1_Y, P1_Z, R_X, R_Y, R_Z);
  input clk;
  input rst;
  input [380:0] P0_X;
  input [380:0] P0_Y;
  input [380:0] P0_Z;
  input [380:0] P1_X;
  input [380:0] P1_Y;
  input [380:0] P1_Z;
  output [380:0] R_X;
  output [380:0] R_Y;
  output [380:0] R_Z;
  l2_msm_padd_rcb_d7267ca0d90c7363_top u (
    .clk(clk),    .rst(rst),    .P0_X_rsc_dat(P0_X),    .P0_Y_rsc_dat(P0_Y),    .P0_Z_rsc_dat(P0_Z),    .P1_X_rsc_dat(P1_X),    .P1_Y_rsc_dat(P1_Y),    .P1_Z_rsc_dat(P1_Z),    .R_X_rsc_dat(R_X),    .R_Y_rsc_dat(R_Y),    .R_Z_rsc_dat(R_Z),    .P0_X_triosy_lz(),    .P0_Y_triosy_lz(),    .P0_Z_triosy_lz(),    .P1_X_triosy_lz(),    .P1_Y_triosy_lz(),    .P1_Z_triosy_lz(),    .R_X_triosy_lz(),    .R_Y_triosy_lz(),    .R_Z_triosy_lz()  );
endmodule
