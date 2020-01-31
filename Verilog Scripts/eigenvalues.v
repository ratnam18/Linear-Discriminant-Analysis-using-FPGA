`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:40:44 11/13/2018 
// Design Name: 
// Module Name:    eigenvalues 
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
module eigenvalues(v1,v2,a1,a2,a3,a4,clk);

//THIS MODULE TAKES 50 CLOCK CYCLES 

input clk;
input [31:0] a1,a2,a3,a4;
output [31:0] v1,v2;

reg [3:0] state = 4'b0000;

parameter first = 4'd0;
parameter second = 4'd1;
parameter third = 4'd2;
parameter fourth = 4'd3;
parameter fifth = 4'd4;
parameter sixth = 4'd5;
parameter seventh = 4'd6;
parameter eighth = 4'd7;
parameter ninth = 4'd8;
parameter tenth = 4'd9;
parameter eleventh = 4'd10;
parameter twelveth = 4'd11;
parameter thirteen = 4'd12;

wire [31:0] x1,x2,x3,x4,x5,x6,x7,x8,x11;
reg [5:0] cnt = 6'd0;

/*

x1 = a1 - a4
x2 = x1*x1
x3 = a2*a3
x4 = x2 + x3
x5 = root(x4)
x6 = a1 + a4
x7 = x6 + x5
x8 = x6-x5
v1 = x7/2
v2 = x8/2

v1 is the  first eigenvalue
v2 is the second eigenvalue

*/

fpu a11(clk,a1,a4,2'b01,x1);
fpu a21(clk,a2,a3,2'b11,x11);

assign x3[30:23] = x11[30:23] + 2;
assign x3[31] = x11[31];
assign x3[22:0] = x11[22:0];

fpu a31(clk,x1,x1,2'b11,x2);
fpu a41(clk,a1,a4,2'b00,x6);
fpu a51(clk,x2,x3,2'b00,x4);

fsqrt f1 (
  .a(x4), // input [31 : 0] a
  .clk(clk), // input clk
  .result(x5) // output [31 : 0] result
);

fpu a61(clk,x6,x5,2'b00,x7);
fpu a71(clk,x6,x5,2'b01,x8);

assign v1[31] = x7[31];
assign v1[30:23] = (x7[30:23]==0) ? 8'd0 : (x7[30:23] - 1);
assign v1[22:0] = x7[22:0];

assign v2[31] = x8[31];
assign v2[30:23] = (x8[30:23]==0) ? 8'd0 : (x8[30:23] - 1);
assign v2[22:0] = x8[22:0];

/*
always@(posedge clk)
begin
	
	case(state)
		
		first: 
		begin
			$display("STATE: %d",(state+1));
			state <= second;
		end
		
		second:  //all X's
		begin
			$display("STATE: %d",(state+1));
			$display("x1: %b",x1);
			$display("x2: %b",x2);
			$display("x3: %b",x3);
			$display("x6: %b",x6);
			state <= third;
		end
		
		third: //got x1,x3,x6
		begin
			$display("STATE: %d",(state+1));
			$display("got x1,x3,x6");
			$display("x1: %b",x1);
			$display("x2: %b",x2);
			$display("x3: %b",x3);
			$display("x6: %b",x6);
			state <= fourth;
		end
		
		fourth:  //got x1,x3,x6
		begin
			$display("STATE: %d",(state+1));
			$display("got x1,x3,x6");
			$display("x1: %b",x1);
			$display("x2: %b",x2);
			$display("x3: %b",x3);
			$display("x4: %b",x4);
			$display("x6: %b",x6);
			state <= fifth;
			//do somethimg
		end
		
		fifth:     //got x2 ,x1,x3,x6
		begin
			$display("STATE: %d",(state+1));
			$display("got x2,x1,x3,x6");
			$display("x1: %b",x1);
			$display("x2: %b",x2);
			$display("x3: %b",x3);
			$display("x4: %b",x4);
			$display("x6: %b",x6);
			state <= sixth;
			//..
		end
	
		
		sixth:     //got x2,x1,x3,x6
		begin
		//..
			$display("STATE: %d",(state+1));
			$display("got x2,x1,x3,x6");
			$display("x1: %b",x1);
			$display("x2: %b",x2);
			$display("x3: %b",x3);
			$display("x6: %b",x6);
			$display("x4: %b",x4);
			state <= seventh;
		end
		
		seventh:   //got x4,x2,x1,x3,x6
		begin
		//..
			$display("STATE: %d",(state+1));
			$display("got x4,x2,x1,x3,x6");
			$display("x1: %b",x1);
			$display("x2: %b",x2);
			$display("x3: %b",x3);
			$display("x6: %b",x6);
			$display("x4: %b",x4);
			state <= eighth;
		end
		
		eighth:     //got x4,x2,x1,x3
		begin
			cnt <= cnt + 6'd1;
			if(cnt == 6'd40)
			begin
				state <= ninth;
			end
			else 
			begin
				state <= eighth;
				$display("STATE: %d",(state+1));
				$display("got x4,x2,x1,x3,x6");
				$display("x1: %b",x1);
				$display("x2: %b",x2);
				$display("x3: %b",x3);
				$display("x6: %b",x6);
				$display("x4: %b",x4);
				$display("x5: %b",x5);
				$display("x7: %b",x7);
				$display("x8: %b",x8);
				$display("v1: %b",v1);
			$display("v2: %b",v2);
			end
			
			
		end
		
		ninth:   //got x5,x4,x2,x1,x3,x7,x8
		begin
			$display("STATE: %d",(state+1));
			$display("got x5,x4,x2,x1,x3,x6");
			$display("x5: %b",x5);
			$display("x7: %b",x7);
			$display("x8: %b",x8);
			$display("v1: %b",v1);
			$display("v2: %b",v2);
			state <= tenth;
		end
		
		tenth:   //
		begin
			$display("STATE: %d",(state+1));
			$display("got x5,x4,x2,x1,x3,x6");
			$display("x5: %b",x5);
			$display("x7: %b",x7);
			$display("x8: %b",x8);
			$display("v1: %b",v1);
			$display("v2: %b",v2);
			state <= eleventh;
		end
		
		eleventh:
		begin
			$display("STATE: %d",(state+1));
			$display("got v1,v2,x7,x8,x5,x4,x2,x1,x3,x6");
			$display("x5: %b",x5);
			$display("x7: %b",x7);
			$display("x8: %b",x8);
			$display("v1: %b",v1);
			$display("v2: %b",v2);
			state <= twelveth;
		end
		
		twelveth:
		begin
			$display("STATE: %d",(state+1));
			$display("x5: %b",x5);
			$display("x6: %b",x6);
			$display("x7: %b",x7);
			$display("x8: %b",x8);
			$display("v1: %b",v1);
			$display("v2: %b",v2);
			state <= thirteen;
		end
		
		thirteen:
		begin
		//..
		end
		
		default:
		begin
		end
		
	endcase
end*/

endmodule
