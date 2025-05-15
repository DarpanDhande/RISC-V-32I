
module PC_adder(a , b , c , rst , halt);

	input [31:0] a , b;
	input rst , halt;
	
	output [31:0] c;
	
	assign c = (rst == 1'b0) ? 32'h00000000 : ((halt) ? a :a + b);


endmodule
