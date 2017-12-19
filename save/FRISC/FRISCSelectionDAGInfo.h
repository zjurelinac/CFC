//===-- FRISCSelectionDAGInfo.h - FRISC SelectionDAG Info -------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the FRISC subclass for TargetSelectionDAGInfo.
//
//===----------------------------------------------------------------------===//

#ifndef FRISCSELECTIONDAGINFO_H
#define FRISCSELECTIONDAGINFO_H

#include "llvm/Target/TargetSelectionDAGInfo.h"

namespace llvm {

class FRISCSelectionDAGInfo : public TargetSelectionDAGInfo {
public:
  ~FRISCSelectionDAGInfo();
};
}

#endif