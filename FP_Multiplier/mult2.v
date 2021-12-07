`timescale 1ns / 1ps

module mult2 #(parameter E_WIDTH=8, M_WIDTH=23) (clk, reset, a_with_hid, b_with_hid, norm_e_prev, temp_48resman, norm_m, norm_e, grs);
    
    input clk;
    input reset;
    input [M_WIDTH:0] a_with_hid;
    input [M_WIDTH:0] b_with_hid;
    input [E_WIDTH:0] norm_e_prev;
    input [2*(M_WIDTH+1)-1:0] temp_48resman;
    
    output reg [M_WIDTH-1:0] norm_m;
    output reg [E_WIDTH:0] norm_e;
    output reg grs;
    
    wire [2*(E_WIDTH+M_WIDTH+1)-1:0]temp_m;
    
    assign temp_m = (temp_48resman<<17) + ({6'b000000, a_with_hid}*{1'b0, b_with_hid[16:0]});
    	
    always @(posedge clk) begin
      if(reset == 0) begin
        grs <= 0;
        norm_m <= 0;
        norm_e <= 0;
      end
      else begin
  		grs <= (temp_m[M_WIDTH] & temp_m[M_WIDTH+1]) | (|temp_m[M_WIDTH-1:0]);
    	norm_m <= (temp_m[2*(M_WIDTH+1)-1]? temp_m[2*M_WIDTH:M_WIDTH+1] : temp_m[2*(M_WIDTH+1)-1:M_WIDTH]);
    	norm_e <= norm_e_prev + temp_m[2*(M_WIDTH+1)-1];
      end
    end
endmodule
