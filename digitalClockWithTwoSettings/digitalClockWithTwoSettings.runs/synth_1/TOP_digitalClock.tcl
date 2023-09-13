# 
# Synthesis run script generated by Vivado
# 

create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/projects/digitalClockWithTwoSettings/digitalClockWithTwoSettings.cache/wt [current_project]
set_property parent.project_path C:/projects/digitalClockWithTwoSettings/digitalClockWithTwoSettings.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/projects/digitalClockWithTwoSettings/digitalClockWithTwoSettings.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib C:/projects/digitalClockWithTwoSettings/digitalClockWithTwoSettings.srcs/sources_1/new/digitalClockWithTwoSettings.v
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/projects/digitalClockWithTwoSettings/digitalClockWithTwoSettings.srcs/constrs_1/new/digitalClockWithTwoSettings.xdc
set_property used_in_implementation false [get_files C:/projects/digitalClockWithTwoSettings/digitalClockWithTwoSettings.srcs/constrs_1/new/digitalClockWithTwoSettings.xdc]


synth_design -top TOP_digitalClock -part xc7a100tcsg324-1


write_checkpoint -force -noxdef TOP_digitalClock.dcp

catch { report_utilization -file TOP_digitalClock_utilization_synth.rpt -pb TOP_digitalClock_utilization_synth.pb }
