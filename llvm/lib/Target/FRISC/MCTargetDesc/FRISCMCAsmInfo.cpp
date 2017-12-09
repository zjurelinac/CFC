//===-- FRISCMCAsmInfo.cpp - FRISC asm properties -----------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "FRISCMCAsmInfo.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Triple.h"
using namespace llvm;

void FRISCMCAsmInfo::anchor() {}

FRISCMCAsmInfo::FRISCMCAsmInfo(const Triple &TT) {
  /*Data16bitsDirective = "\t.half\t";
  Data32bitsDirective = "\t.word\t";
  Data64bitsDirective = 0;  // .xword is only supported by V9.
  ZeroDirective = "\t.skip\t";
  CommentString = "!";
  ConstantPoolSection = "\t.section \".rodata\",#alloc\n";*/
  CommentString = "//";
  SupportsDebugInformation = true;
  PrivateLabelPrefix = "";
}
