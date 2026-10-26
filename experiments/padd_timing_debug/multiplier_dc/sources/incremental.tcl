proc require_file {p} {if {![file isfile $p] || [file size $p] == 0} {error "Missing/empty file: $p"}}
proc fingerprint {p} {return [lindex [exec sha256sum $p] 0]}
proc write_text {p s} {set f [open $p w]; puts $f $s; close $f}
proc checked_design {p} {
    set ok 0
    redirect -file $p {set ok [check_design]}
    if {$ok ne "1"} {error "check_design failed; see $p"}
}
if {[catch {
    source inputs.tcl
    foreach p [list $input_ddc $library_db $input_sdc] {require_file $p}
    if {[fingerprint $input_ddc] ne $input_sha256} {error "Original multiplier DDC checksum changed"}
    foreach d {work results reports} {
        if {[file exists $d]} {error "Fresh incremental output directory required"}
        file mkdir $d
    }
    set_host_options -max_cores 1
    set target_library [list $library_db]
    set synthetic_library {dw_foundation.sldb standard.sldb}
    set link_library [concat [list *] $target_library $synthetic_library]
    define_design_lib WORK -path ./work
    foreach id {LINT-61 UID-3 UID-341} {set_message_info -id $id -stop_on}
    set_svf results/incremental.svf
    read_ddc $input_ddc
    current_design l1_mod_mul
    if {![link]} {error "Multiplier checkpoint link failed"}
    read_sdc $input_sdc
    if {[sizeof_collection [get_clocks clk]] != 1} {error "Expected one clock named clk"}
    if {abs([get_attribute [get_clocks clk] period] - 1.0) > 0.000001} {error "Expected original 1 ns target"}
    checked_design reports/check_design_before.rpt
    redirect -file reports/before_area.rpt {report_area}
    redirect -file reports/before_timing_max.rpt {report_timing -delay max -max_paths 20 -nworst 1 -nosplit -significant_digits 6}
    redirect -file reports/before_qor.rpt {report_qor}
    puts "INCREMENTAL_START: multiplier, one core, unchanged 1 ns constraints"
    if {[compile_ultra -incremental -no_autoungroup -no_boundary_optimization] ne "1"} {error "Incremental compile failed"}
    write_file -format ddc -hierarchy -output results/mapped.ddc
    require_file results/mapped.ddc
    write_text results/mapped.sha256 [fingerprint results/mapped.ddc]
    checked_design reports/check_design.rpt
    redirect -file reports/area.rpt {report_area}
    redirect -file reports/area_hierarchy.rpt {report_area -hierarchy -nosplit}
    redirect -file reports/timing_max.rpt {report_timing -delay max -max_paths 20 -nworst 1 -nosplit -significant_digits 6}
    redirect -file reports/timing_min.rpt {report_timing -delay min -max_paths 20 -nworst 1 -nosplit -significant_digits 6}
    redirect -file reports/qor.rpt {report_qor}
    redirect -file reports/constraints.rpt {report_constraint -all_violators -verbose -nosplit}
    redirect -file reports/check_timing.rpt {check_timing}
    write_file -format verilog -hierarchy -output results/gate.v
    write_sdc results/mapped.sdc
    foreach p {results/gate.v results/mapped.sdc} {require_file $p}
    set_svf -off
    write_text SUCCESS incremental_mapped
} message]} {
    puts stderr "INCREMENTAL_FAILED: $message"
    exit 1
}
puts "INCREMENTAL_FINISHED: inspect before/after reports for actual timing improvement"
exit 0
