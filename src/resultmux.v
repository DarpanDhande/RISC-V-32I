module resultmux(a , b , c , ResultSrc);
    input [31:0] a, b;
    input ResultSrc;

    output [31:0] c;

    assign c = (ResultSrc == 1'b0) ? a : b;
endmodule