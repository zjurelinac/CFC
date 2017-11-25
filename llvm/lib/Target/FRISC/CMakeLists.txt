set(LLVM_TARGET_DEFINITIONS FRISC.td)

tablegen(LLVM FRISCGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM FRISCGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM FRISCGenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM FRISCGenMCPseudoLowering.inc -gen-pseudo-lowering)
#tablegen(LLVM FRISCGenAsmMatcher.inc -gen-asm-matcher)
tablegen(LLVM FRISCGenAsmWriter.inc -gen-asm-writer)
tablegen(LLVM FRISCGenCallingConv.inc -gen-callingconv)
tablegen(LLVM FRISCGenDAGISel.inc -gen-dag-isel)
tablegen(LLVM FRISCGenSubtargetInfo.inc -gen-subtarget)
#tablegen(LLVM FRISCGenDisassemblerTables.inc -gen-disassembler)

add_public_tablegen_target(FRISCCommonTableGen)

add_llvm_target(FRISCCodeGen
  FRISCAsmPrinter.cpp
  FRISCFrameLowering.cpp
  FRISCInstrInfo.cpp
  FRISCISelDAGToDAG.cpp
  FRISCISelLowering.cpp
  FRISCMCInstLower.cpp
  FRISCRegisterInfo.cpp
  FRISCSubtarget.cpp
  FRISCTargetMachine.cpp
  )

#add_subdirectory(AsmParser)
#add_subdirectory(Disassembler)
add_subdirectory(InstPrinter)
add_subdirectory(MCTargetDesc)
add_subdirectory(TargetInfo)
