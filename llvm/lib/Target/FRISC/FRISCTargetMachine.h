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

#ifndef _FRISC_TARGET_MACHINE_H_
#define _FRISC_TARGET_MACHINE_H_

#include "llvm/IR/DataLayout.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {

class FRISCTargetMachine : public LLVMTargetMachine {
    std::unique_ptr<TargetLoweringObjectFile> TLOF;

public:
    // Parameter info:
    //  - Target T = ?
    //  - Triple TT = ?
    //  - StringRef CPU = ?
    //  - StringRef FS = ?
    //  - TargetOptions Options - Various options for target machine code generation
    //  - Reloc::Model RM = static | PIC | dynamic-no-pic | TARGET_DEFAULT (PIC = Position Independent Code) -- use STATIC
    //  - CodeModel::Model CM = small | kernel | medium | large | TARGET_DEFAULT -- use SMALL
    //  - CodeGenOpt::Level OL = None | Less | Default | Aggressive
    //  - DataLayout = ""
    FRISCTargetMachine(const Target &T, const Triple &TT, StringRef CPU,
                       StringRef FS, const TargetOptions &Options, Reloc::Model RM,
                       CodeModel::Model CM, CodeGenOpt::Level OL)
        : LLVMTargetMachine(T, "", TT, CPU, FS, Options, RM, CM, OL){};
    TargetLoweringObjectFile *getObjFileLowering() const override
        { return TLOF.get(); }
    /*bool isMachineVerifierClean() const override
        { return false; }*/
    virtual TargetPassConfig *createPassConfig(PassManagerBase &PM) override;
};

}

#endif // _FRISC_TARGET_MACHINE_H_