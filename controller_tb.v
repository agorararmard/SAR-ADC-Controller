// file: controller_tb.v
// author: @amrgouhar
// Testbench for controller

`timescale 1ns/1ns

module controller_tb;

	//Inputs
	reg go;
	reg clk;
	reg rst;
	reg [1: 0] cmp;
    reg [7:0] vin;

	//Outputs
	wire sample;
	wire valid;
	wire [7: 0] value;
	wire [7: 0] result;


	//Instantiation of Unit Under Test
	controller uut (
		.go(go),
		.clk(clk),
		.rst(rst),
		.cmp(cmp),
		.sample(sample),
		.valid(valid),
		.value(value),
		.result(result)
	);

    always #2 clk = ~clk;

	initial begin
	//Inputs initialization
		go = 1;
		clk = 0;
		rst = 0;
		cmp = 0;
		vin = 64;
        #5 rst = 1;
        #10 go = 0;
	//Wait for the reset
		#1000;
    end
    
    always @(value) begin
        if (value > vin)
            cmp = 2'b00;
        else if (value < vin)
                cmp = 2'b01;
                else cmp = 2'b10;
    end
    
    always @(valid) begin
        if (valid) begin
            #5;
            $display("Vin under test is %0d, Program ouput is %0d ", vin, result);
            if (result != vin) begin
                $display("Failure");
            end
            else $display("Success");
            go = !go;
            vin = $random % 2**7 - 1;
            #10;
            go = !go;
        end
    end
    
endmodule

