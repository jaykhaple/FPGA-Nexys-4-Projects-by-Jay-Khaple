`timescale 1ns / 1ps

module clkDivforRefCount(nclk,clk);
output reg nclk;
input clk;
integer count=0;
always@(posedge clk)
begin
count=count+1;
nclk=count[16];
end
endmodule
////////////////////////////////////////////////////////////////////////////
module refCount(outRefCount,clk);
output reg [2:0]outRefCount=3'd0;
input clk;
always@(posedge clk)
begin
    outRefCount=outRefCount+1;
end
endmodule
////////////////////////////////////////////////////////////////////////////
module amtToPayCal(outAmtToPayCal,outAmtYouArePaying,outAmtBal,selItm1,quantItm1,selItm2,quantItm2,cal,pay,five,ten,confirm);
output reg [5:0]outAmtToPayCal=6'd0;
reg [5:0]temp=6'd0;
output reg [5:0]outAmtYouArePaying=6'd0;
output reg [5:0]outAmtBal=6'd0;
input selItm1,selItm2,cal,pay,confirm;
input [2:0]quantItm1,quantItm2;
input [1:0]five,ten;
always@(*)
begin
    if( cal && pay==0 &&confirm ==0)
    begin
        temp=(selItm1*quantItm1)+(selItm2*quantItm2);
        outAmtToPayCal=temp*2;
    end
    if(cal && pay==1 &&confirm ==0)
    begin
        outAmtYouArePaying=(5*five)+(10*ten);
    end
    if(cal && pay==1 &&confirm ==1)
    begin
        outAmtBal=outAmtYouArePaying-outAmtToPayCal;
    end
end
endmodule
///////////////////////////////////////////////////////////////////////////
module divBigAmt(unitsPlace,tensPlace,unitsPlacePaying,tensPlacePaying,unitsPlaceBal,tensPlaceBal,inDivBigAmt,inDivBigAmtPaying,inDivBigAmtBal);
output reg [3:0]unitsPlace,tensPlace,unitsPlacePaying,tensPlacePaying,unitsPlaceBal,tensPlaceBal;
input [5:0]inDivBigAmt,inDivBigAmtPaying,inDivBigAmtBal;
always@(inDivBigAmt,inDivBigAmtPaying,inDivBigAmtBal)
begin
    unitsPlace=inDivBigAmt%10;
    tensPlace=inDivBigAmt/10;
    
    unitsPlacePaying=inDivBigAmtPaying%10;
    tensPlacePaying=inDivBigAmtPaying/10;

    unitsPlaceBal=inDivBigAmtBal%10;
    tensPlaceBal=inDivBigAmtBal/10;
end
endmodule
////////////////////////////////////////////////////////////////////////////
module messageCntrl(outMsg0,outMsg1,outMsg2,outMsg3,outMsg4,outMsg5,outMsg6,outMsg7,
unitsPlace,tensPlace,unitsPlacePaying,tensPlacePaying,unitsPlaceBal,tensPlaceBal,cal,pay,confirm);
output reg [4:0]outMsg0,outMsg1,outMsg2,outMsg3,outMsg4,outMsg5,outMsg6,outMsg7;
input [3:0]unitsPlace,tensPlace,unitsPlacePaying,tensPlacePaying,unitsPlaceBal,tensPlaceBal;
input cal,pay,confirm;
always@(*)
begin
    if(cal && pay==0 && confirm ==0)
    begin
        outMsg0=unitsPlace;
        outMsg1=tensPlace;
        outMsg2=5'd0;
        outMsg3=5'd0;
        outMsg4=5'd10; //10 => -
        outMsg5=5'd13;  //13 => Y
        outMsg6=5'd11; //11=> A
        outMsg7=5'd12;  // 12 => P
    end
    if(cal && pay ==1  && confirm ==0)
    begin
        outMsg0=unitsPlacePaying;
        outMsg1=tensPlacePaying;
        outMsg2=5'd0;
        outMsg3=5'd0;
        outMsg4=5'd13;  //13 => Y
        outMsg5=5'd11; //11=> A
        outMsg6=5'd12;  // 12 => P
        outMsg7=5'd13;  //13 => Y
    end
    if(cal && pay ==1  && confirm ==1)
    begin
        outMsg0=unitsPlaceBal;
        outMsg1=tensPlaceBal;
        outMsg2=5'd0;
        outMsg3=5'd0;
        outMsg4=5'd10;  //10 => -
        outMsg5=5'd14; //14=> L
        outMsg6=5'd11;  // 11 => A
        outMsg7=5'd8;  //8 => B
    end
end

endmodule
///////////////////////////////////////////////////////////////////////////
module digitCntrl(outDigitCntrl,inMsg0,inMsg1,inMsg2,inMsg3,inMsg4,inMsg5,inMsg6,inMsg7,refCount);
output reg[4:0]outDigitCntrl;
input [4:0]inMsg0,inMsg1,inMsg2,inMsg3,inMsg4,inMsg5,inMsg6,inMsg7;
input [2:0]refCount;
always@(*)
begin
    case(refCount)
    3'd0:outDigitCntrl=inMsg0;
    3'd1:outDigitCntrl=inMsg1;
    3'd2:outDigitCntrl=inMsg2;
    3'd3:outDigitCntrl=inMsg3;
    3'd4:outDigitCntrl=inMsg4;
    3'd5:outDigitCntrl=inMsg5;
    3'd6:outDigitCntrl=inMsg6;
    3'd7:outDigitCntrl=inMsg7;
    default:outDigitCntrl=5'd10;
    endcase
    
    
end
endmodule

///////////////////////////////////////////////////////////////////////////
module segCntrl(seg,inSegCntrl);
output reg [6:0]seg;
input [4:0]inSegCntrl;
always@(inSegCntrl)
begin
    case(inSegCntrl)
    5'd0:seg=7'b1000_000;
    4'd1:seg=7'b1111_001;
    4'd2:seg=7'b0100_100;
    4'd3:seg=7'b0110_000;
    4'd4:seg=7'b0011_001;
    4'd5:seg=7'b0010_010;
    4'd6:seg=7'b0000_010;
    4'd7:seg=7'b1111_000;
    4'd8:seg=7'b0000_000;
    4'd9:seg=7'b0010_000;
    4'd10:seg=7'b0111_111;
    4'd11:seg=7'b0001_000;
    4'd12:seg=7'b0001_100;
    4'd13:seg=7'b0010_001;
    4'd14:seg=7'b1000_111;
    default:seg=7'b1111_111;
    endcase
end
endmodule
///////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////
module vendingMachine(cathode,anode,clk,itm1,quant1,itm2,quant2,cal,pay,five,ten,confirm);
output [6:0]cathode;
output [7:0]anode;
input clk,cal,pay,confirm;
input itm1,itm2;
input [2:0]quant1,quant2;
input [1:0]five,ten;
wire nclk;
wire [2:0]outRefCount;
wire [5:0]outAmtToPayCal,outAmtYouArePaying,outAmtBal;
wire [3:0]unitsPlace,tensPlace,unitsPlacePaying,tensPlacePaying,unitsPlaceBal,tensPlaceBal;
wire [4:0]outMsg0,outMsg1,outMsg2,outMsg3,outMsg4,outMsg5,outMsg6,outMsg7;
wire [4:0]outDigitCntrl;



clkDivforRefCount dut001(nclk,clk);

refCount dut002(outRefCount,nclk);

amtToPayCal dut003(outAmtToPayCal,outAmtYouArePaying,outAmtBal,itm1,quant1,itm2,quant2,cal,pay,five,ten,confirm);

divBigAmt dut004(unitsPlace,tensPlace,unitsPlacePaying,tensPlacePaying,unitsPlaceBal,tensPlaceBal,outAmtToPayCal,outAmtYouArePaying,outAmtBal);

messageCntrl dut005(outMsg0,outMsg1,outMsg2,outMsg3,outMsg4,outMsg5,outMsg6,outMsg7,
unitsPlace,tensPlace,unitsPlacePaying,tensPlacePaying,unitsPlaceBal,tensPlaceBal,cal,pay,confirm);

digitCntrl dut006(outDigitCntrl,outMsg0,outMsg1,outMsg2,outMsg3,outMsg4,outMsg5,outMsg6,outMsg7,outRefCount);

segCntrl dut007(cathode,outDigitCntrl);

anodeCntrl dut008(anode,outRefCount);

endmodule

/////////////////////////////////////////////////////////////////////////////////////////
module TOP_vendingMachine(seg,an,clk,itm1,quant1,itm2,quant2,cal,pay,five,ten,confirm);
output [6:0]seg;
output [7:0]an;
input clk,itm1,itm2,cal,pay,confirm;
input [2:0]quant1,quant2;
input [1:0]five,ten;
vendingMachine UUT(seg,an,clk,itm1,quant1,itm2,quant2,cal,pay,five,ten,confirm);
endmodule
