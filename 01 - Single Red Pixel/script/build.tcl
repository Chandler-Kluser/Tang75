# Gowin EDA TCL Script
set_device GW1NR-LV9QN88PC6/I5
add_file src/pxmat_tn9k.sv
add_file cst/pxmat_tn9k.cst
set_option -use_sspi_as_gpio 1 -top_module pxmat_tn9k -verilog_std sysv2017 -include_path src
run syn
run pnr