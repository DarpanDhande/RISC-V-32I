module alu_decoder(
    input [1:0] ALUOp,           // From main decoder: 00 = default (add), 01 = branch, 10 = R-type/I-type ALU
    input [2:0] funct3,          // ALU function selector
    input funct7,                // Only the MSB bit funct7[5], typically used to distinguish ADD/SUB
    input op5,                   // Bit 5 of opcode to distinguish between ADD/SUB, SRL/SRA
    output reg [3:0] ALUControl  // Output ALU control signal
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 4'b0000; // Default ADD (for load/store/immediate)
        2'b01: ALUControl = 4'b0001; // SUB (for branches)
        2'b10: begin
            case (funct3)
                3'b000: ALUControl = (funct7 & op5) ? 4'b0001 : 4'b0000; // SUB : ADD
                3'b111: ALUControl = 4'b0010; // AND
                3'b110: ALUControl = 4'b0011; // OR
                3'b100: ALUControl = 4'b0100; // XOR
                3'b010: ALUControl = 4'b0101; // SLT
				3'b011: ALUControl = 4'b1001; // SLTU
                3'b001: ALUControl = 4'b0110; // SLL
                3'b101: ALUControl = (funct7 & op5) ? 4'b0111 : 4'b1000; // SRA : SRL
                default: ALUControl = 4'b0000; // Default to ADD
            endcase
        end
        default: ALUControl = 4'b0000;
    endcase
end

endmodule
