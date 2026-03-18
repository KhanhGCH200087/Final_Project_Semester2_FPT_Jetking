module pwm_variable_freq (
    input wire clk,                  // 100MHz từ Basys 3
    input wire [5:0] sw_freq,        // 6 switch chọn tần số (SW5 đến SW10)
    input wire [4:0] sw_duty,        // 5 switch chỉnh công suất (SW0 đến SW4)
    input wire sw_fail_safe,         // Switch bảo vệ (SW15 - Chân R2)
    output reg pwm_out,               // Đầu ra chân J1 (Pmod JA)
    output led_sw_fail_safe,        // kiểm tra led switch_fail_safe
    output reg led_check_duty_calc,           // kiểm tra duty calculation (có lớn hơn 15% không)
    output reg led_check_duty_final           // kiểm tra duty final có lớn hơn 15% không
);

    reg [23:0] max_count_reg;
    reg [23:0] counter = 0;
    
    // Các biến trung gian để tính toán
    wire [4:0]  duty_level;   // Nấc công suất thực tế (0-20)
    wire [31:0] duty_calc;    // Số nhịp tính toán tương ứng với % chọn
    wire [23:0] limit_15pct;  // Ngưỡng chặn 15% công suất
    reg  [23:0] duty_final;   // Số nhịp cuối cùng sau khi qua bộ lọc Fail-safe

    assign led_sw_fail_safe = sw_fail_safe;

    // 1. BẢNG TRA CỨU TẦN SỐ (40 chế độ)
    always @(*) begin
        case (sw_freq)
            6'd0:  max_count_reg = 4000000; // 25 Hz
            6'd1:  max_count_reg = 3125000; // 32 Hz
            6'd2:  max_count_reg = 2500000; // 40 Hz
            6'd3:  max_count_reg = 2000000; // 50 Hz
            6'd4:  max_count_reg = 1562500; // 64 Hz
            6'd5:  max_count_reg = 1250000; // 80 Hz
            6'd6:  max_count_reg = 1000000; // 100 Hz
            6'd7:  max_count_reg = 800000;  // 125 Hz
            6'd8:  max_count_reg = 781250;  // 128 Hz
            6'd9:  max_count_reg = 625000;  // 160 Hz
            6'd10: max_count_reg = 500000;  // 200 Hz
            6'd11: max_count_reg = 400000;  // 250 Hz
            6'd12: max_count_reg = 390625;  // 256 Hz
            6'd13: max_count_reg = 312500;  // 320 Hz
            6'd14: max_count_reg = 250000;  // 400 Hz
            6'd15: max_count_reg = 200000;  // 500 Hz
            6'd16: max_count_reg = 195312;  // 512 Hz
            6'd17: max_count_reg = 160000;  // 625 Hz
            6'd18: max_count_reg = 156250;  // 640 Hz
            6'd19: max_count_reg = 125000;  // 800 Hz
            6'd20: max_count_reg = 100000;  // 1000 Hz
            6'd21: max_count_reg = 97656;   // 1024 Hz
            6'd22: max_count_reg = 80000;   // 1250 Hz
            6'd23: max_count_reg = 78125;   // 1280 Hz
            6'd24: max_count_reg = 62500;   // 1600 Hz
            6'd25: max_count_reg = 50000;   // 2000 Hz
            6'd26: max_count_reg = 40000;   // 2500 Hz
            6'd27: max_count_reg = 39062;   // 2560 Hz
            6'd28: max_count_reg = 32000;   // 3125 Hz
            6'd29: max_count_reg = 31250;   // 3200 Hz
            6'd30: max_count_reg = 25000;   // 4000 Hz
            6'd31: max_count_reg = 20000;   // 5000 Hz
            6'd32: max_count_reg = 16000;   // 6250 Hz
            6'd33: max_count_reg = 15625;   // 6400 Hz
            6'd34: max_count_reg = 12500;   // 8000 Hz
            6'd35: max_count_reg = 10000;   // 10000 Hz
            6'd36: max_count_reg = 8000;    // 12500 Hz
            6'd37: max_count_reg = 6400;    // 15625 Hz
            6'd38: max_count_reg = 5000;    // 20000 Hz
            6'd39: max_count_reg = 4000;    // 25000 Hz
            default: max_count_reg = 4000; 
        endcase
    end

    // 2. TÍNH TOÁN CÔNG SUẤT (Mỗi nấc 5%)
    // Khống chế switch duty tối đa là nấc 20 (100%)
    assign duty_level = (sw_duty > 5'd20) ? 5'd20 : sw_duty;
    
    // Tính số nhịp cho mức hiện tại: (level * max) / 20
    assign duty_calc = (duty_level * max_count_reg) / 20;
    
    // Tính ngưỡng bảo vệ 15%: (3 nấc * max) / 20
    assign limit_15pct = (max_count_reg * 3) / 20;

    // 3. LOGIC FAIL-SAFE (Chặn tại 15%)
    always @(*) begin
        if (!sw_fail_safe) begin 
            // Nếu bảo vệ BẬT (Switch gạt xuống): Chặn tối đa 15%
            duty_final = (duty_calc > limit_15pct) ? limit_15pct : duty_calc[23:0];
        end else begin
            // Nếu bảo vệ TẮT (Switch gạt lên): Cho phép chạy theo Switch (0-100%)
            duty_final = duty_calc[23:0];
        end
    end
    
    //Kiểm tra duty calculation có lớn hơn 15% không
    always @(*) begin
        if(duty_calc > limit_15pct) begin 
            led_check_duty_calc = 1'b1;
        end
    end
    
    //Kiểm tra DUTY FINAL có lớn hơn 15% không
    always @(*) begin
        if(duty_final > limit_15pct) begin 
            led_check_duty_final = 1'b1;
        end
    end

    // 4. BỘ ĐẾM VÀ XUẤT PWM
    always @(posedge clk) begin
        if (counter < max_count_reg - 1)
            counter <= counter + 1;
        else
            counter <= 0;

        // pwm_out = 0 (Dẫn Opto), pwm_out = 1 (Ngắt Opto)
        pwm_out <= (counter < duty_final) ? 1'b0 : 1'b1;
    end

endmodule