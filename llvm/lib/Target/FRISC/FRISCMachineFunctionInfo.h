//=== FRISCMachineFunctionInfo.h - FRISC machine function info -------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares FRISC-specific per-machine-function information.
//
//===----------------------------------------------------------------------===//

#ifndef MACHINEFUNCTIONINFO_H
#define MACHINEFUNCTIONINFO_H

#include "llvm/CodeGen/MachineFunction.h"

namespace llvm {

/// FRISCMachineFunctionInfo - This class is derived from MachineFunction and
/// contains private FRISC target-specific information for each MachineFunction.
class FRISCMachineFunctionInfo : public MachineFunctionInfo {
    virtual void anchor();

    /// CalleeSavedFrameSize - Size of the callee-saved register portion of the
    /// stack frame in bytes.
    unsigned CalleeSavedFrameSize;

    /// ReturnAddrIndex - FrameIndex for return slot.
    int ReturnAddrIndex;

    /// VarArgsFrameIndex - FrameIndex for start of varargs area.
    int VarArgsFrameIndex;

public:
    FRISCMachineFunctionInfo() : CalleeSavedFrameSize(0) {}

    explicit FRISCMachineFunctionInfo(MachineFunction &MF)
        : CalleeSavedFrameSize(0), ReturnAddrIndex(0) {}

    unsigned getCalleeSavedFrameSize() const { return CalleeSavedFrameSize; }
    void setCalleeSavedFrameSize(unsigned bytes) { CalleeSavedFrameSize = bytes; }

    int getRAIndex() const { return ReturnAddrIndex; }
    void setRAIndex(int Index) { ReturnAddrIndex = Index; }

    int getVarArgsFrameIndex() const { return VarArgsFrameIndex;}
    void setVarArgsFrameIndex(int Index) { VarArgsFrameIndex = Index; }
};

} // End llvm namespace

#endif
