# Isolated single PE from the four-PE geometry. Bucket SRAMs are external.
# prepare.py hls prepares the pinned PADD, vectors and run_config.tcl.
source run_config.tcl
source [file join $support_dir tessera tcl catapult init.tcl]
source [file join $support_dir tessera tcl catapult util.tcl]
source [file join $support_dir tessera tcl catapult verify.tcl]
init_options $tool_questa $tool_dc $tool_vivado $threads_per_process 10000
options set Cache/UserCacheHome [file join $design_build_dir ccore_cache]
options set Cache/DefaultCacheHomeEnabled false
options set /Input/CompilerFlags $compiler_flags
foreach p $include_paths { options set /Input/SearchPath $p -append }
# dware_dir is supplied in run_config.tcl.
set uses_blackboxes true
file mkdir [file join $design_build_dir reports]
set t0 [clock seconds]
proc elapsed {stage} {
    global t0
    puts "MSM_MPE_TIME $stage [expr {[clock seconds] - $t0}] s"
}
proc technology {} {
    global tech_type root_dir tech_lib_path tech_catapult_lib_name tech_vendor
    global tech_technology tech_catapult_lib_file period
    set_tech_lib $tech_type $root_dir $tech_lib_path $tech_catapult_lib_name \
        $tech_vendor $tech_technology $tech_catapult_lib_file
    set_clock $period
    solution library add ccs_sample_mem
}
proc fifos {top} {
    foreach p [directive get "$top/.../*:cns" -match glob -return path] {
        directive set $p -FIFO_DEPTH 4
    }
}
project new
solution rename msm_pe_cpp
solution file add [file join $root_dir msm include msm_mpe_pe.h] -type CHEADER
solution file add [file join $root_dir msm src msm_pe_tb.cpp] -type C++ -exclude true
solution file add [file join $root_dir support csvparser.cpp] -exclude true
go analyze
solution design set msm_mpe_pe -top
directive set -CCORE_POINTS 1
directive set -OPT_CONST_MULTS simple_one_adder
go compile
run_osci_test true $test_cpp_only $design_build_dir
elapsed osci
# The outer processes control pipelining with loop pragmas; packaged kernels
# carry their measured latencies and initiation intervals in ac_blackbox.
directive set -OPT_CONST_MULTS simple_one_adder
directive set -DESIGN_GOAL latency
directive set -OUTPUT_REGISTERS false
# Preserve the v3 baseline's reported scheduling assumptions explicitly.
directive set -SPECULATE true
directive set -CLOCK_OVERHEAD 20

go new
solution design set msm_mpe_pe -top
solution rename msm_mpe_pe
go analyze
technology
go libraries
directive set -PIPELINE_INIT_INTERVAL 0
directive set -REGISTER_THRESHOLD 4096
go assembly
set ts /msm_mpe_pe/msm_mpe_pe:sched_thread/sched_thread
foreach m {br_x br_y br_z} {
    directive set $ts/sched_core.$m:rsc -MAP_TO_MODULE ccs_sample_mem.ccs_ram_sync_1R1W
    # Preserve the same synchronous 1R1W schedule but export its pins.
    # SCVerify supplies the sample-memory model outside the synthesized PE.
    directive set $ts/sched_core.$m:rsc -EXTERNAL_MEMORY true
}
foreach m {addr_q q_head q_cnt busy} {
    directive set $ts/sched_core.$m:rsc -MAP_TO_MODULE {[Register]}
}
fifos /msm_mpe_pe
go architect
foreach m {br_x br_y br_z} {
    ignore_memory_precedences -from "*write_mem(*$m:rsc*" -to "*read_mem(*$m:rsc*"
}
go extract
set pe_solution "[solution get /name].[solution get /VERSION]"
project save
save_table [file join $design_build_dir reports pe_metrics.csv]
solution report -filename [file join $design_build_dir reports pe_bom.rpt] -window false -bom true -timing true
elapsed pe_extract

# Exercise the PE through the external-memory SCVerify wrapper.
run_verify_rtl $verify_rtl $design_build_dir
elapsed pe_rtl
exit 0
