`include "P_C.v"
`include "PC_adder.v"
`include "pc_mux.v"
`include "pc_target_adder.v"
`include "pc_jalr_adder.v"
`include "Instr_Mem.v"
`include "Reg_file.v"
`include "Sign_Extend.v"
`include "alu.v"
`include "alu_decoder.v"
`include "main_decoder.v"
`include "Data_Memory.v"
`include "alumux.v"
`include "resultmux.v"
`include "load_case.v"
`include "store_case.v"


module Single_Cycle_Top(clk , rst);
		
		input wire clk , rst;
		
		
		
		wire [31:0] PC_Top , PCPlus4 , pc_next , pc_target , jalr_address;
		wire [31:0] RD_instr , RD1_A , EXT_B , ALU_Result , Read_Data , RD2_WD , SrcB , result , load_data , store_data;
		wire RegWrite , MemWrite , ALUSrc , ResultSrc , PCSrc , zero , negative , carry , jalr_src , overflow; 
		wire [3:0] ALUControl;
		wire [1:0] ALUOp , ImmSrc;
		
		P_C P_C(
			.clk(clk),
			.PC_NEXT(pc_next), 
			.PC(PC_Top),
			.rst(rst)
			);

		pc_mux pc_mux(
			.pc_target(pc_target),
			.pc_plus4(PCPlus4),
			.pc_next(pc_next),
			.PCSrc(PCSrc)
		);
			
		PC_adder PC_adder(
			.a(PC_Top),
			.b(32'd4),
			.c(PCPlus4),
			.rst(rst),
			.halt(halt)
			);
		
		pc_target_adder pc_target_adder(
			.PC_Top(PC_Top),
			.Imm_Ext(EXT_B),
			.pc_target(pc_target),
			.jalr_address(jalr_address),
			.rst(rst),
			.jalr(jalr_src)
			);
		
		pc_jalr_adder pc_jalr_adder(
			.jalr(jalr_src),
			.RD1(RD1_A),
			.jalr_address(jalr_address)
			);
		
		Instr_Mem Instr_Mem(
			.A(PC_Top),
			.rst(rst),
			.RD(RD_instr)
			);
			
		Reg_file Reg_file(
			.A1(RD_instr[19:15]),
			.A2(RD_instr[24:20]),
			.A3(RD_instr[11:7]),
			.WD3(load_data),
			.WE3(RegWrite),
			.rst(rst),
			.clk(clk),
			.RD1(RD1_A),
			.RD2(RD2_WD)
			);
		
		Sign_Extend Sign_Extend(
			.In(RD_instr[31:7]),
			.Imm_Ext(EXT_B),
			.ImmSrc(ImmSrc)
			);
			
		alu alu(
			.A(RD1_A),
			.B(SrcB),
			.ALUControl(ALUControl),
			.Result(ALU_Result),
			.Z(zero),
			.N(negative),
			.V(overflow),
			.C(carry)
			);
			
		alu_decoder alu_decoder(
			.ALUOp(ALUOp),
			.op5(RD_instr[5]),
			.funct3(RD_instr[14:12]),
			.funct7(RD_instr[30]),
			.ALUControl(ALUControl)
			);
			
		main_decoder main_decoder(
			.op(RD_instr[6:0]),
			.funct3(RD_instr[14:12]),
			.zero(zero),
			.negative(negative),
			.carry(carry),
			.RegWrite(RegWrite),
			.MemWrite(MemWrite),
			.ResultSrc(ResultSrc),
			.ALUSrc(ALUSrc),
			.ImmSrc(ImmSrc),
			.jalr_src(jalr_src),
			.ALUOp(ALUOp),
			.PCSrc(PCSrc),
			.halt(halt),
			.V(overflow)
			);

		store_case store_case(
			.funct3(RD_instr[14:12]),
			.data_mem_in(RD2_WD),
			.store_data(store_data),
			.MemWrite(MemWrite)
			);
			
		Data_Memory Data_Memory(
			.A(ALU_Result),
			.WD(store_data),
			.WE(MemWrite),
			.RD(Read_Data),
			.clk(clk)
			);

		load_case load_case(
			.funct3(RD_instr[14:12]),
			.data_mem_out(result),
			.load_data(load_data),
			.ResultSrc(ResultSrc)
			);
			
		alumux alumux(
			.a(RD2_WD),
			.b(EXT_B),
			.c(SrcB),
			.ALUSrc(ALUSrc)
		);

		resultmux resultmux(
			.a(ALU_Result),
			.b(Read_Data),
			.c(result),
			.ResultSrc(ResultSrc)
		);


endmodule
