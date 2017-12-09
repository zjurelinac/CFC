//===-- FRISCMCTargetDesc.cpp - FRISC Target Descriptions ---------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file provides FRISC specific target descriptions.
//
//===----------------------------------------------------------------------===//

#include "FRISCMCTargetDesc.h"
#include "FRISCMCAsmInfo.h"
#include "InstPrinter/FRISCInstPrinter.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Support/TargetRegistry.h"

#define GET_INSTRINFO_MC_DESC
#include "FRISCGenInstrInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "FRISCGenSubtargetInfo.inc"

#define GET_REGINFO_MC_DESC
#include "FRISCGenRegisterInfo.inc"

using namespace llvm;

static MCInstrInfo *createFRISCMCInstrInfo() {
  MCInstrInfo *X = new MCInstrInfo();
  InitFRISCMCInstrInfo(X);
  return X;
}

static MCRegisterInfo *createFRISCMCRegisterInfo(const Triple &TT) {
  MCRegisterInfo *X = new MCRegisterInfo();
  InitFRISCMCRegisterInfo(X, FRISC::PC);
  return X;
}

static MCAsmInfo *createFRISCMCAsmInfo(const MCRegisterInfo &MRI,
                                       const Triple &TT) {
  return new FRISCMCAsmInfo(TT);
}

static MCInstPrinter *
createFRISCMCInstPrinter(const Triple &TT, unsigned SyntaxVariant,
                       const MCAsmInfo &MAI, const MCInstrInfo &MII,
                       const MCRegisterInfo &MRI) {
  return new FRISCInstPrinter(MAI, MII, MRI);
}

extern "C" void LLVMInitializeFRISCTargetMC() {
  RegisterMCAsmInfoFn X(getTheFRISCTarget(), createFRISCMCAsmInfo);
  TargetRegistry::RegisterMCInstrInfo(getTheFRISCTarget(), createFRISCMCInstrInfo);
  TargetRegistry::RegisterMCRegInfo(getTheFRISCTarget(), createFRISCMCRegisterInfo);
  TargetRegistry::RegisterMCAsmBackend(getTheFRISCTarget(), createFRISCAsmBackend);
  TargetRegistry::RegisterMCCodeEmitter(getTheFRISCTarget(), createFRISCMCCodeEmitter);
  TargetRegistry::RegisterMCInstPrinter(getTheFRISCTarget(), createFRISCMCInstPrinter);
}
