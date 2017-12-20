//== FRISCInstPrinter.h - Convert FRISC MCInst to assembly syntax -----*- C++ -*-=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief This file contains the declaration of the FRISCInstPrinter class,
/// which is used to print FRISC MCInst to a .s file.
///
//===----------------------------------------------------------------------===//

#ifndef FRISCINSTPRINTER_H
#define FRISCINSTPRINTER_H
#include "llvm/MC/MCInstPrinter.h"

namespace llvm {

class TargetMachine;

class FRISCInstPrinter : public MCInstPrinter {
public:
  FRISCInstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                 const MCRegisterInfo &MRI)
      : MCInstPrinter(MAI, MII, MRI) {}

  virtual void printInst(const MCInst *MI, raw_ostream &OS, StringRef Annot,
                         const MCSubtargetInfo &STI) override;

  virtual void printRegName(raw_ostream &OS, unsigned RegNo) const override;

  void printOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printMemSrcOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printPCRelImm(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printCondCode(const MCInst *MI, unsigned OpNo, raw_ostream &O);

  // Autogenerated by tblgen.
  void printInstruction(const MCInst *MI, raw_ostream &O);

  static const char *getRegisterName(unsigned RegNo);

};
} // end namespace llvm

#endif
