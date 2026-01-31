

create_clock -period 10.000 -name clk -add [get_ports clk]
#set_false_path -from [get_ports {feature_in[*]}]
#set_input_delay 0.000 [get_ports {feature_in[*]}]

