`timescale 1ns / 1ps

module mult1 #(parameter E_WIDTH=8, M_WIDTH=23) (clk, reset, a_with_hid, b_with_hid, a_exp, b_exp, a_with_hid_prev, b_with_hid_prev, temp_48resman, norm_e);
    input clk;
    input reset;
    input [M_WIDTH:0] a_with_hid;
    input [M_WIDTH:0] b_with_hid;
  	input [E_WIDTH-1:0] a_exp;
    input [E_WIDTH-1:0] b_exp;

  	output reg [M_WIDTH:0] a_with_hid_prev;
    output reg [M_WIDTH:0] b_with_hid_prev;
  	output reg [E_WIDTH:0] norm_e;
    output reg [2*M_WIDTH+1:0] temp_48resman;
    
    always @(posedge clk) begin
      //$display("%d : %d : %d : %d",a_with_hid,b_with_hid,a_exp,b_exp);
      //$display("Stage 2: %d : %d",temp_48resman,norm_e);
      if(reset == 0) begin
        temp_48resman <= 0;
        norm_e <= 0;
        a_with_hid_prev <= 0;
        b_with_hid_prev <= 0;
      end
      else begin
    	temp_48resman <= ({6'b000000, a_with_hid[23:0]}*{11'b00000000000, b_with_hid[23:17]});
        norm_e <= a_exp+b_exp;
        a_with_hid_prev <= a_with_hid;
        b_with_hid_prev <= b_with_hid;
      end
    end
endmodule
