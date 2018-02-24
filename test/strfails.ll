; ModuleID = 'strfails.c'
source_filename = "strfails.c"
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

; Function Attrs: noinline nounwind
define i32 @strcmp(i8*, i8*) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i8*, align 4
  %5 = alloca i8*, align 4
  store i8* %0, i8** %4, align 4
  store i8* %1, i8** %5, align 4
  br label %6

; <label>:6:                                      ; preds = %26, %2
  %7 = load i8*, i8** %4, align 4
  %8 = load i8, i8* %7, align 1
  %9 = sext i8 %8 to i32
  %10 = icmp ne i32 %9, 0
  br i1 %10, label %11, label %24

; <label>:11:                                     ; preds = %6
  %12 = load i8*, i8** %5, align 4
  %13 = load i8, i8* %12, align 1
  %14 = sext i8 %13 to i32
  %15 = icmp ne i32 %14, 0
  br i1 %15, label %16, label %24

; <label>:16:                                     ; preds = %11
  %17 = load i8*, i8** %4, align 4
  %18 = load i8, i8* %17, align 1
  %19 = sext i8 %18 to i32
  %20 = load i8*, i8** %5, align 4
  %21 = load i8, i8* %20, align 1
  %22 = sext i8 %21 to i32
  %23 = icmp eq i32 %19, %22
  br label %24

; <label>:24:                                     ; preds = %16, %11, %6
  %25 = phi i1 [ false, %11 ], [ false, %6 ], [ %23, %16 ]
  br i1 %25, label %26, label %31

; <label>:26:                                     ; preds = %24
  %27 = load i8*, i8** %4, align 4
  %28 = getelementptr inbounds i8, i8* %27, i32 1
  store i8* %28, i8** %4, align 4
  %29 = load i8*, i8** %5, align 4
  %30 = getelementptr inbounds i8, i8* %29, i32 1
  store i8* %30, i8** %5, align 4
  br label %6

; <label>:31:                                     ; preds = %24
  %32 = load i8*, i8** %4, align 4
  %33 = load i8, i8* %32, align 1
  %34 = sext i8 %33 to i32
  %35 = load i8*, i8** %5, align 4
  %36 = load i8, i8* %35, align 1
  %37 = sext i8 %36 to i32
  %38 = icmp eq i32 %34, %37
  br i1 %38, label %39, label %40

; <label>:39:                                     ; preds = %31
  store i32 0, i32* %3, align 4
  br label %50

; <label>:40:                                     ; preds = %31
  %41 = load i8*, i8** %4, align 4
  %42 = load i8, i8* %41, align 1
  %43 = sext i8 %42 to i32
  %44 = load i8*, i8** %5, align 4
  %45 = load i8, i8* %44, align 1
  %46 = sext i8 %45 to i32
  %47 = icmp slt i32 %43, %46
  br i1 %47, label %48, label %49

; <label>:48:                                     ; preds = %40
  store i32 -1, i32* %3, align 4
  br label %50

; <label>:49:                                     ; preds = %40
  store i32 1, i32* %3, align 4
  br label %50

; <label>:50:                                     ; preds = %49, %48, %39
  %51 = load i32, i32* %3, align 4
  ret i32 %51
}

; Function Attrs: noinline nounwind
define i32 @atoi(i8*) #0 {
  %2 = alloca i8*, align 4
  %3 = alloca i32, align 4
  %4 = alloca i8, align 1
  %5 = alloca i32, align 4
  store i8* %0, i8** %2, align 4
  store i32 0, i32* %3, align 4
  br label %6

; <label>:6:                                      ; preds = %12, %1
  %7 = load i8*, i8** %2, align 4
  %8 = load i8, i8* %7, align 1
  %9 = sext i8 %8 to i32
  %10 = call i32 @isdigit(i32 %9) #2
  %11 = icmp ne i32 %10, 0
  br i1 %11, label %12, label %25

; <label>:12:                                     ; preds = %6
  %13 = load i8*, i8** %2, align 4
  %14 = load i8, i8* %13, align 1
  store i8 %14, i8* %4, align 1
  %15 = load i8, i8* %4, align 1
  %16 = sext i8 %15 to i32
  %17 = sub nsw i32 %16, 48
  store i32 %17, i32* %5, align 4
  %18 = load i32, i32* %3, align 4
  %19 = shl i32 %18, 3
  %20 = load i32, i32* %3, align 4
  %21 = shl i32 %20, 1
  %22 = add nsw i32 %19, %21
  %23 = load i32, i32* %5, align 4
  %24 = add nsw i32 %22, %23
  store i32 %24, i32* %3, align 4
  br label %6

; <label>:25:                                     ; preds = %6
  %26 = load i32, i32* %3, align 4
  ret i32 %26
}

; Function Attrs: nounwind readonly
declare i32 @isdigit(i32) #1

; Function Attrs: noinline nounwind
define void @memcpy(i8*, i8*, i32) #0 {
  %4 = alloca i8*, align 4
  %5 = alloca i8*, align 4
  %6 = alloca i32, align 4
  %7 = alloca i8*, align 4
  %8 = alloca i8*, align 4
  %9 = alloca i32, align 4
  store i8* %0, i8** %4, align 4
  store i8* %1, i8** %5, align 4
  store i32 %2, i32* %6, align 4
  %10 = load i8*, i8** %4, align 4
  store i8* %10, i8** %7, align 4
  %11 = load i8*, i8** %5, align 4
  store i8* %11, i8** %8, align 4
  store i32 0, i32* %9, align 4
  br label %12

; <label>:12:                                     ; preds = %20, %3
  %13 = load i32, i32* %9, align 4
  %14 = load i32, i32* %6, align 4
  %15 = icmp slt i32 %13, %14
  br i1 %15, label %16, label %27

; <label>:16:                                     ; preds = %12
  %17 = load i8*, i8** %8, align 4
  %18 = load i8, i8* %17, align 1
  %19 = load i8*, i8** %7, align 4
  store i8 %18, i8* %19, align 1
  br label %20

; <label>:20:                                     ; preds = %16
  %21 = load i32, i32* %9, align 4
  %22 = add nsw i32 %21, 1
  store i32 %22, i32* %9, align 4
  %23 = load i8*, i8** %8, align 4
  %24 = getelementptr inbounds i8, i8* %23, i32 1
  store i8* %24, i8** %8, align 4
  %25 = load i8*, i8** %7, align 4
  %26 = getelementptr inbounds i8, i8* %25, i32 1
  store i8* %26, i8** %7, align 4
  br label %12

; <label>:27:                                     ; preds = %12
  ret void
}

attributes #0 = { noinline nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readonly }

!llvm.ident = !{!0}

!0 = !{!"clang version 4.0.0-1ubuntu1~16.04.2 (tags/RELEASE_400/rc1)"}
