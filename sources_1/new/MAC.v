
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Kamran Zahid
// Create Date:     06/07/2024 04:00:25 AM
// Design Name: 
// Module Name:     MAC
// Project Name:    Multiplication of two matrices
// Target Devices: 
// Tool Versions: 
// Description: 
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module MAC (

    input 				clk,
    input 				reset,
    input 		[23:0] 	base_in,
    input 		[7:0] 	a_in,
    input 		[7:0] 	wt_in,
    output reg 	[23:0] 	base_out,
    output reg 	[7:0] 	a_out,
    output reg 	[7:0] 	Wt_out

);

    wire [15:0] result;
    reg [7:0] weight_reg;


    assign  result 		= a_in * wt_in;

   always @(posedge clk or posedge reset) 
	begin
       if (reset) 
		  begin
            base_out 	<= 24'h0;
            a_out 		<= 8'h0;
            Wt_out 		<=8'h0;
            
          end
       else 
		  begin
            base_out 	<= base_in + result;
            a_out 		<= a_in;
            Wt_out 		<= wt_in;
         end
    end

endmodule
