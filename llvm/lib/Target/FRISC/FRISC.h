//===-- //===-- FRISC.h - Top-level interface for FRISC representation --*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the entry points for global functions defined in the LLVM
// FRISC back-end.
//
//===----------------------------------------------------------------------===//

#ifndef TARGET_FRISC_H
#define TARGET_FRISC_H

//#include "MCTargetDesc/FRISCMCTargetDesc.h" -> todo
#include "llvm/Target/TargetMachine.h"

namespace llvm {
class TargetMachine;
class FRISCTargetMachine;

FunctionPass *createFRISCISelDag(FRISCTargetMachine &TM,
                               CodeGenOpt::Level OptLevel);
} // end namespace llvm;

#endif