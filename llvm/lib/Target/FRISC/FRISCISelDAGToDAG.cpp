//===-- FRISCISelDAGToDAG.cpp - A dag to dag inst selector for FRISC ----------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines an instruction selector for the FRISC target.
//
//===----------------------------------------------------------------------===//

#include "FRISC.h"
#include "FRISCTargetMachine.h"
#include "MCTargetDesc/FRISCMCTargetDesc.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/IR/Function.h" // To access function attributes.
#include "llvm/Support/Debug.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "frisc-isel"

// FRISC-specific code to select FRISC machine instructions for
// SelectionDAG operations.
namespace {
class FRISCDAGToDAGISel : public SelectionDAGISel {

public:
    explicit FRISCDAGToDAGISel(FRISCTargetMachine &TM, CodeGenOpt::Level OptLevel)
        : SelectionDAGISel(TM, OptLevel) {}
    StringRef getPassName() const override
        { return "FRISC DAG->DAG Pattern Instruction Selection"; }
    void Select(SDNode *Node) override;
    bool SelectAddr(SDValue Addr, SDValue &BaseAddr, SDValue &Offset);

// Include the pieces autogenerated from the target description.
#include "FRISCGenDAGISel.inc"
};
} // end anonymous namespace

void FRISCDAGToDAGISel::Select(SDNode *Node) {
    // Dump information about the Node being selected.
    DEBUG(errs() << "Selecting: "; Node->dump(CurDAG); errs() << "\n");

    // If we have a custom node, we have already selected
    if (Node->isMachineOpcode()) {
        DEBUG(errs() << "== "; Node->dump(CurDAG); errs() << "\n");
        Node->setNodeId(-1);
        return;
    }

    SDLoc dl(Node);

    // Few custom selection stuff.
    switch (Node->getOpcode()) {
        default: break;
        case ISD::FrameIndex: {
            assert(Node->getValueType(0) == MVT::i32);
            int FI = cast<FrameIndexSDNode>(Node)->getIndex();
            SDValue TFI = CurDAG->getTargetFrameIndex(FI, MVT::i32);

            if (Node->hasOneUse())
                CurDAG->SelectNodeTo(Node, FRISC::ADD_ri, MVT::i32, TFI,
                    CurDAG->getTargetConstant(0, dl, MVT::i32));
            else
                ReplaceNode(Node, CurDAG->getMachineNode(FRISC::ADD_ri, dl, MVT::i32, TFI,
                    CurDAG->getTargetConstant(0, dl, MVT::i32)));

            return;
        }
        /*case ISD::Constant: {
            uint64_t ImmVal = (cast<ConstantSDNode>(Node))->getZExtValue();
            uint64_t SupportedMask = 0xfffffffff;

            if (isInt<20>(ImmVal) || ImmVal(ImmVal & SupportedMask) != ImmVal) {
                DEBUG(errs() << "Not an Move_ri32"; errs() << "\n");
                break;  // leave the switch-case
            }

            // Split the constant into two 16-bit parts
            uint64_t LoMask = 0xffff, HiMask = 0xffff0000;

            SDValue Const16 = CurDag->getTargetConstant(16, dl, MVT::i32);
            SDValue ConstLo = CurDAG->getTargetConstant((ImmVal & LoMask), dl, MVT::i32);
            SDValue ConstHi = CurDag->getTargetConstant((ImmVal & HiMask) >> 16, dl, MVT::i32);

            MachineSDNode *New = CurDAG->getMachineNode(FRISC::MOVE_ri, dl, MVT::i32, ConstHi);
            New = CurDag->getMachineNode(FRISC::SHL_ri, dl, MVT::i32, SDValue(New, 0), Const16);
            New = CurDag->getMachineNode(FRISC::ADD_ri, dl, MVT::i32, SDValue(New, 0), ConstLo);

            ReplaceNode(Node, New);
        }*/
    }

    // Select the default instruction.
    SelectCode(Node);
}

/// SelectAddr - returns true if it is able pattern match an addressing mode.
/// It returns the operands which make up the maximal addressing mode it can
/// match by reference.
bool FRISCDAGToDAGISel::SelectAddr(SDValue Addr, SDValue &BaseAddr, SDValue &Offset) {
    if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(Addr)) {
        EVT PtrVT = getTargetLowering()->getPointerTy(CurDAG->getDataLayout());
        BaseAddr = CurDAG->getTargetFrameIndex(FIN->getIndex(), PtrVT);
        Offset = CurDAG->getTargetConstant(0, Addr, MVT::i32);
        return true;
    }
    else {
        BaseAddr = Addr;
    }

    if (Addr.getOpcode() == ISD::TargetExternalSymbol ||
        Addr.getOpcode() == ISD::TargetGlobalAddress ||
        Addr.getOpcode() == ISD::TargetGlobalTLSAddress) {
            return false; // direct calls.
    }

    if (CurDAG->isBaseWithConstantOffset(Addr)) {
        ConstantSDNode *CN = dyn_cast<ConstantSDNode>(Addr.getOperand(1));
        Offset = CurDAG->getTargetConstant(CN->getZExtValue(), Addr, MVT::i32);
    } else {
        Offset = CurDAG->getTargetConstant(0, Addr, MVT::i32);
    }

    return true;
}

/// createFRISCISelDag - This pass converts a legalized DAG into a FRISC-specific DAG
FunctionPass *llvm::createFRISCISelDag(FRISCTargetMachine &TM, CodeGenOpt::Level OptLevel) {
    return new FRISCDAGToDAGISel(TM, OptLevel);
}
