set root_dir /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace
set kernel_name l2_msm_padd_rcb
set dware_dir /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/workspace/build/dware
set tool_catapult "/eda/siemens/Catapult/Mgc_home"
set tool_questa "/eda/siemens/Questasim/questasim"
set tool_dc "/eda/synopsys/syn/Y-2026.03"
set tool_prime "/eda/synopsys/prime/Y-2026.03"
set tool_vivado "/eda/xilinx/2026.1/Vivado"
source /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/tessera/tcl/catapult/util.tcl
source /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/tessera/tcl/catapult/init.tcl
source /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/tessera/tcl/catapult/verify.tcl
source /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/tessera/tcl/catapult/vivado.tcl
source design.tcl

# Sweep flags
set syn_sel "all"
set num_test_samples 64
set syn_passes 1
set bb_syn_metrics 0
set test_cpp 1
set test_cpp_only 0
set verify_rtl 1
set run_vivado 0
init_options $tool_questa $tool_dc $tool_vivado 1 10000
file mkdir [file join $design_build_dir reports]

# Cache per design. The shared cache keys a CCORE on its C++ alone, so two
# designs that differ only in which RTL they blackbox reuse the same core.
options set Cache/UserCacheHome [file join $design_build_dir ccore_cache]
options set Cache/DefaultCacheHomeEnabled false
project new
solution rename $kernel_name
# --- new ---
go new
project save
# --- analyze ---
options set Input/SearchPath [file join $design_build_dir blackbox impl] -append
options set Input/SearchPath {
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/tessera/cpp/include
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l0/l0_int_add/impl
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l0/l0_int_cmul/impl
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l0/l0_int_mul/impl
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l0/l0_int_sq/impl
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l0/l0_int_sub/impl
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l1/l1_mod_add/impl
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l1/l1_mod_cmul/impl
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l1/l1_mod_mul/impl
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l1/l1_mod_sub/impl
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l2/l2_msm_normalize/impl
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l2/l2_msm_padd_rcb/impl
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l2/l2_point_add_sw/impl
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l2/l2_point_add_te/impl
  /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l2/l2_point_dbl_sw/impl
} -append
options set Input/SearchPath [file join $design_build_dir include] -append
solution file add [file join $design_build_dir src l2_msm_padd_rcb_top.cpp]
if { $uses_blackboxes } { options set Input/CompilerFlags "[options get Input/CompilerFlags] -DBLACKBOX_FLOW" }
solution file add [file join /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/kernels/l2/l2_msm_padd_rcb/l2_msm_padd_rcb_tb.cpp] -exclude true
solution file add [file join /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/tessera/cpp/src/csvparser.cpp] -exclude true
solution file add [file join /home/ajd9396/hls_sandbox/msm_attempt/v6/experiments/pe_dc_simple/padd_timing_1ns/runs/registered_input_oh20_01/support/tessera/cpp/src/tb_helper.cpp] -exclude true
go analyze
project save
# --- compile ---
solution design set $top_class.run -top
directive set -CCORE_POINTS 1
directive set -DESIGN_GOAL latency
directive set -OUTPUT_REGISTERS true
set_ii $ii
adder_tree_opt $tech_type
directive set -CLOCK_OVERHEAD 20
directive set -SPECULATE true
directive set -OPT_CONST_MULTS simple_one_adder
go compile
project save
# --- libraries ---
run_osci_test $test_cpp $test_cpp_only $design_build_dir
set_tech_lib $tech_type $root_dir $tech_lib_path $tech_catapult_lib_name      $tech_vendor $tech_technology $tech_catapult_lib_file      $tech_family $tech_speed $tech_part
set_clock $period
go libraries
project save
# --- assembly ---
go assembly
project save
# --- architect ---
go architect
project save
# --- allocate ---
go allocate
project save
# --- schedule ---
go schedule
save_table [file join $design_build_dir reports metrics.csv]
# A kernel that schedules in one cycle holds no state, so it is worth
# rebuilding as a combinational CCORE. Anything else continues as it is.
if {$comb_chk && [latency_is_one $design_build_dir]} { exit 2 }
project save
# --- dpfsm ---
go dpfsm
save_table [file join $design_build_dir reports metrics.csv]
project save
# --- extract ---
go extract
save_table [file join $design_build_dir reports metrics.csv]
project save
# The BOM carries the CCORE's own area and delay. The metrics table reports
# the wrapper's totals instead.
solution report -filename [file join $design_build_dir reports ccore.rpt] -window false -bom true -timing true
run_verify_rtl $verify_rtl $design_build_dir

# An FPGA design is synthesized here rather than in a phase of its own. The
# table is written again, since Vivado's numbers only exist once it has run.
if {[is_fpga $tech_type] && $run_vivado} {
    run_fpga_syn $tech_type 1
    save_table [file join $design_build_dir reports metrics.csv]
}
exit 0
