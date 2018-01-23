; ModuleID = 'random.c'
source_filename = "random.c"
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@holdrand = internal global i32 0, align 4

; Function Attrs: noinline nounwind
define void @srand(i32) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  store i32 %3, i32* @holdrand, align 4
  ret void
}

; Function Attrs: noinline nounwind
define i32 @rand() #0 {
  %1 = load i32, i32* @holdrand, align 4
  %2 = mul nsw i32 %1, 214013
  %3 = add nsw i32 %2, 2531011
  store i32 %3, i32* @holdrand, align 4
  %4 = ashr i32 %3, 16
  %5 = and i32 %4, 32767
  ret i32 %5
}

attributes #0 = { noinline nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"}
