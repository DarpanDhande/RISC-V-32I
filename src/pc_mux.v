module pc_mux(pc_target , pc_plus4 , pc_next , PCSrc);
    input [31:0] pc_target , pc_plus4;
    input PCSrc;

    output [31:0] pc_next;

    assign pc_next = (PCSrc == 1'b0) ? pc_plus4 : pc_target;
endmodule