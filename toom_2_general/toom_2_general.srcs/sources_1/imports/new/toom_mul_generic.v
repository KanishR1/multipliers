`timescale 1ns / 1ps


(*USE_DSP="No"*)module toom_mul_generic #(
    parameter DATA_WIDTH = 16
)(
    input [DATA_WIDTH-1:0]a,
    input [DATA_WIDTH-1:0]b,
    output [(2*DATA_WIDTH)-1 : 0]y
);

localparam integer ODD_SIZE_DATA = (((DATA_WIDTH/2)*2) != DATA_WIDTH );
localparam integer MIDDLE_VALUE = DATA_WIDTH/2;

localparam integer MID_IDX = ODD_SIZE_DATA ? MIDDLE_VALUE + 1 : MIDDLE_VALUE ;


reg [MID_IDX:0]hb0;
reg [MID_IDX:0]hb1;
reg [MID_IDX:0]hb2;
reg [MID_IDX:0]sb0;
reg [MID_IDX:0]sb1;
reg [MID_IDX:0]sb2;
wire [(2*MID_IDX)+1:0] ib0;
wire [(2*MID_IDX)+1:0] ib1;
wire [(2*MID_IDX)+1:0] ib2;
reg [(2*MID_IDX)+1:0]r0;
reg [(2*MID_IDX)+1:0]r1;
reg [(2*MID_IDX)+1:0]r2; 

wire [(2*MID_IDX)+1:0] cb0;assign cb0 = hb0 *sb0;
wire [(2*MID_IDX)+1:0] cb1;assign cb1  = hb1 * sb1;
wire [(2*MID_IDX)+1:0] cb2;assign cb2  = hb2 * sb2;

initial begin
    hb0 = 'd0;
    hb1 = 'd0;
    hb2 = 'd0;
    sb0 = 'd0;
    sb1 = 'd0;
    sb2 = 'd0;
    r0 = 'd0;
    r1 = 'd0;
    r2 = 'd0; 
    
end

always @(*) begin
    
    hb0 = a[MID_IDX-1:0];
    sb0 = b[MID_IDX-1:0];

    hb1 = a[DATA_WIDTH-1:MID_IDX]+a[MID_IDX-1:0];
    sb1 = b[DATA_WIDTH-1:MID_IDX]+b[MID_IDX-1:0];

    hb2 = a[DATA_WIDTH-1:MID_IDX];
    sb2 = b[DATA_WIDTH-1:MID_IDX];
    
end

generate
    if(DATA_WIDTH<=8) begin
        school_book #(.DATA_WIDTH(MID_IDX+1)) M1(.a(sb0), .b(hb0), .y(ib0));
        school_book #(.DATA_WIDTH(MID_IDX+1)) M2(.a(sb1), .b(hb1), .y(ib1));
        school_book #(.DATA_WIDTH(MID_IDX+1)) M3(.a(sb2), .b(hb2), .y(ib2));
    end
    else begin
        toom2 #(.DATA_WIDTH(MID_IDX+1)) M4(.a(sb0), .b(hb0), .y(ib0));
        toom2 #(.DATA_WIDTH(MID_IDX+1)) M5(.a(sb1), .b(hb1), .y(ib1));
        toom2 #(.DATA_WIDTH(MID_IDX+1)) M6(.a(sb2), .b(hb2), .y(ib2));
    end
endgenerate

always @(*) begin
    
    r0 = ib0;
    r1 = ib1-(ib0+ib2);
    r2 = ib2;

end

assign y = r0 + {r1,{(MID_IDX){1'b0}}}+{r2,{(2*MID_IDX){1'b0}}};

endmodule
