typedef enum logic [5:0] {
    IR_NOP,
    IR_ADD,
    IR_SUB,
    IR_SLL,
    IR_SLT,
    IR_SLTU,
    IR_XOR,
    IR_SRL,
    IR_SRA,
    IR_OR,
    IR_AND,
    IR_ADDI,
    IR_SLLI,
    IR_SLTI,
    IR_SLTIU,
    IR_XORI,
    IR_SRLI,
    IR_SRAI,
    IR_ORI,
    IR_ANDI,
    IR_SB,
    IR_SH,
    IR_SW,
    IR_LB,
    IR_LH,
    IR_LW,
    IR_LBU,
    IR_LHU,
    IR_BEQ,
    IR_BNE,
    IR_BLT,
    IR_BGE,
    IR_BLTU,
    IR_BGEU,
    IR_JAL,
    IR_JALR,
    IR_LUI,
    IR_AUIPC,
    IR_ECALL,
    IR_URET,
    IR_CSRRSI,
    IR_CSRRCI
} IrOp;

typedef enum logic [3:0] {
    IR_TYPE_R,
    IR_TYPE_I,
    IR_TYPE_S,
    IR_TYPE_B,
    IR_TYPE_U,
    IR_TYPE_J
} IrType;


typedef struct packed {
    IrOp irOp;
    IrType irType;
    AluOp aluOp;
    logic regWrite;
    logic rs1, rs2;
    logic [2:0] rDinSrc;
    logic aluSrcB;
    logic [1:0] branch;
    logic store, load;
    logic [2:0] ramMode;
} Signal;


`define IR_SIGNAL_NOP '{IR_NOP, IR_TYPE_R, ALU_SLL, 0, 0, 0, 0, 0, 0, 0, 0, 0}
`define IR_MASK_ADD 'hfe00707f
`define IR_CODE_ADD 'h00000033
`define IR_SIGNAL_ADD '{IR_ADD, IR_TYPE_R, ALU_ADD, 1, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_SUB 'hfe00707f
`define IR_CODE_SUB 'h40000033
`define IR_SIGNAL_SUB '{IR_SUB, IR_TYPE_R, ALU_SUB, 1, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_SLL 'hfe00707f
`define IR_CODE_SLL 'h00001033
`define IR_SIGNAL_SLL '{IR_SLL, IR_TYPE_R, ALU_SLL, 1, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_SLT 'hfe00707f
`define IR_CODE_SLT 'h00002033
`define IR_SIGNAL_SLT '{IR_SLT, IR_TYPE_R, ALU_SLT, 1, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_SLTU 'hfe00707f
`define IR_CODE_SLTU 'h00003033
`define IR_SIGNAL_SLTU '{IR_SLTU, IR_TYPE_R, ALU_SLTU, 1, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_XOR 'hfe00707f
`define IR_CODE_XOR 'h00004033
`define IR_SIGNAL_XOR '{IR_XOR, IR_TYPE_R, ALU_XOR, 1, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_SRL 'hfe00707f
`define IR_CODE_SRL 'h00005033
`define IR_SIGNAL_SRL '{IR_SRL, IR_TYPE_R, ALU_SRL, 1, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_SRA 'hfe00707f
`define IR_CODE_SRA 'h40005033
`define IR_SIGNAL_SRA '{IR_SRA, IR_TYPE_R, ALU_SRA, 1, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_OR 'hfe00707f
`define IR_CODE_OR 'h00006033
`define IR_SIGNAL_OR '{IR_OR, IR_TYPE_R, ALU_OR, 1, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_AND 'hfe00707f
`define IR_CODE_AND 'h00007033
`define IR_SIGNAL_AND '{IR_AND, IR_TYPE_R, ALU_AND, 1, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_ADDI 'h0000707f
`define IR_CODE_ADDI 'h00000013
`define IR_SIGNAL_ADDI '{IR_ADDI, IR_TYPE_I, ALU_ADD, 1, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_SLLI 'hfe00707f
`define IR_CODE_SLLI 'h00001013
`define IR_SIGNAL_SLLI '{IR_SLLI, IR_TYPE_I, ALU_SLL, 1, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_SLTI 'h0000707f
`define IR_CODE_SLTI 'h00002013
`define IR_SIGNAL_SLTI '{IR_SLTI, IR_TYPE_I, ALU_SLT, 1, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_SLTIU 'h0000707f
`define IR_CODE_SLTIU 'h00003013
`define IR_SIGNAL_SLTIU '{IR_SLTIU, IR_TYPE_I, ALU_SLTU, 1, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_XORI 'h0000707f
`define IR_CODE_XORI 'h00004013
`define IR_SIGNAL_XORI '{IR_XORI, IR_TYPE_I, ALU_XOR, 1, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_SRLI 'hfe00707f
`define IR_CODE_SRLI 'h00005013
`define IR_SIGNAL_SRLI '{IR_SRLI, IR_TYPE_I, ALU_SRL, 1, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_SRAI 'hfe00707f
`define IR_CODE_SRAI 'h40005013
`define IR_SIGNAL_SRAI '{IR_SRAI, IR_TYPE_I, ALU_SRA, 1, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_ORI 'h0000707f
`define IR_CODE_ORI 'h00006013
`define IR_SIGNAL_ORI '{IR_ORI, IR_TYPE_I, ALU_OR, 1, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_ANDI 'h0000707f
`define IR_CODE_ANDI 'h00007013
`define IR_SIGNAL_ANDI '{IR_ANDI, IR_TYPE_I, ALU_AND, 1, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_SB 'h0000707f
`define IR_CODE_SB 'h00000023
`define IR_SIGNAL_SB '{IR_SB, IR_TYPE_S, ALU_ADD, 0, 1, 1, 0, 1, 0, 1, 0, 0}
`define IR_MASK_SH 'h0000707f
`define IR_CODE_SH 'h00001023
`define IR_SIGNAL_SH '{IR_SH, IR_TYPE_S, ALU_ADD, 0, 1, 1, 0, 1, 0, 1, 0, 1}
`define IR_MASK_SW 'h0000707f
`define IR_CODE_SW 'h00002023
`define IR_SIGNAL_SW '{IR_SW, IR_TYPE_S, ALU_ADD, 0, 1, 1, 0, 1, 0, 1, 0, 2}
`define IR_MASK_LB 'h0000707f
`define IR_CODE_LB 'h00000003
`define IR_SIGNAL_LB '{IR_LB, IR_TYPE_I, ALU_ADD, 1, 1, 0, 2, 1, 0, 0, 1, 0}
`define IR_MASK_LH 'h0000707f
`define IR_CODE_LH 'h00001003
`define IR_SIGNAL_LH '{IR_LH, IR_TYPE_I, ALU_ADD, 1, 1, 0, 2, 1, 0, 0, 1, 1}
`define IR_MASK_LW 'h0000707f
`define IR_CODE_LW 'h00002003
`define IR_SIGNAL_LW '{IR_LW, IR_TYPE_I, ALU_ADD, 1, 1, 0, 2, 1, 0, 0, 1, 2}
`define IR_MASK_LBU 'h0000707f
`define IR_CODE_LBU 'h00004003
`define IR_SIGNAL_LBU '{IR_LBU, IR_TYPE_I, ALU_ADD, 1, 1, 0, 2, 1, 0, 0, 1, 4}
`define IR_MASK_LHU 'h0000707f
`define IR_CODE_LHU 'h00005003
`define IR_SIGNAL_LHU '{IR_LHU, IR_TYPE_I, ALU_ADD, 1, 1, 0, 2, 1, 0, 0, 1, 5}
`define IR_MASK_BEQ 'h0000707f
`define IR_CODE_BEQ 'h00000063
`define IR_SIGNAL_BEQ '{IR_BEQ, IR_TYPE_B, ALU_XOR, 0, 1, 1, 0, 0, 1, 0, 0, 0}
`define IR_MASK_BNE 'h0000707f
`define IR_CODE_BNE 'h00001063
`define IR_SIGNAL_BNE '{IR_BNE, IR_TYPE_B, ALU_XOR, 0, 1, 1, 0, 0, 3, 0, 0, 0}
`define IR_MASK_BLT 'h0000707f
`define IR_CODE_BLT 'h00004063
`define IR_SIGNAL_BLT '{IR_BLT, IR_TYPE_B, ALU_SLT, 0, 1, 1, 0, 0, 3, 0, 0, 0}
`define IR_MASK_BGE 'h0000707f
`define IR_CODE_BGE 'h00005063
`define IR_SIGNAL_BGE '{IR_BGE, IR_TYPE_B, ALU_SLT, 0, 1, 1, 0, 0, 1, 0, 0, 0}
`define IR_MASK_BLTU 'h0000707f
`define IR_CODE_BLTU 'h00006063
`define IR_SIGNAL_BLTU '{IR_BLTU, IR_TYPE_B, ALU_SLTU, 0, 1, 1, 0, 0, 3, 0, 0, 0}
`define IR_MASK_BGEU 'h0000707f
`define IR_CODE_BGEU 'h00007063
`define IR_SIGNAL_BGEU '{IR_BGEU, IR_TYPE_B, ALU_SLTU, 0, 1, 1, 0, 0, 1, 0, 0, 0}
`define IR_MASK_JAL 'h0000007f
`define IR_CODE_JAL 'h0000006f
`define IR_SIGNAL_JAL '{IR_JAL, IR_TYPE_J, ALU_SLL, 1, 0, 0, 3, 0, 0, 0, 0, 0}
`define IR_MASK_JALR 'h0000707f
`define IR_CODE_JALR 'h00000067
`define IR_SIGNAL_JALR '{IR_JALR, IR_TYPE_I, ALU_SLL, 1, 1, 0, 3, 0, 0, 0, 0, 0}
`define IR_MASK_LUI 'h0000007f
`define IR_CODE_LUI 'h00000037
`define IR_SIGNAL_LUI '{IR_LUI, IR_TYPE_U, ALU_SLL, 1, 0, 0, 4, 0, 0, 0, 0, 0}
`define IR_MASK_AUIPC 'h0000007f
`define IR_CODE_AUIPC 'h00000017
`define IR_SIGNAL_AUIPC '{IR_AUIPC, IR_TYPE_U, ALU_SLL, 1, 0, 0, 5, 0, 0, 0, 0, 0}
`define IR_MASK_ECALL 'hffffffff
`define IR_CODE_ECALL 'h00000073
`define IR_SIGNAL_ECALL '{IR_ECALL, IR_TYPE_I, ALU_SLL, 0, 1, 1, 6, 0, 0, 0, 0, 0}
`define IR_MASK_URET 'hffffffff
`define IR_CODE_URET 'h00200073
`define IR_SIGNAL_URET '{IR_URET, IR_TYPE_I, ALU_SLL, 0, 0, 0, 0, 0, 0, 0, 0, 0}
`define IR_MASK_CSRRSI 'h0000707f
`define IR_CODE_CSRRSI 'h00006073
`define IR_SIGNAL_CSRRSI '{IR_CSRRSI, IR_TYPE_I, ALU_SLL, 0, 0, 0, 0, 0, 0, 0, 0, 0}
`define IR_MASK_CSRRCI 'h0000707f
`define IR_CODE_CSRRCI 'h00007073
`define IR_SIGNAL_CSRRCI '{IR_CSRRCI, IR_TYPE_I, ALU_SLL, 0, 0, 0, 0, 0, 0, 0, 0, 0}
