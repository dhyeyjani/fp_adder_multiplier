`timescale 1ns / 1ps

module preprocess #(parameter E_WIDTH=8, M_WIDTH=23) (clk, reset, a, b, res_sign, a_with_hid, b_with_hid, a_exp, b_exp);

    input [E_WIDTH+M_WIDTH:0] a;
    input [E_WIDTH+M_WIDTH:0] b;
    input clk;
    input reset;
    
    output reg res_sign;
    output reg [M_WIDTH:0] a_with_hid;
    output reg [M_WIDTH:0] b_with_hid;
    output reg [E_WIDTH-1:0] a_exp;
    output reg [E_WIDTH-1:0] b_exp;
    
    wire [M_WIDTH-1 : 0]a_m = a[M_WIDTH-1 : 0];
    wire [M_WIDTH-1 : 0]b_m = b[M_WIDTH-1 : 0];
    wire [E_WIDTH-1 : 0]a_e = a[E_WIDTH+M_WIDTH-1 : M_WIDTH];
    wire [E_WIDTH-1 : 0]b_e = b[E_WIDTH+M_WIDTH-1 : M_WIDTH];
    wire a_s = a[E_WIDTH+M_WIDTH];
    wire b_s = b[E_WIDTH+M_WIDTH];
    
    wire a_expo_is_00 = ~|a_e;
    wire b_expo_is_00 = ~|b_e;
    wire a_expo_is_ff = &a_e;
    wire b_expo_is_ff = &b_e;
    wire a_frac_is_00 = ~|a_e;
    wire b_frac_is_00 = ~|b_e;
    wire a_is_inf = a_expo_is_ff & a_frac_is_00;
    wire b_is_inf = b_expo_is_ff & b_frac_is_00;
    wire a_is_nan = a_expo_is_ff & ~a_frac_is_00;
    wire b_is_nan = b_expo_is_ff & ~b_frac_is_00;
    wire a_is_0 = a_expo_is_00 & a_frac_is_00;
    wire b_is_0 = b_expo_is_00 & b_frac_is_00;
    wire out_is_0 = a_is_0 | b_is_0;
  
  	wire [2:0] spc_case;
  assign spc_case[0] = a_is_nan | b_is_nan | (a_is_0 & b_is_inf) | (b_is_0 & a_is_inf);
  assign spc_case[1] = a_is_inf | b_is_inf;
  assign spc_case[2] = ~spc_case[1] & ~spc_case[0];
    always @(posedge clk) begin
      if(reset == 0) begin
        res_sign <= 0;
        a_with_hid <= 0;
        b_with_hid <= 0;
        res_sign <= 0;
        a_exp <= 0;
        b_exp <= 0;
      end
      else begin

    	a_with_hid <= {~a_expo_is_00,a_m}; //hidden bit is 0 if expo is 0, else 1
    	b_with_hid <= {~b_expo_is_00,b_m};
        res_sign <= a_s ^ b_s;
        a_exp <= a_e;
        b_exp <= b_e;
      end
    end
endmodule