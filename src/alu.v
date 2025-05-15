
module alu(A,B,ALUControl,Result,Z,N,V,C);
    input [31:0] A;
    input [31:0] B;
    input [3:0] ALUControl;
    output [31:0] Result;
	 output Z,N,V,C;
	 
	 wire [31:0] a_and_b;
	 wire [31:0] a_or_b;
	 wire [31:0] a_xor_b;
	 wire [31:0] not_b;
	 wire [31:0] mux_1;
	 wire [31:0] sum;
	 wire [31:0] mux_2;
	 wire [31:0] slt;
	 wire [31:0] sll;
	 wire [31:0] srl;
	 wire [31:0] sra;
	 wire [31:0] sltu;
	 wire cout;
	 
	 assign a_and_b = A & B;
	 
	 assign a_or_b = A | B;

	 assign a_xor_b = A ^ B;
	 
	 assign not_b = ~B;
	 
	 assign mux_1 = (ALUControl[0] == 1'b0) ? B : not_b;
	 
	 assign {cout,sum} = A + mux_1 + ALUControl[0];
	 
	 assign slt = {31'b0000000000000000000000000000000 , sum[31]};

	 assign sll = A << B[4:0];

	 assign srl = A >> B[4:0];

	 assign sra = $signed(A) >>> B[4:0];

	 assign sltu = ($unsigned(A) < $unsigned(B)) ? 32'b1 : 32'b0;
	 
	 assign mux_2 = (ALUControl[3:0] == 4'b0000) ? sum :
	                (ALUControl[3:0] == 4'b0001) ? sum :
						 (ALUControl[3:0] == 4'b0010) ? a_and_b :
						 (ALUControl[3:0] == 4'b0011) ? a_or_b:
						 (ALUControl[3:0] == 4'b0100) ? a_xor_b:
						 (ALUControl[3:0] == 4'b0110) ? sll :
						 (ALUControl[3:0] == 4'b1000) ? srl :
						 (ALUControl[3:0] == 4'b0111) ? sra :
						 (ALUControl[3:0] == 4'b0101) ? slt : 
						 (ALUControl[3:0] == 4'b1001) ? sltu : 32'h00000000;
	
	 assign Result = mux_2;
	 
	 assign Z = &(~Result);
	 
	 assign N = Result[31];
	 
	 assign C = cout & (~ALUControl[1]);
	 
	 assign V = (~ALUControl[1]) & (A[31] ^ sum[31]) &(~(A[31] ^ B[31] ^ ALUControl[0]));
	 


endmodule
