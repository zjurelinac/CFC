//===-- FRISCTargetInfo.cpp - FRISC Target Implementation ---------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/FRISCMCTargetDesc.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/TargetRegistry.h"
using namespace llvm;

Target &llvm::getTheFRISCTarget() {
	static Target TheFRISCTarget;
	return TheFRISCTarget;
}

extern "C" void LLVMInitializeFRISCTargetInfo() {
	RegisterTarget<Triple::frisc> X(getTheFRISCTarget(), "frisc", "FRISC");
}
