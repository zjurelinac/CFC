//===-- FRISCELFObjectWriter.cpp - FRISC ELF Writer ---------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "MCTargetDesc/FRISCMCTargetDesc.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCFixup.h"
#include "llvm/Support/ErrorHandling.h"

using namespace llvm;

namespace {
  class FRISCELFObjectWriter : public MCELFObjectTargetWriter {
  public:
    FRISCELFObjectWriter(uint8_t OSABI);

    virtual ~FRISCELFObjectWriter();

    unsigned getRelocType(MCContext &Ctx, const MCValue &Target,
                          const MCFixup &Fixup, bool IsPCRel) const override;
    };
}

FRISCELFObjectWriter::FRISCELFObjectWriter(uint8_t OSABI)
    : MCELFObjectTargetWriter(/*Is64Bit*/ false, OSABI,
                              /*ELF::EM_FRISC*/ ELF::EM_FRISC,
                              /*HasRelocationAddend*/ false) {}

FRISCELFObjectWriter::~FRISCELFObjectWriter() {}

unsigned FRISCELFObjectWriter::getRelocType(MCContext &Ctx,
                                            const MCValue &Target,
                                            const MCFixup &Fixup,
                                            bool IsPCRel) const {
  llvm_unreachable("FRISCELFObjectWriter: invalid fixup kind");
}

MCObjectWriter *llvm::createFRISCELFObjectWriter(raw_pwrite_stream &OS,
                                                uint8_t OSABI) {
  MCELFObjectTargetWriter *MOTW = new FRISCELFObjectWriter(OSABI);
  return createELFObjectWriter(MOTW, OS, /*IsLittleEndian=*/true);
}
