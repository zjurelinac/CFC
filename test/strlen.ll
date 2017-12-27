; ModuleID = 'strlen.c'
source_filename = "strlen.c"
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

; Function Attrs: norecurse nounwind readonly
define i32 @strlen(i8* nocapture readonly) local_unnamed_addr #0 {
  %2 = load i8, i8* %0, align 1, !tbaa !2
  %3 = icmp eq i8 %2, 0
  br i1 %3, label %13, label %4

; <label>:4:                                      ; preds = %1
  br label %5

; <label>:5:                                      ; preds = %4, %5
  %6 = phi i32 [ %9, %5 ], [ 0, %4 ]
  %7 = phi i8* [ %8, %5 ], [ %0, %4 ]
  %8 = getelementptr inbounds i8, i8* %7, i32 1
  %9 = add nuw nsw i32 %6, 1
  %10 = load i8, i8* %8, align 1, !tbaa !2
  %11 = icmp eq i8 %10, 0
  br i1 %11, label %12, label %5

; <label>:12:                                     ; preds = %5
  br label %13

; <label>:13:                                     ; preds = %12, %1
  %14 = phi i32 [ 0, %1 ], [ %9, %12 ]
  ret i32 %14
}

attributes #0 = { norecurse nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"NumRegisterParameters", i32 0}
!1 = !{!"clang version 4.0.1-6 (tags/RELEASE_401/final)"}
!2 = !{!3, !3, i64 0}
!3 = !{!"omnipotent char", !4, i64 0}
!4 = !{!"Simple C/C++ TBAA"}
