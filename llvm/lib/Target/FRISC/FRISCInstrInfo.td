//===-- FRISCInstrInfo.td - Target Description for FRISC ---*- tabFRISCen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes the FRISC instructions in TableGen format.
//
//===----------------------------------------------------------------------===//

include "FRISCInstrFormats.td"

//===----------------------------------------------------------------------===//
// Type Profiles
//===----------------------------------------------------------------------===//

// Ensure the two operands of compare are of the same type
def SDT_FRISCCmp        : SDTypeProfile<0, 2, [SDTCisSameAs<0, 1>]>;
def SDT_FRISCBrCC       : SDTypeProfile<0, 2, [SDTCisVT<0, OtherVT>,
                                               SDTCisVT<1, i32>]>;
def SDT_FRISCSelectCC   : SDTypeProfile<1, 3, [SDTCisSameAs<0, 1>,
                                               SDTCisSameAs<1, 2>,
                                               SDTCisVT<3, i32>]>;
def SDT_FRISCWrapper    : SDTypeProfile<1, 1, [SDTCisSameAs<0, 1>,
                                               SDTCisPtrTy<0>]>;
def SDT_FRISCCall         : SDTypeProfile<0, -1, [SDTCisVT<0, iPTR>]>;
def SDT_FRISCCallSeqStart : SDCallSeqStart<[SDTCisVT<0, i32>, SDTCisVT<1, i32>]>;
def SDT_FRISCCallSeqEnd   : SDCallSeqEnd<[SDTCisVT<0, i32>, SDTCisVT<1, i32>]>;

//===----------------------------------------------------------------------===//
// FRISC-specific node definitions
//===----------------------------------------------------------------------===//

def FRISCretFlag : SDNode<"FRISCISD::RET_FLAG", SDTNone,
                     [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;
def FRISCcmp     : SDNode<"FRISCISD::CMP", SDT_FRISCCmp, [SDNPOutGlue]>;
def FRISCbrcc    : SDNode<"FRISCISD::BR_CC", SDT_FRISCBrCC, [SDNPHasChain, SDNPInGlue]>;
def FRISCSelectCC: SDNode<"FRISCISD::SELECT_CC", SDT_FRISCSelectCC, [SDNPInGlue]>;
def FRISCWrapper : SDNode<"FRISCISD::Wrapper", SDT_FRISCWrapper>;
def FRISCcall    : SDNode<"FRISCISD::CALL", SDT_FRISCCall,
                          [SDNPHasChain, SDNPOutGlue, SDNPOptInGlue, SDNPVariadic]>;
def FRISCcallseq_start : SDNode<"ISD::CALLSEQ_START", SDT_FRISCCallSeqStart,
                                [SDNPHasChain, SDNPOutGlue]>;
def FRISCcallseq_end   : SDNode<"ISD::CALLSEQ_END", SDT_FRISCCallSeqEnd,
                                [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue]>;

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

// ALU operations

defm OR   : ALUInst<OPC_OR, "OR", or>;
defm AND  : ALUInst<OPC_AND, "AND", and>;
defm XOR  : ALUInst<OPC_XOR, "XOR", xor>;

let isAdd = 1 in {
    defm ADD  : ALUInst<OPC_ADD, "ADD", add>;
}

defm ADC  : ALUInst<OPC_ADC, "ADC", addc>;
defm SUB  : ALUInst<OPC_SUB, "SUB", sub>;
defm SBC  : ALUInst<OPC_SBC, "SBC", subc>;
defm ROTL : ALUInst<OPC_ROTL, "ROTL", rotl>;
defm ROTR : ALUInst<OPC_ROTR, "ROTR", rotr>;
defm SHL  : ALUInst<OPC_SHL, "SHL", shl>;
defm SHR  : ALUInst<OPC_SHR, "SHR", srl>;
defm ASHR : ALUInst<OPC_ASHR, "ASHR", sra>;

let isCompare = 1 in {
    defm CMP  : ALUInst2<OPC_CMP, "CMP", FRISCcmp>;
}

/*let usesCustomInserter = 1, Defs = [SR], Constraints = "$dst = $src1" in {
    def MUL_rr : FRISCPseudo<(outs MDPseudoR0:$dst),  (ins MDPseudoR0:$src1, MDPseudoR1:$src2), "# MUL", [(set i32:$dst, (mul i32:$src1, i32:$src2)), (implicit SR)]>;
    def UDIV_rr : FRISCPseudo<(outs MDPseudoR0:$dst),  (ins MDPseudoR0:$src1, MDPseudoR1:$src2), "# UDIV", [(set i32:$dst, (udiv i32:$src1, i32:$src2)), (implicit SR)]>;
    def SDIV_rr : FRISCPseudo<(outs MDPseudoR0:$dst),  (ins MDPseudoR0:$src1, MDPseudoR1:$src2), "# SDIV", [(set i32:$dst, (sdiv i32:$src1, i32:$src2)), (implicit SR)]>;
}*/

let Defs = [SR] in {
    def MUL_rr : FRISCPseudo<(outs GPR:$dst), (ins GPR:$src1, GPR:$src2), "; MUL $dst, $src1, $src2",
                             [(set i32:$dst, (mul i32:$src1, i32:$src2)), (implicit SR)]>;
    def SDIV_rr : FRISCPseudo<(outs GPR:$dst), (ins GPR:$src1, GPR:$src2), "; SDIV $dst, $src1, $src2",
                             [(set i32:$dst, (sdiv i32:$src1, i32:$src2)), (implicit SR)]>;
    def UDIV_rr : FRISCPseudo<(outs GPR:$dst), (ins GPR:$src1, GPR:$src2), "; UDIV $dst, $src1, $src2",
                             [(set i32:$dst, (udiv i32:$src1, i32:$src2)), (implicit SR)]>;
}

// Memory operations

let mayLoad = 1 in {
  def LOADB_ri : MemInst_ri<OPC_LOAD, "LOADB", (outs GPR:$dst), (ins MemSrc:$addr),
                            [(set GPR:$dst, (zextloadi8 addr:$addr))]>;
  def LOADH_ri : MemInst_ri<OPC_LOAD, "LOADH", (outs GPR:$dst), (ins MemSrc:$addr),
                            [(set GPR:$dst, (zextloadi16 addr:$addr))]>;
  def LOAD_ri : MemInst_ri<OPC_LOAD, "LOAD", (outs GPR:$dst), (ins MemSrc:$addr),
                           [(set GPR:$dst, (load addr:$addr))]>;
  //def LOAD_i  : MemInst_i<OPC_LOAD, "LOAD", (outs GPR:$dst), (ins Imm20:$addr), [(set GPR:$dst, (load addr:$addr))]>;
}

let mayStore = 1 in {
  def STOREB_ri: MemInst_ri<OPC_STORE, "STOREB", (outs), (ins MemSrc:$addr, GPR:$dst),
                            [(truncstorei8 GPR:$dst, addr:$addr)]>;
  def STOREH_ri: MemInst_ri<OPC_STORE, "STOREH", (outs), (ins MemSrc:$addr, GPR:$dst),
                            [(truncstorei16 GPR:$dst, addr:$addr)]>;
  def STORE_ri: MemInst_ri<OPC_STORE, "STORE", (outs), (ins MemSrc:$addr, GPR:$dst),
                           [(store GPR:$dst, addr:$addr)]>;
  //def STORE_i : MemInst_i<OPC_STORE, "STORE", (outs), (ins GPR:$dst, Imm20:$addr), [(store GPR:$dst, addr:$addr)]>;
}



def PUSH    : StackInst<OPC_PUSH, "PUSH", (outs), (ins GPR:$reg), []>;
def POP     : StackInst<OPC_POP, "POP", (outs GPR:$reg), (ins), []>;

// Control operations

let isBranch = 1, isTerminator = 1, isBarrier = 1 in {
    def JP_i    : CtrlInst_i<OPC_JP, (outs), (ins JMPTarget:$addr), "JP\t$addr", [(br bb:$addr)]>;
}

/*let isBranch = 1, isIndirectBranch = 1, isTerminator = 1, isBarrier = 1 in {
    //def JR_i     : CtrlInst<OPC_JR, "JR", brind>;
}*/

let isBranch = 1, isTerminator = 1, Uses = [SR] in {
    def JPcc_i    : CtrlInst_i<OPC_JP, (outs), (ins JMPTarget:$addr, CondCode:$cc), "JP_$cc\t$addr", [(FRISCbrcc bb:$addr, imm:$cc)]>;
}

let isCall = 1, Uses = [SP] in {
    def CALL_i  : CtrlInst_i<OPC_CALL, (outs), (ins Imm20:$addr), "CALL\t$addr", [(FRISCcall imm:$addr)]>;
}

// Return/Halt operations

let isTerminator = 1, isReturn = 1, isBarrier = 1, Uses = [SP] in {
    defm RET    : RetInst<OPC_RET, "RET", 0b00, [(FRISCretFlag)]>;
    defm RETI    : RetInst<OPC_RET, "RET", 0b01, []>;
    defm RETN    : RetInst<OPC_RET, "RET", 0b11, []>;
}

let isTerminator = 1 in {
    defm HALT   : RetInst<OPC_HALT, "HALT", 0b00, []>;
}

// Move operations

let isAsCheapAsAMove = 1 in {
    def MOVE_rr : FRISCInst<OPC_MOVE, (outs GPR:$dst), (ins GPR:$src), "MOVE\t$src, $dst", []> {
        bits<3> dst;
        bits<3> src;
        let Modifier = 0;
        let Inst{25-23} = dst;
        let Inst{22-20} = 0;
        let Inst{19-17} = src;
    }

    def MOVE_ri : FRISCInst<OPC_MOVE, (outs GPR:$dst), (ins Imm20:$src), "MOVE\t$src, $dst", [(set GPR:$dst, imm:$src)]> {
        let isMoveImm = 1;

        bits<3> dst;
        bits<20> src;
        let Modifier = 1;
        let Inst{25-23} = dst;
        let Inst{22-20} = 0;
        let Inst{19-0} = src;
    }
}

//===----------------------------------------------------------------------===//
// Pseudo instructions
//===----------------------------------------------------------------------===//

let Defs = [SP], Uses = [SP] in {
    def ADJCALLSTACKDOWN : FRISCPseudo<(outs), (ins i32imm:$amt1, i32imm:$amt2),
                                       "# ADJCALLSTACKDOWN $amt1, $amt2",
                                       [(FRISCcallseq_start timm:$amt1, timm:$amt2)]>;
    def ADJCALLSTACKUP : FRISCPseudo<(outs), (ins i32imm:$amt1, i32imm:$amt2),
                                     "# ADJCALLSTACKUP, $amt1",
                                     [(FRISCcallseq_end timm:$amt1, timm:$amt2)]>;
}

//===----------------------------------------------------------------------===//
// Non-Instruction Patterns
//===----------------------------------------------------------------------===//

let usesCustomInserter = 1 in
def Select : FRISCPseudo<(outs GPR:$dst),
                         (ins GPR:$src, GPR:$src2, i32imm:$condition),
                         "# Select PSEUDO",
                         [(set GPR:$dst,
                          (FRISCSelectCC i32:$src, i32:$src2, imm:$condition))]>;

// GlobalAddress, ExternalSymbol
def : Pat<(i32 (FRISCWrapper tglobaladdr:$dst)), (MOVE_ri tglobaladdr:$dst)>;
def : Pat<(i32 (FRISCWrapper texternalsym:$dst)), (MOVE_ri texternalsym:$dst)>;

def : Pat<(add GPR:$src, (FRISCWrapper tglobaladdr:$src2)),
          (ADD_ri GPR:$src, tglobaladdr:$src2)>;
def : Pat<(add GPR:$src, (FRISCWrapper texternalsym:$src2)),
          (ADD_ri GPR:$src, texternalsym:$src2)>;

def : Pat<(store (i32 (FRISCWrapper tglobaladdr:$src)), addr:$dst),
          (STORE_ri addr:$dst, tglobaladdr:$src)>;
def : Pat<(store (i32 (FRISCWrapper texternalsym:$src)), addr:$dst),
          (STORE_ri addr:$dst, texternalsym:$src)>;

// Calls
def : Pat<(FRISCcall (i32 tglobaladdr:$addr)),
          (CALL_i tglobaladdr:$addr)>;
def : Pat<(FRISCcall (i32 texternalsym:$addr)),
          (CALL_i texternalsym:$addr)>;
