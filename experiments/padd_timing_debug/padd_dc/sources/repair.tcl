proc require_file {p} {if {![file isfile $p] || [file size $p] == 0} {error "Missing/empty: $p"}}
proc fingerprint {p} {return [lindex [exec sha256sum $p] 0]}
proc write_text {p s} {set f [open $p w]; puts $f $s; close $f}
proc checked_design {p} {
    set ok 0
    redirect -file $p {set ok [check_design]}
    if {$ok ne "1"} {error "check_design failed: $p"}
}
proc relax_arithmetic {} {
    # Unprotect actual mapped cells; never replace arithmetic by empty boxes.
    set_dont_touch [get_designs *] false
    set h [get_cells -hierarchical -filter "is_hierarchical == true"]
    set_dont_touch $h false
    set_boundary_optimization [get_designs *] true
    set_boundary_optimization $h true
    set_ungroup $h false
    set_app_var compile_preserve_subdesign_interfaces false
}
proc measurements {directory} {
    file mkdir $directory
    checked_design $directory/check_design.rpt
    redirect -file $directory/area.rpt {report_area}
    redirect -file $directory/timing_max.rpt {report_timing -delay max -max_paths 20 -nworst 1 -nosplit -significant_digits 6}
    redirect -file $directory/timing_min.rpt {report_timing -delay min -max_paths 10 -nworst 1 -nosplit -significant_digits 6}
    redirect -file $directory/qor.rpt {report_qor}
    redirect -file $directory/check_timing.rpt {check_timing}
    redirect -file $directory/constraints.rpt {report_constraint -all_violators -nosplit -significant_digits 6}
    set paths [get_timing_paths -delay_type max -max_paths 1]
    if {[sizeof_collection $paths] != 1} {error "No setup timing path"}
    set slack [get_attribute $paths slack]
    write_text $directory/worst_slack_ns.txt $slack
    return $slack
}
if {[catch {
    source inputs.tcl
    foreach p [list $multiplier_ddc $library_db $input_sdc] {require_file $p}
    if {[fingerprint $multiplier_ddc] ne $multiplier_sha256} {error "Multiplier checksum changed"}
    if {[fingerprint $library_db] ne $library_sha256} {error "Library checksum changed"}
    foreach d {work reports results} {file mkdir $d}
    set_host_options -max_cores 4
    redirect -file reports/host_options.rpt {report_host_options}
    set target_library [list $library_db]
    set synthetic_library {dw_foundation.sldb standard.sldb}
    set link_library [concat [list *] $target_library $synthetic_library]
    define_design_lib WORK -path ./work
    foreach id {LINT-61 UID-3 UID-341} {set_message_info -id $id -stop_on}
    set_svf results/repair.svf
    read_ddc $multiplier_ddc
    # Keep every child design distinct from designs in the baseline PADD DDC.
    rename_design [get_designs *] -prefix FIXEDMUL_ -dont_link_with_original_name
    if {$mode eq "incremental"} {
        require_file $baseline_ddc
        if {[fingerprint $baseline_ddc] ne $baseline_sha256} {error "PADD checksum changed"}
        read_ddc $baseline_ddc
        current_design l2_msm_padd_rcb
        if {![link]} {error "Baseline PADD link failed"}
        relax_arithmetic
        set replacements [get_cells -hierarchical -filter "ref_name == l1_mod_mul_d7267ca0d90c7363_top"]
        if {[sizeof_collection $replacements] != 12} {error "Expected twelve multiplier instances"}
        if {[change_link $replacements FIXEDMUL_l1_mod_mul -all_instances] ne "1"} {error "Multiplier replacement failed"}
    } else {
        require_file $parent_rtl
        require_file $child_wrapper
        if {![analyze -library WORK -format sverilog [list $child_wrapper $parent_rtl]]} {error "Pipelined parent analysis failed"}
        elaborate l2_msm_padd_rcb
        current_design l2_msm_padd_rcb
    }
    if {![link]} {error "Repaired PADD link failed"}
    set actual [get_cells -hierarchical -filter "ref_name == FIXEDMUL_l1_mod_mul"]
    if {[sizeof_collection $actual] != 12} {error "Replacement inventory must contain twelve real multipliers"}
    redirect -file reports/multiplier_inventory.rpt {report_cell $actual}
    read_sdc $input_sdc
    if {[sizeof_collection [get_clocks clk]] != 1} {error "Expected one clock"}
    if {abs([get_attribute [get_clocks clk] period]-1.0)>0.000001} {error "Clock target changed"}
    # Same top-level 1 ns / 0 ns input / 0.25 ns max output constraints.
    # No false paths, multicycle exceptions, retiming or clock relaxation.
    relax_arithmetic
    checked_design reports/check_design_before.rpt
    write_file -format ddc -hierarchy -output results/linked.ddc
    write_sdc results/input_constraints.sdc
    measurements reports/before
    for {set pass 1} {$pass <= 2} {incr pass} {
        puts "PADD_REPAIR_COMPILE: mode=$mode pass=$pass latency=$latency_cycles period=1.0"
        if {$mode eq "pipelined" && $pass == 1} {
            set ok [compile_ultra -no_autoungroup]
        } else {
            set ok [compile_ultra -incremental -no_autoungroup]
        }
        if {$ok ne "1"} {error "Compile failed on pass $pass"}
        write_file -format ddc -hierarchy -output results/pass_$pass.ddc
        require_file results/pass_$pass.ddc
        set slack [measurements reports/pass_$pass]
        write_text results/latest_pass.txt $pass
        puts "PADD_REPAIR_PASS: pass=$pass slack_ns=$slack"
        if {$slack >= 0.0} {break}
    }
    write_file -format ddc -hierarchy -output results/mapped.ddc
    write_text results/mapped.sha256 [fingerprint results/mapped.ddc]
    write_file -format verilog -hierarchy -output results/gate.v
    write_sdc results/mapped.sdc
    set_svf -off
    write_text SUCCESS "mapped; setup_slack_ns=$slack"
} message]} {
    puts stderr "PADD_REPAIR_FAILED: $message"
    exit 1
}
puts "PADD_REPAIR_FINISHED: inspect slack, not just SUCCESS"
exit 0
