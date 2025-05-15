
module Reg_file(A1 , A2 , A3 , WD3 , WE3 , rst , clk , RD1 , RD2);
	 
	 input [4:0] A1 , A2 , A3;
	 input [31:0] WD3;
	 input rst , clk , WE3;
	 
	 output [31:0] RD1 , RD2;
	 
	 reg [31:0] Registers [31:0];
	 
	 //Read function
	 assign RD1 = (rst == 1'b0) ? 32'h00000000 : Registers[A1];
	 
	 assign RD2 = (rst == 1'b0) ? 32'h00000000 : Registers[A2];

	 initial begin
		Registers[0] = 32'h00000000;
		Registers[1] = 32'h00000000;
		Registers[2] = 32'h00000000;
		Registers[3] = 32'h00000000;
		Registers[4] = 32'h00000000;
		Registers[5] = 32'h00000000;
		Registers[6] = 32'h00000000;
		Registers[7] = 32'h00000000;
		Registers[8] = 32'h00000000;
		Registers[9] = 32'h00000000;
		Registers[10] = 32'h00000000;
		Registers[11] = 32'h00000000;
		Registers[12] = 32'h00000000;
		Registers[13] = 32'h00000000;
		Registers[14] = 32'h00000000;
		Registers[15] = 32'h00000000;
		Registers[16] = 32'h00000000;
		Registers[17] = 32'h00000000;
		Registers[18] = 32'h00000000;
		Registers[19] = 32'h00000000;
		Registers[20] = 32'h00000000;
		Registers[21] = 32'h00000000;
		Registers[22] = 32'h00000000;
		Registers[23] = 32'h00000000;
		Registers[24] = 32'h00000000;
		Registers[25] = 32'h00000000;
		Registers[26] = 32'h00000000;
		Registers[27] = 32'h00000000;
		Registers[28] = 32'h00000000;
		Registers[29] = 32'h00000000;
		Registers[30] = 32'h00000000;
		Registers[31] = 32'h00000000;
	 	end
	 
	 //write function 
	 // write function with x0 protection
	always @(posedge clk)
	begin
    	if (WE3)  // prevent writing to register x0
    		begin
        		Registers[A3] <= WD3;
    		end
	end



endmodule
