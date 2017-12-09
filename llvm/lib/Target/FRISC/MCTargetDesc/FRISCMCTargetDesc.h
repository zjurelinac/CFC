//===-- FRISCMCTargetDesc.h - FRISC Target Descriptions -------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file provides FRISC specific target descriptions.
//
//===----------------------------------------------------------------------===//

#ifndef FRISCMCTARGETDESC_H
#define FRISCMCTARGETDESC_H

#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCTargetOptions.h"
#include "llvm/Support/DataTypes.h"

namespace llvm {
class Target;
class MCAsmBackend;
class MCCodeEmitter;
class MCContext;
class MCInstrInfo;
class MCObjectWriter;
class MCRegisterInfo;
class MCSubtargetInfo;

class StringRef;
class raw_ostream;
class raw_pwrite_stream;
class Triple;

Target &getTheFRISCTarget();

MCCodeEmitter *createFRISCMCCodeEmitter(const MCInstrInfo &MCII,
                                      const MCRegisterInfo &MRI,
                                      MCContext &Ctx);

MCAsmBackend *createFRISCAsmBackend(const Target &T, const MCRegisterInfo &MRI,
                                  const Triple &TT, StringRef CPU,
                                  const MCTargetOptions &Options);

MCObjectWriter *createFRISCELFObjectWriter(raw_pwrite_stream &OS, uint8_t OSABI);

} // End llvm namespace

// Defines symbolic names for FRISC registers.
#define GET_REGINFO_ENUM
#include "FRISCGenRegisterInfo.inc"

// Defines symbolic names for FRISC instructions.
#define GET_INSTRINFO_ENUM
#include "FRISCGenInstrInfo.inc"

#endif
