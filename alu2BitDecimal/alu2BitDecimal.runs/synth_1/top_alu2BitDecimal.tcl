# 
# Synthesis run script generated by Vivado
# 

create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/projects/alu2BitDecimal/alu2BitDecimal.cache/wt [current_project]
set_property parent.project_path C:/projects/alu2BitDecimal/alu2BitDecimal.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/projects/alu2BitDecimal/alu2BitDecimal.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib C:/projects/alu2BitDecimal/alu2BitDecimal.srcs/sources_1/new/alu2BitDecimal.v
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/projects/alu2BitDecimal/alu2BitDecimal.srcs/constrs_1/new/alu2BitDecimal.xdc
set_property used_in_implementation false [get_files C:/projects/alu2BitDecimal/alu2BitDecimal.srcs/constrs_1/new/alu2BitDecimal.xdc]


synth_design -top top_alu2BitDecimal -part xc7a100tcsg324-1


write_checkpoint -force -noxdef top_alu2BitDecimal.dcp

catch { report_utilization -file top_alu2BitDecimal_utilization_synth.rpt -pb top_alu2BitDecimal_utilization_synth.pb }
