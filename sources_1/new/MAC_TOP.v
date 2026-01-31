
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:        Kamran Zahid
// Create Date:     06/07/2024 04:00:25 AM
// Design Name: 
// Module Name:     MAC_TOP
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


module MAC_TOP
(
    input 				   clk,
    input 				   reset,
    input                  load,
    input 		[23:0] 	   base_in,
    input 		[127:0]     feature_in,
    input 		[127:0]    wt_in,
    output  	[23:0] 	   base_out14,
    output  	[23:0]     base_out24,
    output  	[23:0] 	   base_out34,
    output  	[23:0] 	   base_out44,
    output  reg [127:0]    final_result, // activation function
    output  reg            valid_out,
    output  reg [31:0]     W44_after_actvtn,
    output  reg [31:0]     W34_after_actvtn,
    output  reg [31:0]     W24_after_actvtn,
    output  reg [31:0]     W14_after_actvtn
    


 );
 
////////////////////////////////////////////////////////////////////////////////// 

reg     [31:0]      reg_A,reg_B,reg_C,reg_D; 
reg                 valid_out1,valid_out2,valid_out3;
wire    [7:0]       a_out11,a_out21,a_out31,a_out12,a_out22,a_out32,a_out13,a_out23,a_out33,a_out14,a_out24,a_out34;
wire    [23:0]      base_out11,base_out21,base_out31,base_out41,base_out12,base_out22,base_out32,base_out42,base_out13,base_out23,base_out33,base_out43;
reg     [4:0]       out_count;
reg     [4:0]       output_valid_count;
reg                 en,out_count_en;

////////////////////////////////////////////////////////////////////////////////// 
 
 always @ (posedge clk or posedge reset)
 begin
        if (reset)
            begin
                valid_out1  <= 1'b0;
                valid_out2  <= 1'b0;
                valid_out3  <= 1'b0;
            end
            else
                begin
                valid_out1  <= out_count_en;
                valid_out2  <= valid_out1;
                valid_out3  <= valid_out2;
                end
    
end

////////////////////////////////////////////////////////////////////////////////// 
 
 always @ (posedge clk or posedge reset)
 begin
 
  if (reset || output_valid_count == 5'd12)
       begin
            en              <=  1'b0;
            out_count_en    <=  1'b0; 
        end   
   else if (output_valid_count == 5'd3)
        begin
            en              <=   en;
            out_count_en    <=   1'b1; 
        end
   else if (output_valid_count == 5'd7 )
        begin
            en              <=  en;
            out_count_en    <=  1'b0; 
        end
   else if (load) 
        begin
            en              <=  1'b1;
            out_count_en    <=  1'b0;    
        end
   else 
        begin
             en             <=  en;
             out_count_en   <=  out_count_en; 
        end 
 
 end
 
////////////////////////////////////////////////////////////////////////////////// 

 always @ (posedge clk or posedge reset)
 begin
 if (reset )
  valid_out <= 1'b0;
 else if (output_valid_count == 5'd11)
 valid_out <= 1'b1;
 else
  valid_out <= 1'b0;
end 
////////////////////////////////////////////////////////////////////////////////// 


 always @ (posedge clk or posedge reset)
 begin
 
      if (reset || output_valid_count == 5'd12)
        output_valid_count  <= 5'd0;
      else if (en && output_valid_count <= 5'd11)
         output_valid_count <= output_valid_count +1'b1;
      else
         output_valid_count <= output_valid_count;
  end
  
////////////////////////////////////////////////////////////////////////////////// 
 wire enable;
 reg enable_delay,enable_delay1,enable_delay2,enable_delay3;
 assign enable  = load|| en;
 reg [2:0] count11;
  always @ (posedge clk)
begin
 if (reset || count11 == 3'd4)
 begin
 enable_delay   <=1'b0;  
 count11        <=  3'd0;      
 end
 else if (enable && count11 <= 3'd3)
      begin 
        enable_delay <=1'b1;
        count11<= count11 +1'b1;
        end
        else
        begin
                enable_delay <=1'b0;
        count11<= count11 ;
end
end
 
 
 
 reg [127:0] wt_in_new;
  always @ (posedge clk)
begin
 if (reset )
 
 wt_in_new   <=127'd0;  
 else if (load )  
  wt_in_new <= wt_in;
 else 
       
        wt_in_new <= {wt_in_new[95:0],32'd0};
        

end

 
 
 
 
 
 always @ (posedge clk)
begin
 if (reset)
 begin       
 enable_delay1 <=1'b0;  
 enable_delay2 <=1'b0; 
 enable_delay3 <=1'b0; 
 end
      else begin  

enable_delay1 <=enable_delay;
enable_delay2 <=enable_delay1;
enable_delay3 <=enable_delay2;
end
end
always @ (posedge clk)
begin
    if (reset)
        
        reg_A <=  32'd0;

    else if (load)
    
        reg_A <=  feature_in[127:96];
     else
         
        reg_A <=  {reg_A[23:0],8'd0};
  
     end  
   //////////////////////////////////////////   
   reg [31:0]reg_DDDD,reg_CCC   ,reg_BB;    
always @ (posedge clk)
begin
    if (reset)
        
        reg_B <=  32'd0;

    else if (load)
    
        reg_B <=  feature_in[95:64];
     else 
         
        reg_B <=  {reg_B[23:0],8'd0};
 
     end   
     
    always @ (posedge clk)
reg_BB<=  reg_B; 
 
      //////////////////////////////////////////     
    
always @ (posedge clk)
begin
    if (reset)
        
        reg_C <=  32'd0;

    else if (load)
    
        reg_C <=  feature_in[63:32];
     else 
        reg_C <=  {reg_C[23:0],8'd0};

     end    
     
         always @ (posedge clk)
reg_CCC<=  reg_C;    

      ////////////////////////////////////////// 
 always @ (posedge clk)
begin
    if (reset)
        
        reg_D <=  32'd0;

    else if (load)
    
        reg_D <=  feature_in[31:0];
     else 
         
        reg_D <=  {reg_D[23:0],8'd0};

     end   
     
              always @ (posedge clk)
reg_DDDD<=  reg_D;      
      //////////////////////////////////////////
 
wire [7:0] Wt_out11,Wt_out21,Wt_out31,Wt_out41;
wire [7:0] Wt_out12,Wt_out22,Wt_out32,Wt_out42;
wire [7:0] Wt_out13,Wt_out23,Wt_out33,Wt_out43;
wire [7:0] Wt_out14,Wt_out24,Wt_out34,Wt_out44;

 MAC W11 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_in),
    .a_in       (reg_A[31:24]),
    .wt_in      (wt_in_new[127:120]),
    .base_out   (base_out11),
    .a_out      (a_out11),
    .Wt_out     (Wt_out11));

 MAC W21 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_in),
    .a_in       (a_out11),
    .wt_in      (wt_in[119:112]),////
    .base_out   (base_out21),
    .a_out      (a_out21),
    .Wt_out     (Wt_out21));
    
 MAC W31 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_in),
    .a_in       (a_out21),
    .wt_in      (wt_in[111:104]),
    .base_out   (base_out31),
    .a_out      (a_out31),
    .Wt_out     (Wt_out31));
    
  MAC W41 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_in),
    .a_in       (a_out31),
    .wt_in      (wt_in[103:96]),
    .base_out   (base_out41),
    .a_out      (),
    .Wt_out     (Wt_out41));      


 ////////////////////////////////////////////////////////////////////////////////// 



 MAC W12 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_out11),
    .a_in       (reg_BB[31:24]),
    .wt_in      (Wt_out11), /////
    .base_out   (base_out12),
    .a_out      (a_out12),
    .Wt_out     (Wt_out12));
    
  MAC W22 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_out21),
    .a_in       (a_out12),
    .wt_in      (Wt_out21),
    .base_out   (base_out22),
    .a_out      (a_out22),
    .Wt_out     (Wt_out22));   
    
   MAC W32 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_out31),
    .a_in       (a_out22),
    .wt_in      (Wt_out31),
    .base_out   (base_out32),
    .a_out      (a_out32),
    .Wt_out     (Wt_out32));      
    
   MAC W42 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_out41),
    .a_in       (a_out32),
    .wt_in      (Wt_out41),
    .base_out   (base_out42),
    .a_out      (),
    .Wt_out     (Wt_out42));  
    
    

 ////////////////////////////////////////////////////////////////////////////////// 

    
 MAC W13 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_out12),
    .a_in       (reg_CCC[31:24]),
    .wt_in      (Wt_out12),//
    .base_out   (base_out13),
    .a_out      (a_out13),
    .Wt_out     (Wt_out13));
 
  MAC W23 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_out22),
    .a_in       (a_out13),
    .wt_in      (Wt_out22),
    .base_out   (base_out23),
    .a_out      (a_out23),
    .Wt_out     (Wt_out23));
    
   MAC W33 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_out32),
    .a_in       (a_out23),
    .wt_in      (wt_in[47:40]),
    .base_out   (base_out33),
    .a_out      (a_out33),
    .Wt_out     (Wt_out33));
    
   MAC W43 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_out42),
    .a_in       (a_out33),
    .wt_in      (Wt_out42),
    .base_out   (base_out43),
    .a_out      (),
    .Wt_out     (Wt_out43));
    
////////////////////////////////////////////////////////////////////////////////// 
 
 MAC W14 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_out13),
    .a_in       (reg_DDDD[31:24]),
    .wt_in      (Wt_out13),////
    .base_out   (base_out14),
    .a_out      (a_out14),
    .Wt_out     (Wt_out14));
    
 MAC W24 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_out23),
    .a_in       (a_out14),
    .wt_in      (Wt_out23),
    .base_out   (base_out24),
    .a_out      (a_out24),
    .Wt_out     (Wt_out24));
     
   MAC W34 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_out33),
    .a_in       (a_out24),
    .wt_in      (Wt_out33),
    .base_out   (base_out34),
    .a_out      (a_out34),
    .Wt_out     (Wt_out34));
    
   MAC W44 (
    .clk        (clk),
    .reset      (reset),
    .base_in    (base_out43),
    .a_in       (a_out34),
    .wt_in      (Wt_out43),
    .base_out   (base_out44),
    .a_out      (),
    .Wt_out     (Wt_out44));   
    
/////////////////////////////// 8-Bit quantization ///////////////////////////

    
    function [7:0] Quant;  
    input [23:0] x;  
    begin  
    if (x >= 16'd255)
       Quant = 16'd255;
       else
       Quant = x;
    end  
    endfunction

 /////////////////////////////// Activation Function ///////////////////////////
 
  function [7:0] Actvtn;  
    input [7:0] y;  
    begin  
    if (y >= 8'd10)
       Actvtn = y;
       else
       Actvtn = 8'd0;
    end  
    endfunction
    
////////////////////////////////////////////////////////////////////////////////    

always @ (posedge clk or posedge reset)
    begin
        if (reset)
         W14_after_actvtn  <= 32'd0;
        else if (out_count_en)
         W14_after_actvtn  <= {W14_after_actvtn[23:0],Actvtn(Quant(base_out14)) };
        else begin
         W14_after_actvtn <=  W14_after_actvtn;
    end
end

///////////////////////////////////////////////////////////////////////////////////////////    
 
always @ (posedge clk or posedge reset)
    begin
        if (reset)
         W24_after_actvtn  <= 32'd0;
        else if (valid_out1)
         W24_after_actvtn <= {W24_after_actvtn[23:0],Actvtn(Quant(base_out24)) };
        else begin
         W24_after_actvtn <= W24_after_actvtn;
     end
end

///////////////////////////////////////////////////////////////////////////////////////////    

always @ (posedge clk or posedge reset)
    begin
        if (reset)
         W34_after_actvtn  <= 32'd0;
        else if (valid_out2)
         W34_after_actvtn <= {W34_after_actvtn[23:0],Actvtn(Quant(base_out34)) };
        else begin
         W34_after_actvtn <=  W34_after_actvtn;
    end
end
 ///////////////////////////////////////////////////////////////////////////////////////////    
   
always @ (posedge clk or posedge reset)
    begin
        if (reset)
         W44_after_actvtn  <= 32'd0;
        else if (valid_out3)
         W44_after_actvtn <= {W44_after_actvtn[23:0],Actvtn(Quant(base_out44)) };
        else begin
         W44_after_actvtn <=  W44_after_actvtn;
    end
end
/////////////////////////////////////////////////////////////////////////////////////

always @ (posedge clk or posedge reset)
    begin
    if (reset)
    final_result <= 128'd0;
    else
 final_result <={     W14_after_actvtn[31:24], W24_after_actvtn[31:24], W34_after_actvtn[31:24], W44_after_actvtn[31:24],
					  W14_after_actvtn[23:16], W24_after_actvtn[23:16], W34_after_actvtn[23:16], W44_after_actvtn[23:16],
					  W14_after_actvtn[15:8],  W24_after_actvtn[15:8],  W34_after_actvtn[15:8],  W44_after_actvtn[15:8],
					  W14_after_actvtn[7:0],   W24_after_actvtn[7:0],   W34_after_actvtn[7:0],   W44_after_actvtn[7:0]};
end
///////////////////////////////////////////////////////////////////////////    


endmodule