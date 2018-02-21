//===-- FRISCISelLowering.h - FRISC DAG Lowering Interface ----------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the interfaces that FRISC uses to lower LLVM code into a
// selection DAG.
//
//===----------------------------------------------------------------------===//

#ifndef FRISCISELLOWERING_H
#define FRISCISELLOWERING_H

#include "FRISC.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/Target/TargetLowering.h"

namespace llvm {

class FRISCSubtarget;
class FRISCTargetMachine;

namespace FRISCISD {
enum NodeType {
    FIRST_NUMBER = ISD::BUILTIN_OP_END,    
    RET_FLAG,       // Return with a flag operand. Operand 0 is the chain operand
    CMP,            // The compare instruction    
    BR_CC,          // Branch conditional, condition-code    
    SELECT_CC,      // Select the condition code    
    Wrapper,        // Wrapper - A wrapper node for TargetConstantPool, TargetExternalSymbol, and TargetGlobalAddress
    CALL            // CALL - Abstract call instruction, which includes a bunch of information.
};
}

//===----------------------------------------------------------------------===//
// TargetLowering Implementation
//===----------------------------------------------------------------------===//

class FRISCTargetLowering : public TargetLowering {
public:
    explicit FRISCTargetLowering(const FRISCTargetMachine &TM, const FRISCSubtarget &STI);

  // Provide custom lowering hooks for some operations.
  virtual SDValue LowerOperation(SDValue Op, SelectionDAG &DAG) const override;

  SDValue LowerBR_CC(SDValue Op, SelectionDAG &DAG) const;
  SDValue LowerSELECT_CC(SDValue Op, SelectionDAG &DAG) const;
  SDValue LowerGlobalAddress(SDValue Op, SelectionDAG &DAG) const;
  SDValue LowerExternalSymbol(SDValue Op, SelectionDAG &DAG) const;

  // This method returns the name of a target specific DAG node.
  virtual const char *getTargetNodeName(unsigned Opcode) const override;

  MachineBasicBlock* EmitInstrWithCustomInserter(MachineInstr &MI, MachineBasicBlock *BB) const override;

private:
    // Lower incoming arguments, copy physregs into vregs
    SDValue LowerFormalArguments(SDValue Chain, CallingConv::ID CallConv, bool IsVarArg,
        const SmallVectorImpl<ISD::InputArg> &Ins, const SDLoc &DL, SelectionDAG &DAG,
        SmallVectorImpl<SDValue> &InVals) const override;

    SDValue LowerCall(TargetLowering::CallLoweringInfo &CLI, SmallVectorImpl<SDValue> &InVals) const override;

    SDValue LowerReturn(SDValue Chain, CallingConv::ID CallConv, bool IsVarArg,
        const SmallVectorImpl<ISD::OutputArg> &Outs, const SmallVectorImpl<SDValue> &OutVals,
        const SDLoc &DL, SelectionDAG &DAG) const override;

    SDValue LowerCallResult(SDValue Chain, SDValue InFlag, CallingConv::ID CallConv, bool isVarArg,
        const SmallVectorImpl<ISD::InputArg> &Ins, const SDLoc &dl, SelectionDAG &DAG,
        SmallVectorImpl<SDValue> &InVals) const;

    bool shouldConvertConstantLoadToIntImm(const APInt &Imm, Type *Ty) const override
        { return true; }
};
}

#endif