# IHP SG13G2 Hamming ECC constraints

create_clock -name clk_in -period 20.000 [get_ports {uio[0]}]
create_clock -name clk_core -period 10.000 [get_ports {uio[1]}]
create_clock -name clk_out -period 20.000 [get_ports {uio[2]}]

set_clock_uncertainty 0.2 [get_clocks {clk_in clk_core clk_out}]

# Independent asynchronous clock domains
set_clock_groups -asynchronous \
    -group [get_clocks clk_in] \
    -group [get_clocks clk_core] \
    -group [get_clocks clk_out]

set_input_delay 2.0 -clock clk_in [get_ports ui[*]]
set_output_delay 2.0 -clock clk_out [get_ports uo[*]]
