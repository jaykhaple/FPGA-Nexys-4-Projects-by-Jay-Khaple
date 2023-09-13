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



module clkDiv1hz(clk1hz,clk);
output reg clk1hz=0;
input clk;
integer count=0;
always@(posedge clk)
begin
if(count==50000000)
begin
clk1hz=~clk1hz;
count=0;
end
else count =count +1;
end
endmodule





module refCount(refCountOut,refCountIn);
output reg [2:0]refCountOut=3'd0;
input refCountIn;
always@(posedge refCountIn)
begin
if(refCountOut>=5) refCountOut=3'd0;
else refCountOut=refCountOut+1;
end
endmodule

module countToBcd(cBcdOut,slc,ct1,ct2,ct3,ct4,ct5,ct6);
output reg [3:0]cBcdOut;
input [2:0]slc;
input [3:0]ct1,ct2,ct3,ct4,ct5,ct6;
always@(slc,ct1,ct2,ct3,ct4,ct5,ct6)
begin
case(slc)
3'b000:cBcdOut=ct1;
3'b001:cBcdOut=ct2;
3'b010:cBcdOut=ct3;
3'b011:cBcdOut=ct4;
3'b100:cBcdOut=ct5;
3'b101:cBcdOut=ct6;
default:cBcdOut=4'b0000;
endcase
end
endmodule

module counterSecMinHrMEETOO(outSec,outMin,outHr,clk,rst);
output reg [5:0]outSec=6'd0;
output reg [5:0]outMin=6'd0;
output reg [4:0]outHr=5'd0;
input clk,rst;
always@(posedge clk,posedge rst)
begin
    if(rst)
    begin
        outSec=6'd0;
        outMin=6'd0;
        outHr=5'd0;
    end
    else
    begin
        if(outSec==6'd59)
        begin
            outSec=6'd0;
            if(outMin==6'd59)
            begin
                outMin=6'd0;
                if(outHr==5'd23)
                begin
                    outHr=5'd0;    
                end
                else outHr=outHr+1;
            end
            else outMin=outMin+1;
        end
        else outSec=outSec+1;    
    end
end
endmodule

module countTo6(sec0,sec1,min0,min1,hr0,hr1,inSec,inMin,inHr);
output reg [3:0]sec0,sec1,min0,min1,hr0,hr1;
input [5:0]inSec,inMin;
input [4:0]inHr;
always@(inSec,inMin,inHr)
begin
    sec1=inSec/5'd10;
    sec0=inSec%5'd10;


    min1=inMin/5'd10;
    min0=inMin%5'd10;
    
    hr1=inHr/4'd10;
    hr0=inHr%4'd10;
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
default:bcdToSegOut=7'b1000_000;
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
default:anCntOut=8'b1111_1111;
endcase
end
endmodule

module digitalClock(cathode,anode,clk,rst);
output [6:0]cathode;
output [7:0]anode;
input clk;
input rst;
wire [3:0]sec0,sec1,min0,min1,hr0,hr1;
wire refCountIn;
wire inCount;
wire [2:0]refCountOut;
wire [3:0]cBcdOut;
wire [5:0]outSec;
wire [5:0]outMin;
wire [4:0]outHr;

clkDiv dut1(refCountIn,clk);
clkDiv1hz dut01(inCount,clk);
counterSecMinHrMEETOO dut02(outSec,outMin,outHr,inCount,rst);
countTo6 dut003(sec0,sec1,min0,min1,hr0,hr1,outSec,outMin,outHr);
refCount dut2(refCountOut,refCountIn);
countToBcd dut3(cBcdOut,refCountOut,sec0,sec1,min0,min1,hr0,hr1);
bcdToSeg dut4(cathode,cBcdOut);
anodeCntrl dut5(anode,refCountOut);
endmodule


module TOP_digitalClock(seg,an,led,clk,sw);
output [6:0]seg;
output [7:0]an;
input clk,sw;
output reg led;
digitalClock UUT(seg,an,clk,sw);
always@(sw)
begin
if(sw) led=1;
else led=0;
end

endmodule

//module TEST_digitalClockWithoutCounter();
//wire [6:0]cathode;
//wire [7:0]anode;
//reg clk=0;
//reg [3:0]ct1,ct2,ct3,ct4,ct5,ct6;
//digitalClockWithoutCounter UUT(cathode,anode,clk,ct1,ct2,ct3,ct4,ct5,ct6);
//always #0.1 clk=~clk;
//initial
//begin
//ct1=4'b1001;ct2=4'b1001;ct3=4'b1001;ct4=4'b1001;ct5=4'b1001;ct6=4'b1001;
//#10000 ct1=4'b0001;ct2=4'b0001;ct3=4'b0001;ct4=4'b0001;ct5=4'b0001;ct6=4'b0001;
//#10000 ct1=4'b1001;ct2=4'b1001;ct3=4'b1001;ct4=4'b1001;ct5=4'b1001;ct6=4'b1001;
//#10000 ct1=4'b0001;ct2=4'b0001;ct3=4'b0001;ct4=4'b0001;ct5=4'b0001;ct6=4'b0001;
//#1000000000 $finish;
//end
//endmodule
