module load_case(funct3 , data_mem_out , load_data , ResultSrc);
        input [2:0] funct3;
        input ResultSrc;
        input [31:0] data_mem_out;
        output [31:0] load_data;

        wire [7:0] byte_data   = data_mem_out[7:0];
        wire [15:0] half_data  = data_mem_out[15:0];

        wire [31:0] lb_data  = {{24{byte_data[7]}}, byte_data};
        wire [31:0] lh_data  = {{16{half_data[15]}}, half_data};
        wire [31:0] lbu_data = {24'b0, byte_data};
        wire [31:0] lhu_data = {16'b0, half_data};

        assign load_data = ((funct3 == 3'b000) & ResultSrc) ? lb_data  : // LB
                   ((funct3 == 3'b001) & ResultSrc) ? lh_data  : // LH
                   ((funct3 == 3'b100) & ResultSrc) ? lbu_data : // LBU
                   ((funct3 == 3'b101) & ResultSrc) ? lhu_data : // LHU
                                        data_mem_out; // LW
endmodule