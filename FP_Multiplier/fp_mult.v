// Code your design here
`timescale 1ns / 1ps
`include "preprocess.v"
`include "mult1.v"
`include "mult2.v"
`include "norm_round.v"

module fp_mult #(parameter E_WIDTH=8, M_WIDTH=23) (clk, reset, a, b, res);

    input clk;
    input reset;
    input [E_WIDTH+M_WIDTH:0] a;
    input [E_WIDTH+M_WIDTH:0] b;
    output [E_WIDTH+M_WIDTH:0] res;
    
  	wire res_sign;
    wire [M_WIDTH:0] a_with_hid;
    wire [M_WIDTH:0] b_with_hid;
    wire [M_WIDTH:0] a_with_hid_prev;
    wire [M_WIDTH:0] b_with_hid_prev;
    wire [E_WIDTH-1:0] a_exp;
    wire [E_WIDTH-1:0] b_exp;
    wire [2*(M_WIDTH+1)-1:0] temp_48resman;
    wire [M_WIDTH-1:0] norm_m;
    wire [E_WIDTH:0] norm_e;
  	wire [E_WIDTH:0] norm_e_prev;
    wire grs;
  	wire [E_WIDTH+M_WIDTH:0] ress;    
    
  reg [2:0] res_sign_prev;
    
  preprocess #(E_WIDTH, M_WIDTH) prep(
    				clk, 
    				reset, 
    				a,
    				b,
    				res_sign, 
    				a_with_hid[M_WIDTH:0], 		
    				b_with_hid[M_WIDTH:0], 
    				a_exp[E_WIDTH-1:0], 
    				b_exp[E_WIDTH-1:0]
  				);
  
  mult1 #(E_WIDTH, M_WIDTH) m1 (
    				clk, 
    				reset,
    				a_with_hid,
    				b_with_hid,
    				a_exp[E_WIDTH-1:0], 
    				b_exp[E_WIDTH-1:0], 
    				a_with_hid_prev,
    				b_with_hid_prev,
    				temp_48resman[2*(M_WIDTH+1)-1:0],
    				norm_e_prev
  		   );
  
  mult2 #(E_WIDTH, M_WIDTH) m2 (
    				clk, 
    				reset, 
    				a_with_hid_prev, 
    				b_with_hid_prev, 
    				norm_e_prev,
    				temp_48resman, 
    				norm_m[M_WIDTH-1:0], 
    				norm_e[E_WIDTH:0], 
    				grs
  		   );
  
  norm_round #(E_WIDTH, M_WIDTH) nr(
    				clk, 
    				reset, 
    				res_sign_prev[2], 
    				norm_e, 
    				norm_m, 
    				grs, 
    				ress[E_WIDTH+M_WIDTH:0]
  			   );
    
    assign res = ress;
    
  always @ (negedge clk) begin
      res_sign_prev[2] <= res_sign_prev[1];
      res_sign_prev[1] <= res_sign_prev[0];
      res_sign_prev[0] <= res_sign;
      
          //$display("Stage1: %b : %b : %b",reset,a,b);
          //$display("Stage 1: %d : %b : %b : %d : %d, %d",res_sign,a_with_hid,b_with_hid,a_exp,b_exp,flags);
          //$display("Stage 2: %d : %d",temp_48resman[2*(M_WIDTH+1)-1:0],norm_e_prev);
          //$display("Stage 3: %b, %d",norm_m,norm_e);
          //$display("Result4: %b",ress);  
    end
    
endmodule