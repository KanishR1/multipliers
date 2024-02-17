`timescale 1ns / 1ps


(*USE_DSP="No"*)module toom_mul_generic #(
    parameter DATA_WIDTH = 13
)(
    input [DATA_WIDTH-1:0]a,
    input [DATA_WIDTH-1:0]b,
    output [(2*DATA_WIDTH)-1 : 0]y
);


localparam integer MID_IDX = (((DATA_WIDTH/2)*2) == DATA_WIDTH ) ? DATA_WIDTH/2 : DATA_WIDTH/2 + 1 ;

reg [MID_IDX:0]hb0;
reg [MID_IDX:0]hb1;
reg [MID_IDX:0]hb2;
reg [MID_IDX:0]sb0;
reg [MID_IDX:0]sb1;
reg [MID_IDX:0]sb2;
reg [(2*MID_IDX)+1:0] ib0;
reg [(2*MID_IDX)+1:0] ib1;
reg [(2*MID_IDX)+1:0] ib2;
reg [DATA_WIDTH-1:0]r0;
reg [DATA_WIDTH:0]r1;
reg [DATA_WIDTH-1:0]r2; 

initial begin
    hb0 = 'd0;
    hb1 = 'd0;
    hb2 = 'd0;
    sb0 = 'd0;
    sb1 = 'd0;
    sb2 = 'd0;
    ib0 = 'd0;
    ib1 = 'd0;
    ib2 = 'd0;
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

always @(*) begin
    
    r0 = ib0;
    r1 = ib1-(ib0+ib2);
    r2 = ib2;

end

assign y = r0 + {r1,{(MID_IDX){1'b0}}}+{r2,{(DATA_WIDTH){1'b0}}};

endmodule
