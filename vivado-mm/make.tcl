create_project -force -part xc7k325tffg900-3 mm_iddmm_top

# source files
add_files -fileset sources_1 ../src/mm_iddmm_top.v
add_files -fileset sources_1 ../src/mm_iddmm_sp.v
add_files -fileset sources_1 ../src/mm_iddmm_sub.v
add_files -fileset sources_1 ../src/mm_iddmm_pe.v

add_files -fileset sources_1 ../src/common/simple_ram.v
add_files -fileset sources_1 ../src/common/simple_p1adder129.v
add_files -fileset sources_1 ../src/a0.mem
add_files -fileset sources_1 ../src/x.mem
add_files -fileset sources_1 ../src/y.mem
add_files -fileset sources_1 ../src/m.mem
# xdc files
add_files -fileset constrs_1 ./fpga.xdc



reset_run synth_1
launch_runs synth_1
wait_on_run synth_1

reset_run impl_1
launch_runs impl_1
wait_on_run impl_1



open_run impl_1
write_bitstream -force mm_iddmm_top.bit
exit
