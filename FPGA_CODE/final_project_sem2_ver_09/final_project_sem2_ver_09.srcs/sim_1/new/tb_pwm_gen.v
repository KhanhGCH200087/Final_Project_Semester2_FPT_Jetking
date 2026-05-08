`timescale 1ns / 1ps // Đơn vị thời gian là 1ns

module tb_pwm_gen();
    // 1. Khai báo các dây nối
    reg clk;
    reg [4:0] sw;
    wire pwm_out, led_warning;
    wire [6:0] seg;
    wire [3:0] an;

    // 2. Kết nối Testbench với module PWM của bạn (UUT - Unit Under Test)
    pwm_gen uut (
        .clk(clk), .sw(sw), 
        .pwm_out(pwm_out), .led_warning(led_warning),
        .seg(seg), .an(an)
    );

    // 3. Tạo xung Clock 100MHz
    always #5 clk = ~clk; 

    // 4. Kịch bản kiểm tra
    initial begin
        clk = 0; sw = 0;
        #100;           // Đợi 100ns
        sw = 5'd10;     // Test mức 10%
        #1000000;       // Đợi 1ms để xem sóng
        sw = 5'd30;     // Test mức quá tải (30% -> phải chặn ở 23%)
        #2000000;
        $stop;          // Dừng mô phỏng
    end
endmodule