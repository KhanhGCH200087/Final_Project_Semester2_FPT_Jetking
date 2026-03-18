## Tiêu chuẩn chung 3.3V cho toàn bộ dự án
set_property IOSTANDARD LVCMOS33 [get_ports *]

## Clock signal (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]							
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## 8 Switches chỉnh Duty Cycle (SW0 đến SW7)
set_property PACKAGE_PIN V17 [get_ports {sw_duty[0]}]					
set_property PACKAGE_PIN V16 [get_ports {sw_duty[1]}]					
set_property PACKAGE_PIN W16 [get_ports {sw_duty[2]}]					
set_property PACKAGE_PIN W17 [get_ports {sw_duty[3]}]					
set_property PACKAGE_PIN W15 [get_ports {sw_duty[4]}]					
set_property PACKAGE_PIN V15 [get_ports {sw_duty[5]}]					
set_property PACKAGE_PIN W14 [get_ports {sw_duty[6]}]					
set_property PACKAGE_PIN W13 [get_ports {sw_duty[7]}]					

## 8 Switches chọn Tần số (SW8 đến SW15) - BỔ SUNG MỚI
set_property PACKAGE_PIN V2  [get_ports {sw_freq[0]}]					
set_property PACKAGE_PIN T3  [get_ports {sw_freq[1]}]					
set_property PACKAGE_PIN T2  [get_ports {sw_freq[2]}]					
set_property PACKAGE_PIN R3  [get_ports {sw_freq[3]}]					
set_property PACKAGE_PIN W2  [get_ports {sw_freq[4]}]					
set_property PACKAGE_PIN U1  [get_ports {sw_freq[5]}]					
set_property PACKAGE_PIN T1  [get_ports {sw_freq[6]}]					
set_property PACKAGE_PIN R2  [get_ports {sw_freq[7]}]					

## PWM Output (Xuất ra chân J1 của cổng Pmod JA)
set_property PACKAGE_PIN J1 [get_ports pwm_out]