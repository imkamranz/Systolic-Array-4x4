`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Kamran Zahid
// Design Name: 
// Module Name:     TOP
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


module TOP
(
    input 				   clk,
    input 				   reset,
    input                  load,
    input 		[23:0] 	   base_in,
    input 		[127:0]    wt_in,
    output  	[23:0] 	   base_out14,
    output  	[23:0]     base_out24,
    output  	[23:0] 	   base_out34,
    output      [23:0] 	   base_out44,
    output      [127:0]    final_result, // activation function
    output                 valid_out,
    output      [31:0]     W44_after_actvtn,
    output      [31:0]     W34_after_actvtn,
    output      [31:0]     W24_after_actvtn,
    output      [31:0]     W14_after_actvtn
    
 );
 
 
///////////////////////////////////////////////////////////////////////////////////////
reg     [127:0]     result_feedback;
reg     [31:0]      feature_in_new;
wire 	[127:0]     feature_in;
reg     [2:0]       count;
reg                 load_new;
reg                 valid_out_delay;
reg                 load_delay1,load_delay2,load_delay3,load_out1,load_out2,load_out3;
reg                 load_in;
reg                 en;

///////////////////////////////////////////////////////////////////////////////////////
 
 
assign   feature_in={8'd1,8'd2,8'd3,8'd4,
                     8'd1,8'd2,8'd3,8'd4,
                     8'd1,8'd2,8'd3,8'd4,
                     8'd1,8'd2,8'd3,8'd4 };
 
 
 
///////////////////////////////////////////////////////////////////////////////////////

 
  MAC_TOP DUT
(
   .clk                 (clk),
   .reset               (reset),
   .load                (load),
   .base_in             (base_in),
   .feature_in          (feature_in),
   .wt_in               (wt_in),
   .base_out14          (base_out14),
   .base_out24          (base_out24),
   .base_out34          (base_out34),
   .base_out44          (base_out44),
   .final_result        (final_result), // activation function
   .valid_out           (valid_out),
   .W44_after_actvtn    (W44_after_actvtn),
   .W34_after_actvtn    (W34_after_actvtn),
   .W24_after_actvtn    (W24_after_actvtn),
   .W14_after_actvtn    (W14_after_actvtn)

 );


///////////////////////////////////////////////////////////////////////////////////////



 always @ (negedge clk)
    load_delay1 <= load;
 always @ (negedge clk)
    load_delay2 <= load_delay1;
 always @ (negedge clk)
    load_delay3 <= load_delay2;


 always @ (negedge clk)
    load_out1 <= valid_out_delay;
 always @ (negedge clk)
    load_out2 <= load_out1;
 always @ (negedge clk)
    load_out3 <= load_out2;
    
///////////////////////////////////////////////////////////////////////////////////////

 always @ (negedge clk or negedge reset)
     begin                                 
     if (reset)          
               begin  
               result_feedback  <= 127'd0;;
               valid_out_delay  <= 1'b0;
               end
     else
               begin  
               result_feedback  <= final_result;
               valid_out_delay  <= valid_out;
               end
 end
 
 
///////////////////////////////////////////////////////////////////////////////////////


 always @ (negedge clk or negedge reset)
 begin                                 
     if (reset)          
               begin                       
               feature_in_new      <= 32'd0;
               load_new            <= 1'b0;
               end  
                
     else if (load )
               begin
               feature_in_new      <= feature_in[127:96];
               load_new            <= 1'b1;
               end
        
    else if (load_delay1)
                begin
                feature_in_new      <= feature_in[96:64];
                load_new            <= 1'b1;
                end
    
    else if (load_delay2)
                begin
                feature_in_new      <= feature_in[63:32];
                load_new            <= 1'b1;
                end
    else if (load_delay3)
                begin
                feature_in_new      <=  feature_in[31:0];
                load_new            <= 1'b1;
                end
    
       //////////////////////////////////////////////////////// 
       
       
    else if (valid_out_delay )
                begin
                feature_in_new      <=  result_feedback[127:96];
                load_new<= 1'b1;
                end
        
    else if (load_out1)
                begin
                feature_in_new      <=  result_feedback[96:64];
                load_new<= 1'b1;
                end
    
    else if (load_out2)
                begin
                feature_in_new      <= result_feedback[63:32];
                load_new<= 1'b1;
                end
    
    else if (load_out3)
                begin
                feature_in_new      <=  result_feedback[31:0];
                load_new<= 1'b1;
                end
    
    else
                begin
                feature_in_new      <=  feature_in_new;
                load_new<= 1'b0;
                end
   
end
endmodule
