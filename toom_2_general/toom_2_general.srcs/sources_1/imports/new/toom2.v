`timescale 1ns / 1ps


(*USE_DSP="No"*)module toom_mul_generic #(
    parameter DATA_WIDTH = 32
)(
    input [DATA_WIDTH-1:0]a,
    input [DATA_WIDTH-1:0]b,
    output [(2*DATA_WIDTH)-1 : 0]y
);


localparam integer MID_IDX = DATA_WIDTH/2;

wire [MID_IDX:0]hb0;
wire [MID_IDX:0]hb1;
wire [MID_IDX:0]hb2;

wire [MID_IDX:0]sb0;
wire [MID_IDX:0]sb1;
wire [MID_IDX:0]sb2;

wire [(2*MID_IDX)+1:0] ib0;
wire [(2*MID_IDX)+1:0] ib1;
wire [(2*MID_IDX)+1:0] ib2;

wire [DATA_WIDTH-1:0]r0;
wire [DATA_WIDTH:0]r1;
wire [DATA_WIDTH-1:0]r2; 


assign hb0 = {1'b0,a[MID_IDX-1:0]};
assign sb0 = {1'b0,b[MID_IDX-1:0]};

assign hb1 = a[DATA_WIDTH-1:MID_IDX]+a[MID_IDX-1:0];
assign sb1 = b[DATA_WIDTH-1:MID_IDX]+b[MID_IDX-1:0];

assign hb2 = {1'b0,a[DATA_WIDTH-1:MID_IDX]};
assign sb2 = {1'b0,b[DATA_WIDTH-1:MID_IDX]};

/*
assign ib0 = sb0*hb0;
assign ib1 = sb1*hb1;
assign ib2 = sb2*hb2;
*/
generate
    if(DATA_WIDTH<=8) begin
        school_book #(.DATA_WIDTH(MID_IDX+2)) M1(.a({1'b0,sb0}), .b({1'b0,hb0}), .y(ib0));
        school_book #(.DATA_WIDTH(MID_IDX+2)) M2(.a({1'b0,sb1}), .b({1'b0,hb1}), .y(ib1));
        school_book #(.DATA_WIDTH(MID_IDX+2)) M3(.a({1'b0,sb2}), .b({1'b0,hb2}), .y(ib2));
    end
    else begin
        toom2 #(.DATA_WIDTH(MID_IDX+2)) M4(.a({1'b0,sb0}), .b({1'b0,hb0}), .y(ib0));
        toom2 #(.DATA_WIDTH(MID_IDX+2)) M5(.a({1'b0,sb1}), .b({1'b0,hb1}), .y(ib1));
        toom2 #(.DATA_WIDTH(MID_IDX+2)) M6(.a({1'b0,sb2}), .b({1'b0,hb2}), .y(ib2));
    end
endgenerate

assign r0 = ib0;
assign r1 = ib1-(ib0+ib2);
assign r2 = ib2;

assign y = r0 + {r1,{(MID_IDX){1'b0}}}+{r2,{(DATA_WIDTH){1'b0}}};

endmodule
