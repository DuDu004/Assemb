# Algorithm Workbench

**기준:** *Assembly Language for x86 Processors*, 7th Edition, §10.7.2. 아래 답안은 **32비트 MASM 문법**을 기준으로 한다. `Irvine32.inc`를 사용하는 예제에서는 해당 라이브러리와, 필요하다면 `Macros.inc`를 포함한다고 가정한다. 문제에서 코드의 일부만 요구한 경우에는 해당 부분만 제시한다.

---

## 1. SampleStruct 구조체 선언

**영문 문제:**

Create a structure named SampleStruct containing two fields: field1, a single 16-bit WORD, and field2, an array of 20 32-bit DWORDs. The initial values of the fields may be left undefined.

**한글 번역:**

`field1`에는 16비트 `WORD` 하나, `field2`에는 32비트 `DWORD` 20개로 이루어진 배열이 들어 있는 `SampleStruct` 구조체를 선언하시오. 초깃값은 정의하지 않아도 된다.

**답:**

```asm
SampleStruct STRUCT
    field1 WORD ?
    field2 DWORD 20 DUP(?)
SampleStruct ENDS
```

---

## 2. SYSTEMTIME의 wHour 필드 읽기

**영문 문제:**

Write a statement that retrieves the wHour field of a SYSTEMTIME structure.

**한글 번역:**

`SYSTEMTIME` 구조체에서 `wHour` 필드의 값을 가져오는 명령문을 작성하시오.

**답:**

```asm
.data
sysTime SYSTEMTIME <>

.code
mov ax, sysTime.wHour
```

`wHour`는 16비트 `WORD` 필드이므로 `AX`에 읽는다. 실제 시간을 먼저 채우려면 `GetLocalTime` 등의 호출이 필요하다.

---

## 3. Triangle 구조체 초기화

**영문 문제:**

Using the following Triangle structure, declare a structure variable and initialize its vertices to (0,0), (5, 0), and (7,6):

```asm
Triangle STRUCT
    Vertex1 COORD <>
    Vertex2 COORD <>
    Vertex3 COORD <>
Triangle ENDS
```

**한글 번역:**

제시된 `Triangle` 구조체를 사용하여 구조체 변수를 선언하고 세 꼭짓점을 순서대로 `(0,0)`, `(5,0)`, `(7,6)`으로 초기화하시오.

**답:**

```asm
Triangle STRUCT
    Vertex1 COORD <>
    Vertex2 COORD <>
    Vertex3 COORD <>
Triangle ENDS

.data
triangle1 Triangle <<0,0>, <5,0>, <7,6>>
```

중첩된 `COORD`의 `X`, `Y` 값을 꺾쇠괄호로 차례대로 초기화한다.

---

## 4. Triangle 배열의 Vertex1을 무작위 좌표로 초기화

**영문 문제:**

Declare an array of Triangle structures. Write a loop that initializes Vertex1 of each triangle to random coordinates in the range (0...10, 0...10).

**한글 번역:**

`Triangle` 구조체의 배열을 선언하고, 반복문을 사용하여 각 삼각형의 `Vertex1` 좌표를 `X=0~10`, `Y=0~10` 범위의 무작위 값으로 초기화하시오.

**답:** (`Triangle`은 3번과 같이 선언되어 있다고 가정)

```asm
TriangleCount = 5

.data
triangles Triangle TriangleCount DUP(<>)

.code
call Randomize
mov esi, OFFSET triangles
mov ecx, TriangleCount

L1:
    push ecx

    mov eax, 11
    call RandomRange
    mov (Triangle PTR [esi]).Vertex1.X, ax

    mov eax, 11
    call RandomRange
    mov (Triangle PTR [esi]).Vertex1.Y, ax

    add esi, TYPE Triangle
    pop ecx
    loop L1
```

**짧은 설명:** `RandomRange`에 `11`을 전달하면 `0~10` 가운데 하나를 생성한다. `TYPE Triangle`만큼 주소를 증가시켜 다음 구조체로 이동한다. `COORD`의 좌표 필드는 `WORD`이므로 `AX`를 저장한다.

---

## 5. mPrintChar 매크로

**영문 문제:**

Write a macro named mPrintChar that displays a single character on the screen. It should have two parameters: this first specifies the character to be displayed and the second specifies how many times the character should be repeated. Here is a sample call:

```asm
mPrintChar 'X',20
```

**한글 번역:**

문자 하나를 화면에 출력하는 `mPrintChar` 매크로를 작성하시오. 첫 번째 인수는 출력할 문자이고, 두 번째 인수는 반복 출력 횟수다. 예: `mPrintChar 'X',20`.

**답:**

```asm
mPrintChar MACRO ch:REQ, count:REQ
    LOCAL Again, Done
    push eax
    push ecx
    mov ecx, count
    jecxz Done
Again:
    mov al, ch
    push ecx
    call WriteChar
    pop ecx
    loop Again
Done:
    pop ecx
    pop eax
ENDM

; 사용 예
mPrintChar 'X', 20
```

**예상 출력:**

```text
XXXXXXXXXXXXXXXXXXXX
```

---

## 6. mGenRandom 매크로

**영문 문제:**

Write a macro named mGenRandom that generates a random integer between 0 and n - 1. Let n be the only parameter.

**한글 번역:**

`0`부터 `n-1`까지의 무작위 정수를 생성하는 `mGenRandom` 매크로를 작성하시오. 매개변수는 `n` 하나만 사용하시오.

**답:**

```asm
mGenRandom MACRO n:REQ
    mov eax, n
    call RandomRange
ENDM

; 프로그램 시작 시 한 번: call Randomize
mGenRandom 10             ; EAX = 0~9 중 하나
```

`n`은 양의 정수로 전달한다고 가정한다. 난수 결과는 `EAX`에 저장된다.

---

## 7. mPromptInteger 매크로

**영문 문제:**

Write a macro named mPromptInteger that displays a prompt and inputs an integer from the user. Pass it a string literal and the name of a doubleword variable. Sample call:

```asm
.data
minVal DWORD ?
.code
mPromptInteger "Enter the minimum value", minVal
```

**한글 번역:**

안내 문구를 출력하고 사용자로부터 정수를 입력받는 `mPromptInteger` 매크로를 작성하시오. 문자열 리터럴과 결과를 저장할 `DWORD` 변수 이름을 전달하시오.

**답:** (`INCLUDE Irvine32.inc` 및 `INCLUDE Macros.inc` 사용)

```asm
mPromptInteger MACRO promptText:REQ, outVar:REQ
    mWrite promptText
    call ReadInt
    mov outVar, eax
ENDM

.data
minVal DWORD ?

.code
mPromptInteger "Enter the minimum value", minVal
```

`mWrite`가 문구를 출력하고, `ReadInt`가 읽은 부호 있는 정수를 `EAX`에 반환한다.

---

## 8. mWriteAt 매크로

**영문 문제:**

Write a macro named mWriteAt that locates the cursor and writes a string literal to the console window. Suggestion: Invoke the mGotoxy and mWrite macros from the book’s macro library.

**한글 번역:**

콘솔 창의 커서를 지정된 위치로 이동한 다음 문자열 리터럴을 출력하는 `mWriteAt` 매크로를 작성하시오. 교재의 `mGotoxy`와 `mWrite` 매크로를 활용하시오.

**답:** (`INCLUDE Macros.inc` 사용)

```asm
mWriteAt MACRO x:REQ, y:REQ, message:REQ
    mGotoxy x, y
    mWrite message
ENDM

; 열 10, 행 5부터 출력
mWriteAt 10, 5, "Hello"
```

`mGotoxy`의 첫 인수는 열(`X`), 두 번째 인수는 행(`Y`)이다.

---

## 9. mWriteString 매크로 확장

**영문 문제:**

Show the expanded code produced by the following statement that invokes the mWriteString macro from Section 10.2.5:

```asm
mWriteStr namePrompt
```

**한글 번역:**

10.2.5절의 `mWriteString` 매크로를 호출했을 때 전처리기가 생성하는 확장 코드를 작성하시오. 문제에 제시된 호출 문장은 `mWriteStr namePrompt`다.

**답:**

교재에서 정의한 이름은 **`mWriteString`**이다. 문제의 `mWriteStr`가 별도로 정의되지 않았다면 그대로는 확장되지 않는다. 교재의 실제 이름으로 고친 `mWriteString namePrompt`의 확장 코드는 다음과 같다.

```asm
push edx
mov  edx, OFFSET namePrompt
call WriteString
pop  edx
```

---

## 10. mReadString 매크로 확장

**영문 문제:**

Show the expanded code produced by the following statement that invokes the mReadString macro from Section 10.2.5:

```asm
mReadStr customerName
```

**한글 번역:**

10.2.5절의 `mReadString` 매크로를 호출했을 때 전처리기가 생성하는 확장 코드를 작성하시오. 문제에 제시된 호출 문장은 `mReadStr customerName`이다.

**답:**

교재에서 정의한 이름은 **`mReadString`**이다. 문제의 `mReadStr`가 별도로 정의되지 않았다면 그대로는 확장되지 않는다. 교재의 실제 이름으로 고친 `mReadString customerName`의 확장 코드는 다음과 같다.

```asm
push ecx
push edx
mov  edx, OFFSET customerName
mov  ecx, SIZEOF customerName
call ReadString
pop  edx
pop  ecx
```

---

## 11. mDumpMemx 매크로

**영문 문제:**

Write a macro named mDumpMemx that receives a single parameter, the name of a variable. Your macro must call the mDumpMem macro from the book’s library, passing it the variable’s offset, number of units, and unit size. Demonstrate a call to the mDumpMemx macro.

**한글 번역:**

변수 이름 하나만 인수로 전달받는 `mDumpMemx` 매크로를 작성하시오. 교재의 `mDumpMem` 매크로에 해당 변수의 시작 주소, 원소 개수, 원소 크기를 전달해야 한다. 호출 예제도 작성하시오.

**답:** (`INCLUDE Macros.inc` 사용)

```asm
mDumpMemx MACRO varName:REQ
    mDumpMem OFFSET varName, LENGTHOF varName, TYPE varName
ENDM

.data
numbers DWORD 10, 20, 30, 40

.code
mDumpMemx numbers
```

위 호출은 다음 매크로 호출로 펼쳐진다.

```asm
mDumpMem OFFSET numbers, 4, 4
```

---

## 12. 기본 인수(initializer)가 있는 매크로 매개변수

**영문 문제:**

Show an example of a macro parameter having a default argument initializer.

**한글 번역:**

기본 인수가 지정된 매크로 매개변수의 예제를 작성하시오.

**답:**

```asm
mSetValue MACRO value:=<10>
    mov eax, value
ENDM

mSetValue           ; mov eax, 10
mSetValue 25        ; mov eax, 25
```

`value:=<10>`은 호출할 때 인수를 생략하면 기본값 `10`을 사용한다는 의미다.

---

## 13. IF, ELSE, ENDIF 지시어

**영문 문제:**

Write a short example that uses the IF, ELSE, and ENDIF directives.

**한글 번역:**

`IF`, `ELSE`, `ENDIF` 지시어를 사용하는 간단한 예제를 작성하시오.

**답:**

```asm
LEVEL = 2

IF LEVEL GE 2
    mov eax, 100
ELSE
    mov eax, 0
ENDIF
```

`IF`는 **어셈블 시점의 상수 조건**을 검사한다. 위 예제에서 생성되는 명령은 `mov eax, 100`뿐이다.

---

## 14. 음수 매크로 인수 Z 검사

**영문 문제:**

Write a statement using the IF directive that checks the value of the constant macro parameter Z; if Z is less than zero, display a message during assembly indicating that Z is invalid.

**한글 번역:**

매크로의 상수 매개변수 `Z`가 0보다 작은지 `IF` 지시어로 검사하시오. 음수라면 **어셈블 과정에서** `Z`가 유효하지 않다는 메시지를 표시하시오.

**답:**

```asm
mCheckZ MACRO Z:REQ
    IF Z LT 0
        ECHO Invalid Z: value must not be negative.
    ENDIF
ENDM

mCheckZ -3
```

`ECHO`는 프로그램 실행 중이 아니라 **어셈블 단계**에서 메시지를 출력한다.

---

## 15. 문자열 안에서 & 연산자 사용

**영문 문제:**

Write a short macro that demonstrates the use of the & operator when the macro parameter is embedded in a literal string.

**한글 번역:**

문자열 리터럴 안에 매크로 매개변수가 포함될 때 `&` 연산자를 사용하는 짧은 매크로를 작성하시오.

**답:** (`INCLUDE Macros.inc` 사용)

```asm
mShowName MACRO varName:REQ
    mWrite "Variable name: &varName"
ENDM

mShowName total
```

**예상 출력:**

```text
Variable name: total
```

`&varName`은 문자열 리터럴 내부에서 매개변수 이름을 전달한 실제 인수 텍스트로 치환하도록 지시한다.

---

## 16. mLocate 매크로 전처리 확장

**영문 문제:**

Assume the following mLocate macro definition:

```asm
mLocate MACRO xval,yval
    IF xval LT 0    ;; xval < 0?
        EXITM       ;; if so, exit
    ENDIF
    IF yval LT 0    ;; yval < 0?
        EXITM       ;; if so, exit
    ENDIF
    mov bx,0        ;; video page 0
    mov ah,2        ;; locate cursor
    mov dh,yval
    mov dl,xval
    int 10h         ;; call the BIOS
ENDM
```

Show the source code generated by the preprocessor when the macro is expanded by each of the following statements:

```asm
.data
row BYTE 15
col BYTE 60
.code
mLocate -2,20
mLocate 10,20
mLocate col,row
```

**한글 번역:**

제시된 `mLocate` 매크로를 사용한다고 가정하시오. 다음 세 호출문 각각에 대하여 전처리기가 매크로를 확장했을 때 생성되는 소스 코드를 작성하시오.

- `mLocate -2,20`
- `mLocate 10,20`
- `mLocate col,row` (`row`와 `col`은 `BYTE` 변수)

**답:**

**(a) `mLocate -2,20`**

```asm
; 생성되는 실행 명령 없음
```

`xval=-2`가 `IF xval LT 0` 조건을 만족하므로 `EXITM`에서 매크로 확장을 종료한다.

**(b) `mLocate 10,20`**

```asm
mov bx, 0
mov ah, 2
mov dh, 20
mov dl, 10
int 10h
```

두 인수가 모두 0 이상이므로 위 명령어들이 생성된다.

**(c) `mLocate col,row`**

```asm
; 원래 매크로대로는 올바른 확장 코드를 생성할 수 없음
; IF col LT 0 / IF row LT 0에서 어셈블 시점 상수 조건이 필요함
```

`col`과 `row`는 메모리 변수이고, `IF` 지시어는 실행 중 변하는 변수의 **값**을 검사할 수 없다. 따라서 이 호출은 제시된 매크로 그대로는 조건부 어셈블 오류가 발생한다. 단순히 두 `IF` 검사를 제거해 인수만 치환한 경우의 명령어는 다음과 같다(원래 매크로의 정상적인 확장 결과는 아님).

```asm
mov bx, 0
mov ah, 2
mov dh, row
mov dl, col
int 10h
```

---