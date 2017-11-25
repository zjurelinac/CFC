//===-- FRISCRegisterInfo.td - FRISC Register defs ---------*- tabFRISCen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
//  Declarations that describe the FRISC register file
//===----------------------------------------------------------------------===//

class FRISCReg<bits<16> Enc, string n, list<string> altNames = []> : Register<n, altNames> {
    let HWEncoding = Enc;
    let Namespace = "FRISC";
}

// CPU registers
foreach i = 0-6 in {
    def R#i : FRISCReg<i, "R" ## i>;
}

def R7 : FRISCReg<7, "R7", ["SP"]>;
def SR : FRISCReg<8, "SR">;

def GPRegisters : RegisterClass<"FRISC", [i32], 32, (sequence "R%u", 0, 7)>;

// TODO: Add Vector registers