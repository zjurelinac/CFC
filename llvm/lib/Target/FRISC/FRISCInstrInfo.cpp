//===-- FRISCInstrInfo.cpp - FRISC Instruction Information ----------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the FRISC implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#include "FRISCInstrInfo.h"
#include "FRISC.h"
#include "FRISCSubtarget.h"
#include "FRISCTargetMachine.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"

#define GET_INSTRINFO_CTOR_DTOR
#include "FRISCGenInstrInfo.inc"

using namespace llvm;

// Pin the vtable to this file.
void FRISCInstrInfo::anchor() {}

FRISCInstrInfo::FRISCInstrInfo() : FRISCGenInstrInfo(), RI() {}

void FRISCInstrInfo::copyPhysReg(MachineBasicBlock &MBB,
                                  MachineBasicBlock::iterator I,
                                  const DebugLoc &DL, unsigned DestReg,
                                  unsigned SrcReg, bool KillSrc) const {

  if (FRISC::GPRRegClass.contains(DestReg, SrcReg)) {
      BuildMI(MBB, I, DL, get(FRISC::MOVE_rr), DestReg)
        .addReg(SrcReg, getKillRegState(KillSrc));
  }
  else {
    llvm_unreachable("Impossible reg-to-reg copy");
  }
}

void FRISCInstrInfo::storeRegToStackSlot(MachineBasicBlock &MBB,
                                       MachineBasicBlock::iterator MI,
                                       unsigned SrcReg, bool isKill,
                                       int FrameIdx,
                                       const TargetRegisterClass *RC,
                                       const TargetRegisterInfo *TRI) const {
  DebugLoc DL;
  if (MI != MBB.end()) DL = MI->getDebugLoc();
  //MachineFunction &MF = *MBB.getParent();
  //MachineFrameInfo &MFI = MF.getFrameInfo();

  BuildMI(MBB, MI, DL, get(FRISC::PUSH))
    .addReg(SrcReg, getKillRegState(isKill));
}

void FRISCInstrInfo::loadRegFromStackSlot(MachineBasicBlock &MBB,
                                        MachineBasicBlock::iterator MI,
                                        unsigned DestReg, int FrameIdx,
                                        const TargetRegisterClass *RC,
                                        const TargetRegisterInfo *TRI) const{
  DebugLoc DL;
  if (MI != MBB.end()) DL = MI->getDebugLoc();
  //MachineFunction &MF = *MBB.getParent();
  //MachineFrameInfo &MFI = MF.getFrameInfo();

  BuildMI(MBB, MI, DL, get(FRISC::POP))
    .addReg(DestReg, getDefRegState(true));
}

bool FRISCInstrInfo::
reverseBranchCondition(SmallVectorImpl<MachineOperand> &Cond) const {
  assert(Cond.size() == 1 && "Invalid Xbranch condition!");

  FRISCCC::CondCodes CC = static_cast<FRISCCC::CondCodes>(Cond[0].getImm());

  switch (CC) {
  default: llvm_unreachable("Invalid branch condition!");

  case FRISCCC::COND_C:
    CC = FRISCCC::COND_NC;
    break;
  case FRISCCC::COND_N:
    CC = FRISCCC::COND_NN;
    break;
  case FRISCCC::COND_V:
    CC = FRISCCC::COND_NV;
    break;
  case FRISCCC::COND_Z:
    CC = FRISCCC::COND_NZ;
    break;
  /*case FRISCCC::COND_UGE:
    CC = FRISCCC::COND_ULT;
    break;*/
  case FRISCCC::COND_SGE:
    CC = FRISCCC::COND_SLT;
    break;
  case FRISCCC::COND_NC:
    CC = FRISCCC::COND_C;
    break;
  case FRISCCC::COND_NN:
    CC = FRISCCC::COND_N;
    break;
  case FRISCCC::COND_NV:
    CC = FRISCCC::COND_V;
    break;
  case FRISCCC::COND_NZ:
    CC = FRISCCC::COND_Z;
    break;
  /*case FRISCCC::COND_EQ:
    CC = FRISCCC::COND_NE;
    break;*/
  /*case FRISCCC::COND_NE:
    CC = FRISCCC::COND_EQ;
    break;*/
  /*case FRISCCC::COND_ULT:
    CC = FRISCCC::COND_UGE;
    break;*/
  case FRISCCC::COND_SLT:
    CC = FRISCCC::COND_SGE;
    break;
  case FRISCCC::COND_ULE:
    CC = FRISCCC::COND_UGT;
    break;
  case FRISCCC::COND_UGT:
    CC = FRISCCC::COND_ULE;
    break;
  case FRISCCC::COND_SLE:
    CC = FRISCCC::COND_SGT;
    break;
  case FRISCCC::COND_SGT:
    CC = FRISCCC::COND_SLE;
    break;
  /*case FRISCCC::COND_M:
    CC = FRISCCC::COND_P;
    break;*/
  /*case FRISCCC::COND_P:
    CC = FRISCCC::COND_M;
    break;*/
  }

  Cond[0].setImm(CC);
  return false;
}

bool FRISCInstrInfo::isUnpredicatedTerminator(const MachineInstr &MI) const {
  if (!MI.isTerminator())
    return false;

  // Conditional branch is a special case.
  if (MI.isBranch() && !MI.isBarrier())
    return true;
  if (!MI.isPredicable())
    return true;
  return !isPredicated(MI);
}

bool FRISCInstrInfo::analyzeBranch(MachineBasicBlock &MBB,
                                 MachineBasicBlock *&TBB,
                                 MachineBasicBlock *&FBB,
                                 SmallVectorImpl<MachineOperand> &Cond,
                                 bool AllowModify) const {
  // Start from the bottom of the block and work up, examining the
  // terminator instructions.
  MachineBasicBlock::iterator I = MBB.end();
  while (I != MBB.begin()) {
    --I;
    if (I->isDebugValue())
      continue;

    // Working from the bottom, when we see a non-terminator
    // instruction, we're done.
    if (!isUnpredicatedTerminator(*I))
      break;

    // A terminator that isn't a branch can't easily be handled
    // by this analysis.
    if (!I->isBranch())
      return true;

    // Handle unconditional branches.     // TODO: Detect unconditional branches - JP_i, JR_i, JP_r, JR_r
    if (I->getOpcode() == FRISC::JP_i) {
      if (!AllowModify) {
        TBB = I->getOperand(0).getMBB();
        continue;
      }

      // If the block has any instructions after a JP/JR, delete them.
      while (std::next(I) != MBB.end())
        std::next(I)->eraseFromParent();
      Cond.clear();
      FBB = nullptr;

      // Delete the JP/JR if it's equivalent to a fall-through.
      if (MBB.isLayoutSuccessor(I->getOperand(0).getMBB())) {
        TBB = nullptr;
        I->eraseFromParent();
        I = MBB.end();
        continue;
      }

      // TBB is used to indicate the unconditinal destination.
      TBB = I->getOperand(0).getMBB();
      continue;
    }

    // Handle conditional branches.
    assert((I->getOpcode() == FRISC::JPcc_i) && "Invalid conditional branch");
    FRISCCC::CondCodes BranchCode =
      static_cast<FRISCCC::CondCodes>(I->getOperand(1).getImm());
    if (BranchCode == FRISCCC::COND_INVALID)
      return true;  // Can't handle weird stuff.

    // Working from the bottom, handle the first conditional branch.
    if (Cond.empty()) {
      FBB = TBB;
      TBB = I->getOperand(0).getMBB();
      Cond.push_back(MachineOperand::CreateImm(BranchCode));
      continue;
    }

    // Handle subsequent conditional branches. Only handle the case where all
    // conditional branches branch to the same destination.
    assert(Cond.size() == 1);
    assert(TBB);

    // Only handle the case where all conditional branches branch to
    // the same destination.
    if (TBB != I->getOperand(0).getMBB())
      return true;

    FRISCCC::CondCodes OldBranchCode = (FRISCCC::CondCodes)Cond[0].getImm();
    // If the conditions are the same, we can leave them alone.
    if (OldBranchCode == BranchCode)
      continue;

    return true;
  }

  return false;
}

unsigned FRISCInstrInfo::removeBranch(MachineBasicBlock &MBB,
                                    int *BytesRemoved) const {
  assert(!BytesRemoved && "code size not handled");

  MachineBasicBlock::iterator I = MBB.end();
  unsigned Count = 0;

  while (I != MBB.begin()) {
    --I;
    if (I->isDebugValue())
      continue;
    if (I->getOpcode() != FRISC::JP_i &&
        I->getOpcode() != FRISC::JPcc_i
        )
      break;
    // Remove the branch.
    I->eraseFromParent();
    I = MBB.end();
    ++Count;
  }

  return Count;
}

unsigned FRISCInstrInfo::insertBranch(MachineBasicBlock &MBB,
                                       MachineBasicBlock *TBB,
                                       MachineBasicBlock *FBB,
                                       ArrayRef<MachineOperand> Cond,
                                       const DebugLoc &DL,
                                       int *BytesAdded) const {
  // Shouldn't be a fall through.
  assert(TBB && "insertBranch must not be told to insert a fallthrough");
  assert((Cond.size() == 1 || Cond.size() == 0) &&
         "FRISC branch conditions have one component!");
  assert(!BytesAdded && "code size not handled");

  if (Cond.empty()) {
    // Unconditional branch?
    assert(!FBB && "Unconditional branch with multiple successors!");
    BuildMI(&MBB, DL, get(FRISC::JP_i)).addMBB(TBB);
    return 1;
  }

  // Conditional branch.
  unsigned Count = 0;
  BuildMI(&MBB, DL, get(FRISC::JPcc_i)).addMBB(TBB).addImm(Cond[0].getImm());
  ++Count;

  if (FBB) {
    // Two-way Conditional branch. Insert the second branch.
    BuildMI(&MBB, DL, get(FRISC::JP_i)).addMBB(FBB);
    ++Count;
  }
  return Count;
}
