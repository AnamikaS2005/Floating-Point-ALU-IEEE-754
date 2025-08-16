`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.08.2025 12:18:24
// Design Name: 
// Module Name: float
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module float_alu(
input [31:0] a,b,
input clk,rst,st,
input [1:0] co,
output wire [31:0] r

    );
/*
CODE/ co
add=0
sub=1
mul=2
div=3
*/
wire [31:0] b1;
reg [4:0] shift_no,dsm;
reg [7:0] exp_r,exp_res,exp_p,e_d;
reg [23:0] m_a,m_b,mant_r, mant_req,mqr1,mqr;
reg [22:0] mant_rem;
reg [24:0] m_r,m1,mr1;
wire s_a, s_b,s_d;
reg s_r,s_p;
wire [24:0] mb,m2,m3,m4,m5,m6,m7,m8,m9;

  
wire [31:0] sum,product,div;
wire [7:0] exp_a,exp_b,exp_pro,exp_d;
wire [23:0] mant_a,mant_b,mq1,mq2,mq3,mq4,mq5,mq6,mq7,mq8,mq9;
wire [47:0] mant_pro;

assign b1=(co==1)? (b^32'h80000000) : b; // toggle msb of b when its sub

assign exp_a = a[30:23]-8'd127;
assign exp_b = b1[30:23]-8'd127;

assign mant_a = {1'b1,a[22:0]};
assign mant_b = {1'b1,b1[22:0]};

assign s_a=a[31];
assign s_b=b1[31];


//assign exp_r=(exp_a>=exp_b)? exp_a : exp_b;


always @ (*)

if (exp_a>exp_b)
 begin
   exp_r=exp_a;
   shift_no=exp_a-exp_b;
   m_a=mant_a;
   m_b=mant_b>>shift_no;
 end
else 
 begin
   exp_r=exp_b;
   shift_no=exp_b-exp_a;
   m_a=mant_a>>shift_no;
   m_b=mant_b;
end


 always @ (*)
if (s_a==s_b) 
 begin   // equal case
 s_r=s_a; 
 
 m_r={1'b0,m_a}+{1'b0,m_b};
 if (m_r[24]==1) 
  begin  
   mant_r=m_r>>1;
   exp_res=exp_r+1+127;
 end
 
 else  // no overflow
  begin
   mant_r=m_r[23:0];
   exp_res=exp_r+127;
 end
 end
else
 begin 
  if (m_a>m_b)
   begin
    s_r=s_a;
    m_r=m_a-m_b;
   end
   
  else
  begin
    s_r=s_b;
    m_r=m_b-m_a;
  end
    if (m_r[23]==1) shift_no=0; else 
    if (m_r[22]==1) shift_no=1; else 
    if (m_r[21]==1) shift_no=2; else 
    if (m_r[20]==1) shift_no=3; else 
    if (m_r[19]==1) shift_no=4; else 
    if (m_r[18]==1) shift_no=5; else 
    if (m_r[17]==1) shift_no=6; else 
    if (m_r[16]==1) shift_no=7; else 
    if (m_r[15]==1) shift_no=8; else 
                    shift_no=9;  
    
    mant_r=m_r<<shift_no;
    exp_res=exp_r-shift_no+127;
    
  
 end
 
 assign sum={s_r,exp_res,mant_r[22:0]};

 assign r=(co==2)? product : (co==3)? div :sum;
 
 assign exp_pro=exp_a+exp_b;
 assign mant_pro= mant_a*mant_b;
 
 always @ (*)
 begin
 s_p=s_a^s_b;
 if (mant_pro[47]==1) 
  begin
   mant_req=mant_pro[47:24];
   mant_rem=mant_pro[23:1];
   exp_p=exp_pro+1+127;
   end
   
  else 
   begin
   mant_req=mant_pro[46:23];
   mant_rem=mant_pro[22:0];
   exp_p=exp_pro+127;
 
 end
   end
 assign product={s_p,exp_p,mant_req[22:0]};
 
//-------------------------------------***DIVISION***---------------------------------------------

assign exp_d=(exp_a-exp_b)+127;
assign s_d=s_a^s_b;

always @ (*)
if (mant_a>mant_b) 
begin
 m1=mant_a;
 e_d=exp_d;
end
else
begin
 m1=mant_a<<1;
 e_d=exp_d-1;
end

assign mq1=0; //result
assign mb={1'b0,mant_b}; // variable length reduce

assign m2=(m1>=mb) ? ((m1-mb)<<1) : (m1<<1); assign mq2=(m1>=mb) ? {mq1[22:0],1'b1} : {mq1[22:0],1'b0};
assign m3=(m2>=mb) ? ((m2-mb)<<1) : (m2<<1); assign mq3=(m2>=mb) ? {mq2[22:0],1'b1} : {mq2[22:0],1'b0};
assign m4=(m3>=mb) ? ((m3-mb)<<1) : (m3<<1); assign mq4=(m3>=mb) ? {mq3[22:0],1'b1} : {mq3[22:0],1'b0};
assign m5=(m4>=mb) ? ((m4-mb)<<1) : (m4<<1); assign mq5=(m4>=mb) ? {mq4[22:0],1'b1} : {mq4[22:0],1'b0};
assign m6=(m5>=mb) ? ((m5-mb)<<1) : (m5<<1); assign mq6=(m5>=mb) ? {mq5[22:0],1'b1} : {mq5[22:0],1'b0};
assign m7=(m6>=mb) ? ((m6-mb)<<1) : (m6<<1); assign mq7=(m6>=mb) ? {mq6[22:0],1'b1} : {mq6[22:0],1'b0};
assign m8=(m7>=mb) ? ((m7-mb)<<1) : (m7<<1); assign mq8=(m7>=mb) ? {mq7[22:0],1'b1} : {mq7[22:0],1'b0};
assign m9=(m8>=mb) ? ((m8-mb)<<1) : (m8<<1); assign mq9=(m8>=mb) ? {mq8[22:0],1'b1} : {mq8[22:0],1'b0};

always @ (posedge clk or negedge rst)
if (rst==0) dsm<=0; else 
case (dsm)                      // State machine for division
 0 : if (st==1) dsm<=1;
 25 : dsm<=0;
 default : dsm<=dsm+1;
endcase

always @ (posedge clk or negedge rst)
if (rst==0) begin mqr1<=0; mr1<=0; mqr<=0; end else 
begin
 if (dsm==0) begin mr1<=m1; mqr1<=0; end else 
 if (dsm<=24) 
 begin
  if (mr1>=mb) begin mr1<=(mr1-mb)<<1; mqr1<={mqr1[22:0],1'b1}; end 
  else         begin mr1<=mr1<<1;      mqr1<={mqr1[22:0],1'b0}; end 
 end
 if (dsm==25) mqr<=mqr1; // latch the result
end

assign div={s_d,e_d,mqr[22:0]};
 
  

endmodule
