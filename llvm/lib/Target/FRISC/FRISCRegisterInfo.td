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

def SP : FRISCReg<7, "SP", ["R7"]>;
def SR : FRISCReg<8, "SR">;
def PC : FRISCReg<9, "PC">;

def GPR : RegisterClass<"FRISC", [i32], 32, (add (sequence "R%u", 0, 6), SP)>;

def SRClass : RegisterClass<"FRISC", [i32], 32, (add SR)>;
def PCClass : RegisterClass<"FRISC", [i32], 32, (add PC)>;
// TODO: Add Vector registers