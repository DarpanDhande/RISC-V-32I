
module Sign_Extend(In, ImmSrc, Imm_Ext);
    
    input [24:0] In;
    input [1:0] ImmSrc;
    output reg [31:0] Imm_Ext;

    always @(*) begin
        case (ImmSrc)
           // 2'b00: Imm_Ext = (In[24] == 1'b0) ? {20'h00000, In[24:13]} : {20'h11111, In[24:13]} ;             // I-type
            2'b00: Imm_Ext = {{20{In[24]}}, In[24:13]};
            2'b01: Imm_Ext = {{20{In[24]}}, In[24:18], In[4:0]};                            // S-type
            2'b10: Imm_Ext = {{19{In[24]}}, In[24], In[0], In[23:18], In[4:1], 1'b0};       // B-type
            2'b11: Imm_Ext = {{12{In[24]}}, In[24], In[12:5] , In[13] , In[23:14] , 1'b0};  // J-type
            default: Imm_Ext = 32'b0;
        endcase
    end

endmodule
