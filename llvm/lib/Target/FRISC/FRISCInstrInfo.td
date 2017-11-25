//===-- FRISCInstrInfo.td - Target Description for FRISC ---*- tabFRISCen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file describes the FRISC instructions in TabFRISCen format.
//
//===----------------------------------------------------------------------===//

include "FRISCInstrFormats.td"

// ALU operations

defm OR   : ALUInst<OPC_OR, "OR", or>;
defm AND  : ALUInst<OPC_AND, "AND", and>;
defm XOR  : ALUInst<OPC_XOR, "XOR", xor>;
defm ADD  : ALUInst<OPC_ADD, "ADD", add>;
defm ADC  : ALUInst<OPC_ADC, "ADC", addc>;
defm SUB  : ALUInst<OPC_SUB, "SUB", sub>;
defm SBC  : ALUInst<OPC_SBC, "SBC", subc>;
defm ROTL : ALUInst<OPC_ROTL, "ROTL", rotl>;
defm ROTR : ALUInst<OPC_ROTR, "ROTR", rotr>;
defm SHL  : ALUInst<OPC_SHL, "SHL", shl>;
defm SHR  : ALUInst<OPC_SHR, "SHR", srl>;
defm ASHR : ALUInst<OPC_ASHR, "ASHR", sra>;

defm MUL  : ALUInst<OPC_MUL, "MUL", mul>;

defm CMP  : ALUInst2<OPC_CMP, "CMP", []>;

// Memory operations

defm LOAD : MemInst<OPC_LOAD, "LOAD", (outs GPR:$dst), (ins MemSrc:$addr), [(set GPRegs:$dst, (load addr:$addr))]>;
defm STORE: MemInst<OPC_STORE, "STORE", (outs), (ins GPR:$dst, Imm20:$addr), [(store GPR:$dst, addr:$addr)]>;

def PUSH  : StackInst<OPC_PUSH, "PUSH", (outs), (ins GPR:$reg), []>;
def POP   : StackInst<OPC_POP, "POP", (outs GPR:$reg), (ins), []>;

// Control operations

defm JP   :
defm JR   :
defm CALL :
defm RET  :
defm HALT :
