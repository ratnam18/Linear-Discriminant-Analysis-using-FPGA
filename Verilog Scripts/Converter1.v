`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:40:37 11/15/2018 
// Design Name: 
// Module Name:    Converter1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Converter1(a,clk,sign_ans,ans,temp_ans);

input [31:0] a;
input clk;
output [23:0] ans;
output sign_ans;
output [7:0] temp_ans;

wire [7:0] x,x1,temp,i;
wire [23:0] temp1;
wire [23:0] ans;

assign x = a[30:23] - 127;
assign x1 = 23 - (x-1);
assign temp_ans = temp;
assign sign_ans = a[31];

assign i =  (a[0]) ? 0 :
				(a[1]) ? 1 :
				(a[2]) ? 2 :
				(a[3]) ? 3 :
				(a[4]) ? 4 :
				(a[5]) ? 5 :
				(a[6]) ? 6 :
				(a[7]) ? 7 :
				(a[8]) ? 8 :
				(a[9]) ? 9 :
				(a[10]) ? 10 :
				(a[11]) ? 11 :
				(a[12]) ? 12 :
				(a[13]) ? 13:
				(a[14]) ? 14:
				(a[15]) ? 15 :
				(a[16]) ? 16 :
				(a[17]) ? 17 :
				(a[18]) ? 18 :
				(a[19]) ? 19 :
				(a[20]) ? 20 :
				(a[21]) ? 21 :
				(a[22]) ? 22 : 0;

assign temp = (a[30:0] == 31'd0) ? 1'b0 : (x1-i-1 > 0) ? x1-i-1 : 0;
assign temp1 = {1'b1,a[22:0]};

assign ans = (a[30:0] == 31'd0) ? 24'd0 : temp1 >> (i);

endmodule
