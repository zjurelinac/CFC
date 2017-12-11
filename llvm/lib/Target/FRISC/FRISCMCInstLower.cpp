//===-- FRISCMCInstLower.cpp - Convert FRISC MachineInstr to MCInst -------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief This file contains code to lower FRISC MachineInstrs to their
/// corresponding MCInst records.
///
//===----------------------------------------------------------------------===//
#include "FRISC.h"
#include "FRISCMCInstLower.h"
#include "MCTargetDesc/FRISCBaseInfo.h"
#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineOperand.h"
#include "llvm/IR/Mangler.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"

using namespace llvm;

MCOperand FRISCMCInstLower::LowerSymbolOperand(const MachineOperand &MO,
                                             MCSymbol *Sym) const {
  const MCExpr *Expr = MCSymbolRefExpr::create(Sym, Ctx);

  switch (MO.getTargetFlags()) {
    default: llvm_unreachable("Unknown target flag on GV operand");
    case 0: break;
  }

  if (!MO.isJTI() && MO.getOffset())
    Expr = MCBinaryExpr::createAdd(Expr,
                                   MCConstantExpr::create(MO.getOffset(), Ctx),
                                   Ctx);

  return MCOperand::createExpr(Expr);
}

MCOperand FRISCMCInstLower::LowerOperand(const MachineOperand &MO,
                                       unsigned offset) const {
  MachineOperandType MOTy = MO.getType();

  switch (MOTy) {
    default:
      llvm_unreachable("CJGMCInstLower::Lower() unknown operand type");
    case MachineOperand::MO_Register:
      // Ignore all implicit register operands.
      if (MO.isImplicit()) {
        break;
      }
      return MCOperand::createReg(MO.getReg());
    case MachineOperand::MO_Immediate:
      return MCOperand::createImm(MO.getImm());
    case MachineOperand::MO_GlobalAddress:
      return LowerSymbolOperand(MO, GetGlobalAddressSymbol(MO));
    case MachineOperand::MO_MachineBasicBlock:
      return MCOperand::createExpr(MCSymbolRefExpr::create(
                         MO.getMBB()->getSymbol(), Ctx));
    case MachineOperand::MO_RegisterMask:
      break;
  }

  return MCOperand();
}

void FRISCMCInstLower::Lower(const MachineInstr *MI, MCInst &OutMI) const {
  OutMI.setOpcode(MI->getOpcode());

  for (auto &MO : MI->operands()) {
    const MCOperand MCOp = LowerOperand(MO);

    if (MCOp.isValid()) {
      OutMI.addOperand(MCOp);
    }
  }
}

MCSymbol
*FRISCMCInstLower::GetGlobalAddressSymbol(const MachineOperand &MO) const {
  switch (MO.getTargetFlags()) {
    default: llvm_unreachable("Unknown target flag on GV operand");
    case 0: break;
  }

  return Printer.getSymbol(MO.getGlobal());
}