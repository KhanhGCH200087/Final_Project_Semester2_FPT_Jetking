module pwm_gen (
    input wire clk,          // 100MHz
    input wire [4:0] sw,     // 5 Switch để chỉnh 0-15% (mỗi nấc 1%)
    output reg pwm_out,       // Đầu ra chân J1
    output reg led_warning
);

    // Tần số 32kHz
    localparam MAX_COUNT = 3125; 
    // 1% công suất tương ứng với 33 nhịp (3333 / 100)
    localparam STEP_1PCT = 32;   
    // Ngưỡng chặn 23% công suất 
    localparam LIMIT_PCT = 736; 

    reg [11:0] counter = 0;    
    wire [11:0] duty_calc;
    reg [11:0] duty_final;
    
    reg [25:0] counter_reg = 0;
    reg clk_out_reg = 0;

    always @(posedge clk) begin
    	if(counter_reg == 49_999_999) begin
       	   counter_reg <=0;
           clk_out_reg <= ~clk_out_reg;
        end
        else
           counter_reg <= counter_reg+1;
    end
    
    // 1. Tính toán giá trị Duty dựa trên Switch gạt (mỗi nấc tăng 1%)
    assign duty_calc = sw * STEP_1PCT;

    // 2. Bộ chốt chặn an toàn (Saturation)
    // Dòng này đảm bảo không bao giờ vượt quá 23%
    always @(*) begin
        if (duty_calc > LIMIT_PCT) begin
            duty_final = LIMIT_PCT;
            led_warning = clk_out_reg;
        end else begin
            duty_final = duty_calc;
            led_warning = 1'b0;
        end
    end
    
    // 3. Bộ đếm và tạo xung PWM (Logic đảo cho Opto)
    always @(posedge clk) begin
        if (counter < MAX_COUNT - 1) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
        end

        // Xung PWM: Mức 0 là dẫn Opto, mức 1 là ngắt
        if (counter < duty_final)
            pwm_out <= 1'b0; // Vùng dẫn
        else
            pwm_out <= 1'b1; // Vùng ngắt
    end

endmodule