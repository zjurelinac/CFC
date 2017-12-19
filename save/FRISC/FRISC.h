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

namespace FRISCCC {
    enum CondCodes {
        COND_U                  = 0,
        COND_N,     COND_M      = 1,
        COND_NN,    COND_P      = 2,
        COND_C,     COND_UGE    = 3,
        COND_NC,    COND_ULT    = 4,
        COND_V                  = 5,
        COND_NV                 = 6,
        COND_Z,     COND_EQ     = 7,
        COND_NZ,    COND_NE     = 8,
        COND_ULE                = 9,
        COND_UGT                = 10,
        COND_SLT                = 11,
        COND_SLE                = 12,
        COND_SGE                = 13,
        COND_SGT                = 14,
        COND_INVALID            = -1
    };
}

namespace llvm {
class TargetMachine;
class FRISCTargetMachine;

FunctionPass *createFRISCISelDag(FRISCTargetMachine &TM,
                               CodeGenOpt::Level OptLevel);
} // end namespace llvm;

#endif