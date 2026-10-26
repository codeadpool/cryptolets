# Each stage is a separate single-core DC process; source inputs.tcl is immutable.
proc read_text {path} {set f [open $path r]; set s [string trim [read $f]]; close $f; return $s}
proc write_text {path text} {set f [open $path w]; puts $f $text; close $f}
proc fingerprint {path} {return [lindex [exec sha256sum $path] 0]}
proc require_file {path} {
    if {![file isfile $path] || [file size $path] == 0} {error "Missing/empty file: $path"}
}
proc checkpoint {name} {
    write_file -format ddc -hierarchy -output results/$name.ddc
    require_file results/$name.ddc
}
proc check_report {path} {
    set ok 0
    redirect -file $path {set ok [check_design]}
    if {$ok ne "1"} {error "check_design failed; see $path"}
}
proc protect_child {name expected report} {
    set cells [get_cells -hierarchical -filter "ref_name == $name"]
    if {[sizeof_collection $cells] != $expected} {
        error "Expected $expected instances of $name; found [sizeof_collection $cells]"
    }
    set_dont_touch $cells true
    set_ungroup $cells false
    set_boundary_optimization $cells false
    set f [open $report w]
    foreach_in_collection cell $cells {
        puts $f "[get_object_name $cell] [get_attribute $cell ref_name] dont_touch=[get_attribute $cell dont_touch]"
    }
    close $f
}
if {[catch {
    source inputs.tcl
    foreach path [list $rtl $library_db] {require_file $path}
    foreach d {work reports results} {
        if {[file exists $d]} {error "Fresh stage directory required: $d exists"}
        file mkdir $d
    }
    set_host_options -max_cores 1
    set target_library [list $library_db]
    set synthetic_library {dw_foundation.sldb standard.sldb}
    set link_library [concat [list *] $target_library $synthetic_library]
    define_design_lib WORK -path ./work
    foreach id {LINT-61 UID-3 UID-341} {set_message_info -id $id -stop_on}
    set_svf results/mapping.svf
    if {$resume_ddc ne ""} {
        require_file $resume_ddc
        if {[fingerprint $resume_ddc] ne $resume_sha256} {error "Resume DDC checksum changed"}
        read_ddc $resume_ddc
        current_design $top
        if {![link]} {error "Resume $stage link failed"}
        puts "PE_DC_RESUME: mapped checkpoint loaded; skip compile and retry reports/export"
    } else {
        if {$child_ddc ne ""} {
            require_file $child_ddc
            require_file $child_wrapper
            if {[fingerprint $child_ddc] ne $child_ddc_sha256} {error "Child DDC checksum changed"}
            read_ddc $child_ddc
            rename_design $child_top ${child_ref}_top
            if {![analyze -library WORK -format sverilog $child_wrapper]} {error "Child wrapper analysis failed"}
            elaborate $child_ref
            set_dont_touch [get_designs [list $child_ref ${child_ref}_top]] true
        }
        if {![analyze -library WORK -format sverilog $rtl]} {error "$stage analysis failed"}
        elaborate $top
        current_design $top
        if {![link]} {error "$stage link failed"}
        if {$child_ddc ne ""} {protect_child $child_ref $child_count reports/protected_before.rpt}
        if {[sizeof_collection [get_ports clk]] != 1} {error "Expected clk input"}
        create_clock -name clk -period $period_ns [get_ports clk]
        set data_inputs [remove_from_collection [all_inputs] [get_ports clk]]
        set_input_delay -max 0 -clock clk $data_inputs
        set_input_delay -min 0 -clock clk $data_inputs
        set_output_delay -max [expr {$period_ns / 4.0}] -clock clk [all_outputs]
        set_output_delay -min [expr {$period_ns / 8.0}] -clock clk [all_outputs]
        # Existing architecture-study timing budget; SRAM timing is provided by
        # external port budgets, not by an internal behavioral memory implementation.
        check_report reports/check_design_before.rpt
        checkpoint linked
        write_sdc results/input_constraints.sdc
    }
    if {$check_only} {
        write_text SUCCESS check_only
    } else {
        if {$resume_ddc eq ""} {
            set_datapath_optimization_effort [get_designs *] low
            if {[compile_ultra -no_autoungroup -no_boundary_optimization] ne "1"} {error "$stage compile failed"}
        }
        # The expensive result survives even if reporting/export later fails.
        checkpoint mapped
        write_text results/mapped.sha256 [fingerprint results/mapped.ddc]
        write_text results/mapped.contract [read_text contract.sha256]
        if {$child_ddc ne ""} {protect_child $child_ref $child_count reports/protected_after.rpt}
        check_report reports/check_design.rpt
        redirect -file reports/check_timing.rpt {check_timing}
        redirect -file reports/area.rpt {report_area}
        redirect -file reports/area_hierarchy.rpt {report_area -hierarchy -nosplit}
        redirect -file reports/timing_max.rpt {report_timing -delay max -max_paths 20 -nworst 1 -nosplit}
        redirect -file reports/timing_min.rpt {report_timing -delay min -max_paths 20 -nworst 1 -nosplit}
        redirect -file reports/constraints.rpt {report_constraint -all_violators -verbose -nosplit}
        redirect -file reports/qor.rpt {report_qor}
        write_file -format verilog -hierarchy -output results/gate.v
        write_sdc results/mapped.sdc
        write_sdf results/mapped.sdf
        foreach f {gate.v mapped.sdc mapped.sdf} {require_file results/$f}
        write_text SUCCESS mapped
    }
    set_svf -off
} message]} {
    puts stderr "PE_DC_FAILED: $message"
    exit 1
}
puts "PE_DC_FINISHED: $stage"
exit 0
