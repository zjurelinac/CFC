class FRISCOpcode<bits<5> val> {
    bits<7> Value = val;
}

def OPC_OR     : FRISCOpcode<0b00001>;
def OPC_AND    : FRISCOpcode<0b00010>;
def OPC_XOR    : FRISCOpcode<0b00011>;
def OPC_ADD    : FRISCOpcode<0b00100>;
def OPC_ADC    : FRISCOpcode<0b00101>;
def OPC_SUB    : FRISCOpcode<0b00110>;
def OPC_SBC    : FRISCOpcode<0b00111>;
def OPC_ROTL   : FRISCOpcode<0b01000>;
def OPC_ROTR   : FRISCOpcode<0b01001>;
def OPC_SHL    : FRISCOpcode<0b01010>;
def OPC_SHR    : FRISCOpcode<0b01011>;
def OPC_ASHR   : FRISCOpcode<0b01100>;
def OPC_CMP    : FRISCOpcode<0b01101>;
// Extras
def OPC_MUL    : FRISCOpcode<0b01110>;

// def OPC_POP    : FRISCOpcode<0b10000>;
// def OPC_PUSH   : FRISCOpcode<0b10001>;
def OPC_LOADB  : FRISCOpcode<0b10010>;
def OPC_STOREB : FRISCOpcode<0b10011>;
def OPC_LOADH  : FRISCOpcode<0b10100>;
def OPC_STOREH : FRISCOpcode<0b10101>;
def OPC_LOAD   : FRISCOpcode<0b10110>;
def OPC_STORE  : FRISCOpcode<0b10111>;

def OPC_JP     : FRISCOpcode<0b11000>;
def OPC_JR     : FRISCOpcode<0b11010>;
def OPC_CALL   : FRISCOpcode<0b11001>;
def OPC_RET    : FRISCOpcode<0b11011>;

def OPC_MOVE   : FRISCOpcode<0b00000>;


// Base FRISC Instruction class
class FRISCInst<FRISCOpcode opcode, dag outs, dag ins, string asmstr, list<dag> pattern>
    : Instruction {
    field bits<32> Inst;

    // Opcode size and location
    bits<5> Opcode = opcode.Value;
    let Inst{31-27} = Opcode;

    // Instruction format modifier size and location
    bit Modifier = 0;
    let Inst{26} = Modifier;

    let Namespace = "FRISC";

    dag OutOperandList = outs;
    dag InOperandList = ins;
    let AsmString = asmstr;
    let Pattern = pattern;
    let Size = 4;
}

// FRISC pseudoinstruction, not mapped to final assembly/machine code
class FRISCPseudo<dag outs, dag ins, string asmstr, list<dag> pattern>
        : FRISCInst<0, dag outs, dag ins, string asmstr, list<dag> pattern> {
    let isPseudo = 1;
    let isCodeGenOnly = 1;
}

// Custom data types
def Imm20 : Operand<i32>, ImmLeaf<i32, [{ return Imm >= -524288 && Imm <= 524287;}]>

def CondCode : Operand<i32> { let printMethod = "printCondCode"; }

def MemSrc : Operand<i32> {
    let MIOperandInfo = (ops GPR, Imm20);
    let PrintMethod = "printAddrModeMemSrc";
    let EncoderMethod = "getMemSrcValue";
}

def addr : ComplexPattern<iPTR, 2, "SelectAddr", [], []>;

// ALU instructions
let Defs = [SR] in {
    multiclass ALUInst<FRISCOpcode opcode, string opstr, SDNode opnode> {
        def _rr : FRISCInst<opcode, (outs GPR:$dst), (ins GPR:$src1, GPR:$src2),
                            !strconcat(opstr, "\t$dst, $src1, $src2"), [(set i32:$dst, (opnode i32:$src1, i32:$src2))]>{
            bits<3> dst;
            bits<3> src1;
            bits<3> src2;

            let Modifier = 0;
            let Inst{25-23} = dst;
            let Inst{22-20} = src1;
            let Inst{19-17} = src2;
            let Inst{16-0} = 0;
        }
        def _ri : FRISCInst<opcode, (outs GPR:$dst), (ins GPR:$src1, Imm20:$src2),
                            !strconcat(opstr, "\t$dst, $src1, $src2"), [(set i32:$dst, (opnode i32:$src1, i32:$src2))]>{
            bits<3> dst;
            bits<3> src1;
            bits<3> src2;

            let Modifier = 1;
            let Inst{25-23} = dst;
            let Inst{22-20} = src1;
            let Inst{19-0} = src2;
        }
    }

    multiclass ALUInst2<FRISCOpcode opcode, string opstr, SDNode opnode> {
        def _rr : FRISCInst<opcode, (outs), (ins GPR:$src1, GPR:$src2),
                            !strconcat(opstr, "\t$dst, $src1, $src2"), [(set i32:$dst, (opnode i32:$src1, i32:$src2))]>{
            bits<3> src1;
            bits<3> src2;

            let Modifier = 0;
            let Inst{25-23} = 0;
            let Inst{22-20} = src1;
            let Inst{19-17} = src2;
            let Inst{16-0} = 0;
        }
        def _ri : FRISCInst<opcode, (outs), (ins GPR:$src1, Imm20:$src2),
                            !strconcat(opstr, "\t $dst, $src1, $src2"), [(set i32:$dst, (opnode i32:$src1, i32:$src2))]>{
            bits<3> src1;
            bits<3> src2;

            let Modifier = 1;
            let Inst{25-23} = dst;
            let Inst{22-20} = src1;
            let Inst{19-0} = src2;
        }
    }
}

// Stack instructions
class StackInst<bits<5> opcode, string opstr, dag outs, dag ins, list<dag> pattern>
        : FRISCInst<opcode, outs, ins, !strconcat(opstr, "\t$reg"), pattern> {
    bits<3> reg;
    let Defs = [SP];
    let hasSideEffects = 0;
    let Inst{25-23} = reg;
}

// Memory instructions
multiclass MemInst<FRISCOpcode opcode, string opstr, dag outs, dag ins, list<dag> pattern> {
    def _ri : FRISCInst<opcode, outs, ins,
                        !strconcat(opstr, "\t$dst, $addr"), pattern> {
        bits<23> addr;
        let Modifier = 1;
        let Inst{22-0} = addr;
    }
    def _i : FRISCInst<opcode, (outs GPR:$dst), (ins Imm20:$addr),
                        !strconcat(opstr, "\t$dst, ($addr)"), pattern> {
        bits<20> addr;
        let Modifier = 0;
        let Inst{22-20} = 0;
        let Inst{19-0} = addr;
    }
}

// Control instructions
multiclass CtrlInst<FRISCOpcode opcode, string opstr, dag outs, dag ins, list<dag> pattern, bits<4> cond> {
    def _r : FRISCInst<opcode, outs, ins, !strconcat(opstr, "\t($addr)"), pattern> {
        bits<3> addr;
        bits<4> cond;
        let Modifier = 1;
        Inst{25-22} = cond;
        Inst{19-17} = addr;
        Inst{16-0} = 0;
    }
    def _i : FRISCInst<opcode, outs, ins, !strconcat(opstr, "\t$addr"), pattern> {
        bits<20> addr;
        bits<4> cond;
        let Modifier = 1;
        Inst{25-22} = cond;
        Inst{19-0} = addr;
}
