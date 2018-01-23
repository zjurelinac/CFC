; ModuleID = 'struct.c'
source_filename = "struct.c"
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

%struct.pair = type { i32, i32 }

; Function Attrs: norecurse nounwind readonly
define i32 @same(%struct.pair* nocapture readonly) local_unnamed_addr #0 {
  %2 = getelementptr inbounds %struct.pair, %struct.pair* %0, i32 0, i32 0
  %3 = load i32, i32* %2, align 4, !tbaa !1
  %4 = getelementptr inbounds %struct.pair, %struct.pair* %0, i32 0, i32 1
  %5 = load i32, i32* %4, align 4, !tbaa !6
  %6 = icmp eq i32 %3, %5
  %7 = zext i1 %6 to i32
  ret i32 %7
}

; Function Attrs: norecurse nounwind
define void @inc_fst(%struct.pair* nocapture) local_unnamed_addr #1 {
  %2 = getelementptr inbounds %struct.pair, %struct.pair* %0, i32 0, i32 0
  %3 = load i32, i32* %2, align 4, !tbaa !1
  %4 = add nsw i32 %3, 1
  store i32 %4, i32* %2, align 4, !tbaa !1
  ret void
}

; Function Attrs: norecurse nounwind
define void @inc_snd(%struct.pair* nocapture) local_unnamed_addr #1 {
  %2 = getelementptr inbounds %struct.pair, %struct.pair* %0, i32 0, i32 1
  %3 = load i32, i32* %2, align 4, !tbaa !6
  %4 = add nsw i32 %3, 1
  store i32 %4, i32* %2, align 4, !tbaa !6
  ret void
}

; Function Attrs: nounwind
define void @do_stuff(%struct.pair* noalias nocapture sret, i32, i32) local_unnamed_addr #2 {
  %4 = alloca %struct.pair, align 8
  %5 = bitcast %struct.pair* %4 to i8*
  call void @llvm.lifetime.start(i64 8, i8* nonnull %5) #4
  %6 = getelementptr inbounds %struct.pair, %struct.pair* %4, i32 0, i32 0
  store i32 %1, i32* %6, align 8, !tbaa !1
  %7 = getelementptr inbounds %struct.pair, %struct.pair* %4, i32 0, i32 1
  store i32 %2, i32* %7, align 4, !tbaa !6
  %8 = call i32 @same(%struct.pair* nonnull %4)
  %9 = icmp eq i32 %8, 0
  br i1 %9, label %11, label %10

; <label>:10:                                     ; preds = %3
  call void @inc_fst(%struct.pair* nonnull %4)
  br label %12

; <label>:11:                                     ; preds = %3
  call void @inc_snd(%struct.pair* nonnull %4)
  br label %12

; <label>:12:                                     ; preds = %11, %10
  %13 = bitcast %struct.pair* %4 to i64*
  %14 = bitcast %struct.pair* %0 to i64*
  %15 = load i64, i64* %13, align 8
  store i64 %15, i64* %14, align 4
  call void @llvm.lifetime.end(i64 8, i8* nonnull %5) #4
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #3

attributes #0 = { norecurse nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { norecurse nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { argmemonly nounwind }
attributes #4 = { nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"}
!1 = !{!2, !3, i64 0}
!2 = !{!"pair", !3, i64 0, !3, i64 4}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!2, !3, i64 4}
