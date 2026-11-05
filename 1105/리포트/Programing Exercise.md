# Programing Exercise

## 1. FindLargest Procedure

### 영문 문제

Create a procedure named FindLargest that receives two parameters: a pointer to a signed doubleword array, and a count of the array’s length. The procedure must return the value of the largest array member in EAX. Use the PROC directive with a parameter list when declaring the procedure. Preserve all registers (except EAX) that are modified by the procedure. Write a test program that calls FindLargest and passes three different arrays of different lengths. Be sure to include negative values in your arrays. Create a PROTO declaration for FindLargest.

### 한글 번역

부호 있는 더블워드(SDWORD) 배열의 주소와 배열의 길이(원소 개수)를 매개변수로 받는 `FindLargest` 프로시저를 작성하시오. 프로시저는 배열에서 가장 큰 값을 찾아 `EAX` 레지스터에 반환해야 합니다.

프로시저를 선언할 때는 매개변수 목록이 포함된 `PROC` 지시어를 사용하고, `EAX`를 제외하고 프로시저에서 변경하는 모든 레지스터를 보존하시오. 길이가 서로 다른 배열 세 개를 전달하여 테스트하는 프로그램을 작성하시오. 배열에 음수 값도 포함하고, `FindLargest`에 대한 `PROTO` 선언도 작성하시오.

### 어셈블리 코드

```asm
TITLE FindLargest Procedure
INCLUDE Irvine32.inc

FindLargest PROTO, pArray:PTR SDWORD, arraySize:DWORD

.data
array1 SDWORD 14, -7, 86, 32, -55
array2 SDWORD -12, -44, -3, -100
array3 SDWORD 9, 25, -80, 210, 12, 45, 199, 31

msg1 BYTE "Array 1 largest: ", 0
msg2 BYTE "Array 2 largest: ", 0
msg3 BYTE "Array 3 largest: ", 0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString
    INVOKE FindLargest, ADDR array1, LENGTHOF array1
    call WriteInt
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    INVOKE FindLargest, ADDR array2, LENGTHOF array2
    call WriteInt
    call Crlf

    mov edx, OFFSET msg3
    call WriteString
    INVOKE FindLargest, ADDR array3, LENGTHOF array3
    call WriteInt
    call Crlf

    exit
main ENDP

; pArray: SDWORD 배열의 주소
; arraySize: 배열 원소 개수
; 반환값: EAX = 배열에서 가장 큰 값
FindLargest PROC USES esi ecx, pArray:PTR SDWORD, arraySize:DWORD
    mov esi, pArray
    mov ecx, arraySize
    test ecx, ecx
    jz EmptyArray

    mov eax, [esi]
    dec ecx
    jz Done

L1:
    add esi, 4
    cmp eax, [esi]
    jge NextElement       ; 부호 있는 정수 비교
    mov eax, [esi]

NextElement:
    loop L1
    jmp Done

EmptyArray:
    xor eax, eax          ; 원소가 0개라면 0 반환(추가 처리)

Done:
    ret
FindLargest ENDP

END main
```

### 예상 실행 결과

```text
Array 1 largest: +86
Array 2 largest: -3
Array 3 largest: +210
```

> Irvine32 라이브러리의 `WriteInt`는 부호 있는 정수를 출력하므로 양수 앞에 `+` 기호가 표시된다.


## 2. Chess Board

### 영문 문제

Write a program that draws an 8 X 8 chess board, with alternating gray and white squares. You can use the SetTextColor and Gotoxy procedures from the Irvine32 library. Avoid the use of global variables, and use declared parameters in all procedures. Use short procedures that are focused on a single task.

### 한글 번역

회색(gray)과 흰색(white) 칸이 번갈아 나타나는 **8 × 8 체스판**을 화면에 그리는 프로그램을 작성하시오.

Irvine32 라이브러리의 `SetTextColor`, `Gotoxy` 프로시저를 사용할 수 있습니다. 전역 변수의 사용을 피하고, 매개변수가 필요한 모든 프로시저에 **선언된 매개변수**를 사용하시오. 각 프로시저는 하나의 작업만 담당하도록 짧게 작성하시오.

### 어셈블리 코드

```asm
TITLE Chess Board
INCLUDE Irvine32.inc

DrawRow PROTO, rowNum:DWORD
DrawSquare PROTO, squareColor:DWORD

.code
main PROC
    call Clrscr
    call DrawBoard

    ; 기본 글자색으로 복구
    mov eax, lightGray + (black * 16)
    call SetTextColor
    call Crlf

    exit
main ENDP

; 8개 행을 그림 (각 행은 2줄 높이)
DrawBoard PROC USES ebx
    mov ebx, 0
L1:
    INVOKE DrawRow, ebx
    INVOKE DrawRow, ebx
    inc ebx
    cmp ebx, 8
    jb L1
    ret
DrawBoard ENDP

; 한 행에 8개의 칸을 그림
DrawRow PROC USES ebx esi, rowNum:DWORD
    mov esi, 0
L2:
    mov eax, rowNum
    add eax, esi
    and eax, 1
    jz GraySquare

    INVOKE DrawSquare, white
    jmp NextSquare

GraySquare:
    INVOKE DrawSquare, gray

NextSquare:
    inc esi
    cmp esi, 8
    jb L2

    call Crlf
    ret
DrawRow ENDP

; 지정된 배경색으로 공백 4개를 출력
DrawSquare PROC USES eax ebx esi, squareColor:DWORD
    mov eax, squareColor
    shl eax, 4              ; 배경색을 상위 4비트에 지정
    call SetTextColor

    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    ret
DrawSquare ENDP

END main
```

### 실행 결과 (예상)

실제 콘솔에는 색이 지정된 **공백 문자**가 출력되어 회색과 흰색 사각형이 나타난다. 아래는 각 칸을 기호 하나로 줄여 나타낸 **8 × 8 배치도** (`░`: 회색, `□`: 흰색).

```text
░ □ ░ □ ░ □ ░ □
□ ░ □ ░ □ ░ □ ░
░ □ ░ □ ░ □ ░ □
□ ░ □ ░ □ ░ □ ░
░ □ ░ □ ░ □ ░ □
□ ░ □ ░ □ ░ □ ░
░ □ ░ □ ░ □ ░ □
□ ░ □ ░ □ ░ □ ░
```

실제 한 칸은 가로 4개의 문자 폭, 세로 2줄 높이로 출력되므로 전체 체스판은 **가로 32칸 × 세로 16줄**이다.


## 3. Chess Board with Alternating Colors

### 영문 문제

This exercise extends Exercise 2. Every 500 milliseconds, change the color of the colored squares and redisplay the board. Continue until you have shown the board 16 times, using all possible 4-bit background colors. (The white squares remain white throughout.)

### 한글 번역

이 문제는 2번 연습문제를 확장한 것입니다. 500밀리초마다 색깔이 있는 칸의 배경색을 변경하고 체스판을 다시 그리시오. 4비트로 표현할 수 있는 **16가지 모든 배경색**을 사용하여 체스판을 **총 16번** 표시할 때까지 반복하시오. **흰색 칸은 전체 과정에서 계속 흰색**으로 유지되어야 합니다.

### 어셈블리 코드

```asm
TITLE Chess Board with Alternating Colors
INCLUDE Irvine32.inc

DrawBoard PROTO, squareColor:DWORD
DrawRow PROTO, rowNum:DWORD, squareColor:DWORD
DrawSquare PROTO, squareColor:DWORD

.code
main PROC
    call Clrscr
    mov ebx, 0                  ; 배경색: 0 ~ 15

NextColor:
    mov dl, 0
    mov dh, 0
    call Gotoxy                 ; 체스판을 같은 위치에 다시 그림

    INVOKE DrawBoard, ebx

    mov eax, 500
    call Delay                  ; 500ms 대기

    inc ebx
    cmp ebx, 16
    jb NextColor

    mov eax, lightGray + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 16
    call Gotoxy
    exit
main ENDP

; 전체 8행을 그림 (각 행은 2줄 높이)
DrawBoard PROC USES ebx, squareColor:DWORD
    mov ebx, 0

L1:
    INVOKE DrawRow, ebx, squareColor
    INVOKE DrawRow, ebx, squareColor
    inc ebx
    cmp ebx, 8
    jb L1

    ret
DrawBoard ENDP

; 한 행의 8칸을 번갈아 다른 색으로 그림
DrawRow PROC USES ebx, rowNum:DWORD, squareColor:DWORD
    mov ebx, 0

L2:
    mov eax, rowNum
    add eax, ebx
    test eax, 1
    jnz WhiteSquare

    INVOKE DrawSquare, squareColor
    jmp NextSquare

WhiteSquare:
    INVOKE DrawSquare, white

NextSquare:
    inc ebx
    cmp ebx, 8
    jb L2

    call Crlf
    ret
DrawRow ENDP

; 지정된 배경색으로 공백 문자 4개 출력
DrawSquare PROC USES eax, squareColor:DWORD
    mov eax, squareColor
    shl eax, 4
    call SetTextColor

    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar

    ret
DrawSquare ENDP

END main
```

### 실행 결과 (예상)

콘솔의 **같은 위치**에 8×8 체스판을 500ms 간격으로 총 16번 다시 그린다.  
색상이 변하는 칸은 다음 순서로 바뀌고, 나머지 칸은 항상 흰색이다.  

| 표시 순서 | 변경되는 칸의 배경색 (0~15) |
|---:|---|
| 1 | 0: black (검정) |
| 2 | 1: blue (파랑) |
| 3 | 2: green (초록) |
| 4 | 3: cyan (청록) |
| 5 | 4: red (빨강) |
| 6 | 5: magenta (자홍) |
| 7 | 6: brown (갈색) |
| 8 | 7: lightGray (밝은 회색) |
| 9 | 8: gray (회색) |
| 10 | 9: lightBlue (밝은 파랑) |
| 11 | 10: lightGreen (밝은 초록) |
| 12 | 11: lightCyan (밝은 청록) |
| 13 | 12: lightRed (밝은 빨강) |
| 14 | 13: lightMagenta (밝은 자홍) |
| 15 | 14: yellow (노랑) |
| 16 | 15: white (흰색) |

색상 패턴은 8×8이며, 각 칸을 공백 4개×2줄 크기로 출력한다. 마지막 16번째 화면에서는 모든 칸이 흰색으로 보인다.

### 핵심 설명

- `EBX`: 배경색 코드(0~15)를 순서대로 전달한다.
- `Gotoxy`: 출력 위치를 (0, 0)으로 이동하여 같은 장소에 체스판을 다시 그린다.
- `Delay`: 각 체스판을 500ms 동안 표시한다.
- `rowNum + 열 번호`의 짝홀로 번갈아 바뀌는 칸을 결정한다.
- `SetTextColor`: 배경색은 `색상 값 << 4`로 지정한다.
- `DrawBoard`, `DrawRow`, `DrawSquare`는 선언된 매개변수를 사용하며 전역 변수가 없다.


## 4. FindThrees Procedure

### 영문 문제

Create a procedure named FindThrees that returns 1 if an array has three consecutive values of 3 somewhere in the array. Otherwise, return 0. The procedure’s input parameter list contains a pointer to the array and the array’s size. Use the PROC directive with a parameter list when declaring the procedure. Preserve all registers (except EAX) that are modified by the procedure. Write a test program that calls FindThrees several times with different arrays.

### 한글 번역

배열 내부에 값이 **3인 원소가 연속하여 3개** 존재하면 `1`, 그렇지 않으면 `0`을 반환하는 `FindThrees` 프로시저를 작성하시오.

프로시저는 **배열의 주소**와 **배열의 원소 개수**를 매개변수로 받으며, 매개변수 목록을 포함하는 `PROC` 지시어로 선언해야 합니다. `EAX`를 제외하고 프로시저가 변경하는 모든 레지스터를 보존하시오. 서로 다른 배열을 여러 번 전달하는 테스트 프로그램도 작성하시오.

### 어셈블리 코드

```asm
TITLE FindThrees Procedure
INCLUDE Irvine32.inc

FindThrees PROTO, pArray:PTR SDWORD, arraySize:DWORD

.data
array1 SDWORD 1, 3, 3, 3, 5
array2 SDWORD 3, 3, 2, 3, 3
array3 SDWORD -5, 8, 0, 3, 3, 3
array4 SDWORD 3, 3

msg1 BYTE "Array 1: ", 0
msg2 BYTE "Array 2: ", 0
msg3 BYTE "Array 3: ", 0
msg4 BYTE "Array 4: ", 0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString
    INVOKE FindThrees, ADDR array1, LENGTHOF array1
    call WriteDec
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    INVOKE FindThrees, ADDR array2, LENGTHOF array2
    call WriteDec
    call Crlf

    mov edx, OFFSET msg3
    call WriteString
    INVOKE FindThrees, ADDR array3, LENGTHOF array3
    call WriteDec
    call Crlf

    mov edx, OFFSET msg4
    call WriteString
    INVOKE FindThrees, ADDR array4, LENGTHOF array4
    call WriteDec
    call Crlf

    exit
main ENDP

; pArray = 배열의 주소
; arraySize = 배열의 원소 개수
; EAX = 연속된 3이 세 개 있으면 1, 아니면 0
FindThrees PROC USES esi ecx,
    pArray:PTR SDWORD,
    arraySize:DWORD

    mov esi, pArray
    mov ecx, arraySize
    xor eax, eax

    cmp ecx, 3
    jb Done
    sub ecx, 2

L1:
    cmp DWORD PTR [esi], 3
    jne NextElement
    cmp DWORD PTR [esi+4], 3
    jne NextElement
    cmp DWORD PTR [esi+8], 3
    jne NextElement

    mov eax, 1
    jmp Done

NextElement:
    add esi, 4
    loop L1

Done:
    ret
FindThrees ENDP

END main
```

### 실행 결과 (예상)

```text
Array 1: 1
Array 2: 0
Array 3: 1
Array 4: 0
```

## 5. DifferentInputs Procedure

### 영문 문제

Write a procedure named DifferentInputs that returns EAX = 1 if the values of its three input parameters are all different; otherwise, return with EAX = 0. Use the PROC directive with a parameter list when declaring the procedure. Create a PROTO declaration for your procedure, and call it five times from a test program that passes different inputs.

### 한글 번역

세 개의 입력 매개변수가 **모두 서로 다른 값이면 EAX = 1**, 하나라도 같은 값이 있으면 **EAX = 0**을 반환하는 `DifferentInputs` 프로시저를 작성하시오.

프로시저를 선언할 때 매개변수 목록이 있는 `PROC` 지시어를 사용하고, `PROTO` 선언을 작성하시오. 서로 다른 입력값을 전달하여 테스트 프로그램에서 해당 프로시저를 다섯 번 호출하시오.

### 어셈블리 코드

```asm
TITLE DifferentInputs Procedure
INCLUDE Irvine32.inc

DifferentInputs PROTO, x:SDWORD, y:SDWORD, z:SDWORD

.data
msg1 BYTE "(1, 2, 3) = ", 0
msg2 BYTE "(4, 4, 8) = ", 0
msg3 BYTE "(7, 8, 7) = ", 0
msg4 BYTE "(-1, 5, 5) = ", 0
msg5 BYTE "(-3, 0, 9) = ", 0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString
    INVOKE DifferentInputs, 1, 2, 3
    call WriteDec
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    INVOKE DifferentInputs, 4, 4, 8
    call WriteDec
    call Crlf

    mov edx, OFFSET msg3
    call WriteString
    INVOKE DifferentInputs, 7, 8, 7
    call WriteDec
    call Crlf

    mov edx, OFFSET msg4
    call WriteString
    INVOKE DifferentInputs, -1, 5, 5
    call WriteDec
    call Crlf

    mov edx, OFFSET msg5
    call WriteString
    INVOKE DifferentInputs, -3, 0, 9
    call WriteDec
    call Crlf

    exit
main ENDP

; 세 매개변수가 모두 다르면 EAX = 1, 아니면 EAX = 0
DifferentInputs PROC x:SDWORD, y:SDWORD, z:SDWORD
    mov eax, x
    cmp eax, y
    je SameValue
    cmp eax, z
    je SameValue

    mov eax, y
    cmp eax, z
    je SameValue

    mov eax, 1
    ret

SameValue:
    xor eax, eax
    ret
DifferentInputs ENDP

END main
```

### 실행 결과 (예상)

```text
(1, 2, 3) = 1
(4, 4, 8) = 0
(7, 8, 7) = 0
(-1, 5, 5) = 0
(-3, 0, 9) = 1
```

## 6. Exchanging Integers

### 영문 문제

Create an array of randomly ordered integers. Using the Swap procedure from Section 8.4.6 as a tool, write a loop that exchanges each consecutive pair of integers in the array.

### 한글 번역

무작위 순서로 정렬된 정수 배열을 생성하시오. 8.4.6절의 `Swap` 프로시저를 사용하여, 배열에서 **연속된 두 정수씩 짝을 지어 서로 교환하는 반복문**을 작성하시오.

### 어셈블리 코드

```asm
TITLE Exchanging Integers
INCLUDE Irvine32.inc

Swap PROTO, pValX:PTR DWORD, pValY:PTR DWORD
PrintArray PROTO, pArray:PTR DWORD, arraySize:DWORD

.data
numbers DWORD 42, 7, 19, 3, 25, 88, 11, 54
msg1 BYTE "Before: ", 0
msg2 BYTE "After:  ", 0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString
    INVOKE PrintArray, ADDR numbers, LENGTHOF numbers

    mov esi, OFFSET numbers
    mov ecx, LENGTHOF numbers / 2

L1:
    lea edi, [esi+4]
    INVOKE Swap, esi, edi
    add esi, 8
    loop L1

    mov edx, OFFSET msg2
    call WriteString
    INVOKE PrintArray, ADDR numbers, LENGTHOF numbers

    exit
main ENDP

; 두 DWORD 값을 교환 (교재 8.4.6 방식)
Swap PROC USES eax esi edi,
    pValX:PTR DWORD,
    pValY:PTR DWORD

    mov esi, pValX
    mov edi, pValY
    mov eax, [esi]
    xchg eax, [edi]
    mov [esi], eax
    ret
Swap ENDP

; 배열 요소를 10진수로 출력
PrintArray PROC USES esi ecx,
    pArray:PTR DWORD,
    arraySize:DWORD

    mov esi, pArray
    mov ecx, arraySize
    test ecx, ecx
    jz Done

L2:
    push ecx
    mov eax, [esi]
    call WriteDec
    mov al, ' '
    call WriteChar
    pop ecx

    add esi, 4
    loop L2

Done:
    call Crlf
    ret
PrintArray ENDP

END main
```

### 실행 결과 (예상)

```text
Before: 42 7 19 3 25 88 11 54
After:  7 42 3 19 88 25 54 11
```


## 7. Greatest Common Divisor

### 영문 문제

Write a recursive implementation of Euclid’s algorithm for finding the greatest common divisor (GCD) of two integers. Descriptions of this algorithm are available in algebra books and on the Web. Write a test program that calls your GCD procedure five times, using the following pairs of integers: (5,20), (24,18), (11,7), (432,226), (26,13). After each procedure call, display the GCD

### 한글 번역

두 정수의 최대공약수(GCD)를 구하는 **유클리드 호제법을 재귀 호출 방식으로 구현**하시오. 이 알고리즘은 대수학 교재나 인터넷 자료에서 확인할 수 있습니다.

`GCD` 프로시저를 작성하고 다음 정수 쌍을 사용하여 **총 5번 호출**하는 테스트 프로그램을 작성하시오.

`(5, 20)`, `(24, 18)`, `(11, 7)`, `(432, 226)`, `(26, 13)`

각 호출이 끝날 때마다 최대공약수를 화면에 출력하시오.

### 어셈블리 코드

```asm
TITLE Recursive Greatest Common Divisor
INCLUDE Irvine32.inc

GCD PROTO, x:SDWORD, y:SDWORD

.data
msg1 BYTE "GCD(5, 20) = ", 0
msg2 BYTE "GCD(24, 18) = ", 0
msg3 BYTE "GCD(11, 7) = ", 0
msg4 BYTE "GCD(432, 226) = ", 0
msg5 BYTE "GCD(26, 13) = ", 0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString
    INVOKE GCD, 5, 20
    call WriteDec
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    INVOKE GCD, 24, 18
    call WriteDec
    call Crlf

    mov edx, OFFSET msg3
    call WriteString
    INVOKE GCD, 11, 7
    call WriteDec
    call Crlf

    mov edx, OFFSET msg4
    call WriteString
    INVOKE GCD, 432, 226
    call WriteDec
    call Crlf

    mov edx, OFFSET msg5
    call WriteString
    INVOKE GCD, 26, 13
    call WriteDec
    call Crlf

    exit
main ENDP

; x, y = 두 정수
; 반환: EAX = 최대공약수
GCD PROC USES ebx edx, x:SDWORD, y:SDWORD
    mov eax, x
    test eax, eax
    jns XReady
    neg eax

XReady:
    mov ebx, y
    test ebx, ebx
    jns YReady
    neg ebx

YReady:
    test ebx, ebx
    jz Done

    xor edx, edx
    div ebx                 ; EDX = x mod y
    INVOKE GCD, ebx, edx   ; GCD(y, x mod y) 재귀 호출

Done:
    ret
GCD ENDP

END main
```

### 실행 결과 (예상)

```text
GCD(5, 20) = 5
GCD(24, 18) = 6
GCD(11, 7) = 1
GCD(432, 226) = 2
GCD(26, 13) = 13
```

## 8. Counting Matching Elements

### 영문 문제

Write a procedure named CountMatches that receives points to two arrays of signed doublewords, and a third parameter that indicates the length of the two arrays. For each element xi in the first array, if the corresponding yi in the second array is equal, increment a count. At the end, return a count of the number of matching array elements in EAX. Write a test program that calls your procedure and passes pointers to two different pairs of arrays. Use the INVOKE statement to call your procedure and pass stack parameters. Create a PROTO declaration for CountMatches. Save and restore any registers (other than EAX) changed by your procedure.

### 한글 번역

부호 있는 더블워드(SDWORD) 배열 두 개의 주소와 두 배열의 길이를 매개변수로 받는 `CountMatches` 프로시저를 작성하시오.

첫 번째 배열의 원소 `xᵢ`와 두 번째 배열의 **같은 위치**에 있는 원소 `yᵢ`가 같다면 일치 개수를 1 증가시킵니다. 모든 원소를 비교한 후 일치하는 원소의 개수를 `EAX` 레지스터로 반환하시오.

서로 다른 배열 쌍 두 개를 전달하여 테스트 프로그램을 작성하시오. `PROTO`로 프로시저를 선언하고, `INVOKE`로 스택 매개변수를 전달하시오. 프로시저에서 변경하는 레지스터는 `EAX`를 제외하고 모두 보존하시오.

### 어셈블리 코드

```asm
TITLE Counting Matching Elements
INCLUDE Irvine32.inc

CountMatches PROTO, pArray1:PTR SDWORD, pArray2:PTR SDWORD, arraySize:DWORD

.data
array1A SDWORD 1, -3, 5, 8, 12, 0
array1B SDWORD 1, 7, 5, -8, 12, 0

array2A SDWORD -10, 25, 30, -40, 50
array2B SDWORD 10, 25, -30, -40, 5

msg1 BYTE "Array Pair 1 matches: ", 0
msg2 BYTE "Array Pair 2 matches: ", 0

.code
main PROC
    ; Test 1
    mov edx, OFFSET msg1
    call WriteString
    INVOKE CountMatches, ADDR array1A, ADDR array1B, LENGTHOF array1A
    call WriteDec
    call Crlf

    ; Test 2
    mov edx, OFFSET msg2
    call WriteString
    INVOKE CountMatches, ADDR array2A, ADDR array2B, LENGTHOF array2A
    call WriteDec
    call Crlf

    exit
main ENDP

; EAX = 같은 위치에서 값이 일치하는 원소의 개수
CountMatches PROC USES esi edi ebx ecx,
    pArray1:PTR SDWORD,
    pArray2:PTR SDWORD,
    arraySize:DWORD

    mov esi, pArray1
    mov edi, pArray2
    mov ecx, arraySize
    xor eax, eax

    test ecx, ecx
    jz Done

L1:
    mov ebx, [esi]
    cmp ebx, [edi]
    jne NextElement
    inc eax

NextElement:
    add esi, 4
    add edi, 4
    loop L1

Done:
    ret
CountMatches ENDP

END main
```

### 실행 결과 (예상)

```text
Array Pair 1 matches: 4
Array Pair 2 matches: 2
```

### 테스트 결과 확인

| 테스트 | 첫 번째 배열 | 두 번째 배열 | 일치 원소 개수 |
|---|---|---|---:|
| 1 | `1, -3, 5, 8, 12, 0` | `1, 7, 5, -8, 12, 0` | **4** |
| 2 | `-10, 25, 30, -40, 50` | `10, 25, -30, -40, 5` | **2** |


## 9. Counting Nearly Matching Elements

### 영문 문제

Write a procedure named CountNearMatches that receives pointers to two arrays of signed doublewords, a parameter that indicates the length of the two arrays, and a parameter that indicates the maximum allowed difference (called diff) between any two matching elements. For each element xi in the first array, if the difference between it and the corresponding yi in the second array is less than or equal to diff, increment a count. At the end, return a count of the number of nearly matching array elements in EAX. Write a test program that calls CountNearMatches and passes pointers to two different pairs of arrays. Use the INVOKE statement to call your procedure and pass stack parameters. Create a PROTO declaration for CountMatches. Save and restore any registers(other than EAX) changed by your procedure.

### 한글 번역

`CountNearMatches`라는 프로시저를 작성하시오. 이 프로시저는 부호 있는 더블워드(SDWORD) 배열 두 개의 주소, 배열의 길이, 그리고 대응하는 두 원소가 일치한다고 판단할 최대 허용 차이(`diff`)를 매개변수로 받습니다.

첫 번째 배열의 원소 `xi`와 두 번째 배열의 같은 위치에 있는 원소 `yi`의 차이의 절댓값이 `diff` 이하이면 개수를 1 증가시키고, 최종 개수를 `EAX`에 반환하시오.

서로 다른 두 쌍의 배열로 테스트하시오. `INVOKE`를 이용해 스택 매개변수를 전달하고, `PROTO`를 선언하며, `EAX`를 제외한 변경된 레지스터를 보존하시오.


### 어셈블리 코드

```asm
TITLE Counting Nearly Matching Elements
INCLUDE Irvine32.inc

CountNearMatches PROTO, pArray1:PTR SDWORD, pArray2:PTR SDWORD, arraySize:DWORD, maxDiff:SDWORD

.data
array1A SDWORD -10, 15, 30, -40, 50, 70
array1B SDWORD -12, 19, 31, -35, 50, 63

array2A SDWORD -100, 0, 25, 90, -7, 200, 42
array2B SDWORD -95, -4, 30, 81, -13, 203, 52

msg1 BYTE "Array Pair 1 (diff=3): ", 0
msg2 BYTE "Array Pair 2 (diff=5): ", 0

.code
main PROC
    ; Test 1
    mov edx, OFFSET msg1
    call WriteString
    INVOKE CountNearMatches, ADDR array1A, ADDR array1B, LENGTHOF array1A, 3
    call WriteDec
    call Crlf

    ; Test 2
    mov edx, OFFSET msg2
    call WriteString
    INVOKE CountNearMatches, ADDR array2A, ADDR array2B, LENGTHOF array2A, 5
    call WriteDec
    call Crlf

    exit
main ENDP

; EAX = 차이의 절댓값이 maxDiff 이하인 원소 쌍의 개수
CountNearMatches PROC USES esi edi ebx ecx edx,
    pArray1:PTR SDWORD,
    pArray2:PTR SDWORD,
    arraySize:DWORD,
    maxDiff:SDWORD

    mov esi, pArray1
    mov edi, pArray2
    mov ecx, arraySize
    xor eax, eax

    cmp maxDiff, 0
    jl Done
    test ecx, ecx
    jz Done

L1:
    mov ebx, [esi]
    mov edx, [edi]
    cmp ebx, edx
    jge Ordered
    xchg ebx, edx

Ordered:
    sub ebx, edx         ; |x - y| (부호 없는 차이)
    cmp ebx, maxDiff
    ja NextElement
    inc eax

NextElement:
    add esi, 4
    add edi, 4
    loop L1

Done:
    ret
CountNearMatches ENDP

END main
```

### 실행 결과 (예상)

```text
Array Pair 1 (diff=3): 3
Array Pair 2 (diff=5): 4
```

### 테스트 결과 확인

| 테스트 | 첫 번째 배열 | 두 번째 배열 | diff | 일치 개수 |
|---|---|---|---:|---:|
| 1 | `-10, 15, 30, -40, 50, 70` | `-12, 19, 31, -35, 50, 63` | 3 | **3** |
| 2 | `-100, 0, 25, 90, -7, 200, 42` | `-95, -4, 30, 81, -13, 203, 52` | 5 | **4** |

## 10. Show Procedure Parameters

### 영문 문제

Write a procedure named ShowParams that displays the address and hexadecimal value of the 32-bit parameters on the runtime stack of the procedure that called it. The parameters are to be displayed in order from the lowest address to the highest. Input to the procedure will be a single integer that indicates the number of parameters to display. For example, suppose the following statement in main calls MySample, passing three arguments:

```asm
INVOKE MySample, 1234h, 5000h, 6543h
```

Next, inside MySample, you should be able to call ShowParams, passing the number of parameters you want to display:

```asm
MySample PROC first:DWORD, second:DWORD, third:DWORD
    paramCount = 3
    call ShowParams, paramCount
```

ShowParams should display output in the following format:

```text
Stack parameters:
--------------------
Address 0012FF80 = 00001234
Address 0012FF84 = 00005000
Address 0012FF88 = 00006543
```

### 한글 번역

`ShowParams` 프로시저를 작성하시오. 이 프로시저는 **자신을 호출한 프로시저의 런타임 스택에 저장된 32비트 매개변수**의 주소와 값을 16진수로 출력해야 합니다.

매개변수는 **메모리 주소가 낮은 순서부터 높은 순서**로 출력합니다. `ShowParams`는 출력할 매개변수의 개수를 나타내는 정수 하나를 입력으로 받습니다.

예를 들어 `main`에서 `INVOKE MySample, 1234h, 5000h, 6543h`로 세 인수를 전달하고, `MySample`에서 `ShowParams`를 호출하면 각 매개변수의 주소와 값이 출력되어야 합니다.

### 어셈블리 코드

```asm
TITLE Show Procedure Parameters
INCLUDE Irvine32.inc

MySample PROTO, first:DWORD, second:DWORD, third:DWORD
ShowParams PROTO, paramCount:DWORD

.data
heading BYTE "Stack parameters:", 0Dh, 0Ah, 0
lineMsg BYTE "--------------------", 0Dh, 0Ah, 0
addrMsg BYTE "Address ", 0
equalMsg BYTE " = ", 0

.code
main PROC
    INVOKE MySample, 1234h, 5000h, 6543h
    exit
main ENDP

MySample PROC first:DWORD, second:DWORD, third:DWORD
    INVOKE ShowParams, 3
    ret
MySample ENDP

; paramCount = 출력할 매개변수 개수
ShowParams PROC USES esi ecx, paramCount:DWORD
    mov edx, OFFSET heading
    call WriteString
    mov edx, OFFSET lineMsg
    call WriteString

    mov esi, [ebp]        ; MySample의 EBP
    add esi, 8            ; MySample의 첫 번째 매개변수 주소
    mov ecx, paramCount
    jecxz Done

L1:
    push ecx
    push esi

    mov edx, OFFSET addrMsg
    call WriteString
    mov eax, esi
    call WriteHex

    mov edx, OFFSET equalMsg
    call WriteString
    mov eax, [esi]
    call WriteHex
    call Crlf

    pop esi
    pop ecx
    add esi, 4
    loop L1

Done:
    ret
ShowParams ENDP

END main
```

### 실행 결과 (예상)

```text
Stack parameters:
--------------------
Address 0012FF80 = 00001234
Address 0012FF84 = 00005000
Address 0012FF88 = 00006543
```