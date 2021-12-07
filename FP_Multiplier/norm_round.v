`timescale 1ns / 1ps

module norm_round #(parameter E_WIDTH=8, M_WIDTH=23) (clk, reset, res_sign, norm_e, norm_m, grs, res);
    input clk;
    input reset;
    input res_sign;
    input [E_WIDTH:0] norm_e;
    input [M_WIDTH-1:0] norm_m;
    input grs;
    output reg [E_WIDTH+M_WIDTH:0] res;
    
    wire [E_WIDTH:0] e;
    wire [M_WIDTH:0] m;
    wire [M_WIDTH:0] mm;
    wire [M_WIDTH:0] round_man;
    assign mm = norm_m + 1;
    assign round_man = grs ? mm : norm_m;
    assign m = round_man[M_WIDTH] ? {1'b0, round_man[M_WIDTH:1]} : round_man[M_WIDTH:0];
    assign e = round_man[M_WIDTH] ? norm_e - 126 : norm_e - 127;
    
  	always @(posedge clk) begin
      if(reset == 0) begin
      	res <= 0;
      end
      else begin
  		res <= {res_sign, e[E_WIDTH-1:0], m[M_WIDTH-1:0]};
      end
    end
endmodule