`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:54:08 11/13/2018 
// Design Name: 
// Module Name:    eigenvectors 
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
module eigenvectors(x1,x2,a1,a2,a3,a4,clk);

input [31:0] a1,a2,a3,a4;
input clk;
output reg [31:0] x1,x2;

wire [31:0] y1,a5,a6,y2;

assign a5[31] = !a3[31];
assign a5[30:0] = a3[30:0];

assign a6[31] = !a2[31];
assign a6[30:0] = a2[30:0];

fdiv d1 (
  .a(a5), // input [31 : 0] a
  .b(a1), // input [31 : 0] b
  .clk(clk), // input clk
  .result(y1) // output [31 : 0] result
);

fdiv d2 (
  .a(a6), // input [31 : 0] a
  .b(a4), // input [31 : 0] b
  .clk(clk), // input clk
  .result(y2) // output [31 : 0] result
);


always@(posedge clk)
begin
	if(a1!=0) begin
		x1 = y1;
		x2 = 32'b00111111100000000000000000000000;
	end
	else begin
		if(a3==0 && a2==0)
		begin
			if(a4!=0) begin
				x1 = 32'b00111111100000000000000000000000;
				x2  = 32'b00000000000000000000000000000000;
			end
			else begin
				x1 = 32'b00111111100000000000000000000000;
				x2 = 32'b00111111100000000000000000000000;
			end
		end
		else if(a3==0)
		begin
			if(a4!=0)
			begin
				x2 = y2;
				x1 = 32'b00111111100000000000000000000000;
			end
			else begin
				x1 = 32'b00000000000000000000000000000000;
				x2 = 32'b00111111100000000000000000000000;
			end
		end
		else if(a2==0)
		begin
			x1 = 32'b00111111100000000000000000000000;
			x2 = 32'b00000000000000000000000000000000;
		end
	end
		
end

endmodule
