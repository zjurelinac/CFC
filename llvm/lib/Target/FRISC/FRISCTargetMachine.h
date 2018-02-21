//===-- FRISCTargetMachine.h - Define TargetMachine for FRISC ---*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the FRISC specific subclass of TargetMachine.
//
//===----------------------------------------------------------------------===//

#ifndef FRISCTARGETMACHINE_H
#define FRISCTARGETMACHINE_H

#include "FRISC.h"
#include "FRISCSubtarget.h"
#include "MCTargetDesc/FRISCMCTargetDesc.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {

class FRISCTargetMachine : public LLVMTargetMachine {
    FRISCSubtarget Subtarget;
    std::unique_ptr<TargetLoweringObjectFile> TLOF;

public:
    FRISCTargetMachine(const Target &T, const Triple &TT, StringRef CPU, StringRef FS,
        const TargetOptions &Options, Optional<Reloc::Model> RM, CodeModel::Model CM, CodeGenOpt::Level OL);


    // Pass Pipeline Configuration
    virtual TargetPassConfig *createPassConfig(PassManagerBase &PM) override;
      
    TargetLoweringObjectFile *getObjFileLowering() const override
        { return TLOF.get(); }

    virtual const TargetSubtargetInfo* getSubtargetImpl(const Function &) const override
        { return &Subtarget; }
};

} // end namespace llvm

#endif
