module pc_jalr_adder(jalr , RD1 , jalr_address);
        input jalr;
        input [31:0] RD1;
        output [31:0] jalr_address;

        assign jalr_address = (jalr) ? RD1 : 32'b0;

endmodule