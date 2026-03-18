## Tiêu chuẩn chung 3.3V cho toàn bộ dự án
set_property IOSTANDARD LVCMOS33 [get_ports *]

## Clock signal (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]							
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## 5 Switches chỉnh Duty Cycle (SW0 đến SW4)
set_property PACKAGE_PIN V17 [get_ports {sw_duty[0]}]					
set_property PACKAGE_PIN V16 [get_ports {sw_duty[1]}]					
set_property PACKAGE_PIN W16 [get_ports {sw_duty[2]}]					
set_property PACKAGE_PIN W17 [get_ports {sw_duty[3]}]					
set_property PACKAGE_PIN W15 [get_ports {sw_duty[4]}]					
				

## 6 Switches chọn Tần số (SW5 đến SW11) - BỔ SUNG MỚI
set_property PACKAGE_PIN V15 [get_ports {sw_freq[0]}]					
set_property PACKAGE_PIN W14 [get_ports {sw_freq[1]}]	
set_property PACKAGE_PIN W13 [get_ports {sw_freq[2]}]	
set_property PACKAGE_PIN V2 [get_ports {sw_freq[3]}]	
set_property PACKAGE_PIN T3 [get_ports {sw_freq[4]}]					
set_property PACKAGE_PIN T2 [get_ports {sw_freq[5]}]	

##Fail-Safe 50%
set_property PACKAGE_PIN R2 [get_ports  sw_fail_safe]					
set_property PACKAGE_PIN L1 [get_ports  led_sw_fail_safe]	

##Led check duty cal và duty final
set_property PACKAGE_PIN P1 [get_ports  led_check_duty_calc]					
set_property PACKAGE_PIN N3 [get_ports  led_check_duty_final]					
				


## PWM Output (Xuất ra chân J1 của cổng Pmod JA)
set_property PACKAGE_PIN J1 [get_ports pwm_out]