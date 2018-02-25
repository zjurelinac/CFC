; ModuleID = 'strfails.c'
source_filename = "strfails.c"
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

; Function Attrs: norecurse nounwind readonly
define i32 @strcmp(i8* nocapture readonly, i8* nocapture readonly) local_unnamed_addr #0 {
  %3 = load i8, i8* %0, align 1, !tbaa !1
  %4 = icmp eq i8 %3, 0
  br i1 %4, label %22, label %5

; <label>:5:                                      ; preds = %2
  br label %6

; <label>:6:                                      ; preds = %5, %14
  %7 = phi i8 [ %17, %14 ], [ %3, %5 ]
  %8 = phi i8* [ %16, %14 ], [ %1, %5 ]
  %9 = phi i8* [ %15, %14 ], [ %0, %5 ]
  %10 = load i8, i8* %8, align 1, !tbaa !1
  %11 = icmp eq i8 %7, %10
  %12 = icmp ne i8 %10, 0
  %13 = and i1 %11, %12
  br i1 %13, label %14, label %19

; <label>:14:                                     ; preds = %6
  %15 = getelementptr inbounds i8, i8* %9, i32 1
  %16 = getelementptr inbounds i8, i8* %8, i32 1
  %17 = load i8, i8* %15, align 1, !tbaa !1
  %18 = icmp eq i8 %17, 0
  br i1 %18, label %19, label %6

; <label>:19:                                     ; preds = %14, %6
  %20 = phi i8* [ %16, %14 ], [ %8, %6 ]
  %21 = phi i8 [ 0, %14 ], [ %7, %6 ]
  br label %22

; <label>:22:                                     ; preds = %19, %2
  %23 = phi i8* [ %1, %2 ], [ %20, %19 ]
  %24 = phi i8 [ 0, %2 ], [ %21, %19 ]
  %25 = load i8, i8* %23, align 1, !tbaa !1
  %26 = icmp eq i8 %24, %25
  %27 = icmp slt i8 %24, %25
  %28 = select i1 %27, i32 -1, i32 1
  %29 = select i1 %26, i32 0, i32 %28
  ret i32 %29
}

; Function Attrs: norecurse nounwind readonly
define i32 @atoi(i8* nocapture readonly) local_unnamed_addr #0 {
  %2 = load i8, i8* %0, align 1, !tbaa !1
  %3 = sext i8 %2 to i32
  %4 = add nsw i32 %3, -48
  %5 = icmp ult i32 %4, 10
  br i1 %5, label %6, label %17

; <label>:6:                                      ; preds = %1
  %7 = load i8, i8* %0, align 1, !tbaa !1
  %8 = sext i8 %7 to i32
  %9 = add nsw i32 %8, -48
  %10 = icmp ult i32 %9, 10
  br label %11

; <label>:11:                                     ; preds = %6, %11
  %12 = phi i32 [ %4, %6 ], [ %9, %11 ]
  %13 = phi i32 [ 0, %6 ], [ %15, %11 ]
  %14 = mul i32 %13, 10
  %15 = add nsw i32 %12, %14
  br i1 %10, label %11, label %16

; <label>:16:                                     ; preds = %11
  br label %17

; <label>:17:                                     ; preds = %16, %1
  %18 = phi i32 [ 0, %1 ], [ %15, %16 ]
  ret i32 %18
}

; Function Attrs: norecurse nounwind
define void @memcpy(i8* nocapture, i8* nocapture readonly, i32) local_unnamed_addr #1 {
  %4 = icmp sgt i32 %2, 0
  br i1 %4, label %5, label %7

; <label>:5:                                      ; preds = %3
  br label %8

; <label>:6:                                      ; preds = %8
  br label %7

; <label>:7:                                      ; preds = %6, %3
  ret void

; <label>:8:                                      ; preds = %5, %8
  %9 = phi i32 [ %13, %8 ], [ 0, %5 ]
  %10 = phi i8* [ %14, %8 ], [ %1, %5 ]
  %11 = phi i8* [ %15, %8 ], [ %0, %5 ]
  %12 = load i8, i8* %10, align 1, !tbaa !1
  store i8 %12, i8* %11, align 1, !tbaa !1
  %13 = add nuw nsw i32 %9, 1
  %14 = getelementptr inbounds i8, i8* %10, i32 1
  %15 = getelementptr inbounds i8, i8* %11, i32 1
  %16 = icmp eq i32 %13, %2
  br i1 %16, label %6, label %8
}

attributes #0 = { norecurse nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { norecurse nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"}
!1 = !{!2, !2, i64 0}
!2 = !{!"omnipotent char", !3, i64 0}
!3 = !{!"Simple C/C++ TBAA"}
