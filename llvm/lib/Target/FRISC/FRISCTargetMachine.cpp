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
#include "MCTargetDesc/FRISCMCTargetDesc.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/CodeGen/TargetPassConfig.h"

using namespace llvm;

static std::string computeDataLayout(const Triple &TT, StringRef CPU,
                                     const TargetOptions &Options) {
  return "e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-i64:32-f64:32-a:0:32-n32";
}

/********************************************************************************/

static Reloc::Model getEffectiveRelocModel(const Triple &TT,
                                           Optional<Reloc::Model> RM) {
  if (!RM.hasValue())
    // Default relocation model on Darwin is PIC.
    return TT.isOSBinFormatMachO() ? Reloc::PIC_ : Reloc::Static;

  // DynamicNoPIC is only used on darwin.
  if (*RM == Reloc::DynamicNoPIC && !TT.isOSDarwin())
    return Reloc::Static;

  return *RM;
}

FRISCTargetMachine::FRISCTargetMachine(const Target &T, const Triple &TT,
                                   StringRef CPU, StringRef FS,
                                   const TargetOptions &Options,
                                   Optional<Reloc::Model> RM,
                                   CodeModel::Model CM, CodeGenOpt::Level OL)
    : LLVMTargetMachine(T, computeDataLayout(TT, CPU, Options), TT, CPU, FS,
                        Options, getEffectiveRelocModel(TT, RM), CM, OL),
      Subtarget(TT, CPU, FS, *this),
      TLOF(make_unique<TargetLoweringObjectFileELF>()) {
  initAsmInfo();
}

namespace {
class FRISCPassConfig : public TargetPassConfig {
public:
  FRISCPassConfig(FRISCTargetMachine &TM, PassManagerBase &PM)
      : TargetPassConfig(TM, PM) {}

  FRISCTargetMachine &getFRISCTargetMachine() const {
    return getTM<FRISCTargetMachine>();
  }

  virtual bool addInstSelector() override;
};
}

TargetPassConfig *FRISCTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new FRISCPassConfig(*this, PM);
}

bool FRISCPassConfig::addInstSelector() {
  addPass(createFRISCISelDag(getFRISCTargetMachine(), getOptLevel()));
  return false;
}

// Force static initialization.
extern "C" void LLVMInitializeFRISCTarget() {
  RegisterTargetMachine<FRISCTargetMachine> X(getTheFRISCTarget());
}

/**************************************************************************/
