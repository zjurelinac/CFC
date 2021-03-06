//===-- FRISCSubtarget.h - Define Subtarget for the FRISC -------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the FRISC specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#ifndef FRISCSUBTARGET_H
#define FRISCSUBTARGET_H

#include "FRISCFrameLowering.h"
#include "FRISCISelLowering.h"
#include "FRISCInstrInfo.h"
#include "llvm/CodeGen/SelectionDAGTargetInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetSubtargetInfo.h"
#include <string>


#define GET_SUBTARGETINFO_HEADER
#include "FRISCGenSubtargetInfo.inc"

namespace llvm {
class StringRef;

class FRISCSubtarget : public FRISCGenSubtargetInfo {
    virtual void anchor();

private:
    const DataLayout DL;       // Calculates type size & alignment.
    FRISCInstrInfo InstrInfo;
    FRISCFrameLowering FrameLowering;
    FRISCTargetLowering TLInfo;

public:
    /// This constructor initializes the data members to match that of the specified triple.
    FRISCSubtarget(const Triple &TT, StringRef CPU, StringRef FS, FRISCTargetMachine &TM);

    const FRISCInstrInfo *getInstrInfo() const override
        { return &InstrInfo; }
    const FRISCRegisterInfo *getRegisterInfo() const override
        { return &InstrInfo.getRegisterInfo(); }
    const FRISCTargetLowering *getTargetLowering() const override
        { return &TLInfo; }
    const FRISCFrameLowering *getFrameLowering() const override
        { return &FrameLowering; }

    /// ParseSubtargetFeatures - Parses features string setting specified
    /// subtarget options.  Definition of function is auto generated by tblgen.
    void ParseSubtargetFeatures(StringRef CPU, StringRef FS);
};
} // End llvm namespace

#endif
