
module pc_target_adder(jalr_address , PC_Top , Imm_Ext , pc_target , rst , jalr);

	input [31:0] PC_Top , Imm_Ext , jalr_address;
	input rst , jalr;
	
	output [31:0] pc_target;
	
	assign pc_target = (rst == 1'b0) ? 32'h00000000 : (jalr) ? Imm_Ext + jalr_address : PC_Top + Imm_Ext ;


endmodule
