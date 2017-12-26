; ModuleID = 'real_test.cpp'
source_filename = "real_test.cpp"
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

; Function Attrs: norecurse nounwind readnone
define i32 @_Z3modii(i32, i32) local_unnamed_addr #0 {
  br label %3

; <label>:3:                                      ; preds = %3, %2
  %4 = phi i32 [ %0, %2 ], [ %6, %3 ]
  %5 = icmp sgt i32 %4, %1
  %6 = sub nsw i32 %4, %1
  br i1 %5, label %3, label %7

; <label>:7:                                      ; preds = %3
  ret i32 %4
}

; Function Attrs: norecurse nounwind readnone
define i32 @_Z4sqrti(i32) local_unnamed_addr #0 {
  br label %2

; <label>:2:                                      ; preds = %2, %1
  %3 = phi i32 [ 0, %1 ], [ %6, %2 ]
  %4 = mul nsw i32 %3, %3
  %5 = icmp sgt i32 %4, %0
  %6 = add nuw nsw i32 %3, 1
  br i1 %5, label %7, label %2

; <label>:7:                                      ; preds = %2
  %8 = add nsw i32 %3, -1
  ret i32 %8
}

; Function Attrs: norecurse nounwind readnone
define i32 @_Z7isdigitc(i8 signext) local_unnamed_addr #0 {
  %2 = add i8 %0, -48
  %3 = icmp ult i8 %2, 10
  %4 = zext i1 %3 to i32
  ret i32 %4
}

; Function Attrs: norecurse nounwind readonly
define i32 @_Z4atoiPc(i8* nocapture readonly) local_unnamed_addr #1 {
  %2 = load i8, i8* %0, align 1, !tbaa !1
  %3 = add i8 %2, -48
  %4 = icmp ult i8 %3, 10
  br i1 %4, label %5, label %19

; <label>:5:                                      ; preds = %1
  br label %6

; <label>:6:                                      ; preds = %5, %6
  %7 = phi i8 [ %15, %6 ], [ %2, %5 ]
  %8 = phi i32 [ %14, %6 ], [ 0, %5 ]
  %9 = phi i8* [ %11, %6 ], [ %0, %5 ]
  %10 = mul nsw i32 %8, 10
  %11 = getelementptr inbounds i8, i8* %9, i32 1
  %12 = sext i8 %7 to i32
  %13 = add i32 %10, -48
  %14 = add i32 %13, %12
  %15 = load i8, i8* %11, align 1, !tbaa !1
  %16 = add i8 %15, -48
  %17 = icmp ult i8 %16, 10
  br i1 %17, label %6, label %18

; <label>:18:                                     ; preds = %6
  br label %19

; <label>:19:                                     ; preds = %18, %1
  %20 = phi i32 [ 0, %1 ], [ %14, %18 ]
  ret i32 %20
}

; Function Attrs: norecurse nounwind readonly
define i32 @main(i32, i8** nocapture readonly) local_unnamed_addr #1 {
  %3 = getelementptr inbounds i8*, i8** %1, i32 1
  %4 = load i8*, i8** %3, align 4, !tbaa !4
  %5 = load i8, i8* %4, align 1, !tbaa !1
  %6 = add i8 %5, -48
  %7 = icmp ult i8 %6, 10
  br i1 %7, label %8, label %22

; <label>:8:                                      ; preds = %2
  br label %9

; <label>:9:                                      ; preds = %8, %9
  %10 = phi i8 [ %18, %9 ], [ %5, %8 ]
  %11 = phi i32 [ %17, %9 ], [ 0, %8 ]
  %12 = phi i8* [ %14, %9 ], [ %4, %8 ]
  %13 = mul nsw i32 %11, 10
  %14 = getelementptr inbounds i8, i8* %12, i32 1
  %15 = sext i8 %10 to i32
  %16 = add nsw i32 %15, -48
  %17 = add i32 %16, %13
  %18 = load i8, i8* %14, align 1, !tbaa !1
  %19 = add i8 %18, -48
  %20 = icmp ult i8 %19, 10
  br i1 %20, label %9, label %21

; <label>:21:                                     ; preds = %9
  br label %22

; <label>:22:                                     ; preds = %21, %2
  %23 = phi i32 [ 0, %2 ], [ %17, %21 ]
  br label %24

; <label>:24:                                     ; preds = %24, %22
  %25 = phi i32 [ 0, %22 ], [ %28, %24 ]
  %26 = mul nsw i32 %25, %25
  %27 = icmp sgt i32 %26, %23
  %28 = add nuw nsw i32 %25, 1
  br i1 %27, label %29, label %24

; <label>:29:                                     ; preds = %24
  %30 = add nsw i32 %25, -1
  ret i32 %30
}

attributes #0 = { norecurse nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { norecurse nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"}
!1 = !{!2, !2, i64 0}
!2 = !{!"omnipotent char", !3, i64 0}
!3 = !{!"Simple C++ TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"any pointer", !2, i64 0}
