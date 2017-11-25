; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mcpu=skylake -mtriple=i386-unknown-linux-gnu -mattr=+avx2 | FileCheck --check-prefix=X86 %s
; RUN: llc < %s -mcpu=skylake -mtriple=x86_64-unknown-linux-gnu -mattr=+avx2 | FileCheck --check-prefix=X64 %s

declare <2 x i32> @llvm.masked.gather.v2i32(<2 x i32*> %ptrs, i32 %align, <2 x i1> %masks, <2 x i32> %passthro)

define <2 x i32> @masked_gather_v2i32(<2 x i32*>* %ptr, <2 x i1> %masks, <2 x i32> %passthro) {
; X86-LABEL: masked_gather_v2i32:
; X86:       # BB#0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmovzxdq {{.*#+}} xmm2 = mem[0],zero,mem[1],zero
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X86-NEXT:    vpgatherqd %xmm0, (,%xmm2), %xmm1
; X86-NEXT:    vpmovsxdq %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v2i32:
; X64:       # BB#0: # %entry
; X64-NEXT:    vmovdqa (%rdi), %xmm2
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X64-NEXT:    vpgatherqd %xmm0, (,%xmm2), %xmm1
; X64-NEXT:    vpmovsxdq %xmm1, %xmm0
; X64-NEXT:    retq
entry:
  %ld  = load <2 x i32*>, <2 x i32*>* %ptr
  %res = call <2 x i32> @llvm.masked.gather.v2i32(<2 x i32*> %ld, i32 0, <2 x i1> %masks, <2 x i32> %passthro)
  ret <2 x i32> %res
}

define <4 x i32> @masked_gather_v2i32_concat(<2 x i32*>* %ptr, <2 x i1> %masks, <2 x i32> %passthro) {
; X86-LABEL: masked_gather_v2i32_concat:
; X86:       # BB#0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmovzxdq {{.*#+}} xmm2 = mem[0],zero,mem[1],zero
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X86-NEXT:    vpgatherqd %xmm0, (,%xmm2), %xmm1
; X86-NEXT:    vpmovsxdq %xmm1, %xmm0
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v2i32_concat:
; X64:       # BB#0: # %entry
; X64-NEXT:    vmovdqa (%rdi), %xmm2
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X64-NEXT:    vpgatherqd %xmm0, (,%xmm2), %xmm1
; X64-NEXT:    vpmovsxdq %xmm1, %xmm0
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-NEXT:    retq
entry:
  %ld  = load <2 x i32*>, <2 x i32*>* %ptr
  %res = call <2 x i32> @llvm.masked.gather.v2i32(<2 x i32*> %ld, i32 0, <2 x i1> %masks, <2 x i32> %passthro)
  %res2 = shufflevector <2 x i32> %res, <2 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i32> %res2
}

declare <2 x float> @llvm.masked.gather.v2float(<2 x float*> %ptrs, i32 %align, <2 x i1> %masks, <2 x float> %passthro)

define <2 x float> @masked_gather_v2float(<2 x float*>* %ptr, <2 x i1> %masks, <2 x float> %passthro) {
; X86-LABEL: masked_gather_v2float:
; X86:       # BB#0: # %entry
; X86-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,2],zero,zero
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; X86-NEXT:    vgatherdps %xmm0, (,%xmm2), %xmm1
; X86-NEXT:    vmovaps %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v2float:
; X64:       # BB#0: # %entry
; X64-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,2],zero,zero
; X64-NEXT:    vmovaps (%rdi), %xmm2
; X64-NEXT:    vgatherqps %xmm0, (,%ymm2), %xmm1
; X64-NEXT:    vmovaps %xmm1, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %ld  = load <2 x float*>, <2 x float*>* %ptr
  %res = call <2 x float> @llvm.masked.gather.v2float(<2 x float*> %ld, i32 0, <2 x i1> %masks, <2 x float> %passthro)
  ret <2 x float> %res
}

define <4 x float> @masked_gather_v2float_concat(<2 x float*>* %ptr, <2 x i1> %masks, <2 x float> %passthro) {
; X86-LABEL: masked_gather_v2float_concat:
; X86:       # BB#0: # %entry
; X86-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,2],zero,zero
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; X86-NEXT:    vgatherdps %xmm0, (,%xmm2), %xmm1
; X86-NEXT:    vmovaps %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v2float_concat:
; X64:       # BB#0: # %entry
; X64-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,2],zero,zero
; X64-NEXT:    vmovaps (%rdi), %xmm2
; X64-NEXT:    vgatherqps %xmm0, (,%ymm2), %xmm1
; X64-NEXT:    vmovaps %xmm1, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %ld  = load <2 x float*>, <2 x float*>* %ptr
  %res = call <2 x float> @llvm.masked.gather.v2float(<2 x float*> %ld, i32 0, <2 x i1> %masks, <2 x float> %passthro)
  %res2 = shufflevector <2 x float> %res, <2 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x float> %res2
}


declare <4 x i32> @llvm.masked.gather.v4i32(<4 x i32*> %ptrs, i32 %align, <4 x i1> %masks, <4 x i32> %passthro)

define <4 x i32> @masked_gather_v4i32(<4 x i32*> %ptrs, <4 x i1> %masks, <4 x i32> %passthro) {
; X86-LABEL: masked_gather_v4i32:
; X86:       # BB#0: # %entry
; X86-NEXT:    vpgatherdd %xmm1, (,%xmm0), %xmm2
; X86-NEXT:    vmovdqa %xmm2, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v4i32:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpgatherqd %xmm1, (,%ymm0), %xmm2
; X64-NEXT:    vmovdqa %xmm2, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %res = call <4 x i32> @llvm.masked.gather.v4i32(<4 x i32*> %ptrs, i32 0, <4 x i1> %masks, <4 x i32> %passthro)
  ret <4 x i32> %res
}

declare <4 x float> @llvm.masked.gather.v4float(<4 x float*> %ptrs, i32 %align, <4 x i1> %masks, <4 x float> %passthro)

define <4 x float> @masked_gather_v4float(<4 x float*> %ptrs, <4 x i1> %masks, <4 x float> %passthro) {
; X86-LABEL: masked_gather_v4float:
; X86:       # BB#0: # %entry
; X86-NEXT:    vgatherdps %xmm1, (,%xmm0), %xmm2
; X86-NEXT:    vmovaps %xmm2, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v4float:
; X64:       # BB#0: # %entry
; X64-NEXT:    vgatherqps %xmm1, (,%ymm0), %xmm2
; X64-NEXT:    vmovaps %xmm2, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %res = call <4 x float> @llvm.masked.gather.v4float(<4 x float*> %ptrs, i32 0, <4 x i1> %masks, <4 x float> %passthro)
  ret <4 x float> %res
}

declare <8 x i32> @llvm.masked.gather.v8i32(<8 x i32*> %ptrs, i32 %align, <8 x i1> %masks, <8 x i32> %passthro)

define <8 x i32> @masked_gather_v8i32(<8 x i32*>* %ptr, <8 x i1> %masks, <8 x i32> %passthro) {
; X86-LABEL: masked_gather_v8i32:
; X86:       # BB#0: # %entry
; X86-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovdqa (%eax), %ymm2
; X86-NEXT:    vpgatherdd %ymm0, (,%ymm2), %ymm1
; X86-NEXT:    vmovdqa %ymm1, %ymm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v8i32:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X64-NEXT:    vpslld $31, %ymm0, %ymm0
; X64-NEXT:    vpsrad $31, %ymm0, %ymm0
; X64-NEXT:    vmovdqa (%rdi), %ymm2
; X64-NEXT:    vmovdqa 32(%rdi), %ymm3
; X64-NEXT:    vextracti128 $1, %ymm1, %xmm4
; X64-NEXT:    vextracti128 $1, %ymm0, %xmm5
; X64-NEXT:    vpgatherqd %xmm5, (,%ymm3), %xmm4
; X64-NEXT:    vpgatherqd %xmm0, (,%ymm2), %xmm1
; X64-NEXT:    vinserti128 $1, %xmm4, %ymm1, %ymm0
; X64-NEXT:    retq
entry:
  %ld  = load <8 x i32*>, <8 x i32*>* %ptr
  %res = call <8 x i32> @llvm.masked.gather.v8i32(<8 x i32*> %ld, i32 0, <8 x i1> %masks, <8 x i32> %passthro)
  ret <8 x i32> %res
}

declare <8 x float> @llvm.masked.gather.v8float(<8 x float*> %ptrs, i32 %align, <8 x i1> %masks, <8 x float> %passthro)

define <8 x float> @masked_gather_v8float(<8 x float*>* %ptr, <8 x i1> %masks, <8 x float> %passthro) {
; X86-LABEL: masked_gather_v8float:
; X86:       # BB#0: # %entry
; X86-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovaps (%eax), %ymm2
; X86-NEXT:    vgatherdps %ymm0, (,%ymm2), %ymm1
; X86-NEXT:    vmovaps %ymm1, %ymm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v8float:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X64-NEXT:    vpslld $31, %ymm0, %ymm0
; X64-NEXT:    vpsrad $31, %ymm0, %ymm0
; X64-NEXT:    vmovaps (%rdi), %ymm2
; X64-NEXT:    vmovaps 32(%rdi), %ymm3
; X64-NEXT:    vextractf128 $1, %ymm1, %xmm4
; X64-NEXT:    vextracti128 $1, %ymm0, %xmm5
; X64-NEXT:    vgatherqps %xmm5, (,%ymm3), %xmm4
; X64-NEXT:    vgatherqps %xmm0, (,%ymm2), %xmm1
; X64-NEXT:    vinsertf128 $1, %xmm4, %ymm1, %ymm0
; X64-NEXT:    retq
entry:
  %ld  = load <8 x float*>, <8 x float*>* %ptr
  %res = call <8 x float> @llvm.masked.gather.v8float(<8 x float*> %ld, i32 0, <8 x i1> %masks, <8 x float> %passthro)
  ret <8 x float> %res
}

declare <4 x i64> @llvm.masked.gather.v4i64(<4 x i64*> %ptrs, i32 %align, <4 x i1> %masks, <4 x i64> %passthro)

define <4 x i64> @masked_gather_v4i64(<4 x i64*>* %ptr, <4 x i1> %masks, <4 x i64> %passthro) {
; X86-LABEL: masked_gather_v4i64:
; X86:       # BB#0: # %entry
; X86-NEXT:    vpslld $31, %xmm0, %xmm0
; X86-NEXT:    vpsrad $31, %xmm0, %xmm0
; X86-NEXT:    vpmovsxdq %xmm0, %ymm0
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovdqa (%eax), %xmm2
; X86-NEXT:    vpgatherdq %ymm0, (,%xmm2), %ymm1
; X86-NEXT:    vmovdqa %ymm1, %ymm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v4i64:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpslld $31, %xmm0, %xmm0
; X64-NEXT:    vpsrad $31, %xmm0, %xmm0
; X64-NEXT:    vpmovsxdq %xmm0, %ymm0
; X64-NEXT:    vmovdqa (%rdi), %ymm2
; X64-NEXT:    vpgatherqq %ymm0, (,%ymm2), %ymm1
; X64-NEXT:    vmovdqa %ymm1, %ymm0
; X64-NEXT:    retq
entry:
  %ld  = load <4 x i64*>, <4 x i64*>* %ptr
  %res = call <4 x i64> @llvm.masked.gather.v4i64(<4 x i64*> %ld, i32 0, <4 x i1> %masks, <4 x i64> %passthro)
  ret <4 x i64> %res
}

declare <4 x double> @llvm.masked.gather.v4double(<4 x double*> %ptrs, i32 %align, <4 x i1> %masks, <4 x double> %passthro)

define <4 x double> @masked_gather_v4double(<4 x double*>* %ptr, <4 x i1> %masks, <4 x double> %passthro) {
; X86-LABEL: masked_gather_v4double:
; X86:       # BB#0: # %entry
; X86-NEXT:    vpslld $31, %xmm0, %xmm0
; X86-NEXT:    vpsrad $31, %xmm0, %xmm0
; X86-NEXT:    vpmovsxdq %xmm0, %ymm0
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovapd (%eax), %xmm2
; X86-NEXT:    vgatherdpd %ymm0, (,%xmm2), %ymm1
; X86-NEXT:    vmovapd %ymm1, %ymm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v4double:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpslld $31, %xmm0, %xmm0
; X64-NEXT:    vpsrad $31, %xmm0, %xmm0
; X64-NEXT:    vpmovsxdq %xmm0, %ymm0
; X64-NEXT:    vmovapd (%rdi), %ymm2
; X64-NEXT:    vgatherqpd %ymm0, (,%ymm2), %ymm1
; X64-NEXT:    vmovapd %ymm1, %ymm0
; X64-NEXT:    retq
entry:
  %ld  = load <4 x double*>, <4 x double*>* %ptr
  %res = call <4 x double> @llvm.masked.gather.v4double(<4 x double*> %ld, i32 0, <4 x i1> %masks, <4 x double> %passthro)
  ret <4 x double> %res
}

declare <2 x i64> @llvm.masked.gather.v2i64(<2 x i64*> %ptrs, i32 %align, <2 x i1> %masks, <2 x i64> %passthro)

define <2 x i64> @masked_gather_v2i64(<2 x i64*>* %ptr, <2 x i1> %masks, <2 x i64> %passthro) {
; X86-LABEL: masked_gather_v2i64:
; X86:       # BB#0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmovzxdq {{.*#+}} xmm2 = mem[0],zero,mem[1],zero
; X86-NEXT:    vpgatherqq %xmm0, (,%xmm2), %xmm1
; X86-NEXT:    vmovdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v2i64:
; X64:       # BB#0: # %entry
; X64-NEXT:    vmovdqa (%rdi), %xmm2
; X64-NEXT:    vpgatherqq %xmm0, (,%xmm2), %xmm1
; X64-NEXT:    vmovdqa %xmm1, %xmm0
; X64-NEXT:    retq
entry:
  %ld  = load <2 x i64*>, <2 x i64*>* %ptr
  %res = call <2 x i64> @llvm.masked.gather.v2i64(<2 x i64*> %ld, i32 0, <2 x i1> %masks, <2 x i64> %passthro)
  ret <2 x i64> %res
}

declare <2 x double> @llvm.masked.gather.v2double(<2 x double*> %ptrs, i32 %align, <2 x i1> %masks, <2 x double> %passthro)

define <2 x double> @masked_gather_v2double(<2 x double*>* %ptr, <2 x i1> %masks, <2 x double> %passthro) {
; X86-LABEL: masked_gather_v2double:
; X86:       # BB#0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmovzxdq {{.*#+}} xmm2 = mem[0],zero,mem[1],zero
; X86-NEXT:    vgatherqpd %xmm0, (,%xmm2), %xmm1
; X86-NEXT:    vmovapd %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v2double:
; X64:       # BB#0: # %entry
; X64-NEXT:    vmovapd (%rdi), %xmm2
; X64-NEXT:    vgatherqpd %xmm0, (,%xmm2), %xmm1
; X64-NEXT:    vmovapd %xmm1, %xmm0
; X64-NEXT:    retq
entry:
  %ld  = load <2 x double*>, <2 x double*>* %ptr
  %res = call <2 x double> @llvm.masked.gather.v2double(<2 x double*> %ld, i32 0, <2 x i1> %masks, <2 x double> %passthro)
  ret <2 x double> %res
}

