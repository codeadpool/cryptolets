//  Catapult Ultra Synthesis 2026.1_1/1274012 (Production Release) Thu Mar 12 18:35:35 PDT 2026
//  
//          Copyright (c) Siemens EDA, 1996-2026, All Rights Reserved.
//                        UNPUBLISHED, LICENSED SOFTWARE.
//             CONFIDENTIAL AND PROPRIETARY INFORMATION WHICH IS THE
//                   PROPERTY OF SIEMENS EDA OR ITS LICENSORS.
//  
//  Running on Linux ajd9396@cepool-a00.poly.edu:628855 5.14.0-687.17.1.el9_8.x86_64 x86_64 aol
//  
//  Package information: SIFLIBS v29.1_1.0, HLS_PKGS v29.1_1.0, 
//                       SIF_TOOLKITS v29.1_1.0, SIF_XILINX v29.1_1.0, 
//                       SIF_ALTERA v29.1_1.0, CCS_LIBS v29.1_1.0, 
//                       CDS_PPRO v2026.1, CDS_DesignChecker v2026.1, 
//                       CDS_OASYS v21.1_3.1, CDS_PSR v25.4_0.7, 
//                       DesignPad v2.78_1.0, DesignAnalyzer 2026.1/1266601
//  
solution new -state initial
solution options defaults
solution options set /Cache/UserCacheHome /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/build/l1_mod_mul/d7267ca0d90c7363/ccore_cache
solution options set /Cache/DefaultCacheHomeEnabled false
solution options set /ComponentLibs/SearchPath /home/ajd9396/gf12_libs -append
solution options set /ComponentLibs/TechLibSearchPath {/ip/arm/gf12/sc7p5mcpp84_base_slvt_c14/r1p0 /ip/arm/gf12/sc7p5mcpp84_base_slvt_c14/r1p0/db /ip/arm/gf12/sc7p5mcpp84_base_slvt_c14/r1p0/lef /ip/arm/gf12/sc7p5mcpp84_base_slvt_c14/r1p0/lib}
solution options set /Input/CppStandard c++14
solution options set /Input/TargetPlatform x86_64
solution options set /Input/SearchPath {/home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/build/l1_mod_mul/d7267ca0d90c7363/blackbox/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/tessera/cpp/include /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l0/l0_int_add/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l0/l0_int_cmul/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l0/l0_int_mul/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l0/l0_int_sq/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l0/l0_int_sub/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l1/l1_mod_add/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l1/l1_mod_cmul/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l1/l1_mod_mul/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l1/l1_mod_sub/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l2/l2_msm_normalize/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l2/l2_msm_padd_rcb/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l2/l2_point_add_sw/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l2/l2_point_add_te/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/kernels/l2/l2_point_dbl_sw/impl /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/build/l1_mod_mul/d7267ca0d90c7363/include}
solution options set /Output/OutputVHDL false
solution options set /Output/RTLSchem false
solution options set /Flows/QuestaSIM/Path /eda/siemens/Questasim/questasim/linux_x86_64
solution options set /Flows/QuestaSIM/VCD_SIZE_LIMIT 10000
solution options set /Flows/DesignCompiler/Path /eda/synopsys/syn/Y-2026.03/bin
solution options set /Flows/DesignCompiler/OutNetlistFormat verilog
solution options set /Flows/DesignCompiler/EnablePowerReporting true
solution options set /Flows/DesignCompiler/DesignCompilerMode DC-Ultra
solution options set /Flows/DesignCompiler/CustomScriptDirPath /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/dc_custom_scripts
solution options set /Flows/SCVerify/INVOKE_ARGS {/home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/build/l1_mod_mul/d7267ca0d90c7363/test/samples.csv /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/build/l1_mod_mul/d7267ca0d90c7363/test/outputs_cpp.csv}
solution options set /Flows/SCVerify/MAX_ERROR_CNT 1
solution options set /Flows/Vivado/XILINX_VIVADO /eda/xilinx/2026.1/Vivado
solution file add ./src/l1_mod_mul_top.cpp -type C++
solution file add ../../../kernels/l1/l1_mod_mul/l1_mod_mul_tb.cpp -type C++ -exclude true
solution file add ../../../tessera/cpp/src/csvparser.cpp -type C++ -exclude true
solution file add ../../../tessera/cpp/src/tb_helper.cpp -type C++ -exclude true
directive set -SPECULATE true
directive set -MERGEABLE true
directive set -REGISTER_THRESHOLD 256
directive set -MEM_MAP_THRESHOLD 32
directive set -LOGIC_OPT false
directive set -FSM_ENCODING none
directive set -FSM_BINARY_ENCODING_THRESHOLD 64
directive set -REG_MAX_FANOUT 0
directive set -NO_X_ASSIGNMENTS true
directive set -SAFE_FSM false
directive set -REGISTER_SHARING_MAX_WIDTH_DIFFERENCE 8
directive set -REGISTER_SHARING_LIMIT 0
directive set -ASSIGN_OVERHEAD 0
directive set -TIMING_CHECKS true
directive set -MUXPATH true
directive set -REALLOC true
directive set -UNROLL no
directive set -IO_MODE super
directive set -CHAN_IO_PROTOCOL use_library
directive set -ARRAY_SIZE 1024
directive set -IDLE_SIGNAL {}
directive set -STALL_FLAG_SV off
directive set -STALL_FLAG false
directive set -TRANSACTION_DONE_SIGNAL true
directive set -DONE_FLAG {}
directive set -READY_FLAG {}
directive set -START_FLAG {}
directive set -TRANSACTION_SYNC ready
directive set -RESET_CLEARS_ALL_REGS use_library
directive set -CLOCK_OVERHEAD 20.000000
directive set -ON_THE_FLY_PROTOTYPING false
directive set -CHARACTERIZE_ROM false
directive set -PROTOTYPE_ROM true
directive set -ROM_THRESHOLD 64
directive set -CLUSTER_ADDTREE_IN_WIDTH_THRESHOLD 0
directive set -CLUSTER_ADDTREE_IN_COUNT_THRESHOLD 0
directive set -CLUSTER_OPT_CONSTANT_INPUTS true
directive set -CLUSTER_RTL_SYN false
directive set -CLUSTER_FAST_MODE false
directive set -CLUSTER_TYPE combinational
go new
go analyze
directive set -CCORE_POINTS 1
directive set -DESIGN_GOAL latency
directive set -OUTPUT_REGISTERS false
directive set -PIPELINE_INIT_INTERVAL 1
directive set -OPT_CONST_MULTS simple_one_adder
go compile
directive set -CLOCKS {clk {-CLOCK_PERIOD 1.0 -CLOCK_EDGE rising -CLOCK_UNCERTAINTY 0.0 -CLOCK_HIGH_TIME 0.5 -RESET_SYNC_NAME rst -RESET_ASYNC_NAME arst_n -RESET_KIND sync -RESET_SYNC_ACTIVE high -RESET_ASYNC_ACTIVE low -ENABLE_ACTIVE high}}
solution library add gf12_highperf -- -rtlsyntool DesignCompiler -vendor GlobalFoundries -technology 12nm
go libraries
go extract
