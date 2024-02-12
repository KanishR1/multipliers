`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2024 07:42:48 PM
// Design Name: 
// Module Name: school_book
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


module school_book #(
    parameter DATA_WIDTH = 8
)(
    input [DATA_WIDTH-1:0]a,
    input [DATA_WIDTH-1:0]b,
    output [(2*DATA_WIDTH)-1:0]y
    );
    assign y = a*b;
endmodule
