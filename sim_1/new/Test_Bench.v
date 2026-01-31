`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Kamran Zahid
// Design Name: 
// Module Name:     Test_Bench
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


module Test_Bench;

 
   // Inputs
   reg          clk;
   reg          reset;
   reg          load;
   reg  [23:0]   base_in;
   reg  [127:0]  wt_in;
   // Outputs
   wire [23:0]  base_out14,base_out24,base_out34,base_out44;
   wire         valid_out;
   wire [127:0] final_result;
   wire [31:0]  W44_after_actvtn;
   wire [31:0]  W34_after_actvtn;
   wire [31:0]  W24_after_actvtn;
   wire [31:0]  W14_after_actvtn; 
    /////////////////////////////////////////////////

 

   // Instantiate the Unit Under Test (UUT)
   TOP uut (
    .clk(clk),
    .reset(reset),
    .load(load),
    .base_in(base_in),
    .wt_in(wt_in),
    .base_out14(base_out14),
    .base_out24(base_out24),
    .valid_out(valid_out),
    .base_out34(base_out34),
    .base_out44(base_out44),
   .final_result(final_result),
    .W44_after_actvtn(W44_after_actvtn),
    .W34_after_actvtn(W34_after_actvtn),
    .W24_after_actvtn(W24_after_actvtn),
    .W14_after_actvtn(W14_after_actvtn)

); 

   initial begin
      // Initialize Inputs
      clk = 1;
      reset = 1;
      base_in = 0;
      load= 0;
      wt_in= 0;
      // Wait 100 ns for global reset to finish
      #100;
      reset = 0;
      
      
      #100;
      load= 1;
      
      wt_in={8'd4,8'd0,8'd2,8'd1,
             8'd4,8'd3,8'd2,8'd0,
             8'd4,8'd3,8'd0,8'd1,
             8'd4,8'd3,8'd2,8'd1};

                    
      #10;     load= 0;              
      
      
    end
   

  initial begin
      #10000
      $finish(1);
   end
   
   
   always #5 clk = !clk;
      
endmodule
