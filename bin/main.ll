
@gvar = common global i32 0

declare void @putChar(i32)

declare i32 @getChar()

define void @print(i32 %sym) {
entry:
  %0 = alloca i32
  %1 = load i32* %0
  call void @putChar(i32 %1)
  ret void
}

define i32 @main() {
entry:
  call void @print(i32 61)
  call void @print(i32 65)
  ret i32 0
}
