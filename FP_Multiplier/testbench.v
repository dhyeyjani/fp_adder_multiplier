// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module FPMult_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] a;
	reg [31:0] b;

	// Outputs
	wire [31:0] result;
	wire [4:0] flags;
	
	integer i ;

	// Instantiate the Unit Under Test (UUT)
	fp_mult uut (
		.clk(clk), 
		.reset(rst), 
		.a(a), 
		.b(b), 
		.res(result)
	);

  	task show;
      #10;
      $display("%b",result);
    endtask
  
	always begin
		#5 clk = ~clk;
	end
	
	initial begin
		// Initialize Inputs
		clk <= 0;
		rst <= 0;
		a <= 0;
		b <= 0;
      	#10;

      	rst <= 1;

        a <= 32'b11000000110100011100001011110010; 
        b <= 32'b00111110000111111111010001001101;
      	show;
        a <= 32'b0_1000_0000_10001100010010111100001; 
        b <= 32'b0_1000_0010_00011000110100000100000; 
		show;
      	a <= 32'b01000001000010111010010111110011; 
        b <= 32'b01000001000010101010110010001001; 
        show;
      	a <= 32'b11000000011110110001001000011110; 
        b <= 32'b00111111101100001111010111100000; 
        show;
        a <= 32'b01000000011110110010011000111111; 
        b <= 32'b00111111010110100101011100101111; 
        show;
        a <= 32'b11000000011010100011101010001111; 
        b <= 32'b00111111110100101010011101110101; 
        show;
        a <= 32'b01000000100010111110111010101011; 
        b <= 32'b01000000100110000011001001100010; 
        show;
        a <= 32'b01000000110101010110011010001101; 
        b <= 32'b11000000100110011110100000111111; 
        show;
        a <= 32'b01000000000010100110010110101000; 
        b <= 32'b00111111110111000110001010000000; 
        show;
      	show;
      	show;
      	show;
      	show;
		#100 

		#10 $finish; 

	end
      
endmodule