module pwm_gen_25khz (
    input wire clk,          
    input wire [7:0] sw,     
    output reg pwm_out       
);


    parameter MAX_COUNT = 4000; //25kHz(25.000)

    reg [11:0] counter = 0;    
    wire [11:0] duty_limit;

    assign duty_limit = (sw * MAX_COUNT) >> 8;

    always @(posedge clk) begin
        if (counter < MAX_COUNT - 1) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
        end

        if (counter < duty_limit) begin
            pwm_out <= 1'b0;
        end else begin
            pwm_out <= 1'b1;
        end
    end

endmodule