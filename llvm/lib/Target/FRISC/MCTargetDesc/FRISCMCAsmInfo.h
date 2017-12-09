//===-- FRISCMCAsmInfo.h - FRISC asm properties --------------------*- C++ -*--===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the declaration of the FRISCMCAsmInfo class.
//
//===----------------------------------------------------------------------===//

#ifndef FRISCTARGETASMINFO_H
#define FRISCTARGETASMINFO_H

#include "llvm/MC/MCAsmInfoELF.h"

namespace llvm {
class Triple;

class FRISCMCAsmInfo : public MCAsmInfoELF {
  virtual void anchor();

public:
  explicit FRISCMCAsmInfo(const Triple &TT);
};

} // namespace llvm

#endif
