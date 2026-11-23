# Programming Exercises

---

## 1. mReadkey Macro

### 영문 문제

Create a macro that waits for a keystroke and returns the key that was pressed. 
The macro should include parameters for the ASCII code and keyboard scan code.
Hint: Call ReadChar from the book’s link library. Write a program that tests your macro.
For example, the following code waits for a key; when it returns, the two arguments contain the ASCII code and scan code:

```asm
.data
ascii BYTE ?
scan BYTE ?
.code
mReadkey ascii, scan
```

### 한글 번역

키 입력을 기다린 뒤 누른 키에 관한 정보를 반환하는 `mReadkey` 매크로를 작성하시오.
매크로의 매개변수로 ASCII 코드와 키보드 스캔 코드를 저장할 변수를 전달한다.
교재의 `ReadChar` 프로시저를 사용하고, 매크로를 테스트하는 프로그램을 작성하시오.

### 어셈블리 코드

```asm
TITLE mReadkey Macro
INCLUDE Irvine32.inc

; asciiOut = 입력된 ASCII 코드 저장 변수(BYTE)
; scanOut  = 확장 키 스캔 코드 저장 변수(BYTE)
mReadkey MACRO asciiOut, scanOut
    LOCAL Done
    call ReadChar
    mov asciiOut, al
    mov scanOut, 0
    test al, al
    jnz Done
    mov scanOut, ah
Done:
ENDM

.data
ascii BYTE ?
scan  BYTE ?
msg1  BYTE "Press the Up Arrow key: ", 0
msg2  BYTE "ASCII code (hex): ", 0
msg3  BYTE "Scan code (hex):  ", 0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString
    mReadkey ascii, scan
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    movzx eax, ascii
    call WriteHex
    call Crlf

    mov edx, OFFSET msg3
    call WriteString
    movzx eax, scan
    call WriteHex
    call Crlf

    exit
main ENDP
END main
```

### 실행 결과 (예상)

위쪽 방향키(Up Arrow)를 누른 경우의 대표적인 결과다.

```text
Press the Up Arrow key:
ASCII code (hex): 00000000
Scan code (hex):  00000048
```

입력 키와 실행 환경에 따라 스캔 코드가 다를 수 있다.

### 핵심 설명

- `ReadChar`: 키를 입력받는다. 일반 키의 ASCII 코드는 `AL`로 반환한다.
- **확장 키**: 교재에 따르면 `AL=0`이며, `AH`에 키보드 스캔 코드를 반환한다.
- `mov asciiOut, al`: ASCII 값을 매개변수에 전달한 바이트 변수에 저장한다.
- `test al, al`: 확장 키 여부를 검사한다.
- `mov scanOut, ah`: 확장 키일 때 스캔 코드를 저장한다.
- `LOCAL Done`: 매크로를 여러 번 사용해도 레이블이 중복되지 않도록 한다.

---

## 2. mWritestringAttr Macro

### 영문 문제

(Requires reading ahead to Section 11.1.11.) Create a macro that writes a null-terminated string to the console with a given text color.
The macro parameters should include the string name and the color.
Hint: Call SetTextColor from the book’s link library.
Write a program that tests your macro with several strings in different colors.
Sample call:

```asm
.data
myString db "Here is my string",0
.code
mWritestring myString, white
```

### 한글 번역

지정한 글자색으로 널 종료 문자열을 콘솔에 출력하는 `mWritestringAttr` 매크로를 작성하시오.
문자열의 이름과 색상 값을 매개변수로 전달한다.
교재의 `SetTextColor` 프로시저를 사용하며, 서로 다른 색상의 여러 문자열을 출력하는 테스트 프로그램을 작성하시오.

### 어셈블리 코드

```asm
TITLE mWritestringAttr Macro
INCLUDE Irvine32.inc

mWritestringAttr MACRO stringName, textColor
    push eax
    push edx
    mov eax, textColor
    call SetTextColor
    mov edx, OFFSET stringName
    call WriteString
    pop edx
    pop eax
ENDM

.data
msg1 BYTE "Red text", 0Dh, 0Ah, 0
msg2 BYTE "Green text", 0Dh, 0Ah, 0
msg3 BYTE "Blue text", 0Dh, 0Ah, 0
msg4 BYTE "White text", 0Dh, 0Ah, 0

.code
main PROC
    mWritestringAttr msg1, lightRed
    mWritestringAttr msg2, lightGreen
    mWritestringAttr msg3, lightBlue
    mWritestringAttr msg4, white

    ; 기본 콘솔 색상 복구
    mov eax, lightGray + (black * 16)
    call SetTextColor
    exit
main ENDP
END main
```

### 실행 결과 (예상)

콘솔에는 아래 네 문장이 각각 **밝은 빨강, 밝은 초록, 밝은 파랑, 흰색**으로 표시된다.

```text
Red text
Green text
Blue text
White text
```

### 핵심 설명

- `SetTextColor`: `EAX`에 저장한 색상 속성을 콘솔에 적용한다.
- `WriteString`: `EDX`가 가리키는 널 종료 문자열을 출력한다.
- `OFFSET stringName`: 문자열의 시작 주소를 구한다.
- `PUSH` / `POP`: 매크로에서 사용하는 `EAX`, `EDX`를 보존한다.
- 마지막에 기본 텍스트 색상을 복구한다.

---

## 3. mMove32 Macro

### 영문 문제

Write a macro named mMove32 that receives two 32-bit memory operands.
The macro should move the source operand to the destination operand.
Write a program that tests your macro.

### 한글 번역

두 개의 32비트 메모리 피연산자를 매개변수로 받는 `mMove32` 매크로를 작성하시오.
첫 번째 피연산자의 값을 두 번째 피연산자에 복사하는 매크로를 구현하고, 테스트 프로그램을 작성하시오.

### 어셈블리 코드

```asm
TITLE mMove32 Macro
INCLUDE Irvine32.inc

; source32의 값을 target32로 복사한다.
mMove32 MACRO source32, target32
    push eax
    mov eax, source32
    mov target32, eax
    pop eax
ENDM

.data
source1 DWORD 12345678h
target1 DWORD 0
source2 DWORD 0AABBCCDDh
target2 DWORD 0

msg1 BYTE "Target 1: ", 0
msg2 BYTE "Target 2: ", 0

.code
main PROC
    mMove32 source1, target1
    mMove32 source2, target2

    mov edx, OFFSET msg1
    call WriteString
    mov eax, target1
    call WriteHex
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    mov eax, target2
    call WriteHex
    call Crlf

    exit
main ENDP
END main
```

### 실행 결과 (예상)

```text
Target 1: 12345678
Target 2: AABBCCDD
```

### 핵심 설명

- `mMove32 source32, target32`: 원본 값과 목적지 변수를 전달한다.
- `mov eax, source32`: 32비트 메모리 값을 임시 레지스터에 읽는다.
- `mov target32, eax`: 읽은 값을 목적지 메모리에 저장한다.
- `PUSH EAX` / `POP EAX`: 매크로 호출 전 `EAX` 값을 보존한다.
- 두 메모리 피연산자 간 직접 `MOV`는 불가능하므로 레지스터를 경유한다.

---

## 4. mMult32 Macro

### 영문 문제

Create a macro named mMult32 that multiplies two 32-bit memory operands and produces a 32-bit product.
Write a program that tests your macro.

### 한글 번역

두 개의 32비트 메모리 피연산자를 곱하여 **32비트 곱셈 결과**를 생성하는 `mMult32` 매크로를 작성하시오.
작성한 매크로를 사용하는 테스트 프로그램을 작성하시오.

### 어셈블리 코드

```asm
TITLE mMult32 Macro
INCLUDE Irvine32.inc

; 32비트 메모리 변수 2개의 곱을 EAX로 반환한다.
mMult32 MACRO left32, right32
    mov eax, left32
    imul eax, right32
ENDM

.data
x1 SDWORD 12
x2 SDWORD 13
x3 SDWORD -7
x4 SDWORD 6
x5 SDWORD 12345
x6 SDWORD 6789

msg1 BYTE "12 * 13 = ", 0
msg2 BYTE "-7 * 6 = ", 0
msg3 BYTE "12345 * 6789 = ", 0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString
    mMult32 x1, x2
    call WriteInt
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    mMult32 x3, x4
    call WriteInt
    call Crlf

    mov edx, OFFSET msg3
    call WriteString
    mMult32 x5, x6
    call WriteInt
    call Crlf

    exit
main ENDP
END main
```

### 실행 결과 (예상)

`WriteInt`는 부호 있는 결과의 양수에 `+` 표시를 붙인다.

```text
12 * 13 = +156
-7 * 6 = -42
12345 * 6789 = +83810205
```

### 핵심 설명

- `mMult32`: 두 개의 32비트 메모리 피연산자를 입력받는다.
- `mov eax, left32`: 첫 번째 값을 `EAX`로 가져온다.
- `imul eax, right32`: 두 번째 값과 부호 있는 32비트 곱셈을 수행한다.
- **반환 규약:** 원문에 결과 저장 위치가 지정되지 않아, 이 풀이에서는 결과를 `EAX`의 하위 32비트로 반환하도록 정한다.
- 모든 테스트 값은 32비트 부호 있는 정수 범위 안에 들어간다.

---

## 5. mReadInt Macro

### 영문 문제

Create a macro named mReadInt that reads a 16- or 32-bit signed integer from standard input and returns the value in an argument. Use conditional operators to allow the macro to adapt to the size of the desired result. Write a program that tests the macro, passing it operands of various sizes.

### 한글 번역

표준 입력에서 **16비트 또는 32비트 부호 있는 정수**를 읽고, 매개변수로 전달한 변수에 값을 저장하는 `mReadInt` 매크로를 작성한다. 조건부 어셈블 지시어를 사용하여 결과 변수의 크기에 따라 매크로가 동작하도록 만든다. 크기가 다른 여러 피연산자를 전달하는 테스트 프로그램을 작성한다.

### 어셈블리 코드

```asm
TITLE mReadInt Macro
INCLUDE Irvine32.inc

; dest가 16비트이면 AX, 32비트이면 EAX를 저장한다.
mReadInt MACRO dest
    IF TYPE dest EQ 2
        call ReadInt
        mov dest, ax
    ELSEIF TYPE dest EQ 4
        call ReadInt
        mov dest, eax
    ELSE
        .ERR <mReadInt requires a WORD or DWORD variable>
    ENDIF
ENDM

.data
smallNum  SWORD ?
largeNum  SDWORD ?
another   SWORD ?
prompt1 BYTE "Enter a 16-bit signed integer: ", 0
prompt2 BYTE "Enter a 32-bit signed integer: ", 0
prompt3 BYTE "Enter another 16-bit integer: ", 0
msg1    BYTE "16-bit result: ", 0
msg2    BYTE "32-bit result: ", 0
msg3    BYTE "Second 16-bit result: ", 0

.code
main PROC
    mov edx, OFFSET prompt1
    call WriteString
    mReadInt smallNum

    mov edx, OFFSET prompt2
    call WriteString
    mReadInt largeNum

    mov edx, OFFSET prompt3
    call WriteString
    mReadInt another

    mov edx, OFFSET msg1
    call WriteString
    movsx eax, smallNum
    call WriteInt
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    mov eax, largeNum
    call WriteInt
    call Crlf

    mov edx, OFFSET msg3
    call WriteString
    movsx eax, another
    call WriteInt
    call Crlf

    exit
main ENDP
END main
```

### 실행 결과 (예상)

사용자가 차례대로 `-123`, `123456`, `32767`을 입력한 예시다.

```text
Enter a 16-bit signed integer: -123
Enter a 32-bit signed integer: 123456
Enter another 16-bit integer: 32767
16-bit result: -123
32-bit result: +123456
Second 16-bit result: +32767
```

### 핵심 설명

- `IF TYPE dest EQ 2`: 매개변수의 크기가 2바이트이면 `AX`를 저장한다.
- `ELSEIF TYPE dest EQ 4`: 크기가 4바이트이면 `EAX`를 저장한다.
- `ReadInt`: 부호 있는 32비트 정수를 `EAX`로 입력받는다.
- `MOVSX`: 16비트 부호 있는 정수를 32비트로 부호 확장하여 출력한다.

---

## 6. mWriteInt Macro

### 영문 문제

Create a macro named mWriteInt that writes a signed integer to standard output by calling the WriteInt library procedure. The argument passed to the macro can be a byte, word, or doubleword. Use conditional operators in the macro so it adapts to the size of the argument. Write a program that tests the macro, passing it arguments of different sizes.

### 한글 번역

`WriteInt` 라이브러리 프로시저를 호출하여 **부호 있는 정수를 화면에 출력**하는 `mWriteInt` 매크로를 작성한다. 인수는 BYTE(8비트), WORD(16비트), DWORD(32비트) 크기일 수 있다. 조건부 어셈블 지시어를 이용하여 인수의 크기에 따라 적절한 명령어를 생성하고, 서로 다른 크기의 변수를 전달하여 테스트한다.

### 어셈블리 코드

```asm
TITLE mWriteInt Macro
INCLUDE Irvine32.inc

; 인수의 크기에 따라 EAX에 부호 있는 32비트 값으로 적재한다.
mWriteInt MACRO value
    push eax
    IF TYPE value EQ 1
        movsx eax, value
    ELSEIF TYPE value EQ 2
        movsx eax, value
    ELSEIF TYPE value EQ 4
        mov eax, value
    ELSE
        .ERR <mWriteInt requires a BYTE, WORD, or DWORD operand>
    ENDIF
    call WriteInt
    pop eax
ENDM

.data
byteNum  SBYTE -12
wordNum  SWORD -1234
dwordNum SDWORD 100000
msg1 BYTE "8-bit:  ", 0
msg2 BYTE "16-bit: ", 0
msg3 BYTE "32-bit: ", 0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString
    mWriteInt byteNum
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    mWriteInt wordNum
    call Crlf

    mov edx, OFFSET msg3
    call WriteString
    mWriteInt dwordNum
    call Crlf

    exit
main ENDP
END main
```

### 실행 결과 (예상)

```text
8-bit:  -12
16-bit: -1234
32-bit: +100000
```

### 핵심 설명

- `TYPE value`: 매크로 인수의 바이트 크기를 어셈블 시점에 계산한다.
- `MOVSX EAX, value`: 8비트 또는 16비트 값을 **부호 확장**하여 `EAX`에 저장한다.
- `MOV EAX, value`: 32비트 값은 그대로 `EAX`에 저장한다.
- `WriteInt`: `EAX`의 부호 있는 값을 10진수로 출력한다.
- `PUSH EAX` / `POP EAX`: 매크로 호출 전후의 `EAX` 값을 보존한다.

---

## 7. The Professsor’s Lost Phone

### 영문 문제

When the professor took the drunkard's walk around campus in Section 10.1.6, we discovered that he lost his cell phone somewhere along the path. When you simulate the drunken walk, your program must drop the phone wherever the professor is standing at some random time interval. Each time you run the program, the cell phone will be lost at a different time interval (and location).

### 한글 번역

교재 10.1.6절에서 교수의 무작위 걷기(Drunkard's Walk)를 시뮬레이션할 때, 교수는 이동 경로 어딘가에서 휴대전화를 잃어버린다. 시뮬레이션 도중 **무작위로 정한 시점에 교수의 현재 위치를 휴대전화 분실 위치로 기록**하도록 프로그램을 수정한다. 매번 실행할 때 분실 시점과 장소가 달라질 수 있어야 한다.

### 어셈블리 코드

```asm
TITLE The Professor's Lost Phone
INCLUDE Irvine32.inc

WalkMax = 50
StartX = 25
StartY = 25

DrunkardWalk STRUCT
    path COORD WalkMax DUP(<0,0>)
    pathsUsed WORD 0
    phoneStep DWORD 0
    phoneX WORD 0
    phoneY WORD 0
DrunkardWalk ENDS

DisplayPosition PROTO, currX:WORD, currY:WORD

.data
aWalk DrunkardWalk <>
commaStr BYTE ",", 0
phoneMsg BYTE "Phone lost at step ", 0
placeMsg BYTE " / position: ", 0

.code
main PROC
    call Randomize
    mov esi, OFFSET aWalk
    call TakeDrunkenWalk

    mov edx, OFFSET phoneMsg
    call WriteString
    mov eax, (DrunkardWalk PTR [esi]).phoneStep
    call WriteDec

    mov edx, OFFSET placeMsg
    call WriteString
    movsx eax, (DrunkardWalk PTR [esi]).phoneX
    call WriteInt
    mov edx, OFFSET commaStr
    call WriteString
    movsx eax, (DrunkardWalk PTR [esi]).phoneY
    call WriteInt
    call Crlf

    exit
main ENDP

; ESI = DrunkardWalk 구조체 주소
TakeDrunkenWalk PROC
    LOCAL currX:WORD, currY:WORD
    pushad

    mov edi, esi
    add edi, OFFSET DrunkardWalk.path
    mov currX, StartX
    mov currY, StartY
    mov ecx, WalkMax

    ; 휴대전화를 잃어버릴 시점을 1~50걸음에서 선택한다.
    mov eax, WalkMax
    call RandomRange
    inc eax
    mov (DrunkardWalk PTR [esi]).phoneStep, eax
    mov ebx, 1

WalkLoop:
    ; 현재 좌표를 구조체에 기록한다.
    mov ax, currX
    mov (COORD PTR [edi]).X, ax
    mov ax, currY
    mov (COORD PTR [edi]).Y, ax

    ; 선택된 걸음에서 휴대전화 분실 위치를 저장한다.
    cmp ebx, (DrunkardWalk PTR [esi]).phoneStep
    jne ShowPosition
    mov ax, currX
    mov (DrunkardWalk PTR [esi]).phoneX, ax
    mov ax, currY
    mov (DrunkardWalk PTR [esi]).phoneY, ax

ShowPosition:
    INVOKE DisplayPosition, currX, currY

    mov eax, 4
    call RandomRange
    cmp eax, 0
    je North
    cmp eax, 1
    je South
    cmp eax, 2
    je West
    inc currX            ; East
    jmp NextStep
North:
    dec currY
    jmp NextStep
South:
    inc currY
    jmp NextStep
West:
    dec currX

NextStep:
    add edi, TYPE COORD
    inc ebx
    loop WalkLoop

    mov (DrunkardWalk PTR [esi]).pathsUsed, WalkMax
    popad
    ret
TakeDrunkenWalk ENDP

; 좌표를 'X,Y' 형식으로 출력한다.
DisplayPosition PROC USES eax edx, currX:WORD, currY:WORD
    movsx eax, currX
    call WriteInt
    mov edx, OFFSET commaStr
    call WriteString
    movsx eax, currY
    call WriteInt
    call Crlf
    ret
DisplayPosition ENDP

END main
```

### 실행 결과 (예상)

난수에 따라 실행할 때마다 달라지는 **출력 형식 예시**다. 실제 실행에서는 중간 50걸음의 좌표가 모두 출력된다.

```text
+25,+25
+26,+25
+26,+24
... (중간 이동 좌표 생략)
Phone lost at step 3 / position: +26,+24
```

### 핵심 설명

- `DrunkardWalk.path`: 각 걸음에서의 좌표를 50개 저장한다.
- `phoneStep`: `RandomRange`로 정한 분실 시점(1~50)을 저장한다.
- `phoneX`, `phoneY`: 해당 시점의 교수 위치를 기록한다.
- `Randomize`: 프로그램 시작 시 난수 시드를 초기화한다.
- 교재의 10.1.6절과 같이 북·남·서·동을 각각 같은 확률로 선택한다.
- `WriteInt`: 음수 좌표가 발생하더라도 부호를 포함해 표시한다.

---

## 8. Drunkard’s Walk with Probabilities

### 영문 문제

When testing the DrunkardWalk program, you may have noticed that the professor doesn’t seem to wander very far from the starting point. This is no doubt caused by an equal probability of the professor moving in any direction. Modify the program so there is a 50% probability the professor will continue to walk in the same direction as he or she did when taking the previous step. There should be a 10% probability that he or she will reverse direction and a 20% probability that he or she will turn either right or left. Assign a default starting direction before the loop begins.

### 한글 번역

`DrunkardWalk` 프로그램에서는 네 방향으로 이동할 확률이 동일하기 때문에 시작점에서 멀리 벗어나지 않을 수 있다. 프로그램을 수정하여 다음 이동 방향을 **직전 이동 방향을 기준으로** 결정한다.

- **50%:** 같은 방향으로 계속 이동한다.
- **10%:** 반대 방향으로 이동한다.
- **20%:** 오른쪽으로 방향을 바꾼다.
- **20%:** 왼쪽으로 방향을 바꾼다.

반복문을 시작하기 전에 초기 이동 방향을 기본값으로 지정한다.

### 어셈블리 코드

```asm
TITLE Drunkard's Walk with Probabilities
INCLUDE Irvine32.inc

WalkMax = 50
StartX = 25
StartY = 25

DrunkardWalk STRUCT
    path COORD WalkMax DUP(<0,0>)
    pathsUsed WORD 0
DrunkardWalk ENDS

DisplayPosition PROTO, currX:WORD, currY:WORD

.data
aWalk DrunkardWalk <>
commaStr BYTE ",", 0

.code
main PROC
    call Randomize
    mov esi, OFFSET aWalk
    call TakeDrunkenWalk
    exit
main ENDP

; ESI = DrunkardWalk 구조체 주소
; EBX = 현재 방향: 0=북, 1=동, 2=남, 3=서
TakeDrunkenWalk PROC
    LOCAL currX:WORD, currY:WORD
    pushad

    mov edi, esi
    add edi, OFFSET DrunkardWalk.path
    mov currX, StartX
    mov currY, StartY
    mov ecx, WalkMax
    mov ebx, 0            ; 초기 방향은 북쪽

WalkLoop:
    mov ax, currX
    mov (COORD PTR [edi]).X, ax
    mov ax, currY
    mov (COORD PTR [edi]).Y, ax
    INVOKE DisplayPosition, currX, currY

    mov eax, 10
    call RandomRange     ; 0~9 난수
    cmp eax, 5
    jb MoveNow           ; 0~4: 직진 (50%)
    cmp eax, 6
    jb ReverseDirection  ; 5: 반대 (10%)
    cmp eax, 8
    jb TurnRight         ; 6~7: 우회전 (20%)

    ; 8~9: 좌회전 (20%)
    add ebx, 3
    and ebx, 3
    jmp MoveNow

ReverseDirection:
    xor ebx, 2
    jmp MoveNow

TurnRight:
    inc ebx
    and ebx, 3

MoveNow:
    cmp ebx, 0
    je North
    cmp ebx, 1
    je East
    cmp ebx, 2
    je South

    dec currX            ; West
    jmp NextStep
North:
    dec currY
    jmp NextStep
East:
    inc currX
    jmp NextStep
South:
    inc currY

NextStep:
    add edi, TYPE COORD
    loop WalkLoop

    mov (DrunkardWalk PTR [esi]).pathsUsed, WalkMax
    popad
    ret
TakeDrunkenWalk ENDP

DisplayPosition PROC USES eax edx, currX:WORD, currY:WORD
    movsx eax, currX
    call WriteInt
    mov edx, OFFSET commaStr
    call WriteString
    movsx eax, currY
    call WriteInt
    call Crlf
    ret
DisplayPosition ENDP

END main
```

### 실행 결과 (예상)

난수에 따라 이동 경로가 달라진다. 아래는 **가능한 경로의 앞부분을 발췌한 예시**다. 실제 실행에서는 전체 50개의 위치가 출력된다.

```text
+25,+25
+25,+24
+25,+23
+25,+22
+26,+22
+27,+22
... (나머지 위치 생략)
```

### 핵심 설명

- `EBX=0,1,2,3`: 북·동·남·서 방향을 **시계방향 순서**로 저장한다.
- `MOV EBX, 0`: 첫 번째 방향을 북쪽으로 초기화한다.
- `RandomRange(10)`: `0~9` 중 하나를 균등하게 선택한다.
- `0~4`: 기존 방향 유지(50%).
- `5`: `XOR EBX,2`로 정반대 방향 선택(10%).
- `6~7`: `EBX=(EBX+1) AND 3`으로 우회전(20%).
- `8~9`: `EBX=(EBX+3) AND 3`으로 좌회전(20%).
- 50회의 반복 동안 좌표를 구조체에 저장하고 화면에 출력한다.

---

## 9. Shifting Multiple Doublewords

### 영문 문제

> Create a macro that shifts an array of 32-bit integers a variable number of bits in either direction, using the SHRD and SHLD instructions.  
> Write a test program that tests your macro by shifting the same array in both directions and displaying the resulting values.  
> You can assume that the array is in little-endian order. Here is a sample macro declaration:
>
> ```asm
> mShiftDoublewords MACRO arrayName, direction, numberOfBits
> ```
>
> Parameters:
>
> - `arrayName`: Name of the array
> - `direction`: Right (`R`) or Left (`L`)
> - `numberOfBits`: Number of bit positions to shift

### 한글 번역

32비트 정수(DWORD) 배열을 하나의 긴 이진 정수로 간주하고, **`SHRD`와 `SHLD` 명령어**를 사용하여 지정한 비트 수만큼 왼쪽 또는 오른쪽으로 이동시키는 매크로를 작성하시오.

같은 배열에 대해 오른쪽 및 왼쪽 이동을 각각 수행하고 결과를 출력하는 테스트 프로그램을 작성하시오. 배열은 **리틀 엔디언 순서**로 저장되어 있다고 가정한다.

매크로는 `mShiftDoublewords arrayName, direction, numberOfBits` 형식을 사용하며, `direction`에는 `R`(오른쪽) 또는 `L`(왼쪽)을 전달한다.

### 어셈블리 코드

다음 코드는 **32비트 MASM + Irvine32** 기준이다. `numberOfBits`는 즉시값 또는 DWORD 변수로 전달할 수 있다. `0`부터 배열 전체 비트 수 이상까지 처리하며, 빈 비트는 0으로 채운다. `direction`에는 `R` 또는 `L`만 전달한다고 가정한다.

```asm
TITLE Shifting Multiple Doublewords
INCLUDE Irvine32.inc

; 배열의 각 DWORD는 낮은 자리부터 저장된다.
; SHRD/SHLD의 CL 피연산자로 1~31비트를 처리한다.
; 32비트 이상 이동할 때는 DWORD 단위 이동을 먼저 수행한다.
;
; 매개변수:
;   arrayName    : DWORD 배열의 이름
;   direction    : R 또는 L
;   numberOfBits : 이동 비트 수 (즉시값 / DWORD 변수)
;
; EAX를 제외한 사용 레지스터를 보존한다.
mShiftDoublewords MACRO arrayName, direction, numberOfBits
    LOCAL CopyWhole, FillZero, BitsOnly, BitLoop
    LOCAL LastWord, ZeroAll, ClearLoop, Done

    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp

    mov eax, numberOfBits
    test eax, eax
    jle Done                         ; 0 이하이면 이동하지 않음
    cmp eax, (LENGTHOF arrayName * 32)
    jae ZeroAll                      ; 전체 비트 수 이상이면 모두 0

    mov ebx, eax
    shr ebx, 5                      ; EBX = 이동할 DWORD 개수
    mov ebp, eax
    and ebp, 31                     ; EBP = 나머지 비트 수(0~31)

    IFIDNI <direction>, <R>
        ; 오른쪽 DWORD 단위 이동: 낮은 인덱스부터 복사한다.
        test ebx, ebx
        jz BitsOnly

        mov esi, OFFSET arrayName   ; 대상 위치
        lea edi, [esi + ebx*4]      ; 원본 위치 = 대상 + EBX DWORD
        mov edx, LENGTHOF arrayName
        sub edx, ebx                ; 복사할 DWORD 개수

CopyWhole:
        mov eax, [edi]
        mov [esi], eax
        add esi, 4
        add edi, 4
        dec edx
        jnz CopyWhole

        mov edx, ebx
FillZero:
        mov DWORD PTR [esi], 0
        add esi, 4
        dec edx
        jnz FillZero

BitsOnly:
        test ebp, ebp
        jz Done

        mov esi, OFFSET arrayName
        mov edi, LENGTHOF arrayName - 1
        test edi, edi
        jz LastWord

BitLoop:
        mov eax, [esi]              ; 현재 DWORD
        mov edx, [esi+4]            ; 상위 DWORD의 비트 가져오기
        mov ecx, ebp
        shrd eax, edx, cl
        mov [esi], eax
        add esi, 4
        dec edi
        jnz BitLoop

LastWord:
        mov ecx, ebp
        shr DWORD PTR [esi], cl     ; 가장 높은 DWORD는 0으로 채움

    ELSE
        ; 왼쪽 DWORD 단위 이동: 높은 인덱스부터 복사한다.
        test ebx, ebx
        jz BitsOnly

        mov esi, OFFSET arrayName
        add esi, (LENGTHOF arrayName - 1) * 4
        mov edi, ebx
        shl edi, 2                   ; EBX * 4바이트
        mov edx, esi
        sub edx, edi
        mov edi, edx                ; 원본 = 대상 - EBX DWORD
        mov edx, LENGTHOF arrayName
        sub edx, ebx

CopyWhole:
        mov eax, [edi]
        mov [esi], eax
        sub esi, 4
        sub edi, 4
        dec edx
        jnz CopyWhole

        mov edx, ebx
FillZero:
        mov DWORD PTR [esi], 0
        sub esi, 4
        dec edx
        jnz FillZero

BitsOnly:
        test ebp, ebp
        jz Done

        mov esi, OFFSET arrayName
        add esi, (LENGTHOF arrayName - 1) * 4
        mov edi, LENGTHOF arrayName - 1
        test edi, edi
        jz LastWord

BitLoop:
        mov eax, [esi]              ; 현재 DWORD
        mov edx, [esi-4]            ; 하위 DWORD의 비트 가져오기
        mov ecx, ebp
        shld eax, edx, cl
        mov [esi], eax
        sub esi, 4
        dec edi
        jnz BitLoop

LastWord:
        mov ecx, ebp
        shl DWORD PTR [esi], cl     ; 가장 낮은 DWORD는 0으로 채움
    ENDIF

    jmp Done

ZeroAll:
    mov esi, OFFSET arrayName
    mov ecx, LENGTHOF arrayName
    xor eax, eax
ClearLoop:
    mov DWORD PTR [esi], eax
    add esi, 4
    loop ClearLoop

Done:
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
ENDM

.data
original DWORD 12345678h, 9ABCDEF0h, 13579BDFh, 2468ACE0h
numbers  DWORD 4 DUP(?)
smallShift DWORD 5
largeShift DWORD 36

msg0 BYTE "Original:  ", 0
msg1 BYTE "Right  5:  ", 0
msg2 BYTE "Left   5:  ", 0
msg3 BYTE "Right 36:  ", 0
msg4 BYTE "Left  36:  ", 0

.code
main PROC
    call RestoreArray
    mov edx, OFFSET msg0
    call WriteString
    call PrintArray

    mShiftDoublewords numbers, R, smallShift
    mov edx, OFFSET msg1
    call WriteString
    call PrintArray

    call RestoreArray
    mShiftDoublewords numbers, L, smallShift
    mov edx, OFFSET msg2
    call WriteString
    call PrintArray

    call RestoreArray
    mShiftDoublewords numbers, R, largeShift
    mov edx, OFFSET msg3
    call WriteString
    call PrintArray

    call RestoreArray
    mShiftDoublewords numbers, L, largeShift
    mov edx, OFFSET msg4
    call WriteString
    call PrintArray

    exit
main ENDP

; 같은 배열을 반복 테스트하기 위해 원본 데이터 복원
RestoreArray PROC USES ecx esi edi
    pushfd
    cld
    mov esi, OFFSET original
    mov edi, OFFSET numbers
    mov ecx, LENGTHOF original
    rep movsd
    popfd
    ret
RestoreArray ENDP

; 낮은 DWORD부터 8자리 16진수로 출력
PrintArray PROC USES eax ecx esi
    mov esi, OFFSET numbers
    mov ecx, LENGTHOF numbers

NextDWORD:
    push ecx
    mov eax, [esi]
    call WriteHex
    mov al, ' '
    call WriteChar
    pop ecx
    add esi, 4
    loop NextDWORD

    call Crlf
    ret
PrintArray ENDP

END main
```

### 실행 결과 (예상)

아래의 DWORD들은 **배열에 저장된 순서(낮은 DWORD → 높은 DWORD)** 로 출력된다.

```text
Original:  12345678 9ABCDEF0 13579BDF 2468ACE0
Right  5:  8091A2B3 FCD5E6F7 009ABCDE 01234567
Left   5:  468ACF00 579BDE02 6AF37BF3 8D159C02
Right 36:  F9ABCDEF 013579BD 02468ACE 00000000
Left  36:  00000000 23456780 ABCDEF01 3579BDF9
```

### 핵심 설명

- **리틀 엔디언 DWORD 배열**에서는 `array[0]`이 전체 정수의 최하위 32비트다.
- **오른쪽 이동**은 `SHRD`로 상위 DWORD의 비트를 현재 DWORD로 가져온다. 낮은 인덱스부터 처리해야 이전 값이 덮어써지지 않는다.
- **왼쪽 이동**은 `SHLD`로 하위 DWORD의 비트를 현재 DWORD로 가져온다. 높은 인덱스부터 처리한다.
- `numberOfBits / 32`만큼 DWORD 자체를 이동한 다음, `numberOfBits MOD 32`만큼 `CL`을 사용하여 비트 이동한다.
- 최상위 또는 최하위로 새로 유입되는 비트는 0이다. 전체 너비 이상 이동하면 모든 DWORD가 0이 된다.
- 매크로의 지역 레이블을 `LOCAL`로 정의하여 여러 번 호출해도 레이블이 충돌하지 않는다.

---

## 10. Three-Operand Instructions

### 영문 문제

> Some computer instruction sets permit arithmetic instructions with three operands.  
> Such operations sometimes appear in simple virtual assemblers used to introduce students to the concept of assembly language or using intermediate language in compilers.  
> In the following macros, assume EAX is reserved for macro operations and is not preserved.  
> Other registers modified by the macro must be preserved.  
> All parameters are signed memory doublewords. Write macros that simulate the following operations:
>
> a. `add3 destination, source1, source2`  
> b. `sub3 destination, source1, source2` (`destination = source1 - source2`)  
> c. `mul3 destination, source1, source2`  
> d. `div3 destination, source1, source2` (`destination = source1 / source2`)
>
> For example, the following macro calls implement the expression x  (w  y) * z:
>
> ```asm
> .data
> temp DWORD ?
> .code
> add3 temp, w, y         ; temp = w + y
> mul3 x, temp, z
> ```
>
> Write a program that tests your macros by implementing four arithmetic expressions, each involving multiple operations.

### 한글 번역

일부 명령어 집합에서는 **세 개의 피연산자**를 가진 산술 명령어를 제공한다. 이를 모의하는 다음 네 가지 매크로를 작성하시오.

- `add3 destination, source1, source2`: 두 피연산자를 더한 결과를 저장한다.
- `sub3 destination, source1, source2`: `source1 - source2` 결과를 저장한다.
- `mul3 destination, source1, source2`: 두 피연산자를 곱한 결과를 저장한다.
- `div3 destination, source1, source2`: `source1 / source2` 결과를 저장한다.

모든 매개변수는 **부호 있는 32비트 메모리 피연산자(SDWORD)** 이다. `EAX`는 매크로가 사용하도록 예약되어 있으므로 보존하지 않아도 되지만, **그 밖의 변경한 레지스터는 원래 값으로 복원**해야 한다.

네 가지 복합 산술식을 직접 구현하여 매크로를 테스트하시오.

### 어셈블리 코드

```asm
TITLE Three-Operand Arithmetic Macros
INCLUDE Irvine32.inc

; 모든 인수는 SDWORD 메모리 피연산자다.
; EAX는 보존하지 않는다.

add3 MACRO destination, source1, source2
    mov eax, source1
    add eax, source2
    mov destination, eax
ENDM

sub3 MACRO destination, source1, source2
    mov eax, source1
    sub eax, source2
    mov destination, eax
ENDM

mul3 MACRO destination, source1, source2
    mov eax, source1
    imul eax, source2            ; 부호 있는 32비트 곱셈
    mov destination, eax         ; 하위 32비트 저장
ENDM

div3 MACRO destination, source1, source2
    push edx                     ; EDX 원래 값 보존
    mov eax, source1
    cdq                          ; EAX 부호를 EDX:EAX로 확장
    idiv source2                 ; 부호 있는 나눗셈, 몫은 EAX
    mov destination, eax
    pop edx                      ; EDX 복원
ENDM

.data
w SDWORD 18
y SDWORD -5
z SDWORD 3
two SDWORD 2

tempA SDWORD ?
tempB SDWORD ?
x1 SDWORD ?
x2 SDWORD ?
x3 SDWORD ?
x4 SDWORD ?

msg1 BYTE "(w+y)*z = ", 0
msg2 BYTE "(w-y)/z = ", 0
msg3 BYTE "w*z+(y-z) = ", 0
msg4 BYTE "((w+y)*z-(w-y))/2 = ", 0

.code
main PROC
    ; 1) x1 = (w + y) * z = 39
    add3 tempA, w, y
    mul3 x1, tempA, z

    ; 2) x2 = (w - y) / z = 7 (정수 몫)
    sub3 tempA, w, y
    div3 x2, tempA, z

    ; 3) x3 = w*z + (y - z) = 46
    mul3 tempA, w, z
    sub3 tempB, y, z
    add3 x3, tempA, tempB

    ; 4) x4 = ((w+y)*z - (w-y)) / 2 = 8
    add3 tempA, w, y
    mul3 tempA, tempA, z
    sub3 tempB, w, y
    sub3 tempA, tempA, tempB
    div3 x4, tempA, two

    mov edx, OFFSET msg1
    call WriteString
    mov eax, x1
    call WriteInt
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    mov eax, x2
    call WriteInt
    call Crlf

    mov edx, OFFSET msg3
    call WriteString
    mov eax, x3
    call WriteInt
    call Crlf

    mov edx, OFFSET msg4
    call WriteString
    mov eax, x4
    call WriteInt
    call Crlf

    exit
main ENDP

END main
```

### 실행 결과 (예상)

`WriteInt`는 양수에도 `+` 부호를 출력한다.

```text
(w+y)*z = +39
(w-y)/z = +7
w*z+(y-z) = +46
((w+y)*z-(w-y))/2 = +8
```

### 핵심 설명

- **`add3`**: `source1 + source2`를 계산하여 `destination`에 저장한다.
- **`sub3`**: `source1 - source2`를 계산한다.
- **`mul3`**: `IMUL`의 2피연산자 형식으로 부호 있는 곱셈을 수행하고 하위 32비트를 저장한다.
- **`div3`**: `CDQ`로 부호를 확장한 다음 `IDIV`로 나누고, 몫인 `EAX`를 목적지에 저장한다. `PUSH EDX`/`POP EDX`로 `EDX`를 보존한다.
- `EAX`는 문제 조건에 따라 보존하지 않는다. 다른 범용 레지스터는 수정하지 않거나 복원한다.
- `IDIV`는 **0을 향해 버림**한 정수 몫을 구한다. `source2`는 0이 아니어야 하고 몫이 SDWORD 범위에 있어야 한다.
- 덧셈·뺄셈·곱셈에서 오버플로를 검사하지 않으므로, 테스트 값은 결과가 32비트 부호 있는 정수 범위에 들어가도록 선택했다.
