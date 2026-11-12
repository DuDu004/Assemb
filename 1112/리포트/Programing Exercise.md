# Programming Exercises

## 1. Improved Str_copy Procedure

### 영문 문제

The Str_copy procedure shown in this chapter does not limit the number of characters to be copied. Create a new version (named Str_copyN) that receives an additional input parameter indicating the maximum number of characters to be copied.

### 한글 번역

이 장에서 소개한 `Str_copy` 프로시저는 복사할 문자 수에 제한을 두지 않습니다. 복사 가능한 **최대 문자 수**를 나타내는 입력 매개변수를 추가로 받는 새로운 버전의 프로시저 `Str_copyN`을 작성하시오.

문자열은 널 문자(`0`)로 끝나는 문자열을 사용합니다.

### 어셈블리 코드 (32비트 MASM / Irvine32)

```asm
TITLE Improved Str_copy Procedure
INCLUDE Irvine32.inc

Str_copyN PROTO, source:PTR BYTE, target:PTR BYTE, maxChars:DWORD

.data
source1 BYTE "Assembly Language", 0
source2 BYTE "MASM", 0
source3 BYTE "Computer", 0
buffer  BYTE 32 DUP(?)

msg1 BYTE "Test 1 (max=5):  ", 0
msg2 BYTE "Test 2 (max=10): ", 0
msg3 BYTE "Test 3 (max=3):  ", 0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString
    INVOKE Str_copyN, ADDR source1, ADDR buffer, 5
    mov edx, OFFSET buffer
    call WriteString
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    INVOKE Str_copyN, ADDR source2, ADDR buffer, 10
    mov edx, OFFSET buffer
    call WriteString
    call Crlf

    mov edx, OFFSET msg3
    call WriteString
    INVOKE Str_copyN, ADDR source3, ADDR buffer, 3
    mov edx, OFFSET buffer
    call WriteString
    call Crlf

    exit
main ENDP

; source   = 원본 문자열 주소
; target   = 복사할 버퍼 주소
; maxChars = 복사할 최대 문자 수 (널 문자 제외)
; target 버퍼는 최대 maxChars+1바이트가 필요함

Str_copyN PROC USES eax ecx esi edi,
    source:PTR BYTE,
    target:PTR BYTE,
    maxChars:DWORD

    INVOKE Str_length, source
    mov ecx, eax              ; 원본 문자열의 길이
    cmp ecx, maxChars
    jbe CopyReady
    mov ecx, maxChars         ; 최대 문자 수로 제한

CopyReady:
    mov esi, source
    mov edi, target
    cld
    rep movsb                 ; ECX개 문자 복사
    mov BYTE PTR [edi], 0     ; 널 종료 문자 추가
    ret
Str_copyN ENDP

END main
```

### 실행 결과 (예상)

```text
Test 1 (max=5):  Assem
Test 2 (max=10): MASM
Test 3 (max=3):  Com
```

### 개요

- `Str_length`로 원본 문자열의 길이를 구한 후 `maxChars`와 비교하여 더 작은 수만큼 복사한다.
- `REP MOVSB`는 `ECX`에 지정된 개수의 바이트를 복사한다.
- `MOV BYTE PTR [EDI], 0`으로 복사 결과를 반드시 널 종료합니다. `maxChars=0`이어도 빈 문자열이 된다.
- 대상 버퍼는 **최대 복사 문자 수 + 널 종료 1바이트**를 저장할 만큼 충분히 커야 한다. 소스 길이가 더 짧으면 소스 길이까지만 복사한다.

## 2. Str_concat Procedure

### 영문 문제

Write a procedure named Str_concat that concatenates a source string to the end of a target string. Sufficient space must exist in the target string to accommodate the new characters. Pass pointers to the source and target strings. Here is a sample call:

```asm
.data
targetStr BYTE "ABCDE",10 DUP(0)
sourceStr BYTE "FGH",0
.code
INVOKE Str_concat, ADDR targetStr, ADDR sourceStr
```

### 한글 번역

원본 문자열(source string)을 대상 문자열(target string)의 끝에 이어 붙이는 `Str_concat` 프로시저를 작성하시오.

대상 문자열에는 새로 추가할 문자들을 저장할 **충분한 공간**이 있어야 합니다. 원본 문자열과 대상 문자열의 주소를 포인터 매개변수로 전달하시오. 위 코드는 호출 예시입니다.

### 어셈블리 코드

```asm
TITLE Str_concat Procedure
INCLUDE Irvine32.inc

Str_concat PROTO, pTarget:PTR BYTE, pSource:PTR BYTE

.data
targetStr BYTE "ABCDE", 10 DUP(0)
sourceStr BYTE "FGH", 0
sourceStr2 BYTE "XYZ", 0

msg1 BYTE "Before:  ", 0
msg2 BYTE "After 1: ", 0
msg3 BYTE "After 2: ", 0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString
    mov edx, OFFSET targetStr
    call WriteString
    call Crlf

    ; 첫 번째 문자열 연결
    INVOKE Str_concat, ADDR targetStr, ADDR sourceStr
    mov edx, OFFSET msg2
    call WriteString
    mov edx, OFFSET targetStr
    call WriteString
    call Crlf

    ; 두 번째 문자열 연결
    INVOKE Str_concat, ADDR targetStr, ADDR sourceStr2
    mov edx, OFFSET msg3
    call WriteString
    mov edx, OFFSET targetStr
    call WriteString
    call Crlf

    exit
main ENDP

; pTarget: 연결 결과를 저장할 문자열 주소
; pSource: 뒤에 붙일 문자열 주소
Str_concat PROC USES eax esi edi,
    pTarget:PTR BYTE,
    pSource:PTR BYTE

    mov edi, pTarget

FindEnd:
    cmp BYTE PTR [edi], 0
    je Append
    inc edi
    jmp FindEnd

Append:
    mov esi, pSource

CopyChar:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    test al, al
    jnz CopyChar

    ret
Str_concat ENDP

END main
```

### 실행 결과 (예상)

```text
Before:  ABCDE
After 1: ABCDEFGH
After 2: ABCDEFGHXYZ
```

### 개요

- `FindEnd`: 대상 문자열에서 널 종료 문자(`0`)를 찾아 끝 위치를 구한다.
- `CopyChar`: 원본 문자열의 각 문자를 대상 문자열 끝으로 복사한다.
- 원본의 널 종료 문자도 함께 복사하므로 연결된 결과 역시 널 종료 문자열이다.
- `USES eax esi edi`: 프로시저가 변경하는 레지스터를 보존한다.
- 대상 버퍼 크기는 `기존 문자열 길이 + 추가할 문자열 길이 + 널 문자 1바이트` 이상이어야 한다. 예제의 `targetStr`은 총 15바이트이며, 두 번 연결한 결과는 널 문자를 포함해 12바이트이므로 충분하다.

## 3. Str_remove Procedure

### 영문 문제

Write a procedure named Str_remove that removes n characters from a string. Pass a pointer to
the position in the string where the characters are to be removed. Pass an integer specifying the number of characters to remove. The following code, for example, shows how to remove “xxxx” from target:

```asm
.data
target BYTE "abcxxxxdefghijklmop",0
.code
INVOKE Str_remove, ADDR [target+3], 4
```

### 한글 번역

문자열에서 **n개의 문자를 삭제하는 `Str_remove` 프로시저**를 작성하시오.

삭제를 시작할 **문자열 내부 위치의 주소**와 **삭제할 문자 수**를 매개변수로 전달하시오. 예시에서는 `target`의 4번째 문자부터 `xxxx` 4개를 제거합니다.

### 어셈블리 코드

```asm
TITLE Str_remove Procedure
INCLUDE Irvine32.inc

Str_remove PROTO, pStart:PTR BYTE, n:DWORD

.data
target  BYTE "abcxxxxdefghijklmop", 0
target2 BYTE "12345", 0
target3 BYTE "HELLO", 0

msg1 BYTE "Before: ", 0
msg2 BYTE "After:  ", 0
msg3 BYTE "Remove beyond end: ", 0
msg4 BYTE "Remove zero: ", 0

.code
main PROC
    ; Test 1: 가운데의 xxxx 삭제
    mov edx, OFFSET msg1
    call WriteString
    mov edx, OFFSET target
    call WriteString
    call Crlf

    INVOKE Str_remove, ADDR [target+3], 4

    mov edx, OFFSET msg2
    call WriteString
    mov edx, OFFSET target
    call WriteString
    call Crlf

    ; Test 2: 남은 문자열보다 많이 삭제
    INVOKE Str_remove, ADDR [target2+1], 10
    mov edx, OFFSET msg3
    call WriteString
    mov edx, OFFSET target2
    call WriteString
    call Crlf

    ; Test 3: 0개 삭제
    INVOKE Str_remove, ADDR target3, 0
    mov edx, OFFSET msg4
    call WriteString
    mov edx, OFFSET target3
    call WriteString
    call Crlf

    exit
main ENDP

; pStart = 삭제 시작 위치의 주소
; n      = 삭제할 문자 수
Str_remove PROC USES eax ecx esi edi,
    pStart:PTR BYTE,
    n:DWORD

    mov esi, pStart
    mov edi, esi
    mov ecx, n
    test ecx, ecx
    jz Done

SkipChars:
    cmp BYTE PTR [esi], 0
    je ShiftLeft
    inc esi
    loop SkipChars

ShiftLeft:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    test al, al
    jnz ShiftLeft

Done:
    ret
Str_remove ENDP

END main
```

### 실행 결과 (예상)

```text
Before: abcxxxxdefghijklmop
After:  abcdefghijklmop
Remove beyond end: 1
Remove zero: HELLO
```

### 개요

- `pStart`는 **문자열의 시작 주소가 아니라 삭제할 부분의 첫 문자 주소**다.
- `ESI`를 삭제할 문자 수만큼 앞으로 이동시키되, 문자열 끝(`0`)을 만나면 멈춘다.
- `EDI`는 삭제 시작 위치에 그대로 두고, `ESI`부터 **널 종료 문자까지** 차례로 복사하여 빈 공간을 메운다.
- 삭제할 문자 수가 `0`이면 아무것도 변경하지 않는다. 남은 문자 수보다 많이 삭제해도 널 종료 위치까지만 처리한다.

## 4. Str_find Procedure

### 영문 문제

Write a procedure named Str_find that searches for the first matching occurrence of a source string inside a target string and returns the matching position. The input parameters should be a pointer to the source string and a pointer to the target string. If a match is found, the procedure sets the Zero flag and EAX points to the matching position in the target string. Otherwise, the Zero flag is clear and EAX is undefined. The following code, for example, searches for “ABC” and returns with EAX pointing to the “A” in the target string:

```asm
.data
target BYTE "123ABC342432",0
source BYTE "ABC",0
pos DWORD ?
.code
INVOKE Str_find, ADDR source, ADDR target
jnz notFound
mov pos,eax     ; store the position value
```

### 한글 번역

대상 문자열(target string)에서 원본 문자열(source string)이 **처음 나타나는 위치**를 검색하는 `Str_find` 프로시저를 작성하시오.

원본 문자열과 대상 문자열의 주소를 매개변수로 전달한다. 문자열을 찾으면 **Zero Flag(ZF)를 1로 설정**하고, `EAX`에 일치하는 위치의 **메모리 주소**를 반환한다. 문자열을 찾지 못하면 **ZF를 0으로 설정**하며 `EAX`의 값은 정의되지 않는다.

예시에서는 `"123ABC342432"` 안에서 `"ABC"`를 찾아 `A`의 주소를 반환한다.

### 어셈블리 코드

```asm
TITLE Str_find Procedure
INCLUDE Irvine32.inc

Str_find PROTO, pSource:PTR BYTE, pTarget:PTR BYTE
ShowResult PROTO, pSource:PTR BYTE, pTarget:PTR BYTE

.data
target  BYTE "123ABC342432", 0
target2 BYTE "ABABC", 0

source1 BYTE "ABC", 0
source2 BYTE "342", 0
source3 BYTE "XYZ", 0
source4 BYTE "23", 0

msgIndex BYTE " -> index ", 0
msgFail  BYTE " -> not found", 0

.code
main PROC
    INVOKE ShowResult, ADDR source1, ADDR target
    INVOKE ShowResult, ADDR source2, ADDR target
    INVOKE ShowResult, ADDR source3, ADDR target
    INVOKE ShowResult, ADDR source4, ADDR target
    INVOKE ShowResult, ADDR source1, ADDR target2
    exit
main ENDP

; 일치 시 EAX = 첫 일치 문자의 주소, ZF = 1
; 불일치 시 ZF = 0 (EAX는 사용하지 않음)
Str_find PROC USES ebx esi edi,
    pSource:PTR BYTE,
    pTarget:PTR BYTE

    mov ebx, pTarget          ; 검사할 시작 주소

NextStart:
    mov esi, pSource
    mov edi, ebx

CompareChar:
    mov al, [esi]
    cmp al, 0                ; 원본 끝까지 일치했는가?
    je Found
    cmp BYTE PTR [edi], 0   ; 대상 문자열 끝인가?
    je NotFound
    cmp al, [edi]
    jne NextChar
    inc esi
    inc edi
    jmp CompareChar

NextChar:
    inc ebx
    jmp NextStart

Found:
    mov eax, ebx            ; 첫 일치 위치의 주소
    cmp BYTE PTR [esi], 0  ; ZF = 1
    ret

NotFound:
    mov eax, -1
    or eax, eax             ; ZF = 0
    ret
Str_find ENDP

; 테스트 결과를 인덱스로 출력
ShowResult PROC USES ebx edx,
    pSource:PTR BYTE,
    pTarget:PTR BYTE

    mov edx, pSource
    call WriteString

    INVOKE Str_find, pSource, pTarget
    jnz NoMatch             ; ZF가 0이면 실패

    sub eax, pTarget        ; 주소를 시작 인덱스로 변환
    mov ebx, eax
    mov edx, OFFSET msgIndex
    call WriteString
    mov eax, ebx
    call WriteDec
    call Crlf
    ret

NoMatch:
    mov edx, OFFSET msgFail
    call WriteString
    call Crlf
    ret
ShowResult ENDP

END main
```

### 실행 결과 (예상)

```text
ABC -> index 3
342 -> index 6
XYZ -> not found
23 -> index 1
ABC -> index 2
```

> 출력한 `index`는 문자열의 시작을 0으로 하는 **인덱스**이다. `Str_find` 자체는 인덱스가 아닌 **실제 메모리 주소**를 `EAX`에 반환한다.

### 개요

- `EBX`: 대상 문자열에서 검색을 시작할 위치를 저장한다.
- `ESI`, `EDI`: 원본과 대상의 문자를 하나씩 비교한다.
- `CMP AL, [EDI]`: 두 문자가 다르면 다음 시작 위치에서 다시 검색한다.
- `Found`: `EAX`에 시작 주소를 저장하고 `ZF=1`로 설정한다.
- `NotFound`: `ZF=0`으로 설정한다. 이때 `EAX`의 값은 사용하지 않는다.
- `JNZ NoMatch`: `Str_find` 호출 직후 ZF를 검사해 검색 실패 여부를 판단한다.
- 빈 원본 문자열은 대상 문자열의 시작 위치에서 일치한 것으로 처리한다.

## 5. Str_nextWord Procedure

### 영문 문제

Write a procedure called Str_nextWord that scans a string for the first occurrence of a certain delimiter character and replaces the delimiter with a null byte. There are two input parameters: a pointer to the string and the delimiter character. After the call, if the delimiter was found, the Zero flag is set and EAX contains the offset of the next character beyond the delimiter. Otherwise, the Zero flag is clear and EAX is undefined. The following example code passes the address of target and a comma as the delimiter:

```asm
.data
    target BYTE "Johnson,Calvin",0
.code
    INVOKE Str_nextWord, ADDR target, ','
    jnz notFound
```

In Figure 9-5, after calling Str_nextWord, EAX points to the character following the position where the comma was found (and replaced).

### 한글 번역

문자열에서 지정한 구분 문자(delimiter)가 처음 나타나는 위치를 찾고, 해당 문자를 널 바이트(`0`)로 바꾸는 `Str_nextWord` 프로시저를 작성하시오.

매개변수는 문자열 주소와 구분 문자 두 개를 전달한다.

- **구분 문자를 발견한 경우:** Zero Flag(`ZF`)를 1로 설정하고, 구분 문자 바로 다음 문자의 주소를 `EAX`에 반환한다.
- **구분 문자를 발견하지 못한 경우:** `ZF`를 0으로 설정한다. `EAX` 반환값은 정의하지 않는다.

예제에서는 `"Johnson,Calvin"`의 쉼표를 널 문자로 바꾸고, `EAX`가 `C`의 주소를 가리키도록 한다.

### 어셈블리 코드

```asm
TITLE Str_nextWord Procedure
INCLUDE Irvine32.inc

Str_nextWord PROTO, pString:PTR BYTE, delimiter:BYTE
TestNextWord PROTO, pText:PTR BYTE, separator:BYTE

.data
target1 BYTE "Johnson,Calvin",0
target2 BYTE "Assembly",0
target3 BYTE ",Start",0
target4 BYTE "End,",0

msg1 BYTE "Test 1: ",0
msg2 BYTE "Test 2: ",0
msg3 BYTE "Test 3: ",0
msg4 BYTE "Test 4: ",0
noMatchMsg BYTE "Not found: ",0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString
    INVOKE TestNextWord, ADDR target1, ','

    mov edx, OFFSET msg2
    call WriteString
    INVOKE TestNextWord, ADDR target2, ','

    mov edx, OFFSET msg3
    call WriteString
    INVOKE TestNextWord, ADDR target3, ','

    mov edx, OFFSET msg4
    call WriteString
    INVOKE TestNextWord, ADDR target4, ','

    exit
main ENDP

; 성공: 구분 문자를 0으로 교체, EAX = 다음 문자 주소, ZF = 1
; 실패: ZF = 0 (EAX 값은 사용하지 않음)
Str_nextWord PROC USES esi,
    pString:PTR BYTE,
    delimiter:BYTE

    mov esi, pString

ScanNext:
    mov al, [esi]
    test al, al
    jz NotFound

    cmp al, delimiter
    je Found

    inc esi
    jmp ScanNext

Found:
    mov BYTE PTR [esi], 0
    lea eax, [esi+1]
    cmp BYTE PTR [esi], 0    ; ZF = 1
    ret

NotFound:
    mov eax, -1
    or eax, eax              ; ZF = 0
    ret
Str_nextWord ENDP

; 검색 전·후 문자열을 출력하는 테스트 프로시저
TestNextWord PROC USES ebx edx,
    pText:PTR BYTE,
    separator:BYTE

    INVOKE Str_nextWord, pText, separator
    jnz NoMatch             ; 반환된 ZF를 즉시 검사

    mov ebx, eax            ; 구분 문자 다음 주소 보관
    mov edx, pText
    call WriteString
    mov al, '|'
    call WriteChar
    mov edx, ebx
    call WriteString
    call Crlf
    ret

NoMatch:
    mov edx, OFFSET noMatchMsg
    call WriteString
    mov edx, pText
    call WriteString
    call Crlf
    ret
TestNextWord ENDP

END main
```

### 실행 결과 (예상)

```text
Test 1: Johnson|Calvin
Test 2: Not found: Assembly
Test 3: |Start
Test 4: End|
```

### 개요

- `ESI`: 문자열의 현재 검사 위치를 가리킨다.
- `CMP AL, delimiter`: 현재 문자가 구분 문자와 같은지 비교한다.
- `MOV BYTE PTR [ESI], 0`: 발견한 구분 문자를 널 문자로 바꾼다.
- `LEA EAX, [ESI+1]`: 구분 문자 다음 위치의 **주소**를 반환한다.
- `CMP BYTE PTR [ESI], 0`: 성공 시 `ZF=1`로 설정한다.
- `OR EAX, EAX`: 실패 시 `ZF=0`으로 설정한다.
- `JNZ NoMatch`: `Str_nextWord` 호출 직후의 `ZF` 값을 검사한다.

**예제 메모리 변화:** `"Johnson,Calvin",0` → `"Johnson",0,"Calvin",0`. 처음 쉼표는 인덱스 7에 있고, 반환한 `EAX`는 인덱스 8에 해당하는 문자 `C`의 주소를 가리킨다. `EAX`에 저장된 것은 인덱스 8 자체가 아니라 실제 메모리 주소다.

## 6. Constructing a Frequency Table

### 영문 문제

Write a procedure named Get_frequencies that constructs a character frequency table. Input to the procedure should be a pointer to a string and a pointer to an array of 256 doublewords initialized to all zeros. Each array position is indexed by its corresponding ASCII code. When the procedure returns, each entry in the array contains a count of how many times the corresponding character occurred in the string. For example,

```asm
.data
target BYTE "AAEBDCFBBC",0
freqTable DWORD 256 DUP(0)
.code
INVOKE Get_frequencies, ADDR target, ADDR freqTable
```

Figure 9-6 shows a picture of the string and entries 41 (hexadecimal) through 4B in the frequency table. Position 41 contains the value 2 because the letter A (ASCII code 41h) occurred twice in the string. Similar counts are shown for other characters. Frequency tables are useful in data compression and other applications involving character processing. The Huffman encoding algorithm, for example, stores the most frequently occurring characters in fewer bits than other characters that occur less often.

(Figure 9–6: Sample character frequency table.)

### 한글 번역

문자별 등장 횟수를 저장하는 빈도표(Frequency Table)를 생성하는 `Get_frequencies` 프로시저를 작성하시오.

입력 매개변수는 **문자열 주소**와 **모든 요소가 0으로 초기화된 256개 DWORD 배열의 주소**다. 배열 인덱스는 각 문자의 ASCII 코드와 일치한다. 프로시저가 끝나면 배열의 각 요소에는 해당 문자가 문자열에 등장한 횟수가 저장되어야 한다.

예를 들어 `"AAEBDCFBBC"`에서 문자 `A`의 ASCII 코드는 `41h`이므로 `freqTable[41h]`에는 등장 횟수인 2가 저장된다. 이러한 빈도표는 데이터 압축, 허프만 부호화 등에서 활용된다.

### 어셈블리 코드 (32비트 MASM / Irvine32)

```asm
TITLE Constructing a Frequency Table
INCLUDE Irvine32.inc

Get_frequencies PROTO, pString:PTR BYTE, pTable:PTR DWORD
PrintFrequencies PROTO, pTable:PTR DWORD

.data
target     BYTE "AAEBDCFBBC", 0
freqTable  DWORD 256 DUP(0)

target2    BYTE "Hello!", 0
freqTable2 DWORD 256 DUP(0)

msg1 BYTE "Test 1: AAEBDCFBBC", 0
msg2 BYTE "Test 2: Hello!", 0

.code
main PROC
    ; Test 1
    mov edx, OFFSET msg1
    call WriteString
    call Crlf
    INVOKE Get_frequencies, ADDR target, ADDR freqTable
    INVOKE PrintFrequencies, ADDR freqTable
    call Crlf

    ; Test 2
    mov edx, OFFSET msg2
    call WriteString
    call Crlf
    INVOKE Get_frequencies, ADDR target2, ADDR freqTable2
    INVOKE PrintFrequencies, ADDR freqTable2

    exit
main ENDP

; 문자별 빈도수 계산
; pString = 널 종료 문자열 주소
; pTable  = 256개 DWORD 빈도표 주소
Get_frequencies PROC USES eax esi edi,
    pString:PTR BYTE,
    pTable:PTR DWORD

    mov esi, pString
    mov edi, pTable

CountLoop:
    movzx eax, BYTE PTR [esi]       ; ASCII 코드 (0~255)
    test eax, eax                   ; 널 종료 문자 검사
    jz CountDone

    inc DWORD PTR [edi + eax*4]    ; 해당 ASCII 코드의 횟수 증가
    inc esi
    jmp CountLoop

CountDone:
    ret
Get_frequencies ENDP

; 빈도가 1 이상인 문자만 ASCII 코드 순으로 출력
PrintFrequencies PROC USES ebx esi,
    pTable:PTR DWORD

    mov esi, pTable
    xor ebx, ebx

PrintLoop:
    cmp ebx, 256
    jae PrintDone
    cmp DWORD PTR [esi + ebx*4], 0
    je NextChar

    mov eax, ebx
    call WriteChar
    mov al, ':'
    call WriteChar
    mov al, ' '
    call WriteChar
    mov eax, [esi + ebx*4]
    call WriteDec
    call Crlf

NextChar:
    inc ebx
    jmp PrintLoop

PrintDone:
    ret
PrintFrequencies ENDP

END main
```

### 실행 결과 (예상)

```text
Test 1: AAEBDCFBBC
A: 2
B: 3
C: 2
D: 1
E: 1
F: 1

Test 2: Hello!
!: 1
H: 1
e: 1
l: 2
o: 1
```

### 개요

- `freqTable DWORD 256 DUP(0)`: ASCII 코드 0~255에 대응하는 256개 빈도 칸을 0으로 초기화한다.
- `MOVZX EAX, BYTE PTR [ESI]`: 문자의 ASCII 코드를 부호 없는 값으로 읽는다.
- `INC DWORD PTR [EDI + EAX*4]`: ASCII 코드에 해당하는 DWORD 요소의 값을 1 증가시킨다. DWORD는 4바이트이므로 인덱스에 4를 곱한다.
- `TEST EAX, EAX` / `JZ`: 문자열의 널 종료 문자(0)를 만나면 계산을 종료한다. 널 문자는 빈도에 포함하지 않는다.
- `PrintFrequencies`: 빈도가 0보다 큰 문자만 ASCII 코드 순서로 출력한다. 문제의 필수 프로시저는 `Get_frequencies`이며, `PrintFrequencies`는 테스트용이다.

## 7. Sieve of Eratosthenes

### 영문 문제

The Sieve of Eratosthenes, invented by the Greek mathematician of the same name, provides a quick way to find all prime numbers within a given range. The algorithm involves creating an array of bytes in which positions are “marked” by inserting 1s in the following manner: Beginning with position 2 (which is a prime number), insert a 1 in each array position that is a multiple of 2. Then do the same thing for multiples of 3, the next prime number. Find the next prime number after 3, which is 5, and mark all positions that are multiples of 5. Proceed in this manner until all multiples of primes have been found. The remaining positions of the array that are unmarked indicate which numbers are prime. For this program, create a 65,000-element array and display all primes between 2 and 65,000. Declare the array in an uninitialized data segment (see Section 3.4.11) and use STOSB to fill it with zeros.

### 한글 번역

그리스 수학자 에라토스테네스가 고안한 **에라토스테네스의 체(Sieve of Eratosthenes)**는 주어진 범위의 모든 소수를 빠르게 구하는 알고리즘이다.

바이트 배열을 만들고 합성수에 해당하는 위치를 **1**로 표시한다. 먼저 소수 2의 배수들을 표시하고, 다음 소수 3의 배수들, 이후 5의 배수들을 차례로 표시한다. 이러한 과정을 반복하면 **표시되지 않은 위치가 소수**에 해당한다.

**65,000개의 원소를 가진 배열**을 생성하고, **2부터 65,000까지의 모든 소수**를 화면에 출력한다. 배열은 **초기화되지 않은 데이터 세그먼트(`.data?`)**에 선언하며, **`STOSB` 명령어를 사용해 배열 전체를 0으로 초기화**한다.

### 어셈블리 코드

```asm
TITLE Sieve of Eratosthenes
INCLUDE Irvine32.inc

Sieve PROTO, pArray:PTR BYTE, arraySize:DWORD

.data
msg1 BYTE "Prime numbers (2..65000):", 0
msg2 BYTE "Total primes: ", 0

.data?
marked BYTE 65000 DUP(?)

.code
main PROC
    INVOKE Sieve, ADDR marked, LENGTHOF marked

    mov edx, OFFSET msg1
    call WriteString
    call Crlf

    mov esi, OFFSET marked
    mov ebx, 2             ; 검사할 숫자
    xor edi, edi           ; 소수 총개수
    xor ecx, ecx           ; 한 줄의 출력 개수

PrintLoop:
    cmp ebx, LENGTHOF marked
    jae PrintDone
    cmp BYTE PTR [esi+ebx], 0
    jne NextNumber

    push ecx
    mov eax, ebx
    call WriteDec
    mov al, ' '
    call WriteChar
    pop ecx

    inc edi
    inc ecx
    cmp ecx, 10
    jne NextNumber
    call Crlf
    xor ecx, ecx

NextNumber:
    inc ebx
    jmp PrintLoop

PrintDone:
    call Crlf
    mov edx, OFFSET msg2
    call WriteString
    mov eax, edi
    call WriteDec
    call Crlf
    exit
main ENDP

; pArray = 65,000바이트 배열 주소
; arraySize = 배열의 원소 개수
Sieve PROC USES eax ebx ecx edx esi edi,
    pArray:PTR BYTE,
    arraySize:DWORD

    ; STOSB로 배열 전체를 0으로 초기화
    mov edi, pArray
    mov ecx, arraySize
    xor eax, eax
    cld
    rep stosb

    mov esi, pArray
    mov ebx, 2

BaseLoop:
    mov eax, ebx
    imul eax, ebx          ; 기준 수의 제곱
    cmp eax, arraySize
    jae SieveDone

    cmp BYTE PTR [esi+ebx], 0
    jne NextBase

    mov edx, eax           ; 첫 배수 = 기준 수의 제곱
MarkLoop:
    cmp edx, arraySize
    jae NextBase
    mov BYTE PTR [esi+edx], 1
    add edx, ebx
    jmp MarkLoop

NextBase:
    inc ebx
    jmp BaseLoop

SieveDone:
    ret
Sieve ENDP

END main
```

### 실행 결과 (예상)

전체 **6,493개의 소수**를 모두 출력한다. 아래는 출력 내용의 앞부분과 끝부분만 발췌한 예시다. `...`은 실제 프로그램이 출력하는 문자가 아니다.

```text
Prime numbers (2..65000):
2 3 5 7 11 13 17 19 23 29
31 37 41 43 47 53 59 61 67 71
73 79 83 89 97 101 103 107 109 113
127 131 137 139 149 151 157 163 167 173
...
64709 64717 64747 64763 64781 64783 64793 64811 64817 64849
64853 64871 64877 64879 64891 64901 64919 64921 64927 64937
64951 64969 64997

Total primes: 6493
```

### 개요

- **`.data?`**: 초기값을 지정하지 않는 데이터 영역에 65,000바이트 배열을 선언한다.
- **`CLD`**: 방향 플래그를 0으로 설정해 `STOSB`가 주소를 증가시키게 한다.
- **`REP STOSB`**: `AL=0`인 상태에서 배열의 65,000개 원소를 모두 0으로 채운다.
- **`IMUL EAX, EBX`**: 기준 소수의 제곱을 계산한다. 그보다 작은 배수는 앞선 소수로 이미 처리됐으므로 제곱부터 표시한다.
- **`[ESI+EDX] = 1`**: 합성수 위치를 표시한다.
- **`[ESI+EBX] = 0`**: 표시되지 않은 숫자를 소수로 판단한다.
- **`WriteDec`**: 소수를 화면에 출력한다. 한 줄에 10개씩 배치한다.

## 8. Bubble Sort

### 영문 문제

Add a variable to the BubbleSort procedure in Section 9.5.1 that is set to 1 whenever a pair of values is exchanged within the inner loop. Use this variable to exit the sort before its normal completion if you discover that no exchanges took place during a complete pass through the array. (This variable is commonly known as an exchange flag.)

### 한글 번역

교재 9.5.1절의 `BubbleSort` 프로시저에 **교환 플래그(exchange flag)** 변수를 추가한다.

내부 반복문에서 인접한 두 값의 위치를 교환할 때마다 이 변수를 **1**로 설정한다. 배열을 한 차례 완전히 검사하는 동안 **교환이 한 번도 발생하지 않았다면**, 정해진 반복 횟수가 남아 있어도 정렬을 조기에 종료한다.

### 어셈블리 코드

```asm
TITLE Bubble Sort with Exchange Flag
INCLUDE Irvine32.inc

BubbleSort PROTO, pArray:PTR SDWORD, arraySize:DWORD
PrintArray PROTO, pArray:PTR SDWORD, arraySize:DWORD

.data
array1 SDWORD 7, -2, 4, 4, 1, 8
array2 SDWORD -3, 0, 1, 1, 9
array3 SDWORD 5, 4, 3, 2, 1

msg1 BYTE "Test 1 Before: ", 0
msg2 BYTE "Test 1 After:  ", 0
msg3 BYTE "Test 2 Before: ", 0
msg4 BYTE "Test 2 After:  ", 0
msg5 BYTE "Test 3 Before: ", 0
msg6 BYTE "Test 3 After:  ", 0

.code
main PROC
    ; Test 1: 정렬되지 않은 배열 (중복 및 음수 포함)
    mov edx, OFFSET msg1
    call WriteString
    INVOKE PrintArray, ADDR array1, LENGTHOF array1

    INVOKE BubbleSort, ADDR array1, LENGTHOF array1

    mov edx, OFFSET msg2
    call WriteString
    INVOKE PrintArray, ADDR array1, LENGTHOF array1

    ; Test 2: 이미 정렬된 배열
    mov edx, OFFSET msg3
    call WriteString
    INVOKE PrintArray, ADDR array2, LENGTHOF array2

    INVOKE BubbleSort, ADDR array2, LENGTHOF array2

    mov edx, OFFSET msg4
    call WriteString
    INVOKE PrintArray, ADDR array2, LENGTHOF array2

    ; Test 3: 역순 배열
    mov edx, OFFSET msg5
    call WriteString
    INVOKE PrintArray, ADDR array3, LENGTHOF array3

    INVOKE BubbleSort, ADDR array3, LENGTHOF array3

    mov edx, OFFSET msg6
    call WriteString
    INVOKE PrintArray, ADDR array3, LENGTHOF array3

    exit
main ENDP

; 인접한 값을 비교해 오름차순 정렬한다.
; 한 번의 전체 순회에서 교환이 없으면 즉시 종료한다.
BubbleSort PROC USES eax ecx esi,
    pArray:PTR SDWORD,
    arraySize:DWORD

    LOCAL exchanged:DWORD

    mov ecx, arraySize
    cmp ecx, 1
    jbe SortDone
    dec ecx

OuterLoop:
    mov exchanged, 0       ; 각 패스 시작 시 플래그 초기화
    mov esi, pArray
    push ecx               ; 바깥 반복 횟수 보존

InnerLoop:
    mov eax, [esi]
    cmp eax, [esi+4]
    jle NoSwap             ; 왼쪽 값이 작거나 같으면 교환하지 않음

    xchg eax, [esi+4]
    mov [esi], eax
    mov exchanged, 1       ; 교환 발생

NoSwap:
    add esi, 4
    loop InnerLoop

    pop ecx
    cmp exchanged, 0
    je SortDone            ; 한 번도 교환하지 않음: 조기 종료
    loop OuterLoop

SortDone:
    ret
BubbleSort ENDP

; SDWORD 배열을 한 줄에 출력한다.
PrintArray PROC USES eax ecx edx esi,
    pArray:PTR SDWORD,
    arraySize:DWORD

    mov esi, pArray
    mov ecx, arraySize
    test ecx, ecx
    jz PrintDone

PrintLoop:
    push ecx
    mov eax, [esi]
    call WriteInt
    mov al, ' '
    call WriteChar
    pop ecx

    add esi, 4
    loop PrintLoop

PrintDone:
    call Crlf
    ret
PrintArray ENDP

END main
```

### 실행 결과 (예상)

`WriteInt`는 부호 있는 정수를 출력하므로 양수에는 `+`, 음수에는 `-` 부호가 나타난다.

```text
Test 1 Before: +7 -2 +4 +4 +1 +8
Test 1 After:  -2 +1 +4 +4 +7 +8
Test 2 Before: -3 +0 +1 +1 +9
Test 2 After:  -3 +0 +1 +1 +9
Test 3 Before: +5 +4 +3 +2 +1
Test 3 After:  +1 +2 +3 +4 +5
```

### 개요

- **`LOCAL exchanged:DWORD`**: 교환 여부를 저장하는 지역 변수를 선언한다.
- **`MOV exchanged, 0`**: 바깥 반복문이 시작할 때 교환 플래그를 초기화한다.
- **`CMP EAX, [ESI+4]` / `JLE NoSwap`**: 인접한 두 정수를 부호 있는 값으로 비교하며, 왼쪽이 작거나 같으면 교환을 생략한다. **같은 값끼리는 교환하지 않아야 플래그가 정확하다.**
- **`XCHG`와 `MOV [ESI], EAX`**: 인접한 원소 두 개를 교환한다.
- **`MOV exchanged, 1`**: 실제로 교환이 발생했음을 기록한다.
- **`CMP exchanged, 0` / `JE SortDone`**: 한 차례의 비교에서 교환이 없다면 정렬을 즉시 종료한다.
- **`PUSH ECX` / `POP ECX`**: 내부 반복문을 실행하는 동안 바깥 반복 횟수를 보존한다.

## 9. Binary Search

### 영문 문제

Rewrite the binary search procedure shown in this chapter by using registers for mid, first, and last. Add comments to clarify the registers’ usage.

### 한글 번역

이 장에서 소개한 **이진 탐색(Binary Search)** 프로시저를 다시 작성하시오. 이때 중간 위치(`mid`), 탐색 시작 위치(`first`), 탐색 끝 위치(`last`)를 지역 변수 대신 **레지스터에 저장**하시오. 각 레지스터의 역할을 명확히 설명하는 주석을 추가하시오.

### 어셈블리 코드

```asm
TITLE Binary Search Using Registers
INCLUDE Irvine32.inc

BinarySearch PROTO, pArray:PTR SDWORD, arraySize:DWORD, searchVal:SDWORD

.data
numbers SDWORD -20, -7, 0, 4, 10, 19, 33, 42, 80

msg1 BYTE "Search 33: ", 0
msg2 BYTE "Search -20: ", 0
msg3 BYTE "Search 80: ", 0
msg4 BYTE "Search 12: ", 0
msg5 BYTE "Search 0: ", 0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString
    INVOKE BinarySearch, ADDR numbers, LENGTHOF numbers, 33
    call WriteInt
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    INVOKE BinarySearch, ADDR numbers, LENGTHOF numbers, -20
    call WriteInt
    call Crlf

    mov edx, OFFSET msg3
    call WriteString
    INVOKE BinarySearch, ADDR numbers, LENGTHOF numbers, 80
    call WriteInt
    call Crlf

    mov edx, OFFSET msg4
    call WriteString
    INVOKE BinarySearch, ADDR numbers, LENGTHOF numbers, 12
    call WriteInt
    call Crlf

    mov edx, OFFSET msg5
    call WriteString
    INVOKE BinarySearch, ADDR numbers, LENGTHOF numbers, 0
    call WriteInt
    call Crlf

    exit
main ENDP

; EBX = first: 탐색 구간의 첫 인덱스
; EDX = last:  탐색 구간의 마지막 인덱스
; ESI = mid:   탐색 구간의 중간 인덱스
; EDI = 배열의 시작 주소
; EAX = 검색 성공 시 인덱스, 실패 시 -1

BinarySearch PROC USES ebx edx esi edi,
    pArray:PTR SDWORD,
    arraySize:DWORD,
    searchVal:SDWORD

    mov ebx, 0              ; first = 0
    mov edx, arraySize
    dec edx                 ; last = arraySize - 1
    mov edi, pArray         ; EDI = 배열 시작 주소

SearchLoop:
    cmp ebx, edx
    jg NotFound             ; first > last이면 검색 실패

    mov esi, edx
    sub esi, ebx
    shr esi, 1
    add esi, ebx           ; mid = first + (last-first)/2

    mov eax, [edi+esi*4]   ; EAX = array[mid]
    cmp eax, searchVal
    jl SearchRight         ; array[mid] < searchVal
    jg SearchLeft          ; array[mid] > searchVal

    mov eax, esi           ; 같은 값이면 mid 반환
    ret

SearchRight:
    lea ebx, [esi+1]       ; first = mid + 1
    jmp SearchLoop

SearchLeft:
    lea edx, [esi-1]       ; last = mid - 1
    jmp SearchLoop

NotFound:
    mov eax, -1
    ret
BinarySearch ENDP

END main
```

### 실행 결과 (예상)

`WriteInt`가 양수 앞에 `+`를 붙이는 형식으로 출력하므로 다음과 같이 표시된다.

```text
Search 33: +6
Search -20: +0
Search 80: +8
Search 12: -1
Search 0: +2
```

배열 인덱스는 0부터 시작한다. 따라서 `33`은 인덱스 6, `-20`은 인덱스 0, `80`은 인덱스 8, `0`은 인덱스 2에서 발견된다. `12`는 배열에 없으므로 `-1`을 반환한다.

### 개요

- **`EBX (first)`**: 현재 탐색 범위의 시작 인덱스를 저장한다.
- **`EDX (last)`**: 현재 탐색 범위의 마지막 인덱스를 저장한다.
- **`ESI (mid)`**: 중간 인덱스를 계산하여 저장한다.
- **`EDI`**: 정렬된 배열의 시작 주소를 저장한다.
- **`[EDI+ESI*4]`**: `mid`번째 SDWORD 원소를 읽는다. SDWORD는 4바이트이므로 인덱스에 4를 곱한다.
- **`JL` / `JG`**: 부호 있는 정수 비교 결과에 따라 탐색 범위를 오른쪽 또는 왼쪽으로 줄인다.
- **`EAX`**: 값이 발견되면 해당 인덱스, 발견되지 않으면 `-1`을 반환한다.
- **`USES EBX EDX ESI EDI`**: 호출 전의 레지스터 값을 보존한다.

## 10. Letter Matrix

### 영문 문제

Create a procedure that generates a four-by-four matrix of randomly chosen capital letters. When choosing the letters, there must be a 50% probability that the chosen letter is a vowel. Write a test program with a loop that calls your procedure five times and displays each matrix in the console window. Following is sample output for the first three matrices:

```text
D W A L
S I V W
U I O L
L A I I
K X S V
N U U O
O R Q O
A U U T
P O A Z
A E A U
G K A E
I A G D
```

### 한글 번역

임의로 선택한 **영어 대문자**로 구성된 **4×4 문자 행렬**을 생성하는 프로시저를 작성하시오.

각 문자를 선택할 때 **모음(A, E, I, O, U)이 나올 확률은 50%**여야 한다. 테스트 프로그램에서 반복문을 사용하여 프로시저를 **5번 호출**하고, 매번 생성한 행렬을 콘솔 창에 출력하시오. 문제에 제시된 출력은 처음 세 행렬의 예시다.

### 어셈블리 코드

```asm
TITLE Letter Matrix
INCLUDE Irvine32.inc

GenerateMatrix PROTO, pMatrix:PTR BYTE
PrintMatrix    PROTO, pMatrix:PTR BYTE

.data
vowels     BYTE "AEIOU"
consonants BYTE "BCDFGHJKLMNPQRSTVWXYZ"
matrix     BYTE 16 DUP(?)
msg        BYTE "Matrix ", 0

.code
main PROC
    call Randomize               ; 난수 초기화는 한 번만 실행
    mov ebx, 1                   ; 행렬 번호 (1~5)

NextMatrix:
    mov edx, OFFSET msg
    call WriteString
    mov eax, ebx
    call WriteDec
    call Crlf

    INVOKE GenerateMatrix, ADDR matrix
    INVOKE PrintMatrix, ADDR matrix
    call Crlf

    inc ebx
    cmp ebx, 6
    jb NextMatrix

    exit
main ENDP

; 16개의 무작위 대문자를 생성한다.
; 먼저 모음/자음을 각각 50% 확률로 선택한다.
GenerateMatrix PROC USES esi edi,
    pMatrix:PTR BYTE

    mov edi, pMatrix
    mov esi, 16

FillLoop:
    mov eax, 2
    call RandomRange            ; EAX = 0 또는 1
    cmp eax, 0
    jne PickConsonant

PickVowel:
    mov eax, 5
    call RandomRange            ; EAX = 0~4
    mov al, vowels[eax]
    jmp SaveChar

PickConsonant:
    mov eax, 21
    call RandomRange            ; EAX = 0~20
    mov al, consonants[eax]

SaveChar:
    mov [edi], al
    inc edi
    dec esi
    jnz FillLoop

    ret
GenerateMatrix ENDP

; 16개 문자를 4개씩 한 줄에 출력한다.
PrintMatrix PROC USES ebx esi,
    pMatrix:PTR BYTE

    mov esi, pMatrix
    xor ebx, ebx

PrintLoop:
    mov al, [esi+ebx]
    call WriteChar
    mov al, ' '
    call WriteChar

    inc ebx
    test ebx, 3                 ; 4개마다 줄바꿈
    jnz NextChar
    call Crlf

NextChar:
    cmp ebx, 16
    jb PrintLoop

    ret
PrintMatrix ENDP

END main
```

### 실행 결과 (예상 예시)

난수로 생성하므로 **실행할 때마다 문자 배열은 달라진다**. 아래는 가능한 출력 형태를 보인 예시다. `Matrix 1`~`Matrix 3`은 문제에서 제시한 표본을 사용했다.

```text
Matrix 1
D W A L
S I V W
U I O L
L A I I

Matrix 2
K X S V
N U U O
O R Q O
A U U T

Matrix 3
P O A Z
A E A U
G K A E
I A G D

Matrix 4
C U A N
O R I K
A X T E
W E G O

Matrix 5
P A S U
E N O T
I L A M
R O C E
```

### 개요

- **`Randomize`**: 프로그램 시작 시 난수 발생기의 시드를 한 번 초기화한다.
- **`RandomRange` (EAX=2)**: 0 또는 1을 생성하여 **모음과 자음 중 하나를 각각 50% 확률로 선택한다**.
- **`RandomRange` (EAX=5)**: 모음 5개 중 하나를 선택한다.
- **`RandomRange` (EAX=21)**: 자음 21개 중 하나를 선택한다.
- **`matrix BYTE 16 DUP(?)`**: 4×4 행렬의 16개 문자를 저장한다.
- **`PrintMatrix`**: 문자를 네 개 출력할 때마다 줄을 바꾼다.
- **`NextMatrix`**: 행렬 생성과 출력을 다섯 번 반복한다.

## 11. Letter Matrix/Sets with Vowels

### 영문 문제

Use the letter matrix generated in the previous programming exercise as a starting point for this program. Generate a single random four-by-four letter matrix in which each letter has a 50% probability of being a vowel. Traverse each matrix row, column, and diagonal, generating sets of letters. Display only four-letter sets containing exactly two vowels. Suppose, for example, the following matrix was generated:

```text
P O A Z
A E A U
G K A E
I A G D
```

Then the four-letter sets displayed by the program would be POAZ, GKAE, IAGD, PAGI, ZUED, PEAD, and ZAKI. The order of letters within each set is unimportant.

### 한글 번역

이전 프로그래밍 문제에서 생성한 문자 행렬을 기반으로 프로그램을 작성한다.

각 문자가 **50%의 확률로 모음(A, E, I, O, U)** 이 되는 무작위 **4×4 대문자 행렬 하나**를 생성한다. 행렬의 각 **행 4개, 열 4개, 대각선 2개**를 차례로 순회하여 네 글자 문자열을 만든다. 그중 **모음이 정확히 2개 포함된 문자열만 출력**한다.

예를 들어 다음 행렬이 생성되었다고 가정한다.

```text
P O A Z
A E A U
G K A E
I A G D
```

이 경우 출력할 문자열은 `POAZ`, `GKAE`, `IAGD`, `PAGI`, `ZUED`, `PEAD`, `ZAKI`이다. 각 문자열 안에서 글자의 순서는 중요하지 않다.

### 어셈블리 코드

32비트 MASM 및 Irvine32 라이브러리를 사용한다.

```asm
TITLE Letter Matrix Sets with Vowels
INCLUDE Irvine32.inc

GenerateMatrix PROTO, pMatrix:PTR BYTE
PrintMatrix    PROTO, pMatrix:PTR BYTE
ShowSets       PROTO, pMatrix:PTR BYTE
CheckLine      PROTO, pStart:PTR BYTE, stepSize:DWORD

.data
vowels     BYTE "AEIOU"
consonants BYTE "BCDFGHJKLMNPQRSTVWXYZ"
msg1 BYTE "Matrix:", 0
msg2 BYTE "Two-vowel sets:", 0

.data?
matrix BYTE 16 DUP(?)

.code
main PROC
    call Randomize
    INVOKE GenerateMatrix, ADDR matrix

    mov edx, OFFSET msg1
    call WriteString
    call Crlf
    INVOKE PrintMatrix, ADDR matrix

    mov edx, OFFSET msg2
    call WriteString
    call Crlf
    INVOKE ShowSets, ADDR matrix

    exit
main ENDP

; 16개 문자를 생성한다. 모음/자음 선택 확률은 각각 50%.
GenerateMatrix PROC USES esi edi,
    pMatrix:PTR BYTE

    mov edi, pMatrix
    mov esi, 16

GenerateNext:
    mov eax, 2
    call RandomRange
    test eax, eax
    jnz PickConsonant

    mov eax, 5
    call RandomRange
    mov al, vowels[eax]
    jmp SaveChar

PickConsonant:
    mov eax, 21
    call RandomRange
    mov al, consonants[eax]

SaveChar:
    mov [edi], al
    inc edi
    dec esi
    jnz GenerateNext
    ret
GenerateMatrix ENDP

; 4행 4열로 출력한다.
PrintMatrix PROC USES eax ebx esi,
    pMatrix:PTR BYTE

    mov esi, pMatrix
    xor ebx, ebx

PrintNext:
    mov al, [esi+ebx]
    call WriteChar
    mov al, ' '
    call WriteChar

    inc ebx
    test ebx, 3
    jnz SameRow
    call Crlf

SameRow:
    cmp ebx, 16
    jb PrintNext
    ret
PrintMatrix ENDP

; 행 4개, 열 4개, 두 대각선을 검사한다.
ShowSets PROC USES ebx esi,
    pMatrix:PTR BYTE

    mov esi, pMatrix
    xor ebx, ebx

Rows:
    INVOKE CheckLine, esi, 1
    add esi, 4
    inc ebx
    cmp ebx, 4
    jb Rows

    mov esi, pMatrix
    xor ebx, ebx

Columns:
    INVOKE CheckLine, esi, 4
    inc esi
    inc ebx
    cmp ebx, 4
    jb Columns

    mov esi, pMatrix
    INVOKE CheckLine, esi, 5  ; 왼쪽 위 -> 오른쪽 아래
    add esi, 3
    INVOKE CheckLine, esi, 3  ; 오른쪽 위 -> 왼쪽 아래
    ret
ShowSets ENDP

; 시작 주소부터 stepSize 바이트씩 네 문자를 읽고,
; 모음이 정확히 2개일 때만 문자열을 출력한다.
CheckLine PROC USES eax ebx ecx edx esi edi,
    pStart:PTR BYTE,
    stepSize:DWORD

    LOCAL wordBuf[5]:BYTE

    mov esi, pStart
    lea edi, wordBuf
    mov ecx, 4
    xor ebx, ebx

CheckNext:
    mov al, [esi]
    mov [edi], al

    cmp al, 'A'
    je IsVowel
    cmp al, 'E'
    je IsVowel
    cmp al, 'I'
    je IsVowel
    cmp al, 'O'
    je IsVowel
    cmp al, 'U'
    jne Advance

IsVowel:
    inc ebx

Advance:
    inc edi
    add esi, stepSize
    loop CheckNext

    mov BYTE PTR [edi], 0
    cmp ebx, 2
    jne CheckDone

    lea edx, wordBuf
    call WriteString
    call Crlf

CheckDone:
    ret
CheckLine ENDP

END main
```

### 실행 결과 (예상)

무작위 생성 결과는 실행할 때마다 달라진다. 다음은 **문제에 제시된 행렬이 생성되었을 경우**의 예상 출력이다.

```text
Matrix:
P O A Z
A E A U
G K A E
I A G D
Two-vowel sets:
POAZ
GKAE
IAGD
PAGI
ZUED
PEAD
ZAKI
```

### 개요

- `RandomRange`를 먼저 `2`로 호출하여 모음과 자음 중 하나를 **각각 50% 확률**로 선택한다. 모음이면 5개, 자음이면 21개 중에서 한 글자를 선택한다.
- `ShowSets`는 행 4개, 열 4개, 대각선 2개를 검사하므로 총 **10개의 네 글자 문자열**을 만든다.
- `CheckLine`의 `stepSize`는 다음 문자로 이동할 간격을 뜻한다. 행은 `1`, 열은 `4`, 주대각선은 `5`, 반대각선은 `3`을 사용한다.
- `wordBuf[5]`는 네 글자와 널 종료 문자(`0`)를 저장한다.
- `EBX`는 현재 문자열에 들어 있는 모음의 개수를 센다. 그 값이 `2`일 때만 `WriteString`을 호출한다.

## 12. Calculating the Sum of an Array Row

### 영문 문제

Write a procedure named calc_row_sum that calculates the sum of a single row in a two-dimensional array of bytes, words, or doublewords. The procedure should have the following stack parameters: array offset, row size, array type, row index. It must return the sum in EAX. Use explicit stack parameters, not INVOKE or extended PROC. Write a program that tests your procedure with arrays of byte, word, and doubleword. Prompt the user for the row index, and display the sum of the selected row.

### 한글 번역

BYTE, WORD 또는 DWORD 자료형으로 구성된 2차원 배열에서 **선택한 한 행의 원소 합**을 계산하는 `calc_row_sum` 프로시저를 작성한다.

프로시저는 **배열 주소(array offset), 한 행의 바이트 크기(row size), 원소 자료형의 바이트 크기(array type), 행 인덱스(row index)** 를 스택 매개변수로 받으며, 합계를 `EAX`에 반환한다.

**`INVOKE` 및 매개변수 목록이 포함된 확장 `PROC` 지시어를 사용하지 않고**, `PUSH`와 명시적인 스택 접근으로 구현한다. BYTE·WORD·DWORD 배열을 각각 테스트하고, 사용자에게 행 인덱스를 입력받아 선택한 행의 합을 출력한다.

### 어셈블리 코드

32비트 MASM 및 Irvine32 라이브러리를 사용한다. 각 배열은 **3행 × 4열**로 구성한다.

```asm
TITLE Calculating the Sum of an Array Row
INCLUDE Irvine32.inc

.data
byteArray BYTE 1, 2, 3, 4
          BYTE 5, 6, 7, 8
          BYTE 9, 10, 11, 12

wordArray WORD 100, 200, 300, 400
          WORD 500, 600, 700, 800
          WORD 900, 1000, 1100, 1200

dwordArray DWORD 1000, 2000, 3000, 4000
           DWORD 5000, 6000, 7000, 8000
           DWORD 9000, 10000, 11000, 12000

prompt   BYTE "Enter row index (0-2): ", 0
msgByte  BYTE "BYTE row sum:  ", 0
msgWord  BYTE "WORD row sum:  ", 0
msgDword BYTE "DWORD row sum: ", 0
errMsg   BYTE "Invalid row index!", 0
rowIndex DWORD ?

.code
main PROC
    mov edx, OFFSET prompt
    call WriteString
    call ReadInt

    cmp eax, 0
    jl InvalidRow
    cmp eax, 3
    jge InvalidRow
    mov rowIndex, eax

    ; BYTE: 행 크기 4바이트, 원소 크기 1바이트
    mov edx, OFFSET msgByte
    call WriteString
    push rowIndex
    push 1
    push 4
    push OFFSET byteArray
    call calc_row_sum
    call WriteDec
    call Crlf

    ; WORD: 행 크기 8바이트, 원소 크기 2바이트
    mov edx, OFFSET msgWord
    call WriteString
    push rowIndex
    push 2
    push 8
    push OFFSET wordArray
    call calc_row_sum
    call WriteDec
    call Crlf

    ; DWORD: 행 크기 16바이트, 원소 크기 4바이트
    mov edx, OFFSET msgDword
    call WriteString
    push rowIndex
    push 4
    push 16
    push OFFSET dwordArray
    call calc_row_sum
    call WriteDec
    call Crlf
    exit

InvalidRow:
    mov edx, OFFSET errMsg
    call WriteString
    call Crlf
    exit
main ENDP

; 스택 매개변수:
; [EBP+8]  = 배열 주소
; [EBP+12] = 한 행의 바이트 크기 (4, 8, 16)
; [EBP+16] = 원소 크기 (1=BYTE, 2=WORD, 4=DWORD)
; [EBP+20] = 행 인덱스
; 반환: EAX = 선택한 행의 합

calc_row_sum PROC
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push edx
    push esi

    mov esi, [ebp+8]       ; 배열 시작 주소
    mov eax, [ebp+20]     ; 행 인덱스
    mul DWORD PTR [ebp+12] ; 행 인덱스 * 행 크기(바이트)
    add esi, eax           ; 선택한 행의 시작 주소

    mov ecx, [ebp+12]     ; 남은 행의 바이트 수
    mov ebx, [ebp+16]     ; 원소 크기
    xor eax, eax          ; 합계 = 0
    test ecx, ecx
    jz SumDone

SumLoop:
    cmp ebx, 1
    je AddByte
    cmp ebx, 2
    je AddWord

    add eax, DWORD PTR [esi]
    jmp NextElement

AddByte:
    movzx edx, BYTE PTR [esi]
    add eax, edx
    jmp NextElement

AddWord:
    movzx edx, WORD PTR [esi]
    add eax, edx

NextElement:
    add esi, ebx           ; 다음 원소의 주소
    sub ecx, ebx          ; 처리한 원소의 바이트 수 차감
    jnz SumLoop

SumDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop ebp
    ret 16                 ; 매개변수 4개(16바이트) 정리
calc_row_sum ENDP

END main
```

### 실행 결과 (예상)

입력값이 `1`일 때:

```text
Enter row index (0-2): 1
BYTE row sum:  26
WORD row sum:  2600
DWORD row sum: 26000
```

행 인덱스를 `0`, `1`, `2`로 선택했을 때 각 자료형의 계산 결과:

| 입력 행 인덱스 | BYTE 합 | WORD 합 | DWORD 합 |
| -------------: | ------: | ------: | -------: |
|              0 |      10 |    1000 |    10000 |
|              1 |      26 |    2600 |    26000 |
|              2 |      42 |    4200 |    42000 |

잘못된 행 인덱스를 입력하면 `Invalid row index!`를 출력한다.

### 개요

- **`PUSH`**: `INVOKE` 없이 네 인수를 스택에 전달한다. `PUSH`는 역순으로 수행하므로 배열 주소가 마지막에 들어간다.
- **`[EBP+8]`, `[EBP+12]`, `[EBP+16]`, `[EBP+20]`**: 스택에 전달된 네 매개변수를 읽는다.
- **행 시작 주소**: `배열 시작 주소 + 행 인덱스 × 행 크기(바이트)`로 계산한다.
- **`MOVZX`**: BYTE 또는 WORD 값을 32비트로 0 확장한다. DWORD는 직접 `EAX`에 더한다.
- **`ADD ESI, EBX`**: 원소 크기만큼 다음 주소로 이동한다.
- **`RET 16`**: 네 개의 32비트 스택 매개변수에 해당하는 16바이트를 정리한다.

## 13. Trimming Leading Characters

### 영문 문제

Create a variant of the Str_trim procedure that lets the caller remove all instances of a leading character from a string. For example, if you were to call it with a pointer to the string “###ABC” and pass it the # character, the resulting string would be “ABC.”

### 한글 번역

문자열의 **맨 앞에 연속해서 나타나는 특정 문자**를 모두 제거하는 `Str_trim`의 변형 프로시저를 작성하시오.

예를 들어 `"###ABC"` 문자열의 주소와 문자 `'#'`을 전달하면, 처리 결과는 `"ABC"`가 되어야 한다.

### 어셈블리 코드

```asm
TITLE Trimming Leading Characters
INCLUDE Irvine32.inc

Str_trimLeft PROTO, pString:PTR BYTE, removeChar:BYTE
PrintResult  PROTO, pString:PTR BYTE

.data
str1 BYTE "###ABC", 0
str2 BYTE "....MASM...", 0
str3 BYTE "****", 0
str4 BYTE "HELLO", 0
str5 BYTE 0

msg1 BYTE "Test 1: ", 0
msg2 BYTE "Test 2: ", 0
msg3 BYTE "Test 3: ", 0
msg4 BYTE "Test 4: ", 0
msg5 BYTE "Test 5: ", 0

.code
main PROC
    INVOKE Str_trimLeft, ADDR str1, '#'
    mov edx, OFFSET msg1
    call WriteString
    INVOKE PrintResult, ADDR str1

    INVOKE Str_trimLeft, ADDR str2, '.'
    mov edx, OFFSET msg2
    call WriteString
    INVOKE PrintResult, ADDR str2

    INVOKE Str_trimLeft, ADDR str3, '*'
    mov edx, OFFSET msg3
    call WriteString
    INVOKE PrintResult, ADDR str3

    INVOKE Str_trimLeft, ADDR str4, '#'
    mov edx, OFFSET msg4
    call WriteString
    INVOKE PrintResult, ADDR str4

    INVOKE Str_trimLeft, ADDR str5, '#'
    mov edx, OFFSET msg5
    call WriteString
    INVOKE PrintResult, ADDR str5

    exit
main ENDP

; 문자열 앞에 연속된 removeChar를 제거한다.
; pString = 수정할 문자열 주소
; removeChar = 제거할 문자
Str_trimLeft PROC USES eax esi edi,
    pString:PTR BYTE,
    removeChar:BYTE

    mov esi, pString
    mov edi, esi
    mov al, removeChar
    test al, al
    jz TrimDone

SkipLeading:
    cmp BYTE PTR [esi], 0
    je CopyRest
    cmp [esi], al
    jne CopyRest
    inc esi
    jmp SkipLeading

CopyRest:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    test al, al
    jnz CopyRest

TrimDone:
    ret
Str_trimLeft ENDP

; 빈 문자열도 확인할 수 있도록 [ ] 형태로 출력한다.
PrintResult PROC USES eax edx,
    pString:PTR BYTE

    mov al, '['
    call WriteChar
    mov edx, pString
    call WriteString
    mov al, ']'
    call WriteChar
    call Crlf
    ret
PrintResult ENDP

END main
```

### 실행 결과 (예상)

```text
Test 1: [ABC]
Test 2: [MASM...]
Test 3: []
Test 4: [HELLO]
Test 5: []
```

대괄호는 빈 문자열을 구분하기 위한 출력 기호이며, 실제 문자열에는 포함되지 않는다.

### 개요

- **`Str_trimLeft`**: 문자열 앞에서 지정한 문자가 연속되는 구간만 제거한다.
- **`ESI`**: 제거할 문자를 건너뛰면서 남겨야 할 첫 문자의 위치를 찾는다.
- **`EDI`**: 남은 문자열을 다시 저장할 시작 주소를 가리킨다.
- **`CMP [ESI], AL`**: 현재 문자가 제거 대상인지 비교한다.
- **`CopyRest`**: 남겨야 할 첫 문자부터 널 종료 문자까지 문자열 앞으로 복사한다.
- **`TEST AL, AL`**: 널 종료 문자를 복사했으면 반복을 종료한다.
- 문자열 중간이나 끝에 있는 같은 문자는 제거하지 않는다.

## 14. Trimming a Set of Characters

### 영문 문제

Create a variant of the Str_trim procedure that lets the caller remove all instances of a set of characters from the end of a string. For example, if you were to call it with a pointer to the string "ABC#$&" and pass it a pointer to an array of filter characters containing "%#!;$&\*", the resulting string would be “ABC”.

### 한글 번역

문자열 끝에 연속해서 나타나는 **지정된 문자 집합의 문자들을 모두 제거하는 `Str_trim` 변형 프로시저**를 작성한다.

예를 들어 문자열 `"ABC#$&"`의 주소와 필터 문자열 `"%#!;$&*"`의 주소를 전달하면, 끝의 `#`, `$`, `&`가 제거되어 `"ABC"`가 남아야 한다. 문자열 중간에 있는 필터 문자는 제거하지 않는다.

### 어셈블리 코드

32비트 MASM과 Irvine32 라이브러리를 사용한다.

```asm
TITLE Trimming a Set of Characters
INCLUDE Irvine32.inc

Str_trimSet PROTO, pString:PTR BYTE, pFilters:PTR BYTE
PrintResult PROTO, pString:PTR BYTE

.data
filters BYTE "%#!;$&*", 0

str1 BYTE "ABC#$&", 0
str2 BYTE "AA#BB#$", 0
str3 BYTE "HELLO", 0
str4 BYTE "##$&", 0
str5 BYTE 0

msg1 BYTE "Test 1: ", 0
msg2 BYTE "Test 2: ", 0
msg3 BYTE "Test 3: ", 0
msg4 BYTE "Test 4: ", 0
msg5 BYTE "Test 5: ", 0

.code
main PROC
    INVOKE Str_trimSet, ADDR str1, ADDR filters
    mov edx, OFFSET msg1
    call WriteString
    INVOKE PrintResult, ADDR str1

    INVOKE Str_trimSet, ADDR str2, ADDR filters
    mov edx, OFFSET msg2
    call WriteString
    INVOKE PrintResult, ADDR str2

    INVOKE Str_trimSet, ADDR str3, ADDR filters
    mov edx, OFFSET msg3
    call WriteString
    INVOKE PrintResult, ADDR str3

    INVOKE Str_trimSet, ADDR str4, ADDR filters
    mov edx, OFFSET msg4
    call WriteString
    INVOKE PrintResult, ADDR str4

    INVOKE Str_trimSet, ADDR str5, ADDR filters
    mov edx, OFFSET msg5
    call WriteString
    INVOKE PrintResult, ADDR str5

    exit
main ENDP

; 문자열 끝에서 필터 문자 집합에 포함된 문자를 연속 제거한다.
Str_trimSet PROC USES eax esi edi,
    pString:PTR BYTE,
    pFilters:PTR BYTE

    mov edi, pString

FindEnd:
    cmp BYTE PTR [edi], 0
    je CheckEmpty
    inc edi
    jmp FindEnd

CheckEmpty:
    cmp edi, pString
    je TrimDone              ; 빈 문자열
    dec edi                  ; 마지막 실제 문자

CheckLast:
    mov esi, pFilters
    mov al, [edi]

FindFilter:
    cmp BYTE PTR [esi], 0
    je TrimDone              ; 필터에 없으면 종료
    cmp al, [esi]
    je RemoveLast
    inc esi
    jmp FindFilter

RemoveLast:
    mov BYTE PTR [edi], 0    ; 마지막 문자를 널 문자로 변경
    cmp edi, pString
    je TrimDone              ; 모든 문자가 제거된 경우
    dec edi
    jmp CheckLast

TrimDone:
    ret
Str_trimSet ENDP

; 빈 문자열을 확인하기 위해 대괄호로 감싸 출력한다.
PrintResult PROC USES eax edx,
    pString:PTR BYTE

    mov al, '['
    call WriteChar
    mov edx, pString
    call WriteString
    mov al, ']'
    call WriteChar
    call Crlf
    ret
PrintResult ENDP

END main
```

### 실행 결과 (예상)

```text
Test 1: [ABC]
Test 2: [AA#BB]
Test 3: [HELLO]
Test 4: []
Test 5: []
```

### 개요

- `FindEnd`: 문자열의 널 종료 문자 위치를 찾는다.
- `DEC EDI`: 마지막 실제 문자의 주소로 이동한다.
- `FindFilter`: 마지막 문자가 필터 문자열에 포함되는지 검사한다.
- `RemoveLast`: 포함되면 해당 문자를 널 종료 문자로 변경한다.
- `CheckLast`: 앞의 문자로 이동해 같은 검사를 반복한다.
- **종료 조건**: 필터에 없는 문자를 만나거나 문자열 전체가 제거되면 종료한다.
- **문자열 중간의 문자는 유지**한다. 예를 들어 `AA#BB#$`는 `AA#BB`가 된다.
