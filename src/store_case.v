module store_case(funct3 , data_mem_in , store_data , MemWrite);
        input [2:0] funct3;
        input MemWrite;
        input [31:0] data_mem_in;
        output [31:0] store_data;

        wire [7:0] byte_data   = data_mem_in[7:0];
        wire [15:0] half_data  = data_mem_in[15:0];

        wire [31:0] sb_data  = {{24{byte_data[7]}}, byte_data};
        wire [31:0] sh_data  = {{16{half_data[15]}}, half_data};

        assign store_data = ((funct3 == 3'b000) & MemWrite ) ? sb_data  : // SB
                   ((funct3 == 3'b001) & MemWrite) ? sh_data  : // SH
                                        data_mem_in; // SW
endmodule