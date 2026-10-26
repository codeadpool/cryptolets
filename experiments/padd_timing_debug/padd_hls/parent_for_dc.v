// Extracted reachable parent/helper modules; real child supplied by mapped DDC.
module l2_msm_padd_rcb (
  clk, rst, P0_X_rsc_dat, P0_X_triosy_lz, P0_Y_rsc_dat, P0_Y_triosy_lz, P0_Z_rsc_dat,
      P0_Z_triosy_lz, P1_X_rsc_dat, P1_X_triosy_lz, P1_Y_rsc_dat, P1_Y_triosy_lz,
      P1_Z_rsc_dat, P1_Z_triosy_lz, R_X_rsc_dat, R_X_triosy_lz, R_Y_rsc_dat, R_Y_triosy_lz,
      R_Z_rsc_dat, R_Z_triosy_lz
);
  input clk;
  input rst;
  input [380:0] P0_X_rsc_dat;
  output P0_X_triosy_lz;
  input [380:0] P0_Y_rsc_dat;
  output P0_Y_triosy_lz;
  input [380:0] P0_Z_rsc_dat;
  output P0_Z_triosy_lz;
  input [380:0] P1_X_rsc_dat;
  output P1_X_triosy_lz;
  input [380:0] P1_Y_rsc_dat;
  output P1_Y_triosy_lz;
  input [380:0] P1_Z_rsc_dat;
  output P1_Z_triosy_lz;
  output [380:0] R_X_rsc_dat;
  output R_X_triosy_lz;
  output [380:0] R_Y_rsc_dat;
  output R_Y_triosy_lz;
  output [380:0] R_Z_rsc_dat;
  output R_Z_triosy_lz;



  // Interconnect Declarations for Component Instantiations 
  l2_msm_padd_rcb_run l2_msm_padd_rcb_run_inst (
      .clk(clk),
      .rst(rst),
      .P0_X_rsc_dat(P0_X_rsc_dat),
      .P0_X_triosy_lz(P0_X_triosy_lz),
      .P0_Y_rsc_dat(P0_Y_rsc_dat),
      .P0_Y_triosy_lz(P0_Y_triosy_lz),
      .P0_Z_rsc_dat(P0_Z_rsc_dat),
      .P0_Z_triosy_lz(P0_Z_triosy_lz),
      .P1_X_rsc_dat(P1_X_rsc_dat),
      .P1_X_triosy_lz(P1_X_triosy_lz),
      .P1_Y_rsc_dat(P1_Y_rsc_dat),
      .P1_Y_triosy_lz(P1_Y_triosy_lz),
      .P1_Z_rsc_dat(P1_Z_rsc_dat),
      .P1_Z_triosy_lz(P1_Z_triosy_lz),
      .R_X_rsc_dat(R_X_rsc_dat),
      .R_X_triosy_lz(R_X_triosy_lz),
      .R_Y_rsc_dat(R_Y_rsc_dat),
      .R_Y_triosy_lz(R_Y_triosy_lz),
      .R_Z_rsc_dat(R_Z_rsc_dat),
      .R_Z_triosy_lz(R_Z_triosy_lz)
    );
endmodule

module l2_msm_padd_rcb_run (
  clk, rst, P0_X_rsc_dat, P0_X_triosy_lz, P0_Y_rsc_dat, P0_Y_triosy_lz, P0_Z_rsc_dat,
      P0_Z_triosy_lz, P1_X_rsc_dat, P1_X_triosy_lz, P1_Y_rsc_dat, P1_Y_triosy_lz,
      P1_Z_rsc_dat, P1_Z_triosy_lz, R_X_rsc_dat, R_X_triosy_lz, R_Y_rsc_dat, R_Y_triosy_lz,
      R_Z_rsc_dat, R_Z_triosy_lz
);
  input clk;
  input rst;
  input [380:0] P0_X_rsc_dat;
  output P0_X_triosy_lz;
  input [380:0] P0_Y_rsc_dat;
  output P0_Y_triosy_lz;
  input [380:0] P0_Z_rsc_dat;
  output P0_Z_triosy_lz;
  input [380:0] P1_X_rsc_dat;
  output P1_X_triosy_lz;
  input [380:0] P1_Y_rsc_dat;
  output P1_Y_triosy_lz;
  input [380:0] P1_Z_rsc_dat;
  output P1_Z_triosy_lz;
  output [380:0] R_X_rsc_dat;
  output R_X_triosy_lz;
  output [380:0] R_Y_rsc_dat;
  output R_Y_triosy_lz;
  output [380:0] R_Z_rsc_dat;
  output R_Z_triosy_lz;


  // Interconnect Declarations
  wire [380:0] P0_X_rsci_idat;
  wire [380:0] P0_Y_rsci_idat;
  wire [380:0] P0_Z_rsci_idat;
  wire [380:0] P1_X_rsci_idat;
  wire [380:0] P1_Y_rsci_idat;
  wire [380:0] P1_Z_rsci_idat;
  reg [380:0] R_X_rsci_idat;
  reg [380:0] R_Y_rsci_idat;
  reg [380:0] R_Z_rsci_idat;
  wire [380:0] modmul_inst_rtl_cmp_z;
  wire [380:0] modmul_inst_rtl_cmp_1_z;
  wire [380:0] modmul_inst_rtl_cmp_2_z;
  wire [380:0] modmul_inst_rtl_cmp_3_z;
  wire [380:0] modmul_inst_rtl_cmp_4_z;
  wire [380:0] modmul_inst_rtl_cmp_5_z;
  wire [380:0] modmul_inst_rtl_cmp_6_z;
  wire [380:0] modmul_inst_rtl_cmp_7_z;
  wire [380:0] modmul_inst_rtl_cmp_8_z;
  wire [380:0] modmul_inst_rtl_cmp_9_z;
  wire [380:0] modmul_inst_rtl_cmp_10_z;
  wire [380:0] modmul_inst_rtl_cmp_11_z;
  wire [380:0] modadd_inst_int_sub_inst_run_17_acc_tmp;
  wire [381:0] nl_modadd_inst_int_sub_inst_run_17_acc_tmp;
  wire [381:0] modsub_inst_int_sub_inst_run_4_acc_1_tmp;
  wire [382:0] nl_modsub_inst_int_sub_inst_run_4_acc_1_tmp;
  wire [380:0] modadd_inst_int_sub_inst_run_12_acc_tmp;
  wire [381:0] nl_modadd_inst_int_sub_inst_run_12_acc_tmp;
  wire [382:0] inst_modadd_inst_run_7_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_7_reduced_out_sva_1;
  wire [382:0] inst_modadd_inst_run_6_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_6_reduced_out_sva_1;
  wire [382:0] inst_modadd_inst_run_4_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_4_reduced_out_sva_1;
  wire [382:0] inst_modadd_inst_run_3_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_3_reduced_out_sva_1;
  wire [382:0] inst_modadd_inst_run_1_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_1_reduced_out_sva_1;
  wire [382:0] inst_modadd_inst_run_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_reduced_out_sva_1;
  wire [382:0] inst_modadd_inst_run_10_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_10_reduced_out_sva_1;
  wire [380:0] modadd_inst_int_sub_inst_run_9_acc_psp_sva_1;
  wire [381:0] nl_modadd_inst_int_sub_inst_run_9_acc_psp_sva_1;
  wire [381:0] inst_modsub_inst_run_2_diff_sva_1;
  wire [382:0] inst_modadd_inst_run_8_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_8_reduced_out_sva_1;
  wire [381:0] inst_modsub_inst_run_1_diff_sva_1;
  wire [382:0] nl_inst_modsub_inst_run_1_diff_sva_1;
  wire [382:0] inst_modadd_inst_run_5_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_5_reduced_out_sva_1;
  wire [381:0] inst_modsub_inst_run_diff_sva_1;
  wire [382:0] nl_inst_modsub_inst_run_diff_sva_1;
  wire [382:0] inst_modadd_inst_run_2_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_2_reduced_out_sva_1;
  wire [382:0] inst_modadd_inst_run_19_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_19_reduced_out_sva_1;
  wire [377:0] inst_modadd_inst_run_17_qr_380_3_lpi_1_dfm_mx0;
  wire inst_modadd_inst_run_17_qr_2_lpi_1_dfm_mx0;
  wire [381:0] inst_modsub_inst_run_3_diff_sva_1;
  wire [382:0] nl_inst_modsub_inst_run_3_diff_sva_1;
  wire [382:0] inst_modadd_inst_run_15_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_15_reduced_out_sva_1;
  wire [382:0] inst_modadd_inst_run_14_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_14_reduced_out_sva_1;
  wire [382:0] inst_modadd_inst_run_21_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_21_reduced_out_sva_1;
  wire [382:0] inst_modadd_inst_run_20_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_20_reduced_out_sva_1;
  wire [380:0] modadd_inst_int_sub_inst_run_16_acc_psp_sva_1;
  wire [381:0] nl_modadd_inst_int_sub_inst_run_16_acc_psp_sva_1;
  wire [377:0] inst_modadd_inst_run_12_qr_380_3_lpi_1_dfm_mx0;
  wire inst_modadd_inst_run_12_qr_2_lpi_1_dfm_mx0;
  wire [380:0] modadd_inst_int_sub_inst_run_11_acc_psp_sva_1;
  wire [381:0] nl_modadd_inst_int_sub_inst_run_11_acc_psp_sva_1;
  reg main_stage_0_16;
  reg inst_modadd_inst_run_16_slc_modadd_inst_int_sub_inst_run_16_acc_psp_380_3_itm_1;
  reg reg_R_X_triosy_obj_ld_cse;
  reg reg_P1_Z_triosy_obj_ld_cse;
  wire [380:0] l1_mod_mul_impl_BLS12_381_BASE_0_run_11_mux1h_rmff;
  wire [380:0] l1_mod_mul_impl_BLS12_381_BASE_0_run_9_mux1h_rmff;
  wire [380:0] l1_mod_mul_impl_BLS12_381_BASE_0_run_8_mux1h_rmff;
  wire [380:0] inst_modadd_inst_run_10_qr_lpi_1_dfm_1_1;
  wire [380:0] inst_modsub_inst_run_qr_lpi_1_dfm_1_1;
  reg [380:0] inst_modadd_inst_run_10_qr_lpi_1_dfm_1;
  reg [380:0] inst_modsub_inst_run_qr_lpi_1_dfm_1;
  wire [381:0] inst_modadd_inst_run_6_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_6_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_7_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_7_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_3_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_3_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_4_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_4_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_1_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_1_adder_out_sva_1;
  reg [380:0] inst_modsub_inst_run_1_qr_lpi_1_dfm_1;
  wire CO_out;
  reg main_stage_0_3;
  reg main_stage_0_4;
  reg main_stage_0_5;
  reg main_stage_0_6;
  reg main_stage_0_7;
  reg main_stage_0_8;
  reg main_stage_0_9;
  reg main_stage_0_10;
  reg main_stage_0_11;
  reg main_stage_0_12;
  reg main_stage_0_13;
  reg main_stage_0_14;
  reg main_stage_0_15;
  reg [380:0] l2_msm_padd_rcb_impl_FIELD_0_run_t0_1_sva_1;
  reg [380:0] l2_msm_padd_rcb_impl_FIELD_0_run_t1_1_sva_1;
  reg [380:0] l2_msm_padd_rcb_impl_FIELD_0_run_t1_1_sva_2;
  reg [380:0] l2_msm_padd_rcb_impl_FIELD_0_run_t2_1_sva_1;
  reg [380:0] modsub_inst_int_sub_inst_run_x_sva_1;
  reg [380:0] modsub_inst_int_sub_inst_run_x_1_sva_1;
  reg [380:0] modsub_inst_int_sub_inst_run_x_2_sva_1;
  reg [381:0] inst_modadd_inst_run_14_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_14_adder_out_sva_1;
  reg [378:0] inst_modadd_inst_run_16_qr_380_2_lpi_1_dfm_1;
  reg [380:0] modsub_inst_int_sub_inst_run_y_4_sva_1;
  reg [380:0] inst_modsub_inst_run_a_4_sva_1;
  reg [380:0] modadd_inst_int_add_inst_run_y_20_sva_1;
  reg [380:0] inst_modadd_inst_run_a_20_sva_1;
  reg [380:0] inst_modadd_inst_run_b_21_sva_1;
  reg [380:0] inst_modadd_inst_run_b_21_sva_2;
  reg [380:0] modadd_inst_int_add_inst_run_x_21_sva_1;
  reg l2_msm_padd_rcb_impl_FIELD_0_run_slc_inst_modsub_inst_run_2_qr_0_itm_1;
  wire [381:0] inst_modadd_inst_run_21_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_21_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_20_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_20_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_19_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_19_adder_out_sva_1;
  wire [380:0] modadd_inst_int_sub_inst_run_18_acc_psp_sva_1;
  wire [381:0] nl_modadd_inst_int_sub_inst_run_18_acc_psp_sva_1;
  wire [380:0] inst_modadd_inst_run_14_qr_lpi_1_dfm_mx0;
  wire [381:0] inst_modadd_inst_run_15_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_15_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_10_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_10_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_8_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_8_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_5_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_5_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_2_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_2_adder_out_sva_1;
  wire [380:0] inst_modsub_inst_run_2_qr_lpi_1_dfm_mx0;
  wire [380:0] modadd_inst_int_sub_inst_run_13_acc_psp_sva_1;
  wire [381:0] nl_modadd_inst_int_sub_inst_run_13_acc_psp_sva_1;
  wire [378:0] inst_modadd_inst_run_11_qr_380_2_lpi_1_dfm_mx0;

  wire[380:0] modsub_inst_int_add_inst_run_4_acc_nl;
  wire[381:0] nl_modsub_inst_int_add_inst_run_4_acc_nl;
  wire[380:0] modsub_inst_int_add_inst_run_3_acc_nl;
  wire[381:0] nl_modsub_inst_int_add_inst_run_3_acc_nl;
  wire[380:0] modsub_inst_int_add_inst_run_1_acc_nl;
  wire[381:0] nl_modsub_inst_int_add_inst_run_1_acc_nl;
  wire[376:0] inst_modadd_inst_run_13_mux_nl;
  wire inst_modadd_inst_run_13_mux_1_nl;
  wire inst_modadd_inst_run_13_mux_2_nl;
  wire[380:0] modsub_inst_int_add_inst_run_acc_nl;
  wire[381:0] nl_modsub_inst_int_add_inst_run_acc_nl;
  wire[376:0] inst_modadd_inst_run_18_mux_nl;
  wire inst_modadd_inst_run_18_mux_1_nl;
  wire inst_modadd_inst_run_18_mux_2_nl;
  wire[380:0] inst_modadd_inst_run_2_mux_nl;
  wire[378:0] inst_modadd_inst_run_9_mux_nl;
  wire[380:0] inst_modadd_inst_run_5_mux_nl;
  wire[380:0] modsub_inst_int_add_inst_run_2_acc_nl;
  wire[381:0] nl_modsub_inst_int_add_inst_run_2_acc_nl;

  // Interconnect Declarations for Component Instantiations 
  wire [380:0] nl_modmul_inst_rtl_cmp_7_x;
  assign nl_modmul_inst_rtl_cmp_7_x = MUX_v_381_2_2((inst_modadd_inst_run_6_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_6_adder_out_sva_1[380:0]), inst_modadd_inst_run_6_reduced_out_sva_1[382]);
  wire [380:0] nl_modmul_inst_rtl_cmp_7_y;
  assign nl_modmul_inst_rtl_cmp_7_y = MUX_v_381_2_2((inst_modadd_inst_run_7_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_7_adder_out_sva_1[380:0]), inst_modadd_inst_run_7_reduced_out_sva_1[382]);
  wire [380:0] nl_modmul_inst_rtl_cmp_8_x;
  assign nl_modmul_inst_rtl_cmp_8_x = MUX_v_381_2_2((inst_modadd_inst_run_3_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_3_adder_out_sva_1[380:0]), inst_modadd_inst_run_3_reduced_out_sva_1[382]);
  wire [380:0] nl_modmul_inst_rtl_cmp_8_y;
  assign nl_modmul_inst_rtl_cmp_8_y = MUX_v_381_2_2((inst_modadd_inst_run_4_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_4_adder_out_sva_1[380:0]), inst_modadd_inst_run_4_reduced_out_sva_1[382]);
  wire [380:0] nl_modmul_inst_rtl_cmp_9_x;
  assign nl_modmul_inst_rtl_cmp_9_x = MUX_v_381_2_2((inst_modadd_inst_run_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_adder_out_sva_1[380:0]), inst_modadd_inst_run_reduced_out_sva_1[382]);
  wire [380:0] nl_modmul_inst_rtl_cmp_9_y;
  assign nl_modmul_inst_rtl_cmp_9_y = MUX_v_381_2_2((inst_modadd_inst_run_1_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_1_adder_out_sva_1[380:0]), inst_modadd_inst_run_1_reduced_out_sva_1[382]);
  wire [381:0] nl_modsub_inst_int_sub_inst_run_2_acc_1_rg_A;
  assign nl_modsub_inst_int_sub_inst_run_2_acc_1_rg_A = {1'b1 , modsub_inst_int_sub_inst_run_x_2_sva_1};
  wire[380:0] inst_modadd_inst_run_8_mux_nl;
  wire [381:0] nl_modsub_inst_int_sub_inst_run_2_acc_1_rg_B;
  assign inst_modadd_inst_run_8_mux_nl = MUX_v_381_2_2((inst_modadd_inst_run_8_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_8_adder_out_sva_1[380:0]), inst_modadd_inst_run_8_reduced_out_sva_1[382]);
  assign nl_modsub_inst_int_sub_inst_run_2_acc_1_rg_B = {1'b0, ~ inst_modadd_inst_run_8_mux_nl};
  ccs_in_v1 #(.rscid(32'sd4),
  .width(32'sd381)) P0_X_rsci (
      .dat(P0_X_rsc_dat),
      .idat(P0_X_rsci_idat)
    );
  ccs_in_v1 #(.rscid(32'sd5),
  .width(32'sd381)) P0_Y_rsci (
      .dat(P0_Y_rsc_dat),
      .idat(P0_Y_rsci_idat)
    );
  ccs_in_v1 #(.rscid(32'sd6),
  .width(32'sd381)) P0_Z_rsci (
      .dat(P0_Z_rsc_dat),
      .idat(P0_Z_rsci_idat)
    );
  ccs_in_v1 #(.rscid(32'sd7),
  .width(32'sd381)) P1_X_rsci (
      .dat(P1_X_rsc_dat),
      .idat(P1_X_rsci_idat)
    );
  ccs_in_v1 #(.rscid(32'sd8),
  .width(32'sd381)) P1_Y_rsci (
      .dat(P1_Y_rsc_dat),
      .idat(P1_Y_rsci_idat)
    );
  ccs_in_v1 #(.rscid(32'sd9),
  .width(32'sd381)) P1_Z_rsci (
      .dat(P1_Z_rsc_dat),
      .idat(P1_Z_rsci_idat)
    );
  ccs_out_v1 #(.rscid(32'sd10),
  .width(32'sd381)) R_X_rsci (
      .idat(R_X_rsci_idat),
      .dat(R_X_rsc_dat)
    );
  ccs_out_v1 #(.rscid(32'sd11),
  .width(32'sd381)) R_Y_rsci (
      .idat(R_Y_rsci_idat),
      .dat(R_Y_rsc_dat)
    );
  ccs_out_v1 #(.rscid(32'sd12),
  .width(32'sd381)) R_Z_rsci (
      .idat(R_Z_rsci_idat),
      .dat(R_Z_rsc_dat)
    );
  mgc_io_sync_v2 #(.valid(32'sd0)) P0_X_triosy_obj (
      .ld(reg_P1_Z_triosy_obj_ld_cse),
      .lz(P0_X_triosy_lz)
    );
  mgc_io_sync_v2 #(.valid(32'sd0)) P0_Y_triosy_obj (
      .ld(reg_P1_Z_triosy_obj_ld_cse),
      .lz(P0_Y_triosy_lz)
    );
  mgc_io_sync_v2 #(.valid(32'sd0)) P0_Z_triosy_obj (
      .ld(reg_P1_Z_triosy_obj_ld_cse),
      .lz(P0_Z_triosy_lz)
    );
  mgc_io_sync_v2 #(.valid(32'sd0)) P1_X_triosy_obj (
      .ld(reg_P1_Z_triosy_obj_ld_cse),
      .lz(P1_X_triosy_lz)
    );
  mgc_io_sync_v2 #(.valid(32'sd0)) P1_Y_triosy_obj (
      .ld(reg_P1_Z_triosy_obj_ld_cse),
      .lz(P1_Y_triosy_lz)
    );
  mgc_io_sync_v2 #(.valid(32'sd0)) P1_Z_triosy_obj (
      .ld(reg_P1_Z_triosy_obj_ld_cse),
      .lz(P1_Z_triosy_lz)
    );
  mgc_io_sync_v2 #(.valid(32'sd0)) R_X_triosy_obj (
      .ld(reg_R_X_triosy_obj_ld_cse),
      .lz(R_X_triosy_lz)
    );
  mgc_io_sync_v2 #(.valid(32'sd0)) R_Y_triosy_obj (
      .ld(reg_R_X_triosy_obj_ld_cse),
      .lz(R_Y_triosy_lz)
    );
  mgc_io_sync_v2 #(.valid(32'sd0)) R_Z_triosy_obj (
      .ld(reg_R_X_triosy_obj_ld_cse),
      .lz(R_Z_triosy_lz)
    );
  l1_mod_mul_d7267ca0d90c7363_regin  modmul_inst_rtl_cmp (
      .x(P0_X_rsci_idat),
      .y(P1_X_rsci_idat),
      .z(modmul_inst_rtl_cmp_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363_regin  modmul_inst_rtl_cmp_1 (
      .x(l1_mod_mul_impl_BLS12_381_BASE_0_run_11_mux1h_rmff),
      .y(inst_modsub_inst_run_1_qr_lpi_1_dfm_1),
      .z(modmul_inst_rtl_cmp_1_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363_regin  modmul_inst_rtl_cmp_2 (
      .x(inst_modadd_inst_run_10_qr_lpi_1_dfm_1_1),
      .y(inst_modsub_inst_run_qr_lpi_1_dfm_1_1),
      .z(modmul_inst_rtl_cmp_2_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363_regin  modmul_inst_rtl_cmp_3 (
      .x(l1_mod_mul_impl_BLS12_381_BASE_0_run_9_mux1h_rmff),
      .y(l1_mod_mul_impl_BLS12_381_BASE_0_run_11_mux1h_rmff),
      .z(modmul_inst_rtl_cmp_3_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363_regin  modmul_inst_rtl_cmp_4 (
      .x(l1_mod_mul_impl_BLS12_381_BASE_0_run_8_mux1h_rmff),
      .y(inst_modadd_inst_run_10_qr_lpi_1_dfm_1),
      .z(modmul_inst_rtl_cmp_4_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363_regin  modmul_inst_rtl_cmp_5 (
      .x(inst_modsub_inst_run_qr_lpi_1_dfm_1),
      .y(l1_mod_mul_impl_BLS12_381_BASE_0_run_9_mux1h_rmff),
      .z(modmul_inst_rtl_cmp_5_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363_regin  modmul_inst_rtl_cmp_6 (
      .x(inst_modsub_inst_run_1_qr_lpi_1_dfm_1),
      .y(l1_mod_mul_impl_BLS12_381_BASE_0_run_8_mux1h_rmff),
      .z(modmul_inst_rtl_cmp_6_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363_regin  modmul_inst_rtl_cmp_7 (
      .x(nl_modmul_inst_rtl_cmp_7_x[380:0]),
      .y(nl_modmul_inst_rtl_cmp_7_y[380:0]),
      .z(modmul_inst_rtl_cmp_7_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363_regin  modmul_inst_rtl_cmp_8 (
      .x(nl_modmul_inst_rtl_cmp_8_x[380:0]),
      .y(nl_modmul_inst_rtl_cmp_8_y[380:0]),
      .z(modmul_inst_rtl_cmp_8_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363_regin  modmul_inst_rtl_cmp_9 (
      .x(nl_modmul_inst_rtl_cmp_9_x[380:0]),
      .y(nl_modmul_inst_rtl_cmp_9_y[380:0]),
      .z(modmul_inst_rtl_cmp_9_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363_regin  modmul_inst_rtl_cmp_10 (
      .x(P0_Z_rsci_idat),
      .y(P1_Z_rsci_idat),
      .z(modmul_inst_rtl_cmp_10_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363_regin  modmul_inst_rtl_cmp_11 (
      .x(P0_Y_rsci_idat),
      .y(P1_Y_rsci_idat),
      .z(modmul_inst_rtl_cmp_11_z),
      .clk(clk),
      .rst(rst)
    );
  ccs_dw_add_v1 #(.width(32'sd382)) modsub_inst_int_sub_inst_run_2_acc_1_rg (
      .A(nl_modsub_inst_int_sub_inst_run_2_acc_1_rg_A[381:0]),
      .B(nl_modsub_inst_int_sub_inst_run_2_acc_1_rg_B[381:0]),
      .CI(1'b1),
      .SUM(inst_modsub_inst_run_2_diff_sva_1),
      .CO(CO_out)
    );
  assign l1_mod_mul_impl_BLS12_381_BASE_0_run_11_mux1h_rmff = MUX_v_381_2_2((inst_modadd_inst_run_15_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_15_adder_out_sva_1[380:0]), inst_modadd_inst_run_15_reduced_out_sva_1[382]);
  assign nl_modsub_inst_int_add_inst_run_3_acc_nl = (inst_modsub_inst_run_3_diff_sva_1[380:0])
      + 381'b110100000000100010001111010100011100101111111111001101001101001001011000110111010011110110110010000110100101110101100110101110110010001110111010010111000010011110011100001010001001010111111011001110011000011010010101000001111011010110000111101100010010000011110101010111111111111111110101100010101001111111111111111111011100111111110111111111111111111111111111111111010101010101011;
  assign modsub_inst_int_add_inst_run_3_acc_nl = nl_modsub_inst_int_add_inst_run_3_acc_nl[380:0];
  assign l1_mod_mul_impl_BLS12_381_BASE_0_run_9_mux1h_rmff = MUX_v_381_2_2((inst_modsub_inst_run_3_diff_sva_1[380:0]),
      modsub_inst_int_add_inst_run_3_acc_nl, inst_modsub_inst_run_3_diff_sva_1[381]);
  assign l1_mod_mul_impl_BLS12_381_BASE_0_run_8_mux1h_rmff = MUX_v_381_2_2((inst_modadd_inst_run_19_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_19_adder_out_sva_1[380:0]), inst_modadd_inst_run_19_reduced_out_sva_1[382]);
  assign nl_modsub_inst_int_sub_inst_run_4_acc_1_tmp = ({1'b1 , inst_modsub_inst_run_a_4_sva_1})
      + conv_u2s_381_382(~ modsub_inst_int_sub_inst_run_y_4_sva_1) + 382'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
  assign modsub_inst_int_sub_inst_run_4_acc_1_tmp = nl_modsub_inst_int_sub_inst_run_4_acc_1_tmp[381:0];
  assign nl_inst_modadd_inst_run_21_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_21_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_21_reduced_out_sva_1 = nl_inst_modadd_inst_run_21_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_21_adder_out_sva_1 = conv_u2u_381_382(inst_modadd_inst_run_b_21_sva_2)
      + conv_u2u_381_382(modadd_inst_int_add_inst_run_x_21_sva_1);
  assign inst_modadd_inst_run_21_adder_out_sva_1 = nl_inst_modadd_inst_run_21_adder_out_sva_1[381:0];
  assign nl_inst_modadd_inst_run_20_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_20_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_20_reduced_out_sva_1 = nl_inst_modadd_inst_run_20_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_20_adder_out_sva_1 = conv_u2u_381_382(inst_modadd_inst_run_a_20_sva_1)
      + conv_u2u_381_382(modadd_inst_int_add_inst_run_y_20_sva_1);
  assign inst_modadd_inst_run_20_adder_out_sva_1 = nl_inst_modadd_inst_run_20_adder_out_sva_1[381:0];
  assign nl_inst_modsub_inst_run_3_diff_sva_1 = ({1'b1 , l2_msm_padd_rcb_impl_FIELD_0_run_t1_1_sva_2})
      + conv_u2s_381_382(~ inst_modadd_inst_run_14_qr_lpi_1_dfm_mx0) + 382'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
  assign inst_modsub_inst_run_3_diff_sva_1 = nl_inst_modsub_inst_run_3_diff_sva_1[381:0];
  assign inst_modadd_inst_run_10_qr_lpi_1_dfm_1_1 = MUX_v_381_2_2((inst_modadd_inst_run_10_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_10_adder_out_sva_1[380:0]), inst_modadd_inst_run_10_reduced_out_sva_1[382]);
  assign nl_modsub_inst_int_add_inst_run_acc_nl = (inst_modsub_inst_run_diff_sva_1[380:0])
      + 381'b110100000000100010001111010100011100101111111111001101001101001001011000110111010011110110110010000110100101110101100110101110110010001110111010010111000010011110011100001010001001010111111011001110011000011010010101000001111011010110000111101100010010000011110101010111111111111111110101100010101001111111111111111111011100111111110111111111111111111111111111111111010101010101011;
  assign modsub_inst_int_add_inst_run_acc_nl = nl_modsub_inst_int_add_inst_run_acc_nl[380:0];
  assign inst_modsub_inst_run_qr_lpi_1_dfm_1_1 = MUX_v_381_2_2((inst_modsub_inst_run_diff_sva_1[380:0]),
      modsub_inst_int_add_inst_run_acc_nl, inst_modsub_inst_run_diff_sva_1[381]);
  assign nl_inst_modadd_inst_run_19_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_19_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_19_reduced_out_sva_1 = nl_inst_modadd_inst_run_19_reduced_out_sva_1[382:0];
  assign inst_modadd_inst_run_18_mux_nl = MUX_v_377_2_2((modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[378:2]),
      (inst_modadd_inst_run_17_qr_380_3_lpi_1_dfm_mx0[376:0]), modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[380]);
  assign inst_modadd_inst_run_18_mux_1_nl = MUX_s_1_2_2((modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[1]),
      inst_modadd_inst_run_17_qr_2_lpi_1_dfm_mx0, modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[380]);
  assign inst_modadd_inst_run_18_mux_2_nl = MUX_s_1_2_2((modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[0]),
      (~ inst_modadd_inst_run_16_slc_modadd_inst_int_sub_inst_run_16_acc_psp_380_3_itm_1),
      modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[380]);
  assign nl_inst_modadd_inst_run_19_adder_out_sva_1 = conv_u2u_381_382({inst_modadd_inst_run_17_qr_380_3_lpi_1_dfm_mx0
      , inst_modadd_inst_run_17_qr_2_lpi_1_dfm_mx0 , (~ inst_modadd_inst_run_16_slc_modadd_inst_int_sub_inst_run_16_acc_psp_380_3_itm_1)
      , (~ (modadd_inst_int_sub_inst_run_17_acc_tmp[380]))}) + conv_u2u_381_382({inst_modadd_inst_run_18_mux_nl
      , inst_modadd_inst_run_18_mux_1_nl , inst_modadd_inst_run_18_mux_2_nl , (~
      (modadd_inst_int_sub_inst_run_17_acc_tmp[380])) , (~ (modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[380]))});
  assign inst_modadd_inst_run_19_adder_out_sva_1 = nl_inst_modadd_inst_run_19_adder_out_sva_1[381:0];
  assign inst_modadd_inst_run_17_qr_380_3_lpi_1_dfm_mx0 = MUX_v_378_2_2((modadd_inst_int_sub_inst_run_17_acc_tmp[378:1]),
      (inst_modadd_inst_run_16_qr_380_2_lpi_1_dfm_1[377:0]), modadd_inst_int_sub_inst_run_17_acc_tmp[380]);
  assign inst_modadd_inst_run_17_qr_2_lpi_1_dfm_mx0 = MUX_s_1_2_2((modadd_inst_int_sub_inst_run_17_acc_tmp[0]),
      l2_msm_padd_rcb_impl_FIELD_0_run_slc_inst_modsub_inst_run_2_qr_0_itm_1, modadd_inst_int_sub_inst_run_17_acc_tmp[380]);
  assign nl_modadd_inst_int_sub_inst_run_17_acc_tmp = conv_u2u_380_381({inst_modadd_inst_run_16_qr_380_2_lpi_1_dfm_1
      , l2_msm_padd_rcb_impl_FIELD_0_run_slc_inst_modsub_inst_run_2_qr_0_itm_1})
      + 381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101;
  assign modadd_inst_int_sub_inst_run_17_acc_tmp = nl_modadd_inst_int_sub_inst_run_17_acc_tmp[380:0];
  assign nl_modadd_inst_int_sub_inst_run_18_acc_psp_sva_1 = conv_u2u_380_381({inst_modadd_inst_run_17_qr_380_3_lpi_1_dfm_mx0
      , inst_modadd_inst_run_17_qr_2_lpi_1_dfm_mx0 , (~ inst_modadd_inst_run_16_slc_modadd_inst_int_sub_inst_run_16_acc_psp_380_3_itm_1)})
      + 381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101;
  assign modadd_inst_int_sub_inst_run_18_acc_psp_sva_1 = nl_modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[380:0];
  assign inst_modadd_inst_run_14_qr_lpi_1_dfm_mx0 = MUX_v_381_2_2((inst_modadd_inst_run_14_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_14_adder_out_sva_1[380:0]), inst_modadd_inst_run_14_reduced_out_sva_1[382]);
  assign nl_inst_modadd_inst_run_15_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_15_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_15_reduced_out_sva_1 = nl_inst_modadd_inst_run_15_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_15_adder_out_sva_1 = conv_u2u_381_382(l2_msm_padd_rcb_impl_FIELD_0_run_t1_1_sva_2)
      + conv_u2u_381_382(inst_modadd_inst_run_14_qr_lpi_1_dfm_mx0);
  assign inst_modadd_inst_run_15_adder_out_sva_1 = nl_inst_modadd_inst_run_15_adder_out_sva_1[381:0];
  assign nl_inst_modadd_inst_run_14_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_14_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_14_reduced_out_sva_1 = nl_inst_modadd_inst_run_14_reduced_out_sva_1[382:0];
  assign inst_modadd_inst_run_2_mux_nl = MUX_v_381_2_2((inst_modadd_inst_run_2_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_2_adder_out_sva_1[380:0]), inst_modadd_inst_run_2_reduced_out_sva_1[382]);
  assign nl_inst_modsub_inst_run_diff_sva_1 = ({1'b1 , modsub_inst_int_sub_inst_run_x_sva_1})
      + conv_u2s_381_382(~ inst_modadd_inst_run_2_mux_nl) + 382'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
  assign inst_modsub_inst_run_diff_sva_1 = nl_inst_modsub_inst_run_diff_sva_1[381:0];
  assign nl_inst_modadd_inst_run_10_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_10_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_10_reduced_out_sva_1 = nl_inst_modadd_inst_run_10_reduced_out_sva_1[382:0];
  assign inst_modadd_inst_run_9_mux_nl = MUX_v_379_2_2((modadd_inst_int_sub_inst_run_9_acc_psp_sva_1[378:0]),
      (l2_msm_padd_rcb_impl_FIELD_0_run_t0_1_sva_1[379:1]), modadd_inst_int_sub_inst_run_9_acc_psp_sva_1[380]);
  assign nl_inst_modadd_inst_run_10_adder_out_sva_1 = conv_u2u_381_382(l2_msm_padd_rcb_impl_FIELD_0_run_t0_1_sva_1)
      + conv_u2u_381_382({inst_modadd_inst_run_9_mux_nl , (l2_msm_padd_rcb_impl_FIELD_0_run_t0_1_sva_1[0])
      , (~ (modadd_inst_int_sub_inst_run_9_acc_psp_sva_1[380]))});
  assign inst_modadd_inst_run_10_adder_out_sva_1 = nl_inst_modadd_inst_run_10_adder_out_sva_1[381:0];
  assign nl_modadd_inst_int_sub_inst_run_9_acc_psp_sva_1 = conv_u2u_380_381(l2_msm_padd_rcb_impl_FIELD_0_run_t0_1_sva_1[380:1])
      + 381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101;
  assign modadd_inst_int_sub_inst_run_9_acc_psp_sva_1 = nl_modadd_inst_int_sub_inst_run_9_acc_psp_sva_1[380:0];
  assign nl_inst_modadd_inst_run_8_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_8_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_8_reduced_out_sva_1 = nl_inst_modadd_inst_run_8_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_8_adder_out_sva_1 = conv_u2u_381_382(l2_msm_padd_rcb_impl_FIELD_0_run_t0_1_sva_1)
      + conv_u2u_381_382(l2_msm_padd_rcb_impl_FIELD_0_run_t2_1_sva_1);
  assign inst_modadd_inst_run_8_adder_out_sva_1 = nl_inst_modadd_inst_run_8_adder_out_sva_1[381:0];
  assign inst_modadd_inst_run_5_mux_nl = MUX_v_381_2_2((inst_modadd_inst_run_5_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_5_adder_out_sva_1[380:0]), inst_modadd_inst_run_5_reduced_out_sva_1[382]);
  assign nl_inst_modsub_inst_run_1_diff_sva_1 = ({1'b1 , modsub_inst_int_sub_inst_run_x_1_sva_1})
      + conv_u2s_381_382(~ inst_modadd_inst_run_5_mux_nl) + 382'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
  assign inst_modsub_inst_run_1_diff_sva_1 = nl_inst_modsub_inst_run_1_diff_sva_1[381:0];
  assign nl_inst_modadd_inst_run_5_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_5_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_5_reduced_out_sva_1 = nl_inst_modadd_inst_run_5_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_5_adder_out_sva_1 = conv_u2u_381_382(l2_msm_padd_rcb_impl_FIELD_0_run_t1_1_sva_1)
      + conv_u2u_381_382(l2_msm_padd_rcb_impl_FIELD_0_run_t2_1_sva_1);
  assign inst_modadd_inst_run_5_adder_out_sva_1 = nl_inst_modadd_inst_run_5_adder_out_sva_1[381:0];
  assign nl_inst_modadd_inst_run_2_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_2_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_2_reduced_out_sva_1 = nl_inst_modadd_inst_run_2_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_2_adder_out_sva_1 = conv_u2u_381_382(l2_msm_padd_rcb_impl_FIELD_0_run_t1_1_sva_1)
      + conv_u2u_381_382(l2_msm_padd_rcb_impl_FIELD_0_run_t0_1_sva_1);
  assign inst_modadd_inst_run_2_adder_out_sva_1 = nl_inst_modadd_inst_run_2_adder_out_sva_1[381:0];
  assign nl_inst_modadd_inst_run_7_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_7_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_7_reduced_out_sva_1 = nl_inst_modadd_inst_run_7_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_7_adder_out_sva_1 = conv_u2u_381_382(P1_X_rsci_idat)
      + conv_u2u_381_382(P1_Z_rsci_idat);
  assign inst_modadd_inst_run_7_adder_out_sva_1 = nl_inst_modadd_inst_run_7_adder_out_sva_1[381:0];
  assign nl_inst_modadd_inst_run_6_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_6_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_6_reduced_out_sva_1 = nl_inst_modadd_inst_run_6_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_6_adder_out_sva_1 = conv_u2u_381_382(P0_X_rsci_idat)
      + conv_u2u_381_382(P0_Z_rsci_idat);
  assign inst_modadd_inst_run_6_adder_out_sva_1 = nl_inst_modadd_inst_run_6_adder_out_sva_1[381:0];
  assign nl_inst_modadd_inst_run_4_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_4_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_4_reduced_out_sva_1 = nl_inst_modadd_inst_run_4_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_4_adder_out_sva_1 = conv_u2u_381_382(P1_Y_rsci_idat)
      + conv_u2u_381_382(P1_Z_rsci_idat);
  assign inst_modadd_inst_run_4_adder_out_sva_1 = nl_inst_modadd_inst_run_4_adder_out_sva_1[381:0];
  assign nl_inst_modadd_inst_run_3_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_3_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_3_reduced_out_sva_1 = nl_inst_modadd_inst_run_3_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_3_adder_out_sva_1 = conv_u2u_381_382(P0_Y_rsci_idat)
      + conv_u2u_381_382(P0_Z_rsci_idat);
  assign inst_modadd_inst_run_3_adder_out_sva_1 = nl_inst_modadd_inst_run_3_adder_out_sva_1[381:0];
  assign nl_inst_modadd_inst_run_1_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_1_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_1_reduced_out_sva_1 = nl_inst_modadd_inst_run_1_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_1_adder_out_sva_1 = conv_u2u_381_382(P1_X_rsci_idat)
      + conv_u2u_381_382(P1_Y_rsci_idat);
  assign inst_modadd_inst_run_1_adder_out_sva_1 = nl_inst_modadd_inst_run_1_adder_out_sva_1[381:0];
  assign nl_inst_modadd_inst_run_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_reduced_out_sva_1 = nl_inst_modadd_inst_run_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_adder_out_sva_1 = conv_u2u_381_382(P0_X_rsci_idat)
      + conv_u2u_381_382(P0_Y_rsci_idat);
  assign inst_modadd_inst_run_adder_out_sva_1 = nl_inst_modadd_inst_run_adder_out_sva_1[381:0];
  assign nl_modsub_inst_int_add_inst_run_2_acc_nl = (inst_modsub_inst_run_2_diff_sva_1[380:0])
      + 381'b110100000000100010001111010100011100101111111111001101001101001001011000110111010011110110110010000110100101110101100110101110110010001110111010010111000010011110011100001010001001010111111011001110011000011010010101000001111011010110000111101100010010000011110101010111111111111111110101100010101001111111111111111111011100111111110111111111111111111111111111111111010101010101011;
  assign modsub_inst_int_add_inst_run_2_acc_nl = nl_modsub_inst_int_add_inst_run_2_acc_nl[380:0];
  assign inst_modsub_inst_run_2_qr_lpi_1_dfm_mx0 = MUX_v_381_2_2((inst_modsub_inst_run_2_diff_sva_1[380:0]),
      modsub_inst_int_add_inst_run_2_acc_nl, inst_modsub_inst_run_2_diff_sva_1[381]);
  assign nl_modadd_inst_int_sub_inst_run_16_acc_psp_sva_1 = conv_u2u_380_381(inst_modsub_inst_run_2_qr_lpi_1_dfm_mx0[380:1])
      + 381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101;
  assign modadd_inst_int_sub_inst_run_16_acc_psp_sva_1 = nl_modadd_inst_int_sub_inst_run_16_acc_psp_sva_1[380:0];
  assign inst_modadd_inst_run_12_qr_380_3_lpi_1_dfm_mx0 = MUX_v_378_2_2((modadd_inst_int_sub_inst_run_12_acc_tmp[378:1]),
      (inst_modadd_inst_run_11_qr_380_2_lpi_1_dfm_mx0[377:0]), modadd_inst_int_sub_inst_run_12_acc_tmp[380]);
  assign inst_modadd_inst_run_12_qr_2_lpi_1_dfm_mx0 = MUX_s_1_2_2((modadd_inst_int_sub_inst_run_12_acc_tmp[0]),
      (l2_msm_padd_rcb_impl_FIELD_0_run_t2_1_sva_1[0]), modadd_inst_int_sub_inst_run_12_acc_tmp[380]);
  assign nl_modadd_inst_int_sub_inst_run_11_acc_psp_sva_1 = conv_u2u_380_381(l2_msm_padd_rcb_impl_FIELD_0_run_t2_1_sva_1[380:1])
      + 381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101;
  assign modadd_inst_int_sub_inst_run_11_acc_psp_sva_1 = nl_modadd_inst_int_sub_inst_run_11_acc_psp_sva_1[380:0];
  assign nl_modadd_inst_int_sub_inst_run_12_acc_tmp = conv_u2u_380_381({inst_modadd_inst_run_11_qr_380_2_lpi_1_dfm_mx0
      , (l2_msm_padd_rcb_impl_FIELD_0_run_t2_1_sva_1[0])}) + 381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101;
  assign modadd_inst_int_sub_inst_run_12_acc_tmp = nl_modadd_inst_int_sub_inst_run_12_acc_tmp[380:0];
  assign nl_modadd_inst_int_sub_inst_run_13_acc_psp_sva_1 = conv_u2u_380_381({inst_modadd_inst_run_12_qr_380_3_lpi_1_dfm_mx0
      , inst_modadd_inst_run_12_qr_2_lpi_1_dfm_mx0 , (~ (modadd_inst_int_sub_inst_run_11_acc_psp_sva_1[380]))})
      + 381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101;
  assign modadd_inst_int_sub_inst_run_13_acc_psp_sva_1 = nl_modadd_inst_int_sub_inst_run_13_acc_psp_sva_1[380:0];
  assign inst_modadd_inst_run_11_qr_380_2_lpi_1_dfm_mx0 = MUX_v_379_2_2((modadd_inst_int_sub_inst_run_11_acc_psp_sva_1[378:0]),
      (l2_msm_padd_rcb_impl_FIELD_0_run_t2_1_sva_1[379:1]), modadd_inst_int_sub_inst_run_11_acc_psp_sva_1[380]);
  always @(posedge clk) begin
    if ( rst ) begin
      reg_R_X_triosy_obj_ld_cse <= 1'b0;
      inst_modadd_inst_run_b_21_sva_2 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      modadd_inst_int_add_inst_run_x_21_sva_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      inst_modadd_inst_run_a_20_sva_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      modadd_inst_int_add_inst_run_y_20_sva_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      inst_modsub_inst_run_a_4_sva_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      modsub_inst_int_sub_inst_run_y_4_sva_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      inst_modsub_inst_run_1_qr_lpi_1_dfm_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      inst_modadd_inst_run_10_qr_lpi_1_dfm_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      inst_modsub_inst_run_qr_lpi_1_dfm_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      inst_modadd_inst_run_16_slc_modadd_inst_int_sub_inst_run_16_acc_psp_380_3_itm_1
          <= 1'b0;
      l2_msm_padd_rcb_impl_FIELD_0_run_slc_inst_modsub_inst_run_2_qr_0_itm_1 <= 1'b0;
      inst_modadd_inst_run_16_qr_380_2_lpi_1_dfm_1 <= 379'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l2_msm_padd_rcb_impl_FIELD_0_run_t1_1_sva_2 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      inst_modadd_inst_run_14_adder_out_sva_1 <= 382'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l2_msm_padd_rcb_impl_FIELD_0_run_t0_1_sva_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      modsub_inst_int_sub_inst_run_x_2_sva_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l2_msm_padd_rcb_impl_FIELD_0_run_t2_1_sva_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      modsub_inst_int_sub_inst_run_x_1_sva_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l2_msm_padd_rcb_impl_FIELD_0_run_t1_1_sva_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      modsub_inst_int_sub_inst_run_x_sva_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      reg_P1_Z_triosy_obj_ld_cse <= 1'b0;
      main_stage_0_7 <= 1'b0;
      main_stage_0_8 <= 1'b0;
      main_stage_0_9 <= 1'b0;
      main_stage_0_14 <= 1'b0;
      main_stage_0_15 <= 1'b0;
      main_stage_0_16 <= 1'b0;
      inst_modadd_inst_run_b_21_sva_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      main_stage_0_6 <= 1'b0;
      main_stage_0_13 <= 1'b0;
      main_stage_0_5 <= 1'b0;
      main_stage_0_12 <= 1'b0;
      main_stage_0_4 <= 1'b0;
      main_stage_0_11 <= 1'b0;
      main_stage_0_3 <= 1'b0;
      main_stage_0_10 <= 1'b0;
    end
    else begin
      reg_R_X_triosy_obj_ld_cse <= main_stage_0_16;
      inst_modadd_inst_run_b_21_sva_2 <= inst_modadd_inst_run_b_21_sva_1;
      modadd_inst_int_add_inst_run_x_21_sva_1 <= modmul_inst_rtl_cmp_1_z;
      inst_modadd_inst_run_a_20_sva_1 <= modmul_inst_rtl_cmp_3_z;
      modadd_inst_int_add_inst_run_y_20_sva_1 <= modmul_inst_rtl_cmp_4_z;
      inst_modsub_inst_run_a_4_sva_1 <= modmul_inst_rtl_cmp_5_z;
      modsub_inst_int_sub_inst_run_y_4_sva_1 <= modmul_inst_rtl_cmp_6_z;
      inst_modsub_inst_run_1_qr_lpi_1_dfm_1 <= MUX_v_381_2_2((inst_modsub_inst_run_1_diff_sva_1[380:0]),
          modsub_inst_int_add_inst_run_1_acc_nl, inst_modsub_inst_run_1_diff_sva_1[381]);
      inst_modadd_inst_run_10_qr_lpi_1_dfm_1 <= inst_modadd_inst_run_10_qr_lpi_1_dfm_1_1;
      inst_modsub_inst_run_qr_lpi_1_dfm_1 <= inst_modsub_inst_run_qr_lpi_1_dfm_1_1;
      inst_modadd_inst_run_16_slc_modadd_inst_int_sub_inst_run_16_acc_psp_380_3_itm_1
          <= modadd_inst_int_sub_inst_run_16_acc_psp_sva_1[380];
      l2_msm_padd_rcb_impl_FIELD_0_run_slc_inst_modsub_inst_run_2_qr_0_itm_1 <= inst_modsub_inst_run_2_qr_lpi_1_dfm_mx0[0];
      inst_modadd_inst_run_16_qr_380_2_lpi_1_dfm_1 <= MUX_v_379_2_2((modadd_inst_int_sub_inst_run_16_acc_psp_sva_1[378:0]),
          (inst_modsub_inst_run_2_qr_lpi_1_dfm_mx0[379:1]), modadd_inst_int_sub_inst_run_16_acc_psp_sva_1[380]);
      l2_msm_padd_rcb_impl_FIELD_0_run_t1_1_sva_2 <= l2_msm_padd_rcb_impl_FIELD_0_run_t1_1_sva_1;
      inst_modadd_inst_run_14_adder_out_sva_1 <= nl_inst_modadd_inst_run_14_adder_out_sva_1[381:0];
      l2_msm_padd_rcb_impl_FIELD_0_run_t0_1_sva_1 <= modmul_inst_rtl_cmp_z;
      modsub_inst_int_sub_inst_run_x_2_sva_1 <= modmul_inst_rtl_cmp_7_z;
      l2_msm_padd_rcb_impl_FIELD_0_run_t2_1_sva_1 <= modmul_inst_rtl_cmp_10_z;
      modsub_inst_int_sub_inst_run_x_1_sva_1 <= modmul_inst_rtl_cmp_8_z;
      l2_msm_padd_rcb_impl_FIELD_0_run_t1_1_sva_1 <= modmul_inst_rtl_cmp_11_z;
      modsub_inst_int_sub_inst_run_x_sva_1 <= modmul_inst_rtl_cmp_9_z;
      reg_P1_Z_triosy_obj_ld_cse <= 1'b1;
      main_stage_0_7 <= main_stage_0_6;
      main_stage_0_8 <= main_stage_0_7;
      main_stage_0_9 <= main_stage_0_8;
      main_stage_0_14 <= main_stage_0_13;
      main_stage_0_15 <= main_stage_0_14;
      main_stage_0_16 <= main_stage_0_15;
      inst_modadd_inst_run_b_21_sva_1 <= modmul_inst_rtl_cmp_2_z;
      main_stage_0_6 <= main_stage_0_5;
      main_stage_0_13 <= main_stage_0_12;
      main_stage_0_5 <= main_stage_0_4;
      main_stage_0_12 <= main_stage_0_11;
      main_stage_0_4 <= main_stage_0_3;
      main_stage_0_11 <= main_stage_0_10;
      main_stage_0_3 <= reg_P1_Z_triosy_obj_ld_cse;
      main_stage_0_10 <= main_stage_0_9;
    end
  end
  always @(posedge clk) begin
    if ( rst ) begin
      R_Z_rsci_idat <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      R_Y_rsci_idat <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      R_X_rsci_idat <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    end
    else if ( main_stage_0_16 ) begin
      R_Z_rsci_idat <= MUX_v_381_2_2((inst_modadd_inst_run_21_reduced_out_sva_1[380:0]),
          (inst_modadd_inst_run_21_adder_out_sva_1[380:0]), inst_modadd_inst_run_21_reduced_out_sva_1[382]);
      R_Y_rsci_idat <= MUX_v_381_2_2((inst_modadd_inst_run_20_reduced_out_sva_1[380:0]),
          (inst_modadd_inst_run_20_adder_out_sva_1[380:0]), inst_modadd_inst_run_20_reduced_out_sva_1[382]);
      R_X_rsci_idat <= MUX_v_381_2_2((modsub_inst_int_sub_inst_run_4_acc_1_tmp[380:0]),
          modsub_inst_int_add_inst_run_4_acc_nl, modsub_inst_int_sub_inst_run_4_acc_1_tmp[381]);
    end
  end
  assign nl_modsub_inst_int_add_inst_run_1_acc_nl = (inst_modsub_inst_run_1_diff_sva_1[380:0])
      + 381'b110100000000100010001111010100011100101111111111001101001101001001011000110111010011110110110010000110100101110101100110101110110010001110111010010111000010011110011100001010001001010111111011001110011000011010010101000001111011010110000111101100010010000011110101010111111111111111110101100010101001111111111111111111011100111111110111111111111111111111111111111111010101010101011;
  assign modsub_inst_int_add_inst_run_1_acc_nl = nl_modsub_inst_int_add_inst_run_1_acc_nl[380:0];
  assign inst_modadd_inst_run_13_mux_nl = MUX_v_377_2_2((modadd_inst_int_sub_inst_run_13_acc_psp_sva_1[378:2]),
      (inst_modadd_inst_run_12_qr_380_3_lpi_1_dfm_mx0[376:0]), modadd_inst_int_sub_inst_run_13_acc_psp_sva_1[380]);
  assign inst_modadd_inst_run_13_mux_1_nl = MUX_s_1_2_2((modadd_inst_int_sub_inst_run_13_acc_psp_sva_1[1]),
      inst_modadd_inst_run_12_qr_2_lpi_1_dfm_mx0, modadd_inst_int_sub_inst_run_13_acc_psp_sva_1[380]);
  assign inst_modadd_inst_run_13_mux_2_nl = MUX_s_1_2_2((modadd_inst_int_sub_inst_run_13_acc_psp_sva_1[0]),
      (~ (modadd_inst_int_sub_inst_run_11_acc_psp_sva_1[380])), modadd_inst_int_sub_inst_run_13_acc_psp_sva_1[380]);
  assign nl_inst_modadd_inst_run_14_adder_out_sva_1  = (conv_u2u_381_382({inst_modadd_inst_run_12_qr_380_3_lpi_1_dfm_mx0
      , inst_modadd_inst_run_12_qr_2_lpi_1_dfm_mx0 , (~ (modadd_inst_int_sub_inst_run_11_acc_psp_sva_1[380]))
      , (~ (modadd_inst_int_sub_inst_run_12_acc_tmp[380]))}) + conv_u2u_381_382({inst_modadd_inst_run_13_mux_nl
      , inst_modadd_inst_run_13_mux_1_nl , inst_modadd_inst_run_13_mux_2_nl , (~
      (modadd_inst_int_sub_inst_run_12_acc_tmp[380])) , (~ (modadd_inst_int_sub_inst_run_13_acc_psp_sva_1[380]))}));
  assign nl_modsub_inst_int_add_inst_run_4_acc_nl = (modsub_inst_int_sub_inst_run_4_acc_1_tmp[380:0])
      + 381'b110100000000100010001111010100011100101111111111001101001101001001011000110111010011110110110010000110100101110101100110101110110010001110111010010111000010011110011100001010001001010111111011001110011000011010010101000001111011010110000111101100010010000011110101010111111111111111110101100010101001111111111111111111011100111111110111111111111111111111111111111111010101010101011;
  assign modsub_inst_int_add_inst_run_4_acc_nl = nl_modsub_inst_int_add_inst_run_4_acc_nl[380:0];

  function automatic  MUX_s_1_2_2;
    input  input_0;
    input  input_1;
    input  sel;
    reg  result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_s_1_2_2 = result;
  end
  endfunction


  function automatic [376:0] MUX_v_377_2_2;
    input [376:0] input_0;
    input [376:0] input_1;
    input  sel;
    reg [376:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_377_2_2 = result;
  end
  endfunction


  function automatic [377:0] MUX_v_378_2_2;
    input [377:0] input_0;
    input [377:0] input_1;
    input  sel;
    reg [377:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_378_2_2 = result;
  end
  endfunction


  function automatic [378:0] MUX_v_379_2_2;
    input [378:0] input_0;
    input [378:0] input_1;
    input  sel;
    reg [378:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_379_2_2 = result;
  end
  endfunction


  function automatic [380:0] MUX_v_381_2_2;
    input [380:0] input_0;
    input [380:0] input_1;
    input  sel;
    reg [380:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_381_2_2 = result;
  end
  endfunction


  function automatic [381:0] conv_u2s_381_382 ;
    input [380:0]  vector ;
  begin
    conv_u2s_381_382 =  {1'b0, vector};
  end
  endfunction


  function automatic [382:0] conv_u2s_382_383 ;
    input [381:0]  vector ;
  begin
    conv_u2s_382_383 =  {1'b0, vector};
  end
  endfunction


  function automatic [380:0] conv_u2u_380_381 ;
    input [379:0]  vector ;
  begin
    conv_u2u_380_381 = {1'b0, vector};
  end
  endfunction


  function automatic [381:0] conv_u2u_381_382 ;
    input [380:0]  vector ;
  begin
    conv_u2u_381_382 = {1'b0, vector};
  end
  endfunction

endmodule

module ccs_dw_add_v1(A, B, CI, SUM, CO);
  parameter  integer width=4;
// port decalrations
  input [width-1 : 0]  A,B;
  input                CI;
  output [width-1 : 0] SUM;
  output               CO;

  DW01_add #(width)
    U1 (.A(A), .B(B), .CI(CI), .SUM(SUM), .CO(CO));
endmodule

module mgc_io_sync_v2 (ld, lz);
    parameter valid = 0;

    input  ld;
    output lz;

    wire   lz;

    assign lz = ld;

endmodule

module ccs_out_v1 (dat, idat);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output   [width-1:0] dat;
  input    [width-1:0] idat;

  wire     [width-1:0] dat;

  assign dat = idat;

endmodule

module ccs_in_v1 (idat, dat);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output [width-1:0] idat;
  input  [width-1:0] dat;

  wire   [width-1:0] idat;

  assign idat = dat;

endmodule
