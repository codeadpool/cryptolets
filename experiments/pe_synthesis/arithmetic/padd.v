
//------> /eda/siemens/Catapult/Mgc_home/pkgs/siflibs/ccs_in_v1.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - Sample I/O Port Library
//
// Copyright (c) 2003-2017 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------


module ccs_in_v1 (idat, dat);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output [width-1:0] idat;
  input  [width-1:0] dat;

  wire   [width-1:0] idat;

  assign idat = dat;

endmodule


//------> /eda/siemens/Catapult/Mgc_home/pkgs/siflibs/ccs_out_v1.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - Sample I/O Port Library
//
// Copyright (c) 2003-2015 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------

module ccs_out_v1 (dat, idat);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output   [width-1:0] dat;
  input    [width-1:0] idat;

  wire     [width-1:0] dat;

  assign dat = idat;

endmodule




//------> /eda/siemens/Catapult/Mgc_home/pkgs/siflibs/mgc_io_sync_v2.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - Sample I/O Port Library
//
// Copyright (c) 2003-2017 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------


module mgc_io_sync_v2 (ld, lz);
    parameter valid = 0;

    input  ld;
    output lz;

    wire   lz;

    assign lz = ld;

endmodule


//------> ../../blackbox/rtl/l1_mod_mul_d7267ca0d90c7363.v 

//------> /eda/siemens/Catapult/Mgc_home/pkgs/siflibs/ccs_in_v1.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - Sample I/O Port Library
//
// Copyright (c) 2003-2017 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------


module ccs_in_v1 (idat, dat);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output [width-1:0] idat;
  input  [width-1:0] dat;

  wire   [width-1:0] idat;

  assign idat = dat;

endmodule


//------> /eda/siemens/Catapult/Mgc_home/pkgs/siflibs/ccs_out_v1.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - Sample I/O Port Library
//
// Copyright (c) 2003-2015 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------

module ccs_out_v1 (dat, idat);

  parameter integer rscid = 1;
  parameter integer width = 8;

  output   [width-1:0] dat;
  input    [width-1:0] idat;

  wire     [width-1:0] dat;

  assign dat = idat;

endmodule




//------> /eda/siemens/Catapult/Mgc_home/pkgs/siflibs/mgc_io_sync_v2.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - Sample I/O Port Library
//
// Copyright (c) 2003-2017 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------


module mgc_io_sync_v2 (ld, lz);
    parameter valid = 0;

    input  ld;
    output lz;

    wire   lz;

    assign lz = ld;

endmodule


//------> /eda/siemens/Catapult/Mgc_home/pkgs/siflibs/dware/ccs_dw_mult_v1.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - dware wrappers
//
// Copyright (c) 2021 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------

// DW01_mult

module ccs_dw_mult_v1(A,B,PRODUCT);
  parameter       integer A_width = 8;
  parameter       integer B_width = 8;
  parameter       integer tc_mode = 0;
    
  input   [A_width-1:0]   A;
  input   [B_width-1:0]   B;
  output  [A_width+B_width-1:0]   PRODUCT;

  wire TC;
  assign TC = tc_mode;

  DW02_mult #(A_width,B_width)
    U1 (.A(A), .B(B), .TC(TC), .PRODUCT(PRODUCT));
endmodule

//------> /eda/siemens/Catapult/Mgc_home/pkgs/siflibs/dware/ccs_dw_add_v1.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - dware wrappers
//
// Copyright (c) 2021 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------

// DW01_add

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

//------> ./rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    2026.1_1/1274012 Production Release
//  HLS Date:       Thu Mar 12 18:35:35 PDT 2026
// 
//  Generated by:   ajd9396@cepool-a00.poly.edu
//  Generated date: Fri Oct 23 20:16:12 2026
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    l1_mod_mul_d7267ca0d90c7363_run
// ------------------------------------------------------------------


module l1_mod_mul_d7267ca0d90c7363_run (
  clk, rst, x_rsc_dat, x_triosy_lz, y_rsc_dat, y_triosy_lz, z_rsc_dat, z_triosy_lz
);
  input clk;
  input rst;
  input [380:0] x_rsc_dat;
  output x_triosy_lz;
  input [380:0] y_rsc_dat;
  output y_triosy_lz;
  output [380:0] z_rsc_dat;
  output z_triosy_lz;


  // Interconnect Declarations
  wire [380:0] x_rsci_idat;
  wire [380:0] y_rsci_idat;
  reg [380:0] z_rsci_idat;
  reg z_triosy_obj_ld;
  wire [382:0] inst_mont_inst_run_diff_sva_1;
  wire [383:0] nl_inst_mont_inst_run_diff_sva_1;
  reg main_stage_0_5;
  reg reg_y_triosy_obj_ld_cse;
  wire [761:0] mont_inst_cmul_q_inst_run_constexpr_if_if_mul_itm;
  wire [96:0] l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_10_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_27_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_itm;
  wire [96:0] l0_int_mul_sb_64_96_96_constexpr_if_else_acc_8_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_11_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_8_itm;
  wire [94:0] l0_int_mul_sb_64_48_47_3_constexpr_if_if_mul_itm;
  wire [94:0] l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_itm;
  wire [93:0] l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_itm;
  wire [97:0] l0_int_mul_sb_64_96_96_constexpr_if_else_acc_itm;
  wire [96:0] l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_constexpr_if_if_mul_itm;
  wire [94:0] l0_int_mul_sb_64_48_47_4_constexpr_if_if_mul_itm;
  wire [94:0] l0_int_mul_sb_64_47_48_4_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_4_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_8_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_6_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_15_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_14_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_5_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_24_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_5_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_16_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_20_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_2_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_1_constexpr_if_if_mul_itm;
  wire [94:0] l0_int_mul_sb_64_48_47_constexpr_if_if_mul_itm;
  wire [94:0] l0_int_mul_sb_64_47_48_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_23_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_22_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_19_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_18_constexpr_if_if_mul_itm;
  wire [94:0] l0_int_mul_sb_64_48_47_6_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_7_constexpr_if_if_mul_itm;
  wire [94:0] l0_int_mul_sb_64_47_48_6_constexpr_if_if_mul_itm;
  wire [95:0] l0_int_mul_sb_64_48_48_5_constexpr_if_if_mul_itm;
  wire [94:0] l0_int_mul_sb_64_48_47_2_constexpr_if_if_mul_itm;
  wire [94:0] l0_int_mul_sb_64_47_48_2_constexpr_if_if_mul_itm;
  wire [94:0] l0_int_mul_sb_64_48_47_1_constexpr_if_if_mul_itm;
  wire [94:0] l0_int_mul_sb_64_47_48_1_constexpr_if_if_mul_itm;
  wire [760:0] mont_inst_cmul_q_prime_inst_run_constexpr_if_else_constexpr_if_if_mul_itm_pdr;
  wire CO_out;
  wire CO_out_1;
  wire CO_out_2;
  wire CO_out_3;
  wire CO_out_4;
  wire CO_out_5;
  wire CO_out_6;
  wire CO_out_7;
  wire CO_out_8;
  wire CO_out_9;
  wire CO_out_10;
  wire CO_out_11;
  wire CO_out_12;
  wire CO_out_13;
  wire CO_out_14;
  wire CO_out_15;
  wire CO_out_16;
  wire CO_out_17;
  wire CO_out_18;
  wire CO_out_19;
  wire CO_out_20;
  reg main_stage_0_3;
  reg main_stage_0_4;
  reg [191:0] l0_int_mul_sb_64_96_96_constexpr_if_else_acc_6_psp_sva_1;
  reg [381:0] inst_mont_inst_run_t_mq_762_381_sva_1;
  reg [94:0] l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_itm_1;
  reg [95:0] l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_itm_1;
  reg [93:0] l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_itm_1;
  reg [95:0] l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_itm_1;
  reg [95:0] l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_itm_1;
  reg [95:0] l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_itm_1;
  reg [95:0] l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_itm_1;
  reg [95:0] l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_itm_1;
  reg [95:0] l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_itm_1;
  reg [95:0] l0_int_mul_sb_64_192_192_constexpr_if_else_slc_l0_int_mul_sb_64_192_192_constexpr_if_else_acc_psp_95_0_itm_1;
  reg [47:0] l0_int_mul_sb_64_96_96_1_constexpr_if_else_slc_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_psp_47_0_itm_1;
  reg [47:0] l0_int_mul_sb_64_96_96_1_constexpr_if_else_slc_l0_int_mul_sb_64_48_48_return_13_47_0_itm_1;
  reg [384:0] l0_int_mul_kar_64_192_381_constexpr_if_else_acc_2_itm_1;
  wire [385:0] nl_l0_int_mul_kar_64_192_381_constexpr_if_else_acc_2_itm_1;
  reg [94:0] l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_94_0_1_itm_1;
  reg [94:0] l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_94_0_1_itm_2;
  reg l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_0_1_itm_1;
  reg l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_0_1_itm_2;
  reg [46:0] l0_int_mul_sb_64_95_95_4_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_psp_46_0_itm_1;
  reg [46:0] l0_int_mul_sb_64_95_95_4_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_psp_46_0_itm_2;
  reg [46:0] l0_int_mul_sb_64_95_95_4_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_z0_46_0_3_itm_1;
  reg [94:0] l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_94_0_itm_1;
  reg l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_itm_2;
  reg [46:0] l0_int_mul_sb_64_95_95_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_46_0_2_itm_1;
  reg [380:0] mont_inst_cmul_q_prime_inst_run_constexpr_if_else_constexpr_if_if_mul_itm_1;
  reg [94:0] l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_94_0_3_itm_2;
  reg l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_3_itm_1;
  reg l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_3_itm_3;
  reg [46:0] l0_int_mul_sb_64_95_95_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_46_0_1_itm_2;
  reg [46:0] l0_int_mul_sb_64_95_95_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_z0_46_0_4_itm_1;
  reg [46:0] l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_1_46_0;
  reg [46:0] l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_2_46_0;
  reg [46:0] l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_sva_1_46_0;
  reg [94:0] l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_sva_1_94_0;
  reg [46:0] l0_int_mul_sb_64_95_95_4_constexpr_if_else_z0_sva_1_46_0;
  reg [381:0] l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_sva_1_571_190;
  reg [189:0] l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_sva_1_189_0;
  reg [95:0] l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_7_itm_1_142_47;
  reg [46:0] l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_7_itm_1_46_0;
  reg [96:0] l0_int_mul_sb_64_96_96_constexpr_if_else_acc_7_itm_1_144_48;
  reg [47:0] l0_int_mul_sb_64_96_96_constexpr_if_else_acc_7_itm_1_47_0;
  reg [96:0] l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_7_itm_1_144_48;
  reg [47:0] l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_7_itm_1_47_0;
  wire [381:0] l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_1;
  wire [382:0] nl_l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_1;
  wire [191:0] l0_int_mul_sb_64_96_96_constexpr_if_else_acc_6_psp_sva_1_1;
  wire [192:0] nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_6_psp_sva_1_1;
  wire [382:0] l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_2_sdt_1;
  wire [383:0] nl_l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_2_sdt_1;
  wire [189:0] l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_6_psp_sva_1;
  wire [190:0] nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_6_psp_sva_1;
  wire [95:0] l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_sva_1;
  wire [96:0] nl_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_sva_1;
  wire [96:0] l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_psp_sva_1;
  wire [95:0] l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_sva_1;
  wire [96:0] nl_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_sva_1;
  wire [192:0] l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_sva_1;
  wire [95:0] l0_int_mul_sb_64_48_48_return_13_sva_1;
  wire [97:0] l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_psp_sva_1;
  wire [193:0] l0_int_mul_sb_64_192_192_constexpr_if_else_acc_psp_sva_1;
  wire [191:0] l0_int_mul_kar_64_192_192_x_sva_1;
  wire [191:0] l0_int_mul_kar_64_192_192_y_sva_1;
  wire [191:0] l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_sva_1;
  wire [93:0] l0_int_mul_sb_64_95_95_4_constexpr_if_else_z0_sva_1;
  wire [96:0] l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_sva_1;
  wire [93:0] l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_1;
  wire [97:0] l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_psp_sva_1;
  wire [95:0] l0_int_mul_sb_64_48_48_return_21_sva_1;
  wire [97:0] l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_psp_sva_1;
  wire [95:0] l0_int_mul_sb_64_48_48_return_17_sva_1;
  wire [96:0] l0_int_mul_sb_64_96_95_constexpr_if_else_acc_4_psp_sva_1;
  wire [96:0] l0_int_mul_sb_64_96_95_constexpr_if_else_acc_psp_sva_1;
  wire [97:0] nl_l0_int_mul_sb_64_96_95_constexpr_if_else_acc_psp_sva_1;
  wire [94:0] l0_int_mul_sb_64_96_95_constexpr_if_else_z0_sva_1;
  wire [97:0] l0_int_mul_sb_64_95_96_constexpr_if_else_acc_psp_sva_1;
  wire [94:0] l0_int_mul_sb_64_95_96_constexpr_if_else_z0_sva_1;
  wire [96:0] l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_psp_sva_1;
  wire [93:0] l0_int_mul_sb_64_95_95_2_constexpr_if_else_z0_sva_1;
  wire [96:0] l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_psp_sva_1;
  wire [93:0] l0_int_mul_sb_64_95_95_1_constexpr_if_else_z0_sva_1;

  wire[762:0] inst_mont_inst_run_t_mq_acc_nl;
  wire[763:0] nl_inst_mont_inst_run_t_mq_acc_nl;
  wire[383:0] l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_nl;
  wire[384:0] nl_l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_nl;
  wire[382:0] l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_4_nl;
  wire[383:0] nl_l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_4_nl;
  wire[191:0] l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_nl;
  wire[192:0] nl_l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_nl;
  wire[97:0] l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_9_nl;
  wire[98:0] nl_l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_9_nl;

  // Interconnect Declarations for Component Instantiations 
  wire [380:0] nl_mont_inst_cmul_q_prime_inst_run_constexpr_if_else_constexpr_if_if_mul_rg_B;
  assign nl_mont_inst_cmul_q_prime_inst_run_constexpr_if_else_constexpr_if_if_mul_rg_B
      = {(l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_1[0]) , (l0_int_mul_kar_64_192_381_constexpr_if_else_acc_2_itm_1[189:0])
      , l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_94_0_itm_1
      , l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_itm_2
      , l0_int_mul_sb_64_95_95_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_46_0_2_itm_1
      , l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_2_46_0};
  wire [47:0] nl_l0_int_mul_sb_64_48_48_27_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_27_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[191:144];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_27_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_27_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[143:96];
  wire [96:0] nl_l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_10_rg_A;
  assign nl_l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_10_rg_A = {1'b0, l0_int_mul_sb_64_48_48_27_constexpr_if_if_mul_itm};
  wire [96:0] nl_l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_10_rg_B;
  assign nl_l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_10_rg_B = {47'b0, l0_int_mul_sb_64_192_192_constexpr_if_else_acc_psp_sva_1[193:144]};
  wire [47:0] nl_l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[143:96];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[191:144];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[191:144];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[191:144];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[143:96];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[143:96];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_11_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_11_constexpr_if_if_mul_rg_A = x_rsci_idat[380:333];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_11_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_11_constexpr_if_if_mul_rg_B = y_rsci_idat[332:285];
  wire [96:0] nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_8_rg_A;
  assign nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_8_rg_A = {1'b0, l0_int_mul_sb_64_48_48_11_constexpr_if_if_mul_itm};
  wire [96:0] nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_8_rg_B;
  assign nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_8_rg_B = {47'b0, l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_sva_1[192:143]};
  wire [47:0] nl_l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_rg_A = x_rsci_idat[332:285];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_rg_B = y_rsci_idat[380:333];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_rg_A = x_rsci_idat[380:333];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_rg_B = y_rsci_idat[380:333];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_rg_A = x_rsci_idat[332:285];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_rg_B = y_rsci_idat[332:285];
  wire [47:0] nl_l0_int_mul_sb_64_48_47_3_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_47_3_constexpr_if_if_mul_rg_A = x_rsci_idat[189:142];
  wire [46:0] nl_l0_int_mul_sb_64_48_47_3_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_47_3_constexpr_if_if_mul_rg_B = y_rsci_idat[141:95];
  wire [95:0] nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_8_rg_A;
  assign nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_8_rg_A = {1'b0, l0_int_mul_sb_64_48_47_3_constexpr_if_if_mul_itm};
  wire [95:0] nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_8_rg_B;
  assign nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_8_rg_B = {46'b0, l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_sva_1[191:142]};
  wire [47:0] nl_l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_rg_A = y_rsci_idat[189:142];
  wire [46:0] nl_l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_rg_B = x_rsci_idat[141:95];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_rg_A = x_rsci_idat[189:142];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_rg_B = y_rsci_idat[189:142];
  wire [46:0] nl_l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_rg_A = x_rsci_idat[141:95];
  wire [46:0] nl_l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_rg_B = y_rsci_idat[141:95];
  wire [97:0] nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_rg_A;
  assign nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_rg_A = {1'b0 , l0_int_mul_sb_64_96_96_constexpr_if_else_acc_7_itm_1_144_48};
  wire [97:0] nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_rg_B;
  assign nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_rg_B = {2'b00 , l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_itm_1};
  wire [96:0] nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_rg_A;
  assign nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_rg_A = {1'b0 , l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_7_itm_1_142_47};
  wire [96:0] nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_rg_B;
  assign nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_rg_B = {2'b00 , l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_itm_1};
  wire [47:0] nl_l0_int_mul_sb_64_48_48_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_constexpr_if_if_mul_rg_A = x_rsci_idat[94:47];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_constexpr_if_if_mul_rg_B = y_rsci_idat[94:47];
  wire [47:0] nl_l0_int_mul_sb_64_48_47_4_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_47_4_constexpr_if_if_mul_rg_A = x_rsci_idat[284:237];
  wire [46:0] nl_l0_int_mul_sb_64_48_47_4_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_47_4_constexpr_if_if_mul_rg_B = y_rsci_idat[236:190];
  wire [47:0] nl_l0_int_mul_sb_64_47_48_4_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_47_48_4_constexpr_if_if_mul_rg_A = y_rsci_idat[284:237];
  wire [46:0] nl_l0_int_mul_sb_64_47_48_4_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_47_48_4_constexpr_if_if_mul_rg_B = x_rsci_idat[236:190];
  wire[95:0] l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_6_nl;
  wire[96:0] nl_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_6_nl;
  wire [96:0] nl_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_rg_A;
  assign nl_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_6_nl = conv_u2u_95_96(l0_int_mul_sb_64_48_47_4_constexpr_if_if_mul_itm)
      + conv_u2u_47_96(l0_int_mul_sb_64_95_95_4_constexpr_if_else_z0_sva_1[93:47]);
  assign l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_6_nl = nl_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_6_nl[95:0];
  assign nl_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_rg_A = {1'b0, l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_6_nl};
  wire [96:0] nl_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_rg_B;
  assign nl_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_rg_B = {2'b0, l0_int_mul_sb_64_47_48_4_constexpr_if_if_mul_itm};
  wire [47:0] nl_l0_int_mul_sb_64_48_48_4_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_4_constexpr_if_if_mul_rg_A = x_rsci_idat[284:237];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_4_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_4_constexpr_if_if_mul_rg_B = y_rsci_idat[284:237];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_8_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_8_constexpr_if_if_mul_rg_A = x_rsci_idat[380:333];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_8_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_8_constexpr_if_if_mul_rg_B = y_rsci_idat[284:237];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_6_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_6_constexpr_if_if_mul_rg_A = x_rsci_idat[284:237];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_6_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_6_constexpr_if_if_mul_rg_B = y_rsci_idat[380:333];
  wire[191:0] l0_int_mul_sb_64_191_191_constexpr_if_else_acc_5_nl;
  wire[192:0] nl_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_5_nl;
  wire[95:0] l0_int_mul_sb_64_96_95_constexpr_if_else_acc_5_nl;
  wire[96:0] nl_l0_int_mul_sb_64_96_95_constexpr_if_else_acc_5_nl;
  wire [192:0] nl_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_rg_A;
  assign nl_l0_int_mul_sb_64_96_95_constexpr_if_else_acc_5_nl = l0_int_mul_sb_64_48_48_8_constexpr_if_if_mul_itm
      + conv_u2u_50_96(l0_int_mul_sb_64_96_95_constexpr_if_else_acc_4_psp_sva_1[96:47]);
  assign l0_int_mul_sb_64_96_95_constexpr_if_else_acc_5_nl = nl_l0_int_mul_sb_64_96_95_constexpr_if_else_acc_5_nl[95:0];
  assign nl_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_5_nl = conv_u2u_191_192({l0_int_mul_sb_64_96_95_constexpr_if_else_acc_5_nl
      , (l0_int_mul_sb_64_96_95_constexpr_if_else_acc_4_psp_sva_1[46:0]) , (l0_int_mul_sb_64_96_95_constexpr_if_else_acc_psp_sva_1[0])
      , (l0_int_mul_sb_64_96_95_constexpr_if_else_z0_sva_1[46:0])}) + conv_u2u_95_192(l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_sva_1[95:1]);
  assign l0_int_mul_sb_64_191_191_constexpr_if_else_acc_5_nl = nl_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_5_nl[191:0];
  assign nl_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_rg_A = {1'b0, l0_int_mul_sb_64_191_191_constexpr_if_else_acc_5_nl};
  wire[95:0] l0_int_mul_sb_64_95_96_constexpr_if_else_acc_5_nl;
  wire[96:0] nl_l0_int_mul_sb_64_95_96_constexpr_if_else_acc_5_nl;
  wire [192:0] nl_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_rg_B;
  assign nl_l0_int_mul_sb_64_95_96_constexpr_if_else_acc_5_nl = l0_int_mul_sb_64_48_48_6_constexpr_if_if_mul_itm
      + conv_u2u_50_96(l0_int_mul_sb_64_95_96_constexpr_if_else_acc_psp_sva_1[97:48]);
  assign l0_int_mul_sb_64_95_96_constexpr_if_else_acc_5_nl = nl_l0_int_mul_sb_64_95_96_constexpr_if_else_acc_5_nl[95:0];
  assign nl_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_rg_B = {2'b00 , l0_int_mul_sb_64_95_96_constexpr_if_else_acc_5_nl
      , (l0_int_mul_sb_64_95_96_constexpr_if_else_acc_psp_sva_1[47:0]) , (l0_int_mul_sb_64_95_96_constexpr_if_else_z0_sva_1[46:0])};
  wire [47:0] nl_l0_int_mul_sb_64_48_48_13_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_13_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[47:0];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_13_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_13_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[47:0];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_15_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_15_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[95:48];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_15_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_15_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[47:0];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_14_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_14_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[47:0];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_14_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_14_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[95:48];
  wire[96:0] l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_6_nl;
  wire[97:0] nl_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_6_nl;
  wire [97:0] nl_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_rg_A;
  assign nl_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_6_nl = conv_u2u_96_97(l0_int_mul_sb_64_48_48_15_constexpr_if_if_mul_itm)
      + conv_u2u_48_97(l0_int_mul_sb_64_48_48_return_13_sva_1[95:48]);
  assign l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_6_nl = nl_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_6_nl[96:0];
  assign nl_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_rg_A = {1'b0, l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_6_nl};
  wire [97:0] nl_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_rg_B;
  assign nl_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_rg_B = {2'b0, l0_int_mul_sb_64_48_48_14_constexpr_if_if_mul_itm};
  wire [47:0] nl_l0_int_mul_sb_64_48_48_24_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_24_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[191:144];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_24_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_24_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[95:48];
  wire [95:0] nl_l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_5_rg_B;
  assign nl_l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_5_rg_B = {46'b0, l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_psp_sva_1[97:48]};
  wire [47:0] nl_l0_int_mul_sb_64_48_48_16_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_16_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[95:48];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_16_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_16_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[95:48];
  wire [95:0] nl_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_5_rg_B;
  assign nl_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_5_rg_B = {46'b0, l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_psp_sva_1[97:48]};
  wire [47:0] nl_l0_int_mul_sb_64_48_48_20_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_20_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[95:48];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_20_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_20_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[191:144];
  wire[192:0] l0_int_mul_sb_64_192_192_constexpr_if_else_acc_5_nl;
  wire[193:0] nl_l0_int_mul_sb_64_192_192_constexpr_if_else_acc_5_nl;
  wire [193:0] nl_l0_int_mul_sb_64_192_192_constexpr_if_else_acc_rg_A;
  assign nl_l0_int_mul_sb_64_192_192_constexpr_if_else_acc_5_nl = conv_u2u_192_193({l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_5_itm
      , (l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_psp_sva_1[47:0]) , (l0_int_mul_sb_64_48_48_return_21_sva_1[47:0])})
      + conv_u2u_96_193(l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_5_itm);
  assign l0_int_mul_sb_64_192_192_constexpr_if_else_acc_5_nl = nl_l0_int_mul_sb_64_192_192_constexpr_if_else_acc_5_nl[192:0];
  assign nl_l0_int_mul_sb_64_192_192_constexpr_if_else_acc_rg_A = {1'b0, l0_int_mul_sb_64_192_192_constexpr_if_else_acc_5_nl};
  wire[95:0] l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_5_nl;
  wire[96:0] nl_l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_5_nl;
  wire [193:0] nl_l0_int_mul_sb_64_192_192_constexpr_if_else_acc_rg_B;
  assign nl_l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_5_nl = l0_int_mul_sb_64_48_48_20_constexpr_if_if_mul_itm
      + conv_u2u_50_96(l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_psp_sva_1[97:48]);
  assign l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_5_nl = nl_l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_5_nl[95:0];
  assign nl_l0_int_mul_sb_64_192_192_constexpr_if_else_acc_rg_B = {2'b00 , l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_5_nl
      , (l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_psp_sva_1[47:0]) , (l0_int_mul_sb_64_48_48_return_17_sva_1[47:0])};
  wire [191:0] nl_l0_int_mul_kar_64_192_381_constexpr_if_else_sum_x_acc_rg_A;
  assign nl_l0_int_mul_kar_64_192_381_constexpr_if_else_sum_x_acc_rg_A = {1'b0, x_rsci_idat[380:190]};
  wire [191:0] nl_l0_int_mul_kar_64_192_381_constexpr_if_else_sum_x_acc_rg_B;
  assign nl_l0_int_mul_kar_64_192_381_constexpr_if_else_sum_x_acc_rg_B = {2'b0, x_rsci_idat[189:0]};
  wire [191:0] nl_l0_int_mul_kar_64_192_381_constexpr_if_else_sum_y_acc_rg_A;
  assign nl_l0_int_mul_kar_64_192_381_constexpr_if_else_sum_y_acc_rg_A = {1'b0, y_rsci_idat[380:190]};
  wire [191:0] nl_l0_int_mul_kar_64_192_381_constexpr_if_else_sum_y_acc_rg_B;
  assign nl_l0_int_mul_kar_64_192_381_constexpr_if_else_sum_y_acc_rg_B = {2'b0, y_rsci_idat[189:0]};
  wire [47:0] nl_l0_int_mul_sb_64_48_48_2_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_2_constexpr_if_if_mul_rg_A = x_rsci_idat[189:142];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_2_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_2_constexpr_if_if_mul_rg_B = y_rsci_idat[94:47];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_1_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_1_constexpr_if_if_mul_rg_A = x_rsci_idat[94:47];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_1_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_1_constexpr_if_if_mul_rg_B = y_rsci_idat[189:142];
  wire[190:0] l0_int_mul_sb_64_190_190_constexpr_if_else_acc_5_nl;
  wire[191:0] nl_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_5_nl;
  wire[95:0] l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_5_nl;
  wire[96:0] nl_l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_5_nl;
  wire [191:0] nl_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_rg_A;
  assign nl_l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_5_nl = l0_int_mul_sb_64_48_48_2_constexpr_if_if_mul_itm
      + conv_u2u_50_96(l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_psp_sva_1[96:47]);
  assign l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_5_nl = nl_l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_5_nl[95:0];
  assign nl_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_5_nl = conv_u2u_190_191({l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_5_nl
      , (l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_psp_sva_1[46:0]) , (l0_int_mul_sb_64_95_95_2_constexpr_if_else_z0_sva_1[46:0])})
      + conv_u2u_95_191(l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_sva_1[95:1]);
  assign l0_int_mul_sb_64_190_190_constexpr_if_else_acc_5_nl = nl_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_5_nl[190:0];
  assign nl_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_rg_A = {1'b0, l0_int_mul_sb_64_190_190_constexpr_if_else_acc_5_nl};
  wire[95:0] l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_5_nl;
  wire[96:0] nl_l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_5_nl;
  wire [191:0] nl_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_rg_B;
  assign nl_l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_5_nl = l0_int_mul_sb_64_48_48_1_constexpr_if_if_mul_itm
      + conv_u2u_50_96(l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_psp_sva_1[96:47]);
  assign l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_5_nl = nl_l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_5_nl[95:0];
  assign nl_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_rg_B = {2'b00 , l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_5_nl
      , (l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_psp_sva_1[46:0]) , (l0_int_mul_sb_64_95_95_1_constexpr_if_else_z0_sva_1[46:0])};
  wire [46:0] nl_l0_int_mul_sb_64_47_47_4_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_47_47_4_constexpr_if_if_mul_rg_A = x_rsci_idat[236:190];
  wire [46:0] nl_l0_int_mul_sb_64_47_47_4_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_47_47_4_constexpr_if_if_mul_rg_B = y_rsci_idat[236:190];
  wire [47:0] nl_l0_int_mul_sb_64_48_47_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_47_constexpr_if_if_mul_rg_A = x_rsci_idat[94:47];
  wire [46:0] nl_l0_int_mul_sb_64_48_47_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_47_constexpr_if_if_mul_rg_B = y_rsci_idat[46:0];
  wire [47:0] nl_l0_int_mul_sb_64_47_48_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_47_48_constexpr_if_if_mul_rg_A = y_rsci_idat[94:47];
  wire [46:0] nl_l0_int_mul_sb_64_47_48_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_47_48_constexpr_if_if_mul_rg_B = x_rsci_idat[46:0];
  wire[95:0] l0_int_mul_sb_64_95_95_constexpr_if_else_acc_6_nl;
  wire[96:0] nl_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_6_nl;
  wire [96:0] nl_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_rg_A;
  assign nl_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_6_nl = conv_u2u_95_96(l0_int_mul_sb_64_48_47_constexpr_if_if_mul_itm)
      + conv_u2u_47_96(l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_1[93:47]);
  assign l0_int_mul_sb_64_95_95_constexpr_if_else_acc_6_nl = nl_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_6_nl[95:0];
  assign nl_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_rg_A = {1'b0, l0_int_mul_sb_64_95_95_constexpr_if_else_acc_6_nl};
  wire [96:0] nl_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_rg_B;
  assign nl_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_rg_B = {2'b0, l0_int_mul_sb_64_47_48_constexpr_if_if_mul_itm};
  wire [46:0] nl_l0_int_mul_sb_64_47_47_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_47_47_constexpr_if_if_mul_rg_A = x_rsci_idat[46:0];
  wire [46:0] nl_l0_int_mul_sb_64_47_47_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_47_47_constexpr_if_if_mul_rg_B = y_rsci_idat[46:0];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_23_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_23_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[191:144];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_23_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_23_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[47:0];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_22_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_22_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[143:96];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_22_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_22_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[95:48];
  wire[96:0] l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_6_nl;
  wire[97:0] nl_l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_6_nl;
  wire [97:0] nl_l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_rg_A;
  assign nl_l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_6_nl = conv_u2u_96_97(l0_int_mul_sb_64_48_48_23_constexpr_if_if_mul_itm)
      + conv_u2u_48_97(l0_int_mul_sb_64_48_48_return_21_sva_1[95:48]);
  assign l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_6_nl = nl_l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_6_nl[96:0];
  assign nl_l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_rg_A = {1'b0, l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_6_nl};
  wire [97:0] nl_l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_rg_B;
  assign nl_l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_rg_B = {2'b0, l0_int_mul_sb_64_48_48_22_constexpr_if_if_mul_itm};
  wire [47:0] nl_l0_int_mul_sb_64_48_48_21_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_21_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[143:96];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_21_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_21_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[47:0];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_19_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_19_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[95:48];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_19_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_19_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[143:96];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_18_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_18_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[47:0];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_18_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_18_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[191:144];
  wire[96:0] l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_6_nl;
  wire[97:0] nl_l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_6_nl;
  wire [97:0] nl_l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_rg_A;
  assign nl_l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_6_nl = conv_u2u_96_97(l0_int_mul_sb_64_48_48_19_constexpr_if_if_mul_itm)
      + conv_u2u_48_97(l0_int_mul_sb_64_48_48_return_17_sva_1[95:48]);
  assign l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_6_nl = nl_l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_6_nl[96:0];
  assign nl_l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_rg_A = {1'b0, l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_6_nl};
  wire [97:0] nl_l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_rg_B;
  assign nl_l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_rg_B = {2'b0, l0_int_mul_sb_64_48_48_18_constexpr_if_if_mul_itm};
  wire [47:0] nl_l0_int_mul_sb_64_48_48_17_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_17_constexpr_if_if_mul_rg_A = l0_int_mul_kar_64_192_192_x_sva_1[47:0];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_17_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_17_constexpr_if_if_mul_rg_B = l0_int_mul_kar_64_192_192_y_sva_1[143:96];
  wire [47:0] nl_l0_int_mul_sb_64_48_47_6_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_47_6_constexpr_if_if_mul_rg_A = x_rsci_idat[380:333];
  wire [46:0] nl_l0_int_mul_sb_64_48_47_6_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_47_6_constexpr_if_if_mul_rg_B = y_rsci_idat[236:190];
  wire [96:0] nl_l0_int_mul_sb_64_96_95_constexpr_if_else_acc_4_rg_A;
  assign nl_l0_int_mul_sb_64_96_95_constexpr_if_else_acc_4_rg_A = {2'b0, l0_int_mul_sb_64_48_47_6_constexpr_if_if_mul_itm};
  wire [96:0] nl_l0_int_mul_sb_64_96_95_constexpr_if_else_acc_4_rg_B;
  assign nl_l0_int_mul_sb_64_96_95_constexpr_if_else_acc_4_rg_B = {1'b0, l0_int_mul_sb_64_96_95_constexpr_if_else_acc_psp_sva_1[96:1]};
  wire [47:0] nl_l0_int_mul_sb_64_48_48_7_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_7_constexpr_if_if_mul_rg_A = x_rsci_idat[332:285];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_7_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_7_constexpr_if_if_mul_rg_B = y_rsci_idat[284:237];
  wire [47:0] nl_l0_int_mul_sb_64_48_47_5_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_47_5_constexpr_if_if_mul_rg_A = x_rsci_idat[332:285];
  wire [46:0] nl_l0_int_mul_sb_64_48_47_5_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_47_5_constexpr_if_if_mul_rg_B = y_rsci_idat[236:190];
  wire [47:0] nl_l0_int_mul_sb_64_47_48_6_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_47_48_6_constexpr_if_if_mul_rg_A = y_rsci_idat[380:333];
  wire [46:0] nl_l0_int_mul_sb_64_47_48_6_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_47_48_6_constexpr_if_if_mul_rg_B = x_rsci_idat[236:190];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_5_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_48_5_constexpr_if_if_mul_rg_A = x_rsci_idat[284:237];
  wire [47:0] nl_l0_int_mul_sb_64_48_48_5_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_48_5_constexpr_if_if_mul_rg_B = y_rsci_idat[332:285];
  wire[95:0] l0_int_mul_sb_64_95_96_constexpr_if_else_acc_nl;
  wire[96:0] nl_l0_int_mul_sb_64_95_96_constexpr_if_else_acc_nl;
  wire [97:0] nl_l0_int_mul_sb_64_95_96_constexpr_if_else_acc_rg_A;
  assign nl_l0_int_mul_sb_64_95_96_constexpr_if_else_acc_nl = conv_u2u_95_96(l0_int_mul_sb_64_47_48_6_constexpr_if_if_mul_itm)
      + conv_u2u_47_96(l0_int_mul_sb_64_95_96_constexpr_if_else_z0_sva_1[94:48]);
  assign l0_int_mul_sb_64_95_96_constexpr_if_else_acc_nl = nl_l0_int_mul_sb_64_95_96_constexpr_if_else_acc_nl[95:0];
  assign nl_l0_int_mul_sb_64_95_96_constexpr_if_else_acc_rg_A = {1'b0 , l0_int_mul_sb_64_95_96_constexpr_if_else_acc_nl
      , (l0_int_mul_sb_64_95_96_constexpr_if_else_z0_sva_1[47])};
  wire [97:0] nl_l0_int_mul_sb_64_95_96_constexpr_if_else_acc_rg_B;
  assign nl_l0_int_mul_sb_64_95_96_constexpr_if_else_acc_rg_B = {2'b0, l0_int_mul_sb_64_48_48_5_constexpr_if_if_mul_itm};
  wire [47:0] nl_l0_int_mul_sb_64_47_48_5_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_47_48_5_constexpr_if_if_mul_rg_A = y_rsci_idat[332:285];
  wire [46:0] nl_l0_int_mul_sb_64_47_48_5_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_47_48_5_constexpr_if_if_mul_rg_B = x_rsci_idat[236:190];
  wire [47:0] nl_l0_int_mul_sb_64_48_47_2_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_47_2_constexpr_if_if_mul_rg_A = x_rsci_idat[189:142];
  wire [46:0] nl_l0_int_mul_sb_64_48_47_2_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_47_2_constexpr_if_if_mul_rg_B = y_rsci_idat[46:0];
  wire [47:0] nl_l0_int_mul_sb_64_47_48_2_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_47_48_2_constexpr_if_if_mul_rg_A = y_rsci_idat[94:47];
  wire [46:0] nl_l0_int_mul_sb_64_47_48_2_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_47_48_2_constexpr_if_if_mul_rg_B = x_rsci_idat[141:95];
  wire[95:0] l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_6_nl;
  wire[96:0] nl_l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_6_nl;
  wire [96:0] nl_l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_rg_A;
  assign nl_l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_6_nl = conv_u2u_95_96(l0_int_mul_sb_64_48_47_2_constexpr_if_if_mul_itm)
      + conv_u2u_47_96(l0_int_mul_sb_64_95_95_2_constexpr_if_else_z0_sva_1[93:47]);
  assign l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_6_nl = nl_l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_6_nl[95:0];
  assign nl_l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_rg_A = {1'b0, l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_6_nl};
  wire [96:0] nl_l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_rg_B;
  assign nl_l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_rg_B = {2'b0, l0_int_mul_sb_64_47_48_2_constexpr_if_if_mul_itm};
  wire [46:0] nl_l0_int_mul_sb_64_47_47_2_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_47_47_2_constexpr_if_if_mul_rg_A = x_rsci_idat[141:95];
  wire [46:0] nl_l0_int_mul_sb_64_47_47_2_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_47_47_2_constexpr_if_if_mul_rg_B = y_rsci_idat[46:0];
  wire [47:0] nl_l0_int_mul_sb_64_48_47_1_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_48_47_1_constexpr_if_if_mul_rg_A = x_rsci_idat[94:47];
  wire [46:0] nl_l0_int_mul_sb_64_48_47_1_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_48_47_1_constexpr_if_if_mul_rg_B = y_rsci_idat[141:95];
  wire [47:0] nl_l0_int_mul_sb_64_47_48_1_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_47_48_1_constexpr_if_if_mul_rg_A = y_rsci_idat[189:142];
  wire [46:0] nl_l0_int_mul_sb_64_47_48_1_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_47_48_1_constexpr_if_if_mul_rg_B = x_rsci_idat[46:0];
  wire[95:0] l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_6_nl;
  wire[96:0] nl_l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_6_nl;
  wire [96:0] nl_l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_rg_A;
  assign nl_l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_6_nl = conv_u2u_95_96(l0_int_mul_sb_64_48_47_1_constexpr_if_if_mul_itm)
      + conv_u2u_47_96(l0_int_mul_sb_64_95_95_1_constexpr_if_else_z0_sva_1[93:47]);
  assign l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_6_nl = nl_l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_6_nl[95:0];
  assign nl_l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_rg_A = {1'b0, l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_6_nl};
  wire [96:0] nl_l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_rg_B;
  assign nl_l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_rg_B = {2'b0, l0_int_mul_sb_64_47_48_1_constexpr_if_if_mul_itm};
  wire [46:0] nl_l0_int_mul_sb_64_47_47_1_constexpr_if_if_mul_rg_A;
  assign nl_l0_int_mul_sb_64_47_47_1_constexpr_if_if_mul_rg_A = x_rsci_idat[46:0];
  wire [46:0] nl_l0_int_mul_sb_64_47_47_1_constexpr_if_if_mul_rg_B;
  assign nl_l0_int_mul_sb_64_47_47_1_constexpr_if_if_mul_rg_B = y_rsci_idat[141:95];
  ccs_in_v1 #(.rscid(32'sd1),
  .width(32'sd381)) x_rsci (
      .dat(x_rsc_dat),
      .idat(x_rsci_idat)
    );
  ccs_in_v1 #(.rscid(32'sd2),
  .width(32'sd381)) y_rsci (
      .dat(y_rsc_dat),
      .idat(y_rsci_idat)
    );
  ccs_out_v1 #(.rscid(32'sd3),
  .width(32'sd381)) z_rsci (
      .idat(z_rsci_idat),
      .dat(z_rsc_dat)
    );
  mgc_io_sync_v2 #(.valid(32'sd0)) x_triosy_obj (
      .ld(reg_y_triosy_obj_ld_cse),
      .lz(x_triosy_lz)
    );
  mgc_io_sync_v2 #(.valid(32'sd0)) y_triosy_obj (
      .ld(reg_y_triosy_obj_ld_cse),
      .lz(y_triosy_lz)
    );
  mgc_io_sync_v2 #(.valid(32'sd0)) z_triosy_obj (
      .ld(z_triosy_obj_ld),
      .lz(z_triosy_lz)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd381),
  .B_width(32'sd381),
  .tc_mode(32'sd0)) mont_inst_cmul_q_inst_run_constexpr_if_if_mul_rg (
      .A(mont_inst_cmul_q_prime_inst_run_constexpr_if_else_constexpr_if_if_mul_itm_1),
      .B(381'b110100000000100010001111010100011100101111111111001101001101001001011000110111010011110110110010000110100101110101100110101110110010001110111010010111000010011110011100001010001001010111111011001110011000011010010101000001111011010110000111101100010010000011110101010111111111111111110101100010101001111111111111111111011100111111110111111111111111111111111111111111010101010101011),
      .PRODUCT(mont_inst_cmul_q_inst_run_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd380),
  .B_width(32'sd381),
  .tc_mode(32'sd0)) mont_inst_cmul_q_prime_inst_run_constexpr_if_else_constexpr_if_if_mul_rg
      (
      .A(380'b11101011000001100001000001101111111010101010111111001001010001101000101100110001011011111110111000100110100011001111010110000001100111101100110010100000111010001110101100101101101101001100000101101110111100101110111100001100100011100011000010110100100000101000011010101101101110010010110110011101000100010011111010001000100111110011111111111111110011111111111111001111111111111101),
      .B(nl_mont_inst_cmul_q_prime_inst_run_constexpr_if_else_constexpr_if_if_mul_rg_B[380:0]),
      .PRODUCT(mont_inst_cmul_q_prime_inst_run_constexpr_if_else_constexpr_if_if_mul_itm_pdr)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_27_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_27_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_27_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_27_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd97)) l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_10_rg
      (
      .A(nl_l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_10_rg_A[96:0]),
      .B(nl_l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_10_rg_B[96:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_10_itm),
      .CO(CO_out)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_11_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_11_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_11_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_11_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd97)) l0_int_mul_sb_64_96_96_constexpr_if_else_acc_8_rg
      (
      .A(nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_8_rg_A[96:0]),
      .B(nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_8_rg_B[96:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_96_96_constexpr_if_else_acc_8_itm),
      .CO(CO_out_1)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_47_3_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_47_3_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_47_3_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_48_47_3_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd96)) l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_8_rg
      (
      .A(nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_8_rg_A[95:0]),
      .B(nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_8_rg_B[95:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_8_itm),
      .CO(CO_out_2)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd47),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_rg_A[46:0]),
      .B(nl_l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd98)) l0_int_mul_sb_64_96_96_constexpr_if_else_acc_rg
      (
      .A(nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_rg_A[97:0]),
      .B(nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_rg_B[97:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_96_96_constexpr_if_else_acc_itm),
      .CO(CO_out_3)
    );
  ccs_dw_add_v1 #(.width(32'sd97)) l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_rg
      (
      .A(nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_rg_A[96:0]),
      .B(nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_rg_B[96:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_itm),
      .CO(CO_out_4)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_47_4_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_47_4_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_47_4_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_48_47_4_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_47_48_4_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_47_48_4_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_47_48_4_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_47_48_4_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd97)) l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_rg
      (
      .A(nl_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_rg_A[96:0]),
      .B(nl_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_rg_B[96:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_psp_sva_1),
      .CO(CO_out_5)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_4_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_4_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_4_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_4_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_8_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_8_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_8_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_8_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_6_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_6_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_6_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_6_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd193)) l0_int_mul_sb_64_191_191_constexpr_if_else_acc_rg
      (
      .A(nl_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_rg_A[192:0]),
      .B(nl_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_rg_B[192:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_sva_1),
      .CO(CO_out_6)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_13_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_13_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_13_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_return_13_sva_1)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_15_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_15_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_15_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_15_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_14_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_14_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_14_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_14_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd98)) l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_rg
      (
      .A(nl_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_rg_A[97:0]),
      .B(nl_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_rg_B[97:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_psp_sva_1),
      .CO(CO_out_7)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_24_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_24_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_24_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_24_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd96)) l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_5_rg
      (
      .A(l0_int_mul_sb_64_48_48_24_constexpr_if_if_mul_itm),
      .B(nl_l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_5_rg_B[95:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_5_itm),
      .CO(CO_out_8)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_16_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_16_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_16_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_16_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd96)) l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_5_rg
      (
      .A(l0_int_mul_sb_64_48_48_16_constexpr_if_if_mul_itm),
      .B(nl_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_5_rg_B[95:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_5_itm),
      .CO(CO_out_9)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_20_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_20_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_20_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_20_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd194)) l0_int_mul_sb_64_192_192_constexpr_if_else_acc_rg
      (
      .A(nl_l0_int_mul_sb_64_192_192_constexpr_if_else_acc_rg_A[193:0]),
      .B(nl_l0_int_mul_sb_64_192_192_constexpr_if_else_acc_rg_B[193:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_192_192_constexpr_if_else_acc_psp_sva_1),
      .CO(CO_out_10)
    );
  ccs_dw_add_v1 #(.width(32'sd192)) l0_int_mul_kar_64_192_381_constexpr_if_else_sum_x_acc_rg
      (
      .A(nl_l0_int_mul_kar_64_192_381_constexpr_if_else_sum_x_acc_rg_A[191:0]),
      .B(nl_l0_int_mul_kar_64_192_381_constexpr_if_else_sum_x_acc_rg_B[191:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_kar_64_192_192_x_sva_1),
      .CO(CO_out_11)
    );
  ccs_dw_add_v1 #(.width(32'sd192)) l0_int_mul_kar_64_192_381_constexpr_if_else_sum_y_acc_rg
      (
      .A(nl_l0_int_mul_kar_64_192_381_constexpr_if_else_sum_y_acc_rg_A[191:0]),
      .B(nl_l0_int_mul_kar_64_192_381_constexpr_if_else_sum_y_acc_rg_B[191:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_kar_64_192_192_y_sva_1),
      .CO(CO_out_12)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_2_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_2_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_2_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_2_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_1_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_1_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_1_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_1_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd192)) l0_int_mul_sb_64_190_190_constexpr_if_else_acc_rg
      (
      .A(nl_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_rg_A[191:0]),
      .B(nl_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_rg_B[191:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_sva_1),
      .CO(CO_out_13)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd47),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_47_47_4_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_47_47_4_constexpr_if_if_mul_rg_A[46:0]),
      .B(nl_l0_int_mul_sb_64_47_47_4_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_95_95_4_constexpr_if_else_z0_sva_1)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_47_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_47_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_47_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_48_47_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_47_48_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_47_48_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_47_48_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_47_48_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd97)) l0_int_mul_sb_64_95_95_constexpr_if_else_acc_rg
      (
      .A(nl_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_rg_A[96:0]),
      .B(nl_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_rg_B[96:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_sva_1),
      .CO(CO_out_14)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd47),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_47_47_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_47_47_constexpr_if_if_mul_rg_A[46:0]),
      .B(nl_l0_int_mul_sb_64_47_47_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_1)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_23_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_23_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_23_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_23_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_22_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_22_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_22_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_22_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd98)) l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_rg
      (
      .A(nl_l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_rg_A[97:0]),
      .B(nl_l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_rg_B[97:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_96_96_3_constexpr_if_else_acc_psp_sva_1),
      .CO(CO_out_15)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_21_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_21_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_21_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_return_21_sva_1)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_19_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_19_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_19_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_19_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_18_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_18_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_18_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_18_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd98)) l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_rg
      (
      .A(nl_l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_rg_A[97:0]),
      .B(nl_l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_rg_B[97:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_96_96_2_constexpr_if_else_acc_psp_sva_1),
      .CO(CO_out_16)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_17_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_17_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_17_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_return_17_sva_1)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_47_6_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_47_6_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_47_6_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_48_47_6_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd97)) l0_int_mul_sb_64_96_95_constexpr_if_else_acc_4_rg
      (
      .A(nl_l0_int_mul_sb_64_96_95_constexpr_if_else_acc_4_rg_A[96:0]),
      .B(nl_l0_int_mul_sb_64_96_95_constexpr_if_else_acc_4_rg_B[96:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_96_95_constexpr_if_else_acc_4_psp_sva_1),
      .CO(CO_out_17)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_7_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_7_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_7_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_7_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_47_5_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_47_5_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_47_5_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_96_95_constexpr_if_else_z0_sva_1)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_47_48_6_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_47_48_6_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_47_48_6_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_47_48_6_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd48),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_48_5_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_48_5_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_48_5_constexpr_if_if_mul_rg_B[47:0]),
      .PRODUCT(l0_int_mul_sb_64_48_48_5_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd98)) l0_int_mul_sb_64_95_96_constexpr_if_else_acc_rg
      (
      .A(nl_l0_int_mul_sb_64_95_96_constexpr_if_else_acc_rg_A[97:0]),
      .B(nl_l0_int_mul_sb_64_95_96_constexpr_if_else_acc_rg_B[97:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_95_96_constexpr_if_else_acc_psp_sva_1),
      .CO(CO_out_18)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_47_48_5_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_47_48_5_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_47_48_5_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_95_96_constexpr_if_else_z0_sva_1)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_47_2_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_47_2_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_47_2_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_48_47_2_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_47_48_2_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_47_48_2_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_47_48_2_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_47_48_2_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd97)) l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_rg
      (
      .A(nl_l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_rg_A[96:0]),
      .B(nl_l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_rg_B[96:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_95_95_2_constexpr_if_else_acc_psp_sva_1),
      .CO(CO_out_19)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd47),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_47_47_2_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_47_47_2_constexpr_if_if_mul_rg_A[46:0]),
      .B(nl_l0_int_mul_sb_64_47_47_2_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_95_95_2_constexpr_if_else_z0_sva_1)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_48_47_1_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_48_47_1_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_48_47_1_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_48_47_1_constexpr_if_if_mul_itm)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd48),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_47_48_1_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_47_48_1_constexpr_if_if_mul_rg_A[47:0]),
      .B(nl_l0_int_mul_sb_64_47_48_1_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_47_48_1_constexpr_if_if_mul_itm)
    );
  ccs_dw_add_v1 #(.width(32'sd97)) l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_rg
      (
      .A(nl_l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_rg_A[96:0]),
      .B(nl_l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_rg_B[96:0]),
      .CI(1'b0),
      .SUM(l0_int_mul_sb_64_95_95_1_constexpr_if_else_acc_psp_sva_1),
      .CO(CO_out_20)
    );
  ccs_dw_mult_v1 #(.A_width(32'sd47),
  .B_width(32'sd47),
  .tc_mode(32'sd0)) l0_int_mul_sb_64_47_47_1_constexpr_if_if_mul_rg (
      .A(nl_l0_int_mul_sb_64_47_47_1_constexpr_if_if_mul_rg_A[46:0]),
      .B(nl_l0_int_mul_sb_64_47_47_1_constexpr_if_if_mul_rg_B[46:0]),
      .PRODUCT(l0_int_mul_sb_64_95_95_1_constexpr_if_else_z0_sva_1)
    );
  assign nl_inst_mont_inst_run_diff_sva_1 = conv_u2s_382_383(inst_mont_inst_run_t_mq_762_381_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_mont_inst_run_diff_sva_1 = nl_inst_mont_inst_run_diff_sva_1[382:0];
  assign nl_l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_1 = conv_u2u_195_382(l0_int_mul_kar_64_192_381_constexpr_if_else_acc_2_itm_1[384:190])
      + ({l0_int_mul_sb_64_96_96_constexpr_if_else_acc_6_psp_sva_1 , l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_94_0_1_itm_2
      , l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_0_1_itm_2
      , l0_int_mul_sb_64_95_95_4_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_psp_46_0_itm_2
      , l0_int_mul_sb_64_95_95_4_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_z0_46_0_3_itm_1});
  assign l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_1 = nl_l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_1[381:0];
  assign nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_6_psp_sva_1_1 = conv_u2u_146_192({l0_int_mul_sb_64_96_96_constexpr_if_else_acc_itm
      , l0_int_mul_sb_64_96_96_constexpr_if_else_acc_7_itm_1_47_0}) + ({l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_itm_1
      , l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_itm_1});
  assign l0_int_mul_sb_64_96_96_constexpr_if_else_acc_6_psp_sva_1_1 = nl_l0_int_mul_sb_64_96_96_constexpr_if_else_acc_6_psp_sva_1_1[191:0];
  assign nl_l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_2_sdt_1 = conv_u2u_382_383({(~
      l0_int_mul_sb_64_96_96_constexpr_if_else_acc_6_psp_sva_1_1) , (~ l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_94_0_1_itm_1)
      , (~ l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_0_1_itm_1)
      , (~ l0_int_mul_sb_64_95_95_4_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_psp_46_0_itm_1)
      , (~ l0_int_mul_sb_64_95_95_4_constexpr_if_else_z0_sva_1_46_0)}) + conv_u2u_380_383({(~
      l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_6_psp_sva_1) , (~ l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_sva_1_94_0)
      , (~ l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_3_itm_1)
      , (~ l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_sva_1_46_0) , (~ l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_1_46_0)});
  assign l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_2_sdt_1 = nl_l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_2_sdt_1[382:0];
  assign nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_6_psp_sva_1 = conv_u2u_144_190({l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_itm
      , l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_7_itm_1_46_0}) + ({l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_itm_1
      , l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_itm_1});
  assign l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_6_psp_sva_1 = nl_l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_6_psp_sva_1[189:0];
  assign nl_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_sva_1 = l0_int_mul_sb_64_48_48_constexpr_if_if_mul_itm
      + conv_u2u_50_96(l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_sva_1[96:47]);
  assign l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_sva_1 = nl_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_sva_1[95:0];
  assign nl_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_sva_1 = l0_int_mul_sb_64_48_48_4_constexpr_if_if_mul_itm
      + conv_u2u_50_96(l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_psp_sva_1[96:47]);
  assign l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_sva_1 = nl_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_sva_1[95:0];
  assign nl_l0_int_mul_sb_64_96_95_constexpr_if_else_acc_psp_sva_1 = conv_u2u_96_97(l0_int_mul_sb_64_48_48_7_constexpr_if_if_mul_itm)
      + conv_u2u_48_97(l0_int_mul_sb_64_96_95_constexpr_if_else_z0_sva_1[94:47]);
  assign l0_int_mul_sb_64_96_95_constexpr_if_else_acc_psp_sva_1 = nl_l0_int_mul_sb_64_96_95_constexpr_if_else_acc_psp_sva_1[96:0];
  always @(posedge clk) begin
    if ( rst ) begin
      z_triosy_obj_ld <= 1'b0;
      inst_mont_inst_run_t_mq_762_381_sva_1 <= 382'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      reg_y_triosy_obj_ld_cse <= 1'b0;
      main_stage_0_3 <= 1'b0;
      main_stage_0_4 <= 1'b0;
      main_stage_0_5 <= 1'b0;
      mont_inst_cmul_q_prime_inst_run_constexpr_if_else_constexpr_if_if_mul_itm_1
          <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_sva_1_571_190 <= 382'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_sva_1_189_0 <= 190'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_94_0_3_itm_2
          <= 95'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_3_itm_3
          <= 1'b0;
      l0_int_mul_sb_64_95_95_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_46_0_1_itm_2
          <= 47'b00000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_95_95_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_z0_46_0_4_itm_1
          <= 47'b00000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_2_46_0 <= 47'b00000000000000000000000000000000000000000000000;
      l0_int_mul_kar_64_192_381_constexpr_if_else_acc_2_itm_1 <= 385'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_94_0_itm_1
          <= 95'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_itm_2
          <= 1'b0;
      l0_int_mul_sb_64_95_95_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_46_0_2_itm_1
          <= 47'b00000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_96_96_constexpr_if_else_acc_6_psp_sva_1 <= 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_94_0_1_itm_2
          <= 95'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_0_1_itm_2
          <= 1'b0;
      l0_int_mul_sb_64_95_95_4_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_psp_46_0_itm_2
          <= 47'b00000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_95_95_4_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_z0_46_0_3_itm_1
          <= 47'b00000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_sva_1_46_0 <= 47'b00000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_sva_1_94_0 <= 95'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_95_95_4_constexpr_if_else_z0_sva_1_46_0 <= 47'b00000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_7_itm_1_144_48 <= 97'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_itm_1 <= 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_7_itm_1_47_0 <= 48'b000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_itm_1 <= 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_itm_1 <= 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_192_192_constexpr_if_else_slc_l0_int_mul_sb_64_192_192_constexpr_if_else_acc_psp_95_0_itm_1
          <= 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_96_96_1_constexpr_if_else_slc_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_psp_47_0_itm_1
          <= 48'b000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_96_96_1_constexpr_if_else_slc_l0_int_mul_sb_64_48_48_return_13_47_0_itm_1
          <= 48'b000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_1_46_0 <= 47'b00000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_96_96_constexpr_if_else_acc_7_itm_1_144_48 <= 97'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_itm_1 <= 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_96_96_constexpr_if_else_acc_7_itm_1_47_0 <= 48'b000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_itm_1 <= 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_itm_1 <= 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_7_itm_1_142_47 <= 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_itm_1 <= 95'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_7_itm_1_46_0 <= 47'b00000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_itm_1 <= 96'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_itm_1 <= 94'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_3_itm_1
          <= 1'b0;
      l0_int_mul_sb_64_95_95_4_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_psp_46_0_itm_1
          <= 47'b00000000000000000000000000000000000000000000000;
      l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_0_1_itm_1
          <= 1'b0;
      l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_94_0_1_itm_1
          <= 95'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    end
    else begin
      z_triosy_obj_ld <= main_stage_0_5;
      inst_mont_inst_run_t_mq_762_381_sva_1 <= readslicef_763_382_381(inst_mont_inst_run_t_mq_acc_nl);
      reg_y_triosy_obj_ld_cse <= 1'b1;
      main_stage_0_3 <= reg_y_triosy_obj_ld_cse;
      main_stage_0_4 <= main_stage_0_3;
      main_stage_0_5 <= main_stage_0_4;
      mont_inst_cmul_q_prime_inst_run_constexpr_if_else_constexpr_if_if_mul_itm_1
          <= mont_inst_cmul_q_prime_inst_run_constexpr_if_else_constexpr_if_if_mul_itm_pdr[380:0];
      l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_sva_1_571_190 <= l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_1;
      l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_sva_1_189_0 <= l0_int_mul_kar_64_192_381_constexpr_if_else_acc_2_itm_1[189:0];
      l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_94_0_3_itm_2
          <= l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_94_0_itm_1;
      l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_3_itm_3
          <= l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_itm_2;
      l0_int_mul_sb_64_95_95_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_46_0_1_itm_2
          <= l0_int_mul_sb_64_95_95_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_46_0_2_itm_1;
      l0_int_mul_sb_64_95_95_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_z0_46_0_4_itm_1
          <= l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_2_46_0;
      l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_2_46_0 <= l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_1_46_0;
      l0_int_mul_kar_64_192_381_constexpr_if_else_acc_2_itm_1 <= nl_l0_int_mul_kar_64_192_381_constexpr_if_else_acc_2_itm_1[384:0];
      l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_94_0_itm_1
          <= l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_sva_1_94_0;
      l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_itm_2
          <= l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_3_itm_1;
      l0_int_mul_sb_64_95_95_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_46_0_2_itm_1
          <= l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_sva_1_46_0;
      l0_int_mul_sb_64_96_96_constexpr_if_else_acc_6_psp_sva_1 <= l0_int_mul_sb_64_96_96_constexpr_if_else_acc_6_psp_sva_1_1;
      l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_94_0_1_itm_2
          <= l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_94_0_1_itm_1;
      l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_0_1_itm_2
          <= l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_0_1_itm_1;
      l0_int_mul_sb_64_95_95_4_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_psp_46_0_itm_2
          <= l0_int_mul_sb_64_95_95_4_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_psp_46_0_itm_1;
      l0_int_mul_sb_64_95_95_4_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_z0_46_0_3_itm_1
          <= l0_int_mul_sb_64_95_95_4_constexpr_if_else_z0_sva_1_46_0;
      l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_sva_1_46_0 <= l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_sva_1[46:0];
      l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_sva_1_94_0 <= l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_sva_1[94:0];
      l0_int_mul_sb_64_95_95_4_constexpr_if_else_z0_sva_1_46_0 <= l0_int_mul_sb_64_95_95_4_constexpr_if_else_z0_sva_1[46:0];
      l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_7_itm_1_144_48 <= l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_10_itm;
      l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_itm_1 <= l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_itm;
      l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_7_itm_1_47_0 <= l0_int_mul_sb_64_192_192_constexpr_if_else_acc_psp_sva_1[143:96];
      l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_itm_1 <= l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_itm;
      l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_itm_1 <= l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_itm;
      l0_int_mul_sb_64_192_192_constexpr_if_else_slc_l0_int_mul_sb_64_192_192_constexpr_if_else_acc_psp_95_0_itm_1
          <= l0_int_mul_sb_64_192_192_constexpr_if_else_acc_psp_sva_1[95:0];
      l0_int_mul_sb_64_96_96_1_constexpr_if_else_slc_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_psp_47_0_itm_1
          <= l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_psp_sva_1[47:0];
      l0_int_mul_sb_64_96_96_1_constexpr_if_else_slc_l0_int_mul_sb_64_48_48_return_13_47_0_itm_1
          <= l0_int_mul_sb_64_48_48_return_13_sva_1[47:0];
      l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_1_46_0 <= l0_int_mul_sb_64_95_95_constexpr_if_else_z0_sva_1[46:0];
      l0_int_mul_sb_64_96_96_constexpr_if_else_acc_7_itm_1_144_48 <= l0_int_mul_sb_64_96_96_constexpr_if_else_acc_8_itm;
      l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_itm_1 <= l0_int_mul_sb_64_48_48_10_constexpr_if_if_mul_itm;
      l0_int_mul_sb_64_96_96_constexpr_if_else_acc_7_itm_1_47_0 <= l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_sva_1[142:95];
      l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_itm_1 <= l0_int_mul_sb_64_48_48_12_constexpr_if_if_mul_itm;
      l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_itm_1 <= l0_int_mul_sb_64_48_48_9_constexpr_if_if_mul_itm;
      l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_7_itm_1_142_47 <= l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_8_itm;
      l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_itm_1 <= l0_int_mul_sb_64_47_48_3_constexpr_if_if_mul_itm;
      l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_7_itm_1_46_0 <= l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_sva_1[141:95];
      l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_itm_1 <= l0_int_mul_sb_64_48_48_3_constexpr_if_if_mul_itm;
      l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_itm_1 <= l0_int_mul_sb_64_47_47_3_constexpr_if_if_mul_itm;
      l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_3_itm_1
          <= l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_sva_1[0];
      l0_int_mul_sb_64_95_95_4_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_psp_46_0_itm_1
          <= l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_psp_sva_1[46:0];
      l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_0_1_itm_1
          <= l0_int_mul_sb_64_95_95_4_constexpr_if_else_acc_5_psp_sva_1[0];
      l0_int_mul_sb_64_191_191_constexpr_if_else_slc_l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_94_0_1_itm_1
          <= l0_int_mul_sb_64_191_191_constexpr_if_else_acc_psp_sva_1[94:0];
    end
  end
  always @(posedge clk) begin
    if ( rst ) begin
      z_rsci_idat <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    end
    else if ( main_stage_0_5 ) begin
      z_rsci_idat <= MUX_v_381_2_2((inst_mont_inst_run_diff_sva_1[380:0]), (inst_mont_inst_run_t_mq_762_381_sva_1[380:0]),
          inst_mont_inst_run_diff_sva_1[382]);
    end
  end
  assign nl_inst_mont_inst_run_t_mq_acc_nl = conv_u2u_762_763(mont_inst_cmul_q_inst_run_constexpr_if_if_mul_itm)
      + conv_u2u_762_763({l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_sva_1_571_190
      , l0_int_mul_kar_64_192_381_constexpr_if_else_acc_psp_sva_1_189_0 , l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_190_190_constexpr_if_else_acc_psp_94_0_3_itm_2
      , l0_int_mul_sb_64_190_190_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_5_psp_0_3_itm_3
      , l0_int_mul_sb_64_95_95_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_acc_psp_46_0_1_itm_2
      , l0_int_mul_sb_64_95_95_constexpr_if_else_slc_l0_int_mul_sb_64_95_95_constexpr_if_else_z0_46_0_4_itm_1});
  assign inst_mont_inst_run_t_mq_acc_nl = nl_inst_mont_inst_run_t_mq_acc_nl[762:0];
  assign nl_l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_4_nl = conv_u2s_382_383(l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_2_sdt_1[382:1])
      + 383'b10110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
  assign l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_4_nl = nl_l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_4_nl[382:0];
  assign nl_l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_9_nl = conv_u2u_97_98(l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_7_itm_1_144_48)
      + conv_u2u_96_98(l0_int_mul_sb_64_48_48_26_constexpr_if_if_mul_itm_1);
  assign l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_9_nl = nl_l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_9_nl[97:0];
  assign nl_l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_nl = conv_u2u_146_192({l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_9_nl
      , l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_7_itm_1_47_0}) + ({l0_int_mul_sb_64_48_48_28_constexpr_if_if_mul_itm_1
      , l0_int_mul_sb_64_48_48_25_constexpr_if_if_mul_itm_1});
  assign l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_nl = nl_l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_nl[191:0];
  assign nl_l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_nl = ({l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_4_nl
      , (l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_2_sdt_1[0])}) + ({l0_int_mul_sb_64_96_96_4_constexpr_if_else_acc_nl
      , l0_int_mul_sb_64_192_192_constexpr_if_else_slc_l0_int_mul_sb_64_192_192_constexpr_if_else_acc_psp_95_0_itm_1
      , l0_int_mul_sb_64_96_96_1_constexpr_if_else_slc_l0_int_mul_sb_64_96_96_1_constexpr_if_else_acc_psp_47_0_itm_1
      , l0_int_mul_sb_64_96_96_1_constexpr_if_else_slc_l0_int_mul_sb_64_48_48_return_13_47_0_itm_1});
  assign l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_nl = nl_l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_nl[383:0];
  assign nl_l0_int_mul_kar_64_192_381_constexpr_if_else_acc_2_itm_1  = (conv_u2u_384_385(l0_int_mul_kar_64_192_381_constexpr_if_else_diff_acc_nl)
      + conv_u2u_190_385(l0_int_mul_sb_64_95_95_3_constexpr_if_else_acc_6_psp_sva_1));

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


  function automatic [381:0] readslicef_763_382_381;
    input [762:0] vector;
    reg [762:0] tmp;
  begin
    tmp = vector >> 381;
    readslicef_763_382_381 = tmp[381:0];
  end
  endfunction


  function automatic [382:0] conv_u2s_382_383 ;
    input [381:0]  vector ;
  begin
    conv_u2s_382_383 =  {1'b0, vector};
  end
  endfunction


  function automatic [95:0] conv_u2u_47_96 ;
    input [46:0]  vector ;
  begin
    conv_u2u_47_96 = {{49{1'b0}}, vector};
  end
  endfunction


  function automatic [96:0] conv_u2u_48_97 ;
    input [47:0]  vector ;
  begin
    conv_u2u_48_97 = {{49{1'b0}}, vector};
  end
  endfunction


  function automatic [95:0] conv_u2u_50_96 ;
    input [49:0]  vector ;
  begin
    conv_u2u_50_96 = {{46{1'b0}}, vector};
  end
  endfunction


  function automatic [95:0] conv_u2u_95_96 ;
    input [94:0]  vector ;
  begin
    conv_u2u_95_96 = {1'b0, vector};
  end
  endfunction


  function automatic [190:0] conv_u2u_95_191 ;
    input [94:0]  vector ;
  begin
    conv_u2u_95_191 = {{96{1'b0}}, vector};
  end
  endfunction


  function automatic [191:0] conv_u2u_95_192 ;
    input [94:0]  vector ;
  begin
    conv_u2u_95_192 = {{97{1'b0}}, vector};
  end
  endfunction


  function automatic [96:0] conv_u2u_96_97 ;
    input [95:0]  vector ;
  begin
    conv_u2u_96_97 = {1'b0, vector};
  end
  endfunction


  function automatic [97:0] conv_u2u_96_98 ;
    input [95:0]  vector ;
  begin
    conv_u2u_96_98 = {{2{1'b0}}, vector};
  end
  endfunction


  function automatic [192:0] conv_u2u_96_193 ;
    input [95:0]  vector ;
  begin
    conv_u2u_96_193 = {{97{1'b0}}, vector};
  end
  endfunction


  function automatic [97:0] conv_u2u_97_98 ;
    input [96:0]  vector ;
  begin
    conv_u2u_97_98 = {1'b0, vector};
  end
  endfunction


  function automatic [189:0] conv_u2u_144_190 ;
    input [143:0]  vector ;
  begin
    conv_u2u_144_190 = {{46{1'b0}}, vector};
  end
  endfunction


  function automatic [191:0] conv_u2u_146_192 ;
    input [145:0]  vector ;
  begin
    conv_u2u_146_192 = {{46{1'b0}}, vector};
  end
  endfunction


  function automatic [190:0] conv_u2u_190_191 ;
    input [189:0]  vector ;
  begin
    conv_u2u_190_191 = {1'b0, vector};
  end
  endfunction


  function automatic [384:0] conv_u2u_190_385 ;
    input [189:0]  vector ;
  begin
    conv_u2u_190_385 = {{195{1'b0}}, vector};
  end
  endfunction


  function automatic [191:0] conv_u2u_191_192 ;
    input [190:0]  vector ;
  begin
    conv_u2u_191_192 = {1'b0, vector};
  end
  endfunction


  function automatic [192:0] conv_u2u_192_193 ;
    input [191:0]  vector ;
  begin
    conv_u2u_192_193 = {1'b0, vector};
  end
  endfunction


  function automatic [381:0] conv_u2u_195_382 ;
    input [194:0]  vector ;
  begin
    conv_u2u_195_382 = {{187{1'b0}}, vector};
  end
  endfunction


  function automatic [382:0] conv_u2u_380_383 ;
    input [379:0]  vector ;
  begin
    conv_u2u_380_383 = {{3{1'b0}}, vector};
  end
  endfunction


  function automatic [382:0] conv_u2u_382_383 ;
    input [381:0]  vector ;
  begin
    conv_u2u_382_383 = {1'b0, vector};
  end
  endfunction


  function automatic [384:0] conv_u2u_384_385 ;
    input [383:0]  vector ;
  begin
    conv_u2u_384_385 = {1'b0, vector};
  end
  endfunction


  function automatic [762:0] conv_u2u_762_763 ;
    input [761:0]  vector ;
  begin
    conv_u2u_762_763 = {1'b0, vector};
  end
  endfunction

endmodule

// ------------------------------------------------------------------
//  Design Unit:    l1_mod_mul_d7267ca0d90c7363_top
// ------------------------------------------------------------------


module l1_mod_mul_d7267ca0d90c7363_top (
  clk, rst, x_rsc_dat, x_triosy_lz, y_rsc_dat, y_triosy_lz, z_rsc_dat, z_triosy_lz
);
  input clk;
  input rst;
  input [380:0] x_rsc_dat;
  output x_triosy_lz;
  input [380:0] y_rsc_dat;
  output y_triosy_lz;
  output [380:0] z_rsc_dat;
  output z_triosy_lz;



  // Interconnect Declarations for Component Instantiations 
  l1_mod_mul_d7267ca0d90c7363_run l1_mod_mul_d7267ca0d90c7363_run_inst (
      .clk(clk),
      .rst(rst),
      .x_rsc_dat(x_rsc_dat),
      .x_triosy_lz(x_triosy_lz),
      .y_rsc_dat(y_rsc_dat),
      .y_triosy_lz(y_triosy_lz),
      .z_rsc_dat(z_rsc_dat),
      .z_triosy_lz(z_triosy_lz)
    );
endmodule




module l1_mod_mul_d7267ca0d90c7363 (clk, rst, x, y, z);
  input clk;
  input rst;
  input [380:0] x;
  input [380:0] y;
  output [380:0] z;
  l1_mod_mul_d7267ca0d90c7363_top u (
    .clk(clk),    .rst(rst),    .x_rsc_dat(x),    .y_rsc_dat(y),    .z_rsc_dat(z),    .x_triosy_lz(),    .y_triosy_lz(),    .z_triosy_lz()  );
endmodule

//------> /eda/siemens/Catapult/Mgc_home/pkgs/siflibs/dware/ccs_dw_add_v1.v 
//------------------------------------------------------------------------------
// Catapult Synthesis - dware wrappers
//
// Copyright (c) 2021 Mentor Graphics Corp.
//       All Rights Reserved
//
// This document may be used and distributed without restriction provided that
// this copyright statement is not removed from the file and that any derivative
// work contains this copyright notice.
//
// The design information contained in this file is intended to be an example
// of the functionality which the end user may study in preparation for creating
// their own custom interfaces. This design does not necessarily present a 
// complete implementation of the named protocol or standard.
//
//------------------------------------------------------------------------------

// DW01_add

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

//------> ./rtl.v 
// ----------------------------------------------------------------------
//  HLS HDL:        Verilog Netlister
//  HLS Version:    2026.1_1/1274012 Production Release
//  HLS Date:       Thu Mar 12 18:35:35 PDT 2026
// 
//  Generated by:   ajd9396@cepool-a00.poly.edu
//  Generated date: Fri Oct 23 20:18:50 2026
// ----------------------------------------------------------------------

// 
// ------------------------------------------------------------------
//  Design Unit:    l2_msm_padd_rcb_d7267ca0d90c7363_run
// ------------------------------------------------------------------


module l2_msm_padd_rcb_d7267ca0d90c7363_run (
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
  wire [381:0] inst_modsub_inst_run_2_diff_sva_1;
  wire [382:0] nl_inst_modsub_inst_run_2_diff_sva_1;
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
  wire [380:0] modadd_inst_int_sub_inst_run_16_acc_psp_sva_1;
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
  wire [377:0] inst_modadd_inst_run_12_qr_380_3_lpi_1_dfm_mx0;
  wire inst_modadd_inst_run_12_qr_2_lpi_1_dfm_mx0;
  wire [380:0] modadd_inst_int_sub_inst_run_11_acc_psp_sva_1;
  wire [381:0] nl_modadd_inst_int_sub_inst_run_11_acc_psp_sva_1;
  wire [382:0] inst_modadd_inst_run_10_reduced_out_sva_1;
  wire [383:0] nl_inst_modadd_inst_run_10_reduced_out_sva_1;
  wire [380:0] modadd_inst_int_sub_inst_run_9_acc_psp_sva_1;
  wire [381:0] nl_modadd_inst_int_sub_inst_run_9_acc_psp_sva_1;
  reg main_stage_0_12;
  reg reg_R_X_triosy_obj_ld_cse;
  reg reg_P1_Z_triosy_obj_ld_cse;
  wire [380:0] l1_mod_mul_impl_BLS12_381_BASE_0_run_11_mux1h_rmff;
  wire [380:0] l1_mod_mul_impl_BLS12_381_BASE_0_run_9_mux1h_rmff;
  wire [380:0] l1_mod_mul_impl_BLS12_381_BASE_0_run_8_mux1h_rmff;
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
  reg [380:0] inst_modadd_inst_run_10_qr_lpi_1_dfm_1;
  reg [380:0] inst_modsub_inst_run_qr_lpi_1_dfm_1;
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
  reg [380:0] l2_msm_padd_rcb_d7267ca0d90c7363_impl_FIELD_0_run_t1_1_sva_1;
  reg [380:0] inst_modsub_inst_run_2_qr_lpi_1_dfm_1;
  reg [381:0] inst_modadd_inst_run_14_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_14_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_21_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_21_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_20_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_20_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_19_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_19_adder_out_sva_1;
  wire [380:0] modadd_inst_int_sub_inst_run_18_acc_psp_sva_1;
  wire [381:0] nl_modadd_inst_int_sub_inst_run_18_acc_psp_sva_1;
  wire [378:0] inst_modadd_inst_run_16_qr_380_2_lpi_1_dfm_mx0;
  wire [380:0] inst_modadd_inst_run_14_qr_lpi_1_dfm_mx0;
  wire [381:0] inst_modadd_inst_run_15_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_15_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_8_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_8_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_5_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_5_adder_out_sva_1;
  wire [381:0] inst_modadd_inst_run_2_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_2_adder_out_sva_1;
  wire [380:0] modadd_inst_int_sub_inst_run_13_acc_psp_sva_1;
  wire [381:0] nl_modadd_inst_int_sub_inst_run_13_acc_psp_sva_1;
  wire [378:0] inst_modadd_inst_run_11_qr_380_2_lpi_1_dfm_mx0;
  wire [381:0] inst_modadd_inst_run_10_adder_out_sva_1;
  wire [382:0] nl_inst_modadd_inst_run_10_adder_out_sva_1;

  wire[380:0] modsub_inst_int_add_inst_run_4_acc_nl;
  wire[381:0] nl_modsub_inst_int_add_inst_run_4_acc_nl;
  wire[380:0] modsub_inst_int_add_inst_run_3_acc_nl;
  wire[381:0] nl_modsub_inst_int_add_inst_run_3_acc_nl;
  wire[380:0] modsub_inst_int_add_inst_run_1_acc_nl;
  wire[381:0] nl_modsub_inst_int_add_inst_run_1_acc_nl;
  wire[380:0] modsub_inst_int_add_inst_run_acc_nl;
  wire[381:0] nl_modsub_inst_int_add_inst_run_acc_nl;
  wire[380:0] modsub_inst_int_add_inst_run_2_acc_nl;
  wire[381:0] nl_modsub_inst_int_add_inst_run_2_acc_nl;
  wire[376:0] inst_modadd_inst_run_13_mux_nl;
  wire inst_modadd_inst_run_13_mux_1_nl;
  wire inst_modadd_inst_run_13_mux_2_nl;
  wire[376:0] inst_modadd_inst_run_18_mux_nl;
  wire inst_modadd_inst_run_18_mux_1_nl;
  wire inst_modadd_inst_run_18_mux_2_nl;
  wire[380:0] inst_modadd_inst_run_8_mux_nl;
  wire[380:0] inst_modadd_inst_run_5_mux_nl;
  wire[380:0] inst_modadd_inst_run_2_mux_nl;
  wire[378:0] inst_modadd_inst_run_9_mux_nl;

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
  wire [380:0] nl_modadd_inst_int_sub_inst_run_16_acc_rg_A;
  assign nl_modadd_inst_int_sub_inst_run_16_acc_rg_A = {1'b0, inst_modsub_inst_run_2_qr_lpi_1_dfm_1[380:1]};
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
  l1_mod_mul_d7267ca0d90c7363  modmul_inst_rtl_cmp (
      .x(P0_X_rsci_idat),
      .y(P1_X_rsci_idat),
      .z(modmul_inst_rtl_cmp_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363  modmul_inst_rtl_cmp_1 (
      .x(l1_mod_mul_impl_BLS12_381_BASE_0_run_11_mux1h_rmff),
      .y(inst_modsub_inst_run_1_qr_lpi_1_dfm_1),
      .z(modmul_inst_rtl_cmp_1_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363  modmul_inst_rtl_cmp_2 (
      .x(inst_modadd_inst_run_10_qr_lpi_1_dfm_1),
      .y(inst_modsub_inst_run_qr_lpi_1_dfm_1),
      .z(modmul_inst_rtl_cmp_2_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363  modmul_inst_rtl_cmp_3 (
      .x(l1_mod_mul_impl_BLS12_381_BASE_0_run_9_mux1h_rmff),
      .y(l1_mod_mul_impl_BLS12_381_BASE_0_run_11_mux1h_rmff),
      .z(modmul_inst_rtl_cmp_3_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363  modmul_inst_rtl_cmp_4 (
      .x(l1_mod_mul_impl_BLS12_381_BASE_0_run_8_mux1h_rmff),
      .y(inst_modadd_inst_run_10_qr_lpi_1_dfm_1),
      .z(modmul_inst_rtl_cmp_4_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363  modmul_inst_rtl_cmp_5 (
      .x(inst_modsub_inst_run_qr_lpi_1_dfm_1),
      .y(l1_mod_mul_impl_BLS12_381_BASE_0_run_9_mux1h_rmff),
      .z(modmul_inst_rtl_cmp_5_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363  modmul_inst_rtl_cmp_6 (
      .x(inst_modsub_inst_run_1_qr_lpi_1_dfm_1),
      .y(l1_mod_mul_impl_BLS12_381_BASE_0_run_8_mux1h_rmff),
      .z(modmul_inst_rtl_cmp_6_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363  modmul_inst_rtl_cmp_7 (
      .x(nl_modmul_inst_rtl_cmp_7_x[380:0]),
      .y(nl_modmul_inst_rtl_cmp_7_y[380:0]),
      .z(modmul_inst_rtl_cmp_7_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363  modmul_inst_rtl_cmp_8 (
      .x(nl_modmul_inst_rtl_cmp_8_x[380:0]),
      .y(nl_modmul_inst_rtl_cmp_8_y[380:0]),
      .z(modmul_inst_rtl_cmp_8_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363  modmul_inst_rtl_cmp_9 (
      .x(nl_modmul_inst_rtl_cmp_9_x[380:0]),
      .y(nl_modmul_inst_rtl_cmp_9_y[380:0]),
      .z(modmul_inst_rtl_cmp_9_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363  modmul_inst_rtl_cmp_10 (
      .x(P0_Z_rsci_idat),
      .y(P1_Z_rsci_idat),
      .z(modmul_inst_rtl_cmp_10_z),
      .clk(clk),
      .rst(rst)
    );
  l1_mod_mul_d7267ca0d90c7363  modmul_inst_rtl_cmp_11 (
      .x(P0_Y_rsci_idat),
      .y(P1_Y_rsci_idat),
      .z(modmul_inst_rtl_cmp_11_z),
      .clk(clk),
      .rst(rst)
    );
  ccs_dw_add_v1 #(.width(32'sd381)) modadd_inst_int_sub_inst_run_16_acc_rg (
      .A(nl_modadd_inst_int_sub_inst_run_16_acc_rg_A[380:0]),
      .B(381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101),
      .CI(1'b0),
      .SUM(modadd_inst_int_sub_inst_run_16_acc_psp_sva_1),
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
  assign nl_modsub_inst_int_sub_inst_run_4_acc_1_tmp = ({1'b1 , modmul_inst_rtl_cmp_5_z})
      + conv_u2s_381_382(~ modmul_inst_rtl_cmp_6_z) + 382'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
  assign modsub_inst_int_sub_inst_run_4_acc_1_tmp = nl_modsub_inst_int_sub_inst_run_4_acc_1_tmp[381:0];
  assign nl_inst_modadd_inst_run_21_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_21_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_21_reduced_out_sva_1 = nl_inst_modadd_inst_run_21_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_21_adder_out_sva_1 = conv_u2u_381_382(modmul_inst_rtl_cmp_2_z)
      + conv_u2u_381_382(modmul_inst_rtl_cmp_1_z);
  assign inst_modadd_inst_run_21_adder_out_sva_1 = nl_inst_modadd_inst_run_21_adder_out_sva_1[381:0];
  assign nl_inst_modadd_inst_run_20_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_20_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_20_reduced_out_sva_1 = nl_inst_modadd_inst_run_20_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_20_adder_out_sva_1 = conv_u2u_381_382(modmul_inst_rtl_cmp_3_z)
      + conv_u2u_381_382(modmul_inst_rtl_cmp_4_z);
  assign inst_modadd_inst_run_20_adder_out_sva_1 = nl_inst_modadd_inst_run_20_adder_out_sva_1[381:0];
  assign nl_inst_modsub_inst_run_3_diff_sva_1 = ({1'b1 , l2_msm_padd_rcb_d7267ca0d90c7363_impl_FIELD_0_run_t1_1_sva_1})
      + conv_u2s_381_382(~ inst_modadd_inst_run_14_qr_lpi_1_dfm_mx0) + 382'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
  assign inst_modsub_inst_run_3_diff_sva_1 = nl_inst_modsub_inst_run_3_diff_sva_1[381:0];
  assign nl_inst_modadd_inst_run_19_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_19_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_19_reduced_out_sva_1 = nl_inst_modadd_inst_run_19_reduced_out_sva_1[382:0];
  assign inst_modadd_inst_run_18_mux_nl = MUX_v_377_2_2((modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[378:2]),
      (inst_modadd_inst_run_17_qr_380_3_lpi_1_dfm_mx0[376:0]), modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[380]);
  assign inst_modadd_inst_run_18_mux_1_nl = MUX_s_1_2_2((modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[1]),
      inst_modadd_inst_run_17_qr_2_lpi_1_dfm_mx0, modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[380]);
  assign inst_modadd_inst_run_18_mux_2_nl = MUX_s_1_2_2((modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[0]),
      (~ (modadd_inst_int_sub_inst_run_16_acc_psp_sva_1[380])), modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[380]);
  assign nl_inst_modadd_inst_run_19_adder_out_sva_1 = conv_u2u_381_382({inst_modadd_inst_run_17_qr_380_3_lpi_1_dfm_mx0
      , inst_modadd_inst_run_17_qr_2_lpi_1_dfm_mx0 , (~ (modadd_inst_int_sub_inst_run_16_acc_psp_sva_1[380]))
      , (~ (modadd_inst_int_sub_inst_run_17_acc_tmp[380]))}) + conv_u2u_381_382({inst_modadd_inst_run_18_mux_nl
      , inst_modadd_inst_run_18_mux_1_nl , inst_modadd_inst_run_18_mux_2_nl , (~
      (modadd_inst_int_sub_inst_run_17_acc_tmp[380])) , (~ (modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[380]))});
  assign inst_modadd_inst_run_19_adder_out_sva_1 = nl_inst_modadd_inst_run_19_adder_out_sva_1[381:0];
  assign inst_modadd_inst_run_17_qr_380_3_lpi_1_dfm_mx0 = MUX_v_378_2_2((modadd_inst_int_sub_inst_run_17_acc_tmp[378:1]),
      (inst_modadd_inst_run_16_qr_380_2_lpi_1_dfm_mx0[377:0]), modadd_inst_int_sub_inst_run_17_acc_tmp[380]);
  assign inst_modadd_inst_run_17_qr_2_lpi_1_dfm_mx0 = MUX_s_1_2_2((modadd_inst_int_sub_inst_run_17_acc_tmp[0]),
      (inst_modsub_inst_run_2_qr_lpi_1_dfm_1[0]), modadd_inst_int_sub_inst_run_17_acc_tmp[380]);
  assign nl_modadd_inst_int_sub_inst_run_17_acc_tmp = conv_u2u_380_381({inst_modadd_inst_run_16_qr_380_2_lpi_1_dfm_mx0
      , (inst_modsub_inst_run_2_qr_lpi_1_dfm_1[0])}) + 381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101;
  assign modadd_inst_int_sub_inst_run_17_acc_tmp = nl_modadd_inst_int_sub_inst_run_17_acc_tmp[380:0];
  assign nl_modadd_inst_int_sub_inst_run_18_acc_psp_sva_1 = conv_u2u_380_381({inst_modadd_inst_run_17_qr_380_3_lpi_1_dfm_mx0
      , inst_modadd_inst_run_17_qr_2_lpi_1_dfm_mx0 , (~ (modadd_inst_int_sub_inst_run_16_acc_psp_sva_1[380]))})
      + 381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101;
  assign modadd_inst_int_sub_inst_run_18_acc_psp_sva_1 = nl_modadd_inst_int_sub_inst_run_18_acc_psp_sva_1[380:0];
  assign inst_modadd_inst_run_16_qr_380_2_lpi_1_dfm_mx0 = MUX_v_379_2_2((modadd_inst_int_sub_inst_run_16_acc_psp_sva_1[378:0]),
      (inst_modsub_inst_run_2_qr_lpi_1_dfm_1[379:1]), modadd_inst_int_sub_inst_run_16_acc_psp_sva_1[380]);
  assign inst_modadd_inst_run_14_qr_lpi_1_dfm_mx0 = MUX_v_381_2_2((inst_modadd_inst_run_14_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_14_adder_out_sva_1[380:0]), inst_modadd_inst_run_14_reduced_out_sva_1[382]);
  assign nl_inst_modadd_inst_run_15_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_15_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_15_reduced_out_sva_1 = nl_inst_modadd_inst_run_15_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_15_adder_out_sva_1 = conv_u2u_381_382(l2_msm_padd_rcb_d7267ca0d90c7363_impl_FIELD_0_run_t1_1_sva_1)
      + conv_u2u_381_382(inst_modadd_inst_run_14_qr_lpi_1_dfm_mx0);
  assign inst_modadd_inst_run_15_adder_out_sva_1 = nl_inst_modadd_inst_run_15_adder_out_sva_1[381:0];
  assign nl_inst_modadd_inst_run_14_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_14_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_14_reduced_out_sva_1 = nl_inst_modadd_inst_run_14_reduced_out_sva_1[382:0];
  assign inst_modadd_inst_run_8_mux_nl = MUX_v_381_2_2((inst_modadd_inst_run_8_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_8_adder_out_sva_1[380:0]), inst_modadd_inst_run_8_reduced_out_sva_1[382]);
  assign nl_inst_modsub_inst_run_2_diff_sva_1 = ({1'b1 , modmul_inst_rtl_cmp_7_z})
      + conv_u2s_381_382(~ inst_modadd_inst_run_8_mux_nl) + 382'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
  assign inst_modsub_inst_run_2_diff_sva_1 = nl_inst_modsub_inst_run_2_diff_sva_1[381:0];
  assign nl_inst_modadd_inst_run_8_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_8_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_8_reduced_out_sva_1 = nl_inst_modadd_inst_run_8_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_8_adder_out_sva_1 = conv_u2u_381_382(modmul_inst_rtl_cmp_z)
      + conv_u2u_381_382(modmul_inst_rtl_cmp_10_z);
  assign inst_modadd_inst_run_8_adder_out_sva_1 = nl_inst_modadd_inst_run_8_adder_out_sva_1[381:0];
  assign inst_modadd_inst_run_5_mux_nl = MUX_v_381_2_2((inst_modadd_inst_run_5_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_5_adder_out_sva_1[380:0]), inst_modadd_inst_run_5_reduced_out_sva_1[382]);
  assign nl_inst_modsub_inst_run_1_diff_sva_1 = ({1'b1 , modmul_inst_rtl_cmp_8_z})
      + conv_u2s_381_382(~ inst_modadd_inst_run_5_mux_nl) + 382'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
  assign inst_modsub_inst_run_1_diff_sva_1 = nl_inst_modsub_inst_run_1_diff_sva_1[381:0];
  assign nl_inst_modadd_inst_run_5_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_5_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_5_reduced_out_sva_1 = nl_inst_modadd_inst_run_5_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_5_adder_out_sva_1 = conv_u2u_381_382(modmul_inst_rtl_cmp_11_z)
      + conv_u2u_381_382(modmul_inst_rtl_cmp_10_z);
  assign inst_modadd_inst_run_5_adder_out_sva_1 = nl_inst_modadd_inst_run_5_adder_out_sva_1[381:0];
  assign inst_modadd_inst_run_2_mux_nl = MUX_v_381_2_2((inst_modadd_inst_run_2_reduced_out_sva_1[380:0]),
      (inst_modadd_inst_run_2_adder_out_sva_1[380:0]), inst_modadd_inst_run_2_reduced_out_sva_1[382]);
  assign nl_inst_modsub_inst_run_diff_sva_1 = ({1'b1 , modmul_inst_rtl_cmp_9_z})
      + conv_u2s_381_382(~ inst_modadd_inst_run_2_mux_nl) + 382'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
  assign inst_modsub_inst_run_diff_sva_1 = nl_inst_modsub_inst_run_diff_sva_1[381:0];
  assign nl_inst_modadd_inst_run_2_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_2_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_2_reduced_out_sva_1 = nl_inst_modadd_inst_run_2_reduced_out_sva_1[382:0];
  assign nl_inst_modadd_inst_run_2_adder_out_sva_1 = conv_u2u_381_382(modmul_inst_rtl_cmp_11_z)
      + conv_u2u_381_382(modmul_inst_rtl_cmp_z);
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
  assign inst_modadd_inst_run_12_qr_380_3_lpi_1_dfm_mx0 = MUX_v_378_2_2((modadd_inst_int_sub_inst_run_12_acc_tmp[378:1]),
      (inst_modadd_inst_run_11_qr_380_2_lpi_1_dfm_mx0[377:0]), modadd_inst_int_sub_inst_run_12_acc_tmp[380]);
  assign inst_modadd_inst_run_12_qr_2_lpi_1_dfm_mx0 = MUX_s_1_2_2((modadd_inst_int_sub_inst_run_12_acc_tmp[0]),
      (modmul_inst_rtl_cmp_10_z[0]), modadd_inst_int_sub_inst_run_12_acc_tmp[380]);
  assign nl_modadd_inst_int_sub_inst_run_11_acc_psp_sva_1 = conv_u2u_380_381(modmul_inst_rtl_cmp_10_z[380:1])
      + 381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101;
  assign modadd_inst_int_sub_inst_run_11_acc_psp_sva_1 = nl_modadd_inst_int_sub_inst_run_11_acc_psp_sva_1[380:0];
  assign nl_modadd_inst_int_sub_inst_run_12_acc_tmp = conv_u2u_380_381({inst_modadd_inst_run_11_qr_380_2_lpi_1_dfm_mx0
      , (modmul_inst_rtl_cmp_10_z[0])}) + 381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101;
  assign modadd_inst_int_sub_inst_run_12_acc_tmp = nl_modadd_inst_int_sub_inst_run_12_acc_tmp[380:0];
  assign nl_modadd_inst_int_sub_inst_run_13_acc_psp_sva_1 = conv_u2u_380_381({inst_modadd_inst_run_12_qr_380_3_lpi_1_dfm_mx0
      , inst_modadd_inst_run_12_qr_2_lpi_1_dfm_mx0 , (~ (modadd_inst_int_sub_inst_run_11_acc_psp_sva_1[380]))})
      + 381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101;
  assign modadd_inst_int_sub_inst_run_13_acc_psp_sva_1 = nl_modadd_inst_int_sub_inst_run_13_acc_psp_sva_1[380:0];
  assign inst_modadd_inst_run_11_qr_380_2_lpi_1_dfm_mx0 = MUX_v_379_2_2((modadd_inst_int_sub_inst_run_11_acc_psp_sva_1[378:0]),
      (modmul_inst_rtl_cmp_10_z[379:1]), modadd_inst_int_sub_inst_run_11_acc_psp_sva_1[380]);
  assign nl_inst_modadd_inst_run_10_reduced_out_sva_1 = conv_u2s_382_383(inst_modadd_inst_run_10_adder_out_sva_1)
      + 383'b11001011111111011101110000101011100011010000000000110010110010110110100111001000101100001001001101111001011010001010011001010001001101110001000101101000111101100001100011110101110110101000000100110001100111100101101010111110000100101001111000010011101101111100001010101000000000000000001010011101010110000000000000000000100011000000001000000000000000000000000000000000101010101010101;
  assign inst_modadd_inst_run_10_reduced_out_sva_1 = nl_inst_modadd_inst_run_10_reduced_out_sva_1[382:0];
  assign inst_modadd_inst_run_9_mux_nl = MUX_v_379_2_2((modadd_inst_int_sub_inst_run_9_acc_psp_sva_1[378:0]),
      (modmul_inst_rtl_cmp_z[379:1]), modadd_inst_int_sub_inst_run_9_acc_psp_sva_1[380]);
  assign nl_inst_modadd_inst_run_10_adder_out_sva_1 = conv_u2u_381_382(modmul_inst_rtl_cmp_z)
      + conv_u2u_381_382({inst_modadd_inst_run_9_mux_nl , (modmul_inst_rtl_cmp_z[0])
      , (~ (modadd_inst_int_sub_inst_run_9_acc_psp_sva_1[380]))});
  assign inst_modadd_inst_run_10_adder_out_sva_1 = nl_inst_modadd_inst_run_10_adder_out_sva_1[381:0];
  assign nl_modadd_inst_int_sub_inst_run_9_acc_psp_sva_1 = conv_u2u_380_381(modmul_inst_rtl_cmp_z[380:1])
      + 381'b110010111111110111011100001010111000110100000000001100101100101101101001110010001011000010010011011110010110100010100110010100010011011100010001011010001111011000011000111101011101101010000001001100011001111001011010101111100001001010011110000100111011011111000010101010000000000000000010100111010101100000000000000000001000110000000010000000000000000000000000000000001010101010101;
  assign modadd_inst_int_sub_inst_run_9_acc_psp_sva_1 = nl_modadd_inst_int_sub_inst_run_9_acc_psp_sva_1[380:0];
  always @(posedge clk) begin
    if ( rst ) begin
      reg_R_X_triosy_obj_ld_cse <= 1'b0;
      inst_modsub_inst_run_1_qr_lpi_1_dfm_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      inst_modsub_inst_run_qr_lpi_1_dfm_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      inst_modadd_inst_run_10_qr_lpi_1_dfm_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      inst_modsub_inst_run_2_qr_lpi_1_dfm_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      l2_msm_padd_rcb_d7267ca0d90c7363_impl_FIELD_0_run_t1_1_sva_1 <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      inst_modadd_inst_run_14_adder_out_sva_1 <= 382'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      reg_P1_Z_triosy_obj_ld_cse <= 1'b0;
      main_stage_0_6 <= 1'b0;
      main_stage_0_7 <= 1'b0;
      main_stage_0_12 <= 1'b0;
      main_stage_0_5 <= 1'b0;
      main_stage_0_11 <= 1'b0;
      main_stage_0_4 <= 1'b0;
      main_stage_0_10 <= 1'b0;
      main_stage_0_3 <= 1'b0;
      main_stage_0_9 <= 1'b0;
      main_stage_0_8 <= 1'b0;
    end
    else begin
      reg_R_X_triosy_obj_ld_cse <= main_stage_0_12;
      inst_modsub_inst_run_1_qr_lpi_1_dfm_1 <= MUX_v_381_2_2((inst_modsub_inst_run_1_diff_sva_1[380:0]),
          modsub_inst_int_add_inst_run_1_acc_nl, inst_modsub_inst_run_1_diff_sva_1[381]);
      inst_modsub_inst_run_qr_lpi_1_dfm_1 <= MUX_v_381_2_2((inst_modsub_inst_run_diff_sva_1[380:0]),
          modsub_inst_int_add_inst_run_acc_nl, inst_modsub_inst_run_diff_sva_1[381]);
      inst_modadd_inst_run_10_qr_lpi_1_dfm_1 <= MUX_v_381_2_2((inst_modadd_inst_run_10_reduced_out_sva_1[380:0]),
          (inst_modadd_inst_run_10_adder_out_sva_1[380:0]), inst_modadd_inst_run_10_reduced_out_sva_1[382]);
      inst_modsub_inst_run_2_qr_lpi_1_dfm_1 <= MUX_v_381_2_2((inst_modsub_inst_run_2_diff_sva_1[380:0]),
          modsub_inst_int_add_inst_run_2_acc_nl, inst_modsub_inst_run_2_diff_sva_1[381]);
      l2_msm_padd_rcb_d7267ca0d90c7363_impl_FIELD_0_run_t1_1_sva_1 <= modmul_inst_rtl_cmp_11_z;
      inst_modadd_inst_run_14_adder_out_sva_1 <= nl_inst_modadd_inst_run_14_adder_out_sva_1[381:0];
      reg_P1_Z_triosy_obj_ld_cse <= 1'b1;
      main_stage_0_6 <= main_stage_0_5;
      main_stage_0_7 <= main_stage_0_6;
      main_stage_0_12 <= main_stage_0_11;
      main_stage_0_5 <= main_stage_0_4;
      main_stage_0_11 <= main_stage_0_10;
      main_stage_0_4 <= main_stage_0_3;
      main_stage_0_10 <= main_stage_0_9;
      main_stage_0_3 <= reg_P1_Z_triosy_obj_ld_cse;
      main_stage_0_9 <= main_stage_0_8;
      main_stage_0_8 <= main_stage_0_7;
    end
  end
  always @(posedge clk) begin
    if ( rst ) begin
      R_Z_rsci_idat <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      R_Y_rsci_idat <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
      R_X_rsci_idat <= 381'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    end
    else if ( main_stage_0_12 ) begin
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
  assign nl_modsub_inst_int_add_inst_run_acc_nl = (inst_modsub_inst_run_diff_sva_1[380:0])
      + 381'b110100000000100010001111010100011100101111111111001101001101001001011000110111010011110110110010000110100101110101100110101110110010001110111010010111000010011110011100001010001001010111111011001110011000011010010101000001111011010110000111101100010010000011110101010111111111111111110101100010101001111111111111111111011100111111110111111111111111111111111111111111010101010101011;
  assign modsub_inst_int_add_inst_run_acc_nl = nl_modsub_inst_int_add_inst_run_acc_nl[380:0];
  assign nl_modsub_inst_int_add_inst_run_2_acc_nl = (inst_modsub_inst_run_2_diff_sva_1[380:0])
      + 381'b110100000000100010001111010100011100101111111111001101001101001001011000110111010011110110110010000110100101110101100110101110110010001110111010010111000010011110011100001010001001010111111011001110011000011010010101000001111011010110000111101100010010000011110101010111111111111111110101100010101001111111111111111111011100111111110111111111111111111111111111111111010101010101011;
  assign modsub_inst_int_add_inst_run_2_acc_nl = nl_modsub_inst_int_add_inst_run_2_acc_nl[380:0];
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

// ------------------------------------------------------------------
//  Design Unit:    l2_msm_padd_rcb_d7267ca0d90c7363_top
// ------------------------------------------------------------------


module l2_msm_padd_rcb_d7267ca0d90c7363_top (
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
  l2_msm_padd_rcb_d7267ca0d90c7363_run l2_msm_padd_rcb_d7267ca0d90c7363_run_inst (
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
