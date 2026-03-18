## Tiêu chuẩn chung 3.3V cho toàn bộ dự án
set_property IOSTANDARD LVCMOS33 [get_ports *]

## Clock signal (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]							
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## 8 Switches (V17 đến W13 trên Basys 3)
set_property PACKAGE_PIN R2 [get_ports {sw[0]}]					
set_property PACKAGE_PIN T1 [get_ports {sw[1]}]					
set_property PACKAGE_PIN U1 [get_ports {sw[2]}]					
set_property PACKAGE_PIN W2 [get_ports {sw[3]}]	
set_property PACKAGE_PIN R3 [get_ports {sw[4]}]					
				

## Led kiểm tra
set_property PACKAGE_PIN L1 [get_ports {led_duty[0]}]					
set_property PACKAGE_PIN P1 [get_ports {led_duty[1]}]					
set_property PACKAGE_PIN N3 [get_ports {led_duty[2]}]					
set_property PACKAGE_PIN P3 [get_ports {led_duty[3]}]					
set_property PACKAGE_PIN U3 [get_ports {led_duty[4]}]					
set_property PACKAGE_PIN W3 [get_ports {led_duty[5]}]					
set_property PACKAGE_PIN V3 [get_ports {led_duty[6]}]					
set_property PACKAGE_PIN V13 [get_ports {led_duty[7]}]					
set_property PACKAGE_PIN V14 [get_ports {led_duty[8]}]					
set_property PACKAGE_PIN U14 [get_ports {led_duty[9]}]					
set_property PACKAGE_PIN V15 [get_ports {led_duty[10]}]					
set_property PACKAGE_PIN W18 [get_ports {led_duty[11]}]					
set_property PACKAGE_PIN V19 [get_ports {led_duty[12]}]					
set_property PACKAGE_PIN U19 [get_ports {led_duty[13]}]					
set_property PACKAGE_PIN E19 [get_ports {led_duty[14]}]					

# Led báo quá duty quá 15%
set_property PACKAGE_PIN U16 [get_ports led_warning]					

## PWM Output gắn vào LED LD0 (Chân U16)
##set_property PACKAGE_PIN U16 [get_ports pwm_out]
## PWM Output (Ví dụ xuất ra chân J1 của cổng Pmod JA)
set_property PACKAGE_PIN J1 [get_ports pwm_out]					
