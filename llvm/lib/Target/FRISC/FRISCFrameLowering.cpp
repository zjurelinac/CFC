//===-- FRISCFrameLowering.cpp - FRISC Frame Information ----------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the FRISC implementation of TargetFrameLowering class.
//
//===----------------------------------------------------------------------===//

#include "FRISC.h"
#include "FRISCFrameLowering.h"
#include "FRISCInstrInfo.h"
#include "FRISCMachineFunctionInfo.h"
#include "FRISCSubtarget.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"

using namespace llvm;

FRISCFrameLowering::FRISCFrameLowering(const FRISCSubtarget &STI)
    : TargetFrameLowering(TargetFrameLowering::StackGrowsDown, /*StackAlignment=*/4, /*LocalAreaOffset=*/0) {}

bool FRISCFrameLowering::hasFP(const MachineFunction &MF) const { return true; }

void FRISCFrameLowering::emitPrologue(MachineFunction &MF, MachineBasicBlock &MBB) const {}

void FRISCFrameLowering::emitEpilogue(MachineFunction &MF, MachineBasicBlock &MBB) const {}

MachineBasicBlock::iterator FRISCFrameLowering::eliminateCallFramePseudoInstr(MachineFunction &MF,
        MachineBasicBlock &MBB, MachineBasicBlock::iterator I) const {

    const FRISCInstrInfo &TII = *static_cast<const FRISCInstrInfo*>(MF.getSubtarget().getInstrInfo());
    unsigned StackAlign = getStackAlignment();

    if (!hasReservedCallFrame(MF)) {
        // If the stack pointer can be changed after prologue, turn the
        // adjcallstackup instruction into a 'sub SP, <amt>' and the
        // adjcallstackdown instruction into 'add SP, <amt>'
        // TODO: consider using push / pop instead of sub + store / add
        MachineInstr &Old = *I;
        uint64_t Amount = Old.getOperand(0).getImm();
        if (Amount != 0) {
            // We need to keep the stack aligned properly.  To do this, we round the
            // amount of space needed for the outgoing arguments up to the next
            // alignment boundary.
            Amount = (Amount + StackAlign - 1) / StackAlign * StackAlign;

            MachineInstr *New = nullptr;
            if (Old.getOpcode() == TII.getCallFrameSetupOpcode()) {
                New = BuildMI(MF, Old.getDebugLoc(), TII.get(FRISC::SUB_ri), FRISC::SP)
                        .addReg(FRISC::SP)
                        .addImm(Amount);
            } else {
                assert(Old.getOpcode() == TII.getCallFrameDestroyOpcode());
                // factor out the amount the callee already popped.
                uint64_t CalleeAmt = Old.getOperand(1).getImm();
                Amount -= CalleeAmt;
                if (Amount)
                    New = BuildMI(MF, Old.getDebugLoc(), TII.get(FRISC::ADD_ri), FRISC::SP)
                            .addReg(FRISC::SP).addImm(Amount);
            }

            if (New) {
                New->getOperand(3).setIsDead();     // The SRW implicit def is dead.
                MBB.insert(I, New);                 // Replace the pseudo instruction with a new instruction...
            }
        }
    } else if (I->getOpcode() == TII.getCallFrameDestroyOpcode()) {
        // If we are performing frame pointer elimination and if the callee pops
        // something off the stack pointer, add it back.
        if (uint64_t CalleeAmt = I->getOperand(1).getImm()) {
            MachineInstr &Old = *I;
            MachineInstr *New =
                BuildMI(MF, Old.getDebugLoc(), TII.get(FRISC::SUB_ri), FRISC::SP)
                    .addReg(FRISC::SP).addImm(CalleeAmt);
          
          New->getOperand(3).setIsDead(); // The SRW implicit def is dead.
          MBB.insert(I, New);
        }
    }

    return MBB.erase(I);
}

bool FRISCFrameLowering::spillCalleeSavedRegisters(MachineBasicBlock &MBB, MachineBasicBlock::iterator MI,
        const std::vector<CalleeSavedInfo> &CSI, const TargetRegisterInfo *TRI) const {

    if (CSI.empty()) return false;

    DebugLoc DL;
    if (MI != MBB.end()) DL = MI->getDebugLoc();

    MachineFunction &MF = *MBB.getParent();
    const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
    FRISCMachineFunctionInfo *MFI = MF.getInfo<FRISCMachineFunctionInfo>();
    MFI->setCalleeSavedFrameSize(CSI.size() * 2);

    for (unsigned i = CSI.size(); i != 0; --i) {
        unsigned Reg = CSI[i-1].getReg();
        // Add the callee-saved register as live-in. It's killed at the spill.
        MBB.addLiveIn(Reg);
        BuildMI(MBB, MI, DL, TII.get(FRISC::PUSH)).addReg(Reg, RegState::Kill);
    }
    return true;
}

bool FRISCFrameLowering::restoreCalleeSavedRegisters(MachineBasicBlock &MBB, MachineBasicBlock::iterator MI,
        const std::vector<CalleeSavedInfo> &CSI, const TargetRegisterInfo *TRI) const {
  
    if (CSI.empty()) return false;

    DebugLoc DL;
    if (MI != MBB.end()) DL = MI->getDebugLoc();

    MachineFunction &MF = *MBB.getParent();
    const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();

    for (unsigned i = 0, e = CSI.size(); i != e; ++i)
        BuildMI(MBB, MI, DL, TII.get(FRISC::POP), CSI[i].getReg());

    return true;
}

bool FRISCFrameLowering::hasReservedCallFrame(const MachineFunction &MF) const {
    return !MF.getFrameInfo().hasVarSizedObjects();
}

void FRISCFrameLowering::processFunctionBeforeFrameFinalized(MachineFunction &MF,
                                                         RegScavenger *) const {
    // Create a frame entry for the FP register that must be saved.
    if (hasFP(MF)) {
        int FrameIdx = MF.getFrameInfo().CreateFixedObject(4, -4, true);
        // (void)FrameIdx; -- ??!
        assert(FrameIdx == MF.getFrameInfo().getObjectIndexBegin() &&
               "Slot for FP register must be last in order to be found!");
    }
}
