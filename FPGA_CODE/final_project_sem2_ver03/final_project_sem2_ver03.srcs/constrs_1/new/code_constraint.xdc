## Cấu hình chung cho IO
set_property IOSTANDARD LVCMOS33 [get_ports *]

## Xung Clock (W5 là chân clock 100MHz hệ thống)
set_property PACKAGE_PIN W5 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Nút bấm điều chỉnh Duty 
set_property PACKAGE_PIN T18 [get_ports btnU]
set_property PACKAGE_PIN U17 [get_ports btnD]
set_property PULLDOWN true [get_ports btnU]
set_property PULLDOWN true [get_ports btnD]

## Nút bấm điều chỉnh Frequency 
set_property PACKAGE_PIN W19 [get_ports btnL]
set_property PACKAGE_PIN T17 [get_ports btnR]
set_property PULLDOWN true [get_ports btnL]
set_property PULLDOWN true [get_ports btnR]

## Switch FailSafe 50%
set_property PACKAGE_PIN V17 [get_ports sw_fail_safe]

## LED hiển thị chế độ tần số (LD0 đến LD3)
set_property PACKAGE_PIN U16 [get_ports {led_freq_mode[0]}]
set_property PACKAGE_PIN E19 [get_ports {led_freq_mode[1]}]
set_property PACKAGE_PIN U19 [get_ports {led_freq_mode[2]}]
set_property PACKAGE_PIN V19 [get_ports {led_freq_mode[3]}]

## PWM Output (Chân số 1 của cổng Pmod JA)
set_property PACKAGE_PIN J1 [get_ports pwm_out]