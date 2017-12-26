//===-- FRISCRegisterInfo.cpp - FRISC Register Information ----------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the FRISC implementation of the TargetRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#include "FRISC.h"
#include "FRISCRegisterInfo.h"
#include "FRISCSubtarget.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Target/TargetFrameLowering.h"
#include "llvm/Target/TargetInstrInfo.h"

#define GET_REGINFO_TARGET_DESC
#include "FRISCGenRegisterInfo.inc"

using namespace llvm;

FRISCRegisterInfo::FRISCRegisterInfo() : FRISCGenRegisterInfo(FRISC::PC) {}

const MCPhysReg *
FRISCRegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  return CC_Save_SaveList; // from tablegen
}

BitVector FRISCRegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  BitVector Reserved(getNumRegs());

  Reserved.set(FRISC::SR); // status regsiter
  Reserved.set(FRISC::PC); // program counter

  return Reserved;
}

const TargetRegisterClass *
FRISCRegisterInfo::getPointerRegClass(const MachineFunction &MF, unsigned Kind) const {
  return &FRISC::GPRRegClass;
}

void FRISCRegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                          int SPAdj, unsigned FIOperandNum,
                                          RegScavenger *RS) const {
  // TODO: Look into this!
  MachineInstr &MI = *II;
  MachineBasicBlock &MBB = *MI.getParent();
  const MachineFunction &MF = *MBB.getParent();
  const MachineFrameInfo MFI = MF.getFrameInfo();
  MachineOperand &FIOp = MI.getOperand(FIOperandNum);
  unsigned FI = FIOp.getIndex();

  // Determine if we can eliminate the index from this kind of instruction.
  unsigned ImmOpIdx = 0;
  switch (MI.getOpcode()) {
    default:
      llvm_unreachable("Instruction not supported");
    case FRISC::LOAD_ri:
    case FRISC::STORE_ri:
    case FRISC::ADD_ri:
      ImmOpIdx = FIOperandNum + 1;
      break;
}

  // FIXME: check the size of offset.
  MachineOperand &ImmOp = MI.getOperand(ImmOpIdx);
  int Offset = MFI.getObjectOffset(FI) + MFI.getStackSize() + ImmOp.getImm();
  if (Offset % 4) {
    llvm_unreachable("Offset must be aligned to 4 bytes because memory is "
                     "32-bit word addressable only");
  }
  FIOp.ChangeToRegister(FRISC::SP, false);
  ImmOp.setImm(Offset);
}

unsigned FRISCRegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  return FRISC::SP;
}
