module alumux(a , b , c , ALUSrc);
    input [31:0] a, b;
    input ALUSrc;

    output [31:0] c;

    assign c = (ALUSrc == 1'b0) ? a : b;
endmodule