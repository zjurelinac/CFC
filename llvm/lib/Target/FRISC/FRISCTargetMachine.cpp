//===-- FRISCTargetMachine.cpp - Define TargetMachine for FRISC -----------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
//
//===----------------------------------------------------------------------===//

#include "FRISCTargetMachine.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

static std::string computeDataLayout(const Triple &TT, StringRef CPU,
                                     const TargetOptions &Options) {
  // XXX Build the triple from the arguments.
  // This is hard-coded for now for this example target.
  return "e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-a:0:32-n32-S8";
}

FRISCTargetMachine::FRISCTargetMachine(const Target &T, const Triple &TT,
                                   StringRef CPU, StringRef FS,
                                   const TargetOptions &Options,
                                   Reloc::Model RM, CodeModel::Model CM,
                                   CodeGenOpt::Level OL)
    : LLVMTargetMachine(T, computeDataLayout(TT, CPU, Options), TT, CPU, FS,
                        Options, RM, CM, OL),
      Subtarget(TT, CPU, FS, *this),
      TLOF(make_unique<TargetLoweringObjectFileELF>()) {
  initAsmInfo();
}

namespace {
/// FRISC Code Generator Pass Configuration Options.
class FRISCPassConfig : public TargetPassConfig {
public:
  FRISCPassConfig(LEGTargetMachine *TM, PassManagerBase &PM)
      : TargetPassConfig(TM, PM) {}

  FRISCTargetMachine &getFRISCTargetMachine() const {
    return getTM<FRISCTargetMachine>();
  }

  virtual bool addPreISel() override;
  virtual bool addInstSelector() override;
  virtual void addPreEmitPass() override;
};
} // namespace

TargetPassConfig *FRISCTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new FRISCPassConfig(this, PM);
}

bool FRISCPassConfig::addPreISel() { return false; }

bool FRISCPassConfig::addInstSelector() {
  addPass(createFRISCISelDag(getFRISCTargetMachine(), getOptLevel()));
  return false;
}

void FRISCPassConfig::addPreEmitPass() {}

// Force static initialization.
extern "C" void LLVMInitializeFRISCTarget() {
  RegisterTargetMachine<FRISCTargetMachine> X(TheFRISCTarget);
}