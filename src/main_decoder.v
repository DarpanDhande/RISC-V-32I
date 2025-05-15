
module main_decoder(
    input [6:0] op,
    input zero,
    input negative,
    input carry,
    input V,
    input [2:0] funct3,
    output RegWrite,
    output MemWrite,
    output ResultSrc,
    output ALUSrc,
    output PCSrc,
    output jalr_src,
    output halt,
    output [1:0] ImmSrc,
    output [1:0] ALUOp
);

    wire branch;
    wire bne;
    wire beq;
    wire bge;
    wire blt;
    wire bltu;
    wire bgeu;
    wire jal;
    wire jalr;
    wire lui;
    wire auipc;
    wire load;
    wire store;
    wire rtype;
    wire itype;
    wire fence;
    wire system;

    assign rtype  = (op == 7'b0110011); // R-type
    assign itype  = (op == 7'b0010011); // I-type (ALU)
    assign load   = (op == 7'b0000011); // Load
    assign store  = (op == 7'b0100011); // Store
    assign branch = (op == 7'b1100011); // Branch
    assign jal    = (op == 7'b1101111); // JAL
    assign jalr   = (op == 7'b1100111); // JALR
    assign lui    = (op == 7'b0110111); // LUI
    assign auipc  = (op == 7'b0010111); // AUIPC
    assign fence  = (op == 7'b0001111); // FENCE
    assign system = (op == 7'b1110011); // SYSTEM (ECALL/EBREAK)
    assign bne = (branch & (funct3 == 3'b001) & (~zero)); // BNE intruction requires non zero that is not equal
    assign beq = (branch & (funct3 == 3'b000) & (zero));
    assign blt = (branch & (funct3 == 3'b100) & (negative));
    assign bge = (branch & (funct3 == 3'b101) & (~negative));
    assign bltu = (branch & (funct3 == 3'b110) & carry);  // Branch if Less Than Unsigned
    assign bgeu = (branch & (funct3 == 3'b111) & ~carry); // Branch if Greater Than or Equal Unsigned

    // RegWrite: All instructions that write to a register
    assign RegWrite = rtype | itype | load | jal | jalr | lui | auipc;

    // MemWrite: only S-type (store)
    assign MemWrite = store;

    // ResultSrc: 1 if coming from memory (load), 0 if from ALU
    assign ResultSrc = load;

    // ALUSrc: 1 for ALU immediate, load/store address, JALR, etc.
    assign ALUSrc = itype | load | store | jalr | system | lui | auipc;

    // PCSrc: branch or jal or jalr causes PC to update from target
    assign PCSrc = beq | jal | jalr | bne | blt | bge | bltu | bgeu;

    // ImmSrc: 
    // 00 → I-type
    // 01 → S-type
    // 10 → B-type
    // 11 → J-type
    assign ImmSrc = (store)           ? 2'b01 : 
                    (branch)          ? 2'b10 : 
                    (lui | auipc | jal) ? 2'b11 :
                    2'b00;

    // ALUOp:
    // 00 → ADD or default (load, store)
    // 01 → for branch comparison
    // 10 → R-type and I-type ALU operations
    assign ALUOp = rtype     ? 2'b10 :
                   itype     ? 2'b10 :
                   branch    ? 2'b01 : 
                   2'b00;

    assign jalr_src = jalr ;

    assign halt = system;

endmodule
