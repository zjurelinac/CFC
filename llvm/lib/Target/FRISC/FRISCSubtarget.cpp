//===-- FRISCSubtarget.cpp - FRISC Subtarget Information ------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the FRISC specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#include "FRISC.h"
#include "FRISCFrameLowering.h"
#include "FRISCSubtarget.h"
#include "llvm/Support/TargetRegistry.h"

#define DEBUG_TYPE "frisc-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "FRISCGenSubtargetInfo.inc"

using namespace llvm;

void FRISCSubtarget::anchor() {}

FRISCSubtarget::FRISCSubtarget(const Triple &TT, StringRef CPU, StringRef FS,
                           LEGTargetMachine &TM)
    : FRISCGenSubtargetInfo(TT, CPU, FS),
      DL("e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-a:0:32-n32-S32"),
      InstrInfo(), FrameLowering(*this),
      TLInfo(TM, *this) {}