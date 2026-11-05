# Chapter 8.10.2 Algorithm Workbench

## 1. Here is a calling sequence for a procedure named AddThree that adds three doublewords (assume that the STDCALL calling convention is used):

```asm
push 10h
push 20h
push 30h
call AddThree
```

Draw a picture of the procedure’s stack frame immediately after EBP has been pushed on the runtime stack.

**한글 번역**

세 개의 더블워드를 더하는 `AddThree` 프로시저의 호출 순서가 다음과 같이 주어졌습니다(STDCALL 호출 규약 사용). 런타임 스택에 EBP를 PUSH한 직후의 스택 프레임을 그림으로 나타내시오.

**정답**

```text
높은 메모리 주소
+--------------------+
| 10h                |  [ESP+16]
+--------------------+
| 20h                |  [ESP+12]
+--------------------+
| 30h                |  [ESP+8]
+--------------------+
| 복귀 주소           |  [ESP+4]
+--------------------+
| 이전 EBP 값         |  [ESP]  <- 현재 ESP
+--------------------+
낮은 메모리 주소
```

---

## 2. Create a procedure named AddThree that receives three integer parameters and calculates and returns their sum in the EAX register.

**한글 번역**

세 개의 정수 매개변수를 전달받아 합계를 계산하고, `EAX` 레지스터에 반환하는 `AddThree` 프로시저를 작성하시오.

**정답**

```asm
AddThree PROC a:DWORD, b:DWORD, c:DWORD
    mov eax, a
    add eax, b
    add eax, c
    ret
AddThree ENDP
```

---

## 3. Declare a local variable named pArray that is a pointer to an array of doublewords.

**한글 번역**

더블워드 배열을 가리키는 포인터인 지역 변수 `pArray`를 선언하시오.

**정답**

```asm
LOCAL pArray:PTR DWORD
```

---

## 4. Declare a local variable named buffer that is an array of 20 bytes.

**한글 번역**

20바이트 배열인 지역 변수 `buffer`를 선언하시오.

**정답**

```asm
LOCAL buffer[20]:BYTE
```

---

## 5. Declare a local variable named pwArray that points to a 16-bit unsigned integer.

**한글 번역**

16비트 부호 없는 정수를 가리키는 포인터인 지역 변수 `pwArray`를 선언하시오.

**정답**

```asm
LOCAL pwArray:PTR WORD
```

---

## 6. Declare a local variable named myByte that holds an 8-bit signed integer.

**한글 번역**

8비트 부호 있는 정수를 저장하는 지역 변수 `myByte`를 선언하시오.

**정답**

```asm
LOCAL myByte:SBYTE
```

---

## 7. Declare a local variable named myArray that is an array of 20 doublewords.

**한글 번역**

20개의 더블워드로 구성된 배열인 지역 변수 `myArray`를 선언하시오.

**정답**

```asm
LOCAL myArray[20]:DWORD
```

---

## 8. Create a procedure named SetColor that receives two stack parameters: forecolor and backcolor, and calls the SetTextColor procedure from the Irvine32 library.

**한글 번역**

스택 매개변수 `forecolor`(전경색)와 `backcolor`(배경색)를 전달받아 Irvine32 라이브러리의 `SetTextColor` 프로시저를 호출하는 `SetColor` 프로시저를 작성하시오.

**정답**

```asm
SetColor PROC USES eax edx,
    forecolor:DWORD, backcolor:DWORD

    mov eax, backcolor
    and eax, 0Fh
    shl eax, 4
    mov edx, forecolor
    and edx, 0Fh
    or  eax, edx
    call SetTextColor
    ret
SetColor ENDP
```

---

## 9. Create a procedure named WriteColorChar that receives three stack parameters: char, forecolor, and backcolor. It displays a single character using the color attributes specified in forecolor and backcolor.

**한글 번역**

스택 매개변수 `char`(문자), `forecolor`(전경색), `backcolor`(배경색)를 전달받는 `WriteColorChar` 프로시저를 작성하시오. 지정된 전경색과 배경색으로 문자 하나를 출력해야 합니다.

**정답**

```asm
; 8번의 SetColor 프로시저를 함께 사용
WriteColorChar PROC USES eax,
    char:BYTE, forecolor:DWORD, backcolor:DWORD

    INVOKE SetColor, forecolor, backcolor
    mov al, char
    call WriteChar
    ret
WriteColorChar ENDP
```

---

## 10. Write a procedure named DumpMemory that encapsulates the DumpMem procedure in the Irvine32 library. Use declared parameters and the USES directive. The following is an example of how it should be called: INVOKE DumpMemory, OFFSET array, LENGTHOF array, TYPE array.

**한글 번역**

Irvine32 라이브러리의 `DumpMem` 프로시저를 감싸는 `DumpMemory` 프로시저를 작성하시오. 선언된 매개변수와 `USES` 지시어를 사용해야 합니다. 다음과 같이 호출할 수 있어야 합니다: `INVOKE DumpMemory, OFFSET array, LENGTHOF array, TYPE array`.

**정답**

```asm
DumpMemory PROTO, pArray:PTR BYTE, count:DWORD, unitSize:DWORD

DumpMemory PROC USES esi ecx ebx,
    pArray:PTR BYTE, count:DWORD, unitSize:DWORD

    mov esi, pArray
    mov ecx, count
    mov ebx, unitSize
    call DumpMem
    ret
DumpMemory ENDP


```

---

## 11. Declare a procedure named MultArray that receives two pointers to arrays of doublewords, and a third parameter indicating the number of array elements. Also, create a PROTO declaration for this procedure.

**한글 번역**

더블워드 배열을 가리키는 포인터 두 개와 배열 요소의 개수를 나타내는 세 번째 매개변수를 전달받는 `MultArray` 프로시저를 선언하시오. 또한 이 프로시저에 대한 `PROTO` 선언을 작성하시오.

**정답**

```asm
MultArray PROTO,
    pArray1:PTR DWORD, pArray2:PTR DWORD, count:DWORD

MultArray PROC,
    pArray1:PTR DWORD, pArray2:PTR DWORD, count:DWORD
    ; 프로시저 선언 예시: 실제 연산 내용은 문제에서 요구하지 않음
    ret
MultArray ENDP
```

---
