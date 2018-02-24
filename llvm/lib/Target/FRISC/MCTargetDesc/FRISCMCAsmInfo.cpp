//===-- FRISCMCAsmInfo.cpp - FRISC asm properties -----------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "FRISCMCAsmInfo.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Triple.h"
using namespace llvm;

void FRISCMCAsmInfo::anchor() {}

FRISCMCAsmInfo::FRISCMCAsmInfo(const Triple &TT) {
	// TODO: Think about ? parameters
	MinInstAlignment = 4; 					// Instruction alignment
	SeparatorString = nullptr; 				// Separator for instructions on the same line -> No such thing in FRISC
	CommentString = ";"; 					// Start of line comment
	LabelSuffix = ":";  					// Will be outputted after each label
	NeedsLocalForSize = false; 				// ?
	PrivateGlobalPrefix = "L"; 				// Prefix for private globals
	// PrivateLabelPrefix = ""; 			// Prefix for private labels (basic block names)
	ZeroDirective = "\tDS\t";				// Define a sequence of 0-initialized bytes
	AsciiDirective = "\tDA\t"; 				// Define an ASCII string (C-style escaping)
	AscizDirective = nullptr; 				// Special handling of zero-terminated strings, unsupported
	Data8bitsDirective = "\tDB\t";			// Define 8-bit data (byte)
	Data16bitsDirective = "\tDH\t"; 		// Define 16-bit data (halfword)
	Data32bitsDirective = "\tDW\t"; 		// Define 32-bit data (word)
	Data64bitsDirective = "\tDD\t"; 		// Define 64-bit data (doubleword)
	// GlobalDirective = "\tDG\t"; 			// Define a global symbol
	// HasFunctionAlignment = false; 		// ?
	// HasDotTypeDotSizeDirective = false;	// ?
	// HasSingleParameterDotFile = false; 	// ?
	// HasIdentDirective = false; 			// ?
	SupportsDebugInformation = true; 		// ?
}
