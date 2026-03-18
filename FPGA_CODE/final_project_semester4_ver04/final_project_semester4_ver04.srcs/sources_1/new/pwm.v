module pwm_variable_freq (
    input wire clk,                  // 100MHz từ Basys 3
    input wire [7:0] sw_freq,        // 8 switch chọn tần số (sw[7:0])
    input wire [7:0] sw_duty,        // 8 switch chỉnh Duty Cycle (sw[15:8])
    output reg pwm_out,
    input wire sw_fail_safe
);

    reg [23:0] max_count_reg;
    reg [23:0] counter = 0;
    wire [31:0] duty_limit; // Dùng 32 bit để tính toán trung gian tránh tràn

    // 1. Cơ chế chọn tần số (Ước của 100.000.000)
 always @(*) begin
    case (sw_freq)
        8'd0:  max_count_reg = 4000000; // 25 Hz
        8'd1:  max_count_reg = 3125000; // 32 Hz (xấp xỉ 31.25Hz nếu cần chính xác 32Hz thì chọn ước khác, nhưng đây là ước gần nhất)
        8'd2:  max_count_reg = 2500000; // 40 Hz
        8'd3:  max_count_reg = 2000000; // 50 Hz
        8'd4:  max_count_reg = 1562500; // 64 Hz (xấp xỉ)
        8'd5:  max_count_reg = 1250000; // 80 Hz
        8'd6:  max_count_reg = 1000000; // 100 Hz
        8'd7:  max_count_reg = 800000;  // 125 Hz
        8'd8:  max_count_reg = 781250;  // 128 Hz
        8'd9:  max_count_reg = 625000;  // 160 Hz
        8'd10: max_count_reg = 500000;  // 200 Hz
        8'd11: max_count_reg = 400000;  // 250 Hz
        8'd12: max_count_reg = 390625;  // 256 Hz
        8'd13: max_count_reg = 312500;  // 320 Hz
        8'd14: max_count_reg = 250000;  // 400 Hz
        8'd15: max_count_reg = 200000;  // 500 Hz
        8'd16: max_count_reg = 195312;  // 512 Hz (xấp xỉ)
        8'd17: max_count_reg = 160000;  // 625 Hz
        8'd18: max_count_reg = 156250;  // 640 Hz
        8'd19: max_count_reg = 125000;  // 800 Hz
        8'd20: max_count_reg = 100000;  // 1000 Hz
        8'd21: max_count_reg = 97656;   // 1024 Hz (xấp xỉ)
        8'd22: max_count_reg = 80000;   // 1250 Hz
        8'd23: max_count_reg = 78125;   // 1280 Hz
        8'd24: max_count_reg = 62500;   // 1600 Hz
        8'd25: max_count_reg = 50000;   // 2000 Hz
        8'd26: max_count_reg = 40000;   // 2500 Hz
        8'd27: max_count_reg = 39062;   // 2560 Hz (xấp xỉ)
        8'd28: max_count_reg = 32000;   // 3125 Hz
        8'd29: max_count_reg = 31250;   // 3200 Hz
        8'd30: max_count_reg = 25000;   // 4000 Hz
        8'd31: max_count_reg = 20000;   // 5000 Hz
        8'd32: max_count_reg = 16000;   // 6250 Hz
        8'd33: max_count_reg = 15625;   // 6400 Hz
        8'd34: max_count_reg = 12500;   // 8000 Hz
        8'd35: max_count_reg = 10000;   // 10000 Hz
        8'd36: max_count_reg = 8000;    // 12500 Hz
        8'd37: max_count_reg = 6400;    // 15625 Hz
        8'd38: max_count_reg = 5000;    // 20000 Hz
        default: max_count_reg = 4000;  // Mặc định 25kHz nếu vượt quá
    endcase
end
    // 2. Tính toán Duty Cycle động theo tần số hiện tại
    // Công thức: (sw_duty * max_count_reg) / 256
    assign duty_limit = (sw_duty * max_count_reg) >> 8;
    
    // 3. Bộ đếm và tạo xung
    always @(posedge clk) begin
        if (counter < max_count_reg - 1) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
        end

        // Output logic (Positive)
        pwm_out <= (counter < duty_limit) ? 1'b1 : 1'b0;
    end

endmodule