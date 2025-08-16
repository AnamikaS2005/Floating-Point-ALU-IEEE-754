`timescale 1ns/1ns

module float_alu_tb;
reg [31:0] a,b;
reg clk, rst,st;
reg [1:0] co;
wire [31:0] r;

    
float_alu uut(
    .a(a),
    .b(b),
    .clk(clk),
    .rst(rst),
    .st(st),
    .co(co),
    .r(r));
    
always #5 clk=~clk;
initial begin
clk=0;
rst=0;
st=0;

  


a=32'h458DD44C;
b=32'h461373BA;
co=3;
#10 rst=1; 
#10 st=1; 
#10 st=0;
end
    
endmodule
