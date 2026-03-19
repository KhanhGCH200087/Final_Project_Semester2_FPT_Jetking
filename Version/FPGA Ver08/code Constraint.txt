## Tiêu chuẩn chung 3.3V cho toàn bộ dự án
set_property IOSTANDARD LVCMOS33 [get_ports *]

## Clock signal (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]							
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## 8 Switches (V17 đến W13 trên Basys 3)
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]					
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]					
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]					
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]	
set_property PACKAGE_PIN W15 [get_ports {sw[4]}]					
		
# Led báo quá duty quá 23%
set_property PACKAGE_PIN U16 [get_ports led_warning]					

## PWM Output (Ví dụ xuất ra chân J1 của cổng Pmod JA)
set_property PACKAGE_PIN J1 [get_ports pwm_out]					
