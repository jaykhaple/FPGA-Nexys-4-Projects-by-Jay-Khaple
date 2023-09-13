`timescale 1ns / 1ps


module clkDiv(nclk,clk);
output reg nclk;
input clk;
reg [31:0]count=32'd0;
always@(posedge clk)
begin
    count=count+1;
    nclk=count[16];
end
endmodule

module refCount(outRef,nclk);
output reg [2:0]outRef=3'd0;
input nclk;
always@(posedge nclk)
begin
    outRef=outRef+1;
end
endmodule

module swtichOption(add,sub,mul,div,sw);
output reg add=0,sub=0,mul=0,div=0;
input [1:0]sw;
always@(sw)
begin
    case(sw)
    2'b00:begin add=1;sub=0;mul=0;div=0; end
    2'b01:begin add=0;sub=1;mul=0;div=0; end
    2'b10:begin add=0;sub=0;mul=1;div=0; end
    2'b11:begin add=0;sub=0;mul=0;div=1; end
    default:begin add=0;sub=0;mul=0;div=0; end
    endcase
end
endmodule

module takingInput(num1Units,num1Tens,num2Units,num2Tens,RGB1_Red,RGB1_Green,num1OrNum2,swForUnits,swForTens);
output reg [3:0]num1Units,num1Tens,num2Units,num2Tens;
output reg RGB1_Red,RGB1_Green;
input num1OrNum2;
input [3:0]swForUnits,swForTens;
always@(swForUnits,swForTens,num1OrNum2)
begin
    if(swForUnits<=4'd9 && swForTens<=4'd9)
    begin
        RGB1_Red=0;RGB1_Green=1;
    end
    else
    begin
        RGB1_Red=1;RGB1_Green=0;
    end
    
    if(num1OrNum2==1)
    begin
        if(swForUnits<=4'd9)
        begin
            num2Units=swForUnits;
        end
        else num2Units=4'd9;
        
        if(swForTens<=4'd9)
        begin
            num2Tens=swForTens;
        end
        else num2Tens=4'd9;
    end
    else
    begin
        if(swForUnits<=4'd9)
        begin
            num1Units=swForUnits;
        end
        else num1Units=4'd9;
    
        if(swForTens<=4'd9)
        begin
            num1Tens=swForTens;
        end
        else num1Tens=4'd9;   
    end
end
endmodule

module processingUnit(outAddAndSubAndMul,divQ,divR,aUnits,aTens,bUnits,bTens,
                        add,sub,mul,div,rst);
output reg [13:0]outAddAndSubAndMul=14'd0;
output reg [6:0]divQ=7'd0,divR=7'd0;
input add,sub,mul,div,rst;
input [3:0]aUnits,aTens,bUnits,bTens;
reg [6:0]num1=7'd0,num2=7'd0;
always@(*)
begin
    if(!rst) 
    begin
        num1=(10*aTens)+(1*aUnits);
        num2=(10*bUnits)+(1*bTens); 
    end
    else 
    begin
        num1=7'd0;
        num2=7'd0; 
    end
    
    if(add) outAddAndSubAndMul=num1+num2;
    if(sub) outAddAndSubAndMul=num1-num2;
    if(mul) outAddAndSubAndMul=num1*num2;
    if(div)
    begin
        if(!rst && num2!=0)
        begin
            divQ=num1/num2;
            divR=num1%num2;
        end
        else
        begin
            if(rst)begin divQ=0;divR=0; end
            if(num2==0)begin divQ=1;divR=1;end 
        end
    end
end
endmodule

module breaker(out0,out1,out2,out3,out4,out5,out6,out7,inAddAndSubAndMul,divQ,divR);
output reg[3:0]out0,out1,out2,out3,out4,out5,out6,out7;
reg [3:0]temp0,temp1;
input [13:0]inAddAndSubAndMul;
input [6:0]divQ,divR;
always@(*)
begin
    out0=inAddAndSubAndMul%10;
    temp0=inAddAndSubAndMul/10;
    out1=(temp0)%10;
    temp1=temp0/10;
    out2=(temp1)%10;
    out3=(temp1)/10;
    
    //forRemainder
    out4=divQ%10;
    out5=divQ/10;
    
    //forQuotient
    out6=divR%10;
    out7=divR/10;
    
end
endmodule


module segCntrl(outSegCntrl,in0,in1,in2,in3,in4,in5,in6,in7,refCount);
output reg [3:0]outSegCntrl;
input [3:0]in0,in1,in2,in3,in4,in5,in6,in7;
input [2:0]refCount;
always@(*)
begin
    case(refCount)
    3'd0:outSegCntrl=in0;
    3'd1:outSegCntrl=in1;
    3'd2:outSegCntrl=in2;
    3'd3:outSegCntrl=in3;
    3'd4:outSegCntrl=in4;
    3'd5:outSegCntrl=in5;
    3'd6:outSegCntrl=in6;
    3'd7:outSegCntrl=in7;
    endcase
end
endmodule

module bcdToSeg(bcdToSegOut,bcdToSegIn);
output reg [6:0]bcdToSegOut;
input [3:0]bcdToSegIn;
always@(bcdToSegIn)
begin
case(bcdToSegIn)
4'b0000:bcdToSegOut=7'b1000_000;
4'b0001:bcdToSegOut=7'b1111_001;
4'b0010:bcdToSegOut=7'b0100_100;
4'b0011:bcdToSegOut=7'b0110_000;
4'b0100:bcdToSegOut=7'b0011_001;
4'b0101:bcdToSegOut=7'b0010_010;
4'b0110:bcdToSegOut=7'b0000_010;
4'b0111:bcdToSegOut=7'b1111_000;
4'b1000:bcdToSegOut=7'b0000_000;
4'b1001:bcdToSegOut=7'b0010_000;
default:bcdToSegOut=7'b1111_111;
endcase
end
endmodule

module anodeCntrl(anCntOut,anCntIn);
output reg [7:0]anCntOut;
input [2:0]anCntIn;
always@(anCntIn)
begin
case(anCntIn)
3'b000:anCntOut=8'b1111_1110;
3'b001:anCntOut=8'b1111_1101;
3'b010:anCntOut=8'b1111_1011;
3'b011:anCntOut=8'b1111_0111;
3'b100:anCntOut=8'b1110_1111;
3'b101:anCntOut=8'b1101_1111;
3'b110:anCntOut=8'b1011_1111;
3'b111:anCntOut=8'b0111_1111;
default:anCntOut=8'b1111_1111;
endcase
end
endmodule


module alu2BitDecimal(cathode,anode,RGB1_Red,RGB1_Green,num1OrNum2,swForUnits,swForTens,rst,sw,clk);
output [6:0]cathode;
output [7:0]anode;
output RGB1_Red,RGB1_Green;
input num1OrNum2;
input [3:0]swForUnits,swForTens;
input rst;
input clk;
input [1:0]sw;
wire add,sub,mul,div;
wire [3:0]num1Units,num1Tens,num2Units,num2Tens;
wire [13:0]outAddAndSubAndMul;
wire [6:0]divQ,divR;
wire [3:0]out0,out1,out2,out3,out4,out5,out6,out7;
wire nclk;
wire [2:0]outRef;
wire [3:0]outSegCntrl;
clkDiv dut00(nclk,clk);

refCount dut01(outRef,nclk);

swtichOption dut001 (add,sub,mul,div,sw);

takingInput dut02(num1Units,num1Tens,num2Units,num2Tens,RGB1_Red,RGB1_Green,num1OrNum2,swForUnits,swForTens);

processingUnit dut03 (outAddAndSubAndMul,divQ,divR,num1Units,num1Tens,num2Units,num2Tens,
                        add,sub,mul,div,rst);
                        
breaker dut04(out0,out1,out2,out3,out4,out5,out6,out7,outAddAndSubAndMul,divQ,divR);

segCntrl dut05(outSegCntrl,out0,out1,out2,out3,out4,out5,out6,out7,outRef);

bcdToSeg dut06(cathode,outSegCntrl);

anodeCntrl dut07(anode,outRef);

endmodule

module top_alu2BitDecimal(seg,an,RGB1_Red,RGB1_Green,num,swForUnits,swForTens,clk,sw,rst);
output [6:0]seg;
output [7:0]an;
output RGB1_Red,RGB1_Green;
input num;
input [3:0]swForUnits,swForTens;
input clk;
input rst;
input [1:0]sw;

alu2BitDecimal UUT (seg,an,RGB1_Red,RGB1_Green,num,swForUnits,swForTens,rst,sw,clk);
endmodule