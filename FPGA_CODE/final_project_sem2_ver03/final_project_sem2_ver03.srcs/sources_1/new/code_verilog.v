//Module phụ: chống dội phím
module debounce(
    input clk, 
    input btn_in,
    output reg btn_out
);

    reg [26:0] count; // dùng 26 thanh ghi để chứa giá trị 1 trăm triệu
    reg btn_pre; //trạng thái trước đó của nút
    
    always @(posedge clk) begin
        if(btn_in == btn_pre) begin // trường hợp 2 nút có giá trị bằng nhau --> đang ổn định
            if(count < 27'd1_000_000) count <= count + 1; //chưa đạt tới chu kỳ --> tiếp tục đếm thời gian
            else btn_out <= btn_in; //đã đủ chu kỳ --> xuất tín hiệu ra ngoài
        end else begin //trường hợp 2 nút có giá trị khác nhau (mới bấm hoặc đang bị nhiễu
            count <= 0; //reset bộ đếm về 0 để bắt đầu lại từ đầu
            btn_pre <= btn_in;   // Cập nhật trạng thái mới để so sánh ở nhịp sau
            btn_out <= 0; // Trong lúc đang nhiễu thì tuyệt đối không xuất tín hiệu 1
        end
    end
 endmodule

//Phần module chính
module pwm_multi_freq (
    input wire clk,
    input wire btnU, btnD,      // Tăng/Giảm Duty Cycle (0-100%)
    input wire btnL, btnR,      // Giảm/Tăng Tần số (25Hz - 25kHz)
    input wire sw_fail_safe,
    output reg pwm_out,
    output wire [3:0] led_freq_mode // LED báo chế độ tần số (0-3)
);

    // --- QUẢN LÝ TẦN SỐ ---
    reg [1:0] freq_mode = 2'd3; // Mặc định 25kHz (chế độ 3)
    reg [21:0] max_count_reg;   // Cần 22-bit để chứa số 4 triệu
    
    // Tự động tính toán MAX_COUNT dựa trên chế độ
    always @(*) begin
        case(freq_mode)
            2'd0: max_count_reg = 22'd4_000_000; // 25Hz
            2'd1: max_count_reg = 22'd400_000;   // 250Hz
            2'd2: max_count_reg = 22'd40_000;    // 2500Hz
            2'd3: max_count_reg = 22'd4_000;     // 25000Hz
            default: max_count_reg = 22'd4_000;
        endcase
    end
    assign led_freq_mode = (1 << freq_mode); // LED sáng theo vị trí mode

    // --- QUẢN LÝ DUTY CYCLE THEO PHẦN TRĂM (0 đến 10) ---
    reg [3:0] duty_percent = 0; 
    wire [21:0] duty_count_target = (duty_percent * max_count_reg) / 10;
    wire [21:0] final_duty_limit;

    // --- CHỐNG DỘI PHÍM (Cần 4 bộ cho 4 nút) ---
    wire db_up, db_down, db_left, db_right;
    debounce d0(clk, btnU, db_up);
    debounce d1(clk, btnD, db_down);
    debounce d2(clk, btnL, db_left);
    debounce d3(clk, btnR, db_right);

    // --- LOGIC ĐIỀU KHIỂN ---
    always @(posedge clk) begin
        // Điều khiển Duty (0-10 cấp)
        if (db_up && duty_percent < 10) duty_percent <= duty_percent + 1;
        else if (db_down && duty_percent > 0) duty_percent <= duty_percent - 1;

        // Điều khiển Tần số (4 cấp)
        if (db_right && freq_mode < 3) freq_mode <= freq_mode + 1;
        else if (db_left && freq_mode > 0) freq_mode <= freq_mode - 1;
    end

    // --- FAIL-SAFE 50% ---
    wire [21:0] limit_50 = max_count_reg >> 1; // Chia đôi nhanh bằng dịch bit
    assign final_duty_limit = (!sw_fail_safe && duty_count_target > limit_50) 
                              ? limit_50 : duty_count_target;

    // --- TẠO XUNG PWM ---
    reg [21:0] pwm_counter = 0;
    always @(posedge clk) begin
        pwm_counter <= (pwm_counter < max_count_reg - 1) ? pwm_counter + 1 : 0;
        pwm_out <= (pwm_counter < final_duty_limit) ? 1'b0 : 1'b1; // Đảo pha cho Opto
    end

endmodule









