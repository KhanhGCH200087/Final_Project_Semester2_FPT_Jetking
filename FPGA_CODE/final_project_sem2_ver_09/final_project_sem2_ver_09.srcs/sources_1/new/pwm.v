module pwm_gen (
    input wire clk,          // 100MHz
    input wire [4:0] sw,     // 5 Switch
    output reg pwm_out,      // Đầu ra chân J1
    output reg led_warning,
    output reg [6:0] seg,    // 7 đoạn (a-g)
    output reg [3:0] an      // 4 chân Anode (AN0-AN3)
);

    // Thông số PWM
    localparam MAX_COUNT = 3125; 
    localparam STEP_1PCT = 32;   
    localparam LIMIT_PCT = 800; 
    localparam MAX_FREQUENCY = 26'd49_999_999;

    reg [11:0] counter = 0;    
    wire [11:0] duty_calc;
    reg [11:0] duty_final;
    
    // Bộ đếm 1Hz và Quét LED
    reg [25:0] counter_reg = 0;
    reg clk_out_reg = 0;

    always @(posedge clk) begin
        if(counter_reg == MAX_FREQUENCY) begin
            counter_reg <= 0;
            clk_out_reg <= ~clk_out_reg;
        end else
            counter_reg <= counter_reg + 1;
    end
    
    // 1. Logic tính toán và Giới hạn
    assign duty_calc = sw * STEP_1PCT;
    wire [4:0] disp_val = (sw > 23) ? 5'd23 : sw; // Giá trị để hiển thị LED 7 thanh

    always @(*) begin
        if (duty_calc > LIMIT_PCT) begin
            duty_final = LIMIT_PCT;
            led_warning = clk_out_reg;
        end else begin
            duty_final = duty_calc;
            led_warning = 1'b0;
        end
    end
    
    // 2. Bộ đếm PWM
    always @(posedge clk) begin
        if (counter < MAX_COUNT - 1) counter <= counter + 1;
        else counter <= 0;
        pwm_out <= (counter < duty_final) ? 1'b0 : 1'b1;
    end

    // 3. Logic LED 7 đoạn (Quét LED)
    wire [3:0] tens = disp_val / 10; // Hàng chục
    wire [3:0] ones = disp_val % 10; // Hàng đơn vị
    reg [3:0] char_to_decode;

    // Tận dụng bit thứ 17 của counter_reg (~760Hz) để chuyển đổi giữa 2 LED
    always @(posedge clk) begin
        case (counter_reg[17])
            1'b0: begin
                an <= 4'b1110;          // Bật AN0 (phải cùng)
                char_to_decode <= ones; // Hiện hàng đơn vị
            end
            1'b1: begin
                an <= 4'b1101;          // Bật AN1
                char_to_decode <= tens; // Hiện hàng chục
            end
        endcase
    end

    // 4. Bộ giải mã 0-9 sang 7 đoạn (Cathode chung - Active Low cho Basys 3)
    always @(*) begin
        case(char_to_decode)
            4'h0: seg = 7'b1000000; // 0
            4'h1: seg = 7'b1111001; // 1
            4'h2: seg = 7'b0100100; // 2
            4'h3: seg = 7'b0110000; // 3
            4'h4: seg = 7'b0011001; // 4
            4'h5: seg = 7'b0010010; // 5
            4'h6: seg = 7'b0000010; // 6
            4'h7: seg = 7'b1111000; // 7
            4'h8: seg = 7'b0000000; // 8
            4'h9: seg = 7'b0010000; // 9
            default: seg = 7'b1111111;
        endcase
    end

endmodule





















