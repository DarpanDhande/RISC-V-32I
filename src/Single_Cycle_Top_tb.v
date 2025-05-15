
module Single_Cycle_Top_tb;

	// Inputs
	reg clk;
	reg rst;

	// Instantiate the Unit Under Test (UUT)
	Single_Cycle_Top uut (
		.clk(clk), 
		.rst(rst)
	);

	initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0 , uut);
    end

	always begin
	
	clk = 1'b0;
	#50;
	
	clk = 1'b1;
	#50;
	end

	initial begin
		
		rst = 1'b0;

		// Wait 100 ns for global reset to finish
		#150;
		
		rst = 1'b1;
		#10000;
		$finish;
        
		// Add stimulus here

	end
	

      
endmodule

