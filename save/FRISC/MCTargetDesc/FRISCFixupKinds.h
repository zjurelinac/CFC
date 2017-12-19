//===-- FRISCFixupKinds.h - FRISC Specific Fixup Entries ------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef FRISCFIXUPKINDS_H
#define FRISCFIXUPKINDS_H

#include "llvm/MC/MCFixup.h"

namespace llvm {
namespace FRISC {

  // This table *must* be in the same order of
  // MCFixupKindInfo Infos[FRISC::NumTargetFixupKinds]
  // in FRISCAsmBackend.cpp.
  enum Fixups {
    fixup_FRISC_NONE = FirstTargetFixupKind,

    // Pure 32 but data fixup
    fixup_FRISC_32,

    // Marker
    LastTargetFixupKind,
    NumTargetFixupKinds = LastTargetFixupKind - FirstTargetFixupKind
  };
} // namespace FRISC
} // namespace llvm


#endif
