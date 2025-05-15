

module Instr_Mem(A , rst , RD);
		
		input [31:0] A;
		input rst;
		
		output [31:0] RD;
		
		//creation of memory
		reg [31:0] Mem [1023:0];
		
		assign RD = (rst == 1'b0) ? 32'h00000000 : Mem[A[31:0]];
/*      
		initial begin
				// You can load the hex file directly 
    		$readmemh("memfile.hex",Mem);
  		end
*/	
		initial begin
				// You can manually add hex to desired location 
			Mem[0] = 32'h7ff00313; // ADDI x6, x0, 2047    ; x6 = 2047
			Mem[4] = 32'h80000393; // ADDI x7, x0, -2048   ; x7 = -2048 (two's complement)
			Mem[8] = 32'h007304b3; // ADD x9, x6, x7       ; x9 = 2047 + (-2048) = -1


		end
		
		

endmodule
