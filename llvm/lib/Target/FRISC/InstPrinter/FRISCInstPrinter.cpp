//===-- FRISCInstPrinter.cpp - Convert FRISC MCInst to asm syntax -------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This class prints an FRISC MCInst to a .s file.
//
//===----------------------------------------------------------------------===//

#include "FRISC.h"
#include "FRISCInstPrinter.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/FormattedStream.h"

using namespace llvm;

#define DEBUG_TYPE "asm-printer"

// Include the auto-generated portion of the assembly writer.
#include "FRISCGenAsmWriter.inc"

void FRISCInstPrinter::printInst(const MCInst *MI, raw_ostream &O, StringRef Annot, const MCSubtargetInfo &STI) {
    printInstruction(MI, O);
    printAnnotation(O, Annot);
}

void FRISCInstPrinter::printRegName(raw_ostream &O, unsigned RegNo) const {
    O << StringRef(getRegisterName(RegNo));
}

void FRISCInstPrinter::printOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O) {
    const MCOperand &Op = MI->getOperand(OpNo);

    if (Op.isReg()) {
        printRegName(O, Op.getReg());
        return;
    }

    if (Op.isImm()) {
        O << Op.getImm();
        return;
    }

    if (Op.isExpr()) {
        Op.getExpr()->print(O, &MAI);
        return;
    }

    llvm_unreachable("Unknown operand");
}

// Print a MemSrc (defined in FRISCInstrFormats.td)
// This is an operand which defines a location for loading or storing which
// is a register offset by an immediate value
void FRISCInstPrinter::printMemSrcOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O) {
    const MCOperand &BaseAddr = MI->getOperand(OpNo);
    const MCOperand &Offset = MI->getOperand(OpNo + 1);

    assert(Offset.isImm() && "Expected immediate in displacement field");

    O << "(";
    printRegName(O, BaseAddr.getReg());
    unsigned OffsetVal = Offset.getImm();
    if (OffsetVal) {
        if (Offset.getImm() < 0)
            O << "-" << -Offset.getImm();
        else
            O << "+" << Offset.getImm();
    }
    O << ")";
}

void FRISCInstPrinter::printPCRelImm(const MCInst *MI, unsigned OpNo, raw_ostream &O) {
    const MCOperand &Op = MI->getOperand(OpNo);
    if (Op.isImm()) {
        O << '(' << Op.getImm() << ')';
    } else {
        assert(Op.isExpr() && "unknown pcrel immediate operand");
        Op.getExpr()->print(O, &MAI);
    }
}

void FRISCInstPrinter::printCondCode(const MCInst *MI, unsigned OpNo, raw_ostream &O) {
    unsigned CC = MI->getOperand(OpNo).getImm();

    switch (CC) {
        default:
            llvm_unreachable("Unsupported CC code");
        case FRISCCC::COND_C:
            O << "UGE";
            break;
        case FRISCCC::COND_N:
            O << "N";
            break;
        case FRISCCC::COND_V:
            O << "V";
            break;
        case FRISCCC::COND_Z:
            O << "EQ";
            break;
        case FRISCCC::COND_NC:
            O << "ULT";
            break;
        case FRISCCC::COND_NN:
            O << "NN";
            break;
        case FRISCCC::COND_NV:
            O << "NV";
            break;
        case FRISCCC::COND_NZ:
            O << "NE";
            break;
        case FRISCCC::COND_ULE:
            O << "ULE";
            break;
        case FRISCCC::COND_UGT:
            O << "UGT";
            break;
        case FRISCCC::COND_SLE:
            O << "SLE";
            break;
        case FRISCCC::COND_SGT:
            O << "SGT";
            break;
        case FRISCCC::COND_SGE:
            O << "SGE";
            break;
        case FRISCCC::COND_SLT:
            O << "SLT";
            break;
    }
}
