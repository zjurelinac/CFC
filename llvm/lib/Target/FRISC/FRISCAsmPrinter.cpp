//===-- FRISCAsmPrinter.cpp - FRISC LLVM assembly writer ------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains a printer that converts from our internal representation
// of machine-dependent LLVM code to the FRISC assembly language.
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "asm-printer"
#include "FRISC.h"
#include "InstPrinter/FRISCInstPrinter.h"
#include "FRISCInstrInfo.h"
#include "FRISCMCInstLower.h"
#include "FRISCSubtarget.h"
#include "FRISCTargetMachine.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineJumpTableInfo.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Mangler.h"
#include "llvm/IR/Module.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetLoweringObjectFile.h"
#include <algorithm>
#include <cctype>

using namespace llvm;

namespace {
  class FRISCAsmPrinter : public AsmPrinter {
    FRISCMCInstLower MCInstLowering;

  public:
    explicit FRISCAsmPrinter(TargetMachine &TM, std::unique_ptr<MCStreamer> Streamer)
        : AsmPrinter(TM, std::move(Streamer)), MCInstLowering(OutContext, *this) {}

    virtual StringRef getPassName() const
        { return StringRef("FRISC Assembly Printer"); }

    void EmitFunctionEntryLabel();
    void EmitInstruction(const MachineInstr *MI);
    void EmitFunctionBodyStart();
  };
} // end of anonymous namespace

void FRISCAsmPrinter::EmitFunctionBodyStart() {}

void FRISCAsmPrinter::EmitFunctionEntryLabel() { OutStreamer->EmitLabel(CurrentFnSym); }

void FRISCAsmPrinter::EmitInstruction(const MachineInstr *MI) {
    MCInst TmpInst;
    MCInstLowering.Lower(MI, TmpInst);
    EmitToStreamer(*OutStreamer, TmpInst);
}

// Force static initialization.
extern "C" void LLVMInitializeFRISCAsmPrinter() {
    RegisterAsmPrinter<FRISCAsmPrinter> X(getTheFRISCTarget());
}
