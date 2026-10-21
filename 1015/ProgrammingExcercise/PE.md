# Chapter 6.11 — Programming Exercises 풀이

---

# 6.11.1 Suggestions for Testing Your Code

| 확인 항목 | 적용 방법 | 예시 |
|---|---|---|
| 처음에는 단계별 실행 | 디버거에서 명령을 한 줄씩 실행하면서 레지스터와 메모리를 관찰 | `CMP` 뒤의 `ZF`, `CF`, `SF`, `OF` 확인 |
| 부호 있는 자료 | 음수·0·양수를 모두 포함하여 테스트 | 2번 배열에 `-7, 0, 12` 포함 |
| 경계값 검사 | 범위의 바로 아래, 경계 자체, 바로 위를 각각 테스트 | 3번 점수 `59/60`, `69/70`, `79/80`, `89/90` |
| 입력 크기 다양화 | 배열 길이를 바꾸어 검사하며, 허용되는 경우 길이 0도 시험 | 2번에 배열 길이 `0, 1, 5` 사용 |
| 메모리 검증 | 디버거의 **Memory** 창에서 배열 변경 결과를 확인 | 1번의 두 배열이 각각 지정된 범위에 있는지 검사 |
| 프로시저 재호출 | 같은 인자로 다시 호출하고, 반환값을 제외한 레지스터가 유지되는지 확인 | 2번의 `SumArrayRange` 두 번 연속 호출 |
| 배열의 독립성 | 프로시저 내부에서 특정 전역 배열 이름 대신 전달된 주소(`[esi]` 등)를 사용 | 1·2·9·10번의 포인터 인자 |
| 프로시저 전용 변수 | 필요한 경우 프로시저 범위 근처에 데이터를 둘 수 있으나, 재호출 시 반드시 초기화 | 누적 합계를 호출마다 `xor eax,eax`로 초기화 |

**레지스터 보존 검사 예시(2번):**

```asm
mov esi,OFFSET numbers
mov ecx,LENGTHOF numbers
mov ebx,-10                ; j
mov edx,20                 ; k
call SumArrayRange         ; sum returned in EAX
mov firstResult,eax
call SumArrayRange         ; no need to restore input registers
mov secondResult,eax       ; must match firstResult
```

---

# 6.11.2 Exercise Descriptions

## Exercise 1 — Filling an Array

### 문제 요약

포인터로 받은 DWORD 배열에 `N`개의 난수를 기록하는 프로시저를 작성한다. 모든 난수는 **양끝을 포함한** 범위 `[j, k]`에 들어가야 한다. 배열 주소, 길이, 최솟값·최댓값을 인자로 전달하며, 호출 전후 **모든 범용 레지스터**를 보존한다. 범위가 서로 다른 두 배열로 검사한다.

### 풀이 코드 — `Ex01_FillArray.asm`

```asm
INCLUDE Irvine32.inc
.data
arr1 DWORD 10 DUP(?)
arr2 DWORD 10 DUP(?)
.code
; ESI=배열, ECX=개수, EBX=j, EDX=k
FillArray PROC
    pushad                  ; 모든 범용 레지스터 보존
    mov edi,edx
    sub edi,ebx
    inc edi                 ; k-j+1
    jecxz Done
L1:
    mov eax,edi
    call RandomRange        ; 0 ~ (k-j)
    add eax,ebx            ; j ~ k
    mov [esi],eax
    add esi,4
    loop L1
Done:
    popad
    ret
FillArray ENDP

main PROC
    call Randomize
    mov esi,OFFSET arr1
    mov ecx,LENGTHOF arr1
    mov ebx,1
    mov edx,100
    call FillArray

    mov esi,OFFSET arr2
    mov ecx,LENGTHOF arr2
    mov ebx,200
    mov edx,300
    call FillArray
    exit
main ENDP
END main
```

→ `arr1`은 **1~100**, `arr2`는 **200~300** 범위. 디버거에서 배열 확인.

---

## Exercise 2 — Summing Array Elements in a Range

### 문제 요약

부호 있는 32비트 정수 배열에서 값이 `[j, k]`에 포함되는 원소만 합산하여 **EAX로 반환**한다. 배열 주소, 원소 개수, 범위를 전달한다. EAX 이외의 모든 범용 레지스터를 보존하고, 서로 다른 조건으로 두 번 테스트한다.

### 풀이 코드 — `Ex02_SumRange.asm`

```asm
INCLUDE Irvine32.inc
.data
nums SDWORD -10,-5,0,10,20,30
sum1 SDWORD ?
sum2 SDWORD ?
.code
; ESI=배열, ECX=개수, EBX=j, EDX=k
SumRange PROC USES ebx ecx edx esi edi
    xor eax,eax
    jecxz Done
L1:
    mov edi,[esi]
    cmp edi,ebx
    jl Skip
    cmp edi,edx
    jg Skip
    add eax,edi
Skip:
    add esi,4
    loop L1
Done:
    ret
SumRange ENDP

main PROC
    mov esi,OFFSET nums
    mov ecx,LENGTHOF nums
    mov ebx,-5
    mov edx,20
    call SumRange
    mov sum1,eax            ; -5+0+10+20 = 25

    mov esi,OFFSET nums
    mov ecx,LENGTHOF nums
    mov ebx,10
    mov edx,30
    call SumRange
    mov sum2,eax            ; 10+20+30 = 60
    exit
main ENDP
END main
```

→ `sum1=25`, `sum2=60`. **JL/JG**는 부호 있는 정수 비교.

**예상 결과:** `sumA=6`, `sumB=51`. 경계값 `j`, `k`와 같은 원소는 포함되어야 한다. 배열 길이를 0으로 주면 `EAX=0`을 반환한다.

---

## Exercise 3 — Test Score Evaluation

### 문제 요약

`CalcGrade` 프로시저는 0~100점의 정수를 받아 `AL`에 **대문자 학점 한 글자**를 반환한다. 50~100 범위에서 난수 10개를 만들어 검사한다. 교재의 기준은 다음과 같다.

| 점수 | 학점 |
|---|---|
| 90–100 | A |
| 80–89 | B |
| 70–79 | C |
| 60–69 | D |
| 0–59 | F |

### 풀이 코드 — `Ex03_CalcGrade.asm`

```asm
TITLE Test Score Evaluation

INCLUDE Irvine32.inc

.code
main PROC
    mov ecx, 10             ; 10번 반복

L1:
    ; 50~100 범위의 난수 생성
    mov eax, 50             ; 하한
    mov ebx, 51             ; 범위 (100-50+1)
    call RandomRange        ; EAX = 난수 (50~100)

    mov edx, eax            ; EDX에 점수 저장

    ; 성적 계산
    call CalcGrade          ; AL = 성적

    ; 점수와 성적 표시
    call WriteDec           ; 점수 출력
    mov al, ' '
    call WriteChar
    mov al, [ebp-4]         ; 성적 출력
    call WriteChar
    call Crlf

    loop L1

    exit
main ENDP

; ==========================================
; CalcGrade 프로시저
; ==========================================
; 입력:
;   EAX = 점수 (0~100)
; 출력:
;   AL = 성적 ('A', 'B', 'C', 'D', 'F')
; 보존: EBX, ECX, EDX, ESI, EDI, EBP
; ==========================================

CalcGrade PROC
    push ebx
    push ecx
    push edx

    mov ebx, eax            ; EBX = 점수

    ; 90 이상
    cmp ebx, 90
    jl CheckB
    mov al, 'A'
    jmp Done

CheckB:
    ; 80 이상 89 이하
    cmp ebx, 80
    jl CheckC
    mov al, 'B'
    jmp Done

CheckC:
    ; 70 이상 79 이하
    cmp ebx, 70
    jl CheckD
    mov al, 'C'
    jmp Done

CheckD:
    ; 60 이상 69 이하
    cmp ebx, 60
    jl CheckF
    mov al, 'D'
    jmp Done

CheckF:
    ; 0 이상 59 이하
    mov al, 'F'

Done:
    pop edx
    pop ecx
    pop ebx
    ret
CalcGrade ENDP

END main
```


---

## Exercise 4 — College Registration

### 문제 요약

교재 §6.7.3의 수강 신청 판단 로직을 `CMP` 및 조건부 점프만으로 재작성한다. 학점 평균과 신청 학점을 입력받고, **신청 학점은 1~30** 사이인지 확인한다. 신청 가능/불가능 메시지를 출력한다.

원래 예제의 판정 논리는 다음과 같다.

- 평균 점수가 **350 초과**이면 신청 가능
- 그 외에 평균 점수가 **250 초과이고**, 신청 학점이 **16 이하**이면 신청 가능
- 그 외에 신청 학점이 **12 이하**이면 신청 가능
- 위 조건에 해당하지 않으면 신청 불가능

### 풀이 코드 — `Ex04_CollegeRegistration.asm`

```asm
INCLUDE Irvine32.inc

.data
avgPrompt BYTE "Grade average (0..400): ",0
crPrompt  BYTE "Credits (1..30): ",0
badAvg    BYTE "Invalid grade average.",0
badCredit BYTE "Invalid credits: enter 1..30.",0
allowMsg  BYTE "The student can register.",0
denyMsg   BYTE "The student cannot register.",0

gradeAverage WORD ?
credits WORD ?

.code
main PROC
    mov edx,OFFSET avgPrompt
    call WriteString
    call ReadInt
    cmp eax,0
    jl InvalidAvg
    cmp eax,400
    jg InvalidAvg
    mov gradeAverage,ax

    mov edx,OFFSET crPrompt
    call WriteString
    call ReadInt
    cmp eax,1
    jl InvalidCredit
    cmp eax,30
    jg InvalidCredit
    mov credits,ax

    ; Check the three conditions from section 6.7.3 in order
    movzx eax,gradeAverage
    cmp eax,350
    ja Allowed

    cmp eax,250
    jbe CheckSmallCredits
    movzx ebx,credits
    cmp ebx,16
    jbe Allowed

CheckSmallCredits:
    movzx ebx,credits
    cmp ebx,12
    jbe Allowed
    jmp Denied

Allowed:
    mov edx,OFFSET allowMsg
    call WriteString
    jmp Finish

Denied:
    mov edx,OFFSET denyMsg
    call WriteString
    jmp Finish

InvalidAvg:
    mov edx,OFFSET badAvg
    call WriteString
    jmp Finish

InvalidCredit:
    mov edx,OFFSET badCredit
    call WriteString

Finish:
    call Crlf
    exit
main ENDP
END main
```

### 핵심 해설

`JA`는 unsigned `>`이고 `JBE`는 unsigned `<=`이다. 입력을 검사한 후 0 이상의 숫자만 판정하므로 부호 없는 비교가 적절하다. `350`이나 `250`은 **초과가 아닌 경우 다음 조건으로 이동**하는 점에 주의한다.

**테스트 예시:** `평균 351, 학점 30→가능`; `평균 300, 학점 16→가능`; `평균 300, 학점 17→불가`; `평균 200, 학점 12→가능`; `평균 200, 학점 13→불가`; 학점 `0`·`31`은 오류 메시지.

---

## Exercise 5 — Boolean Calculator (1)

### 문제 요약

32비트 정수용 부울 계산기에서 **AND, OR, NOT, XOR, 종료**를 고르는 메뉴를 만든다. 1~4를 선택하면 해당 연산의 이름을 출력하는 프로시저를 호출한다. 연산 이름을 찾는 프로시저는 §6.5.4의 **Table-Driven Selection** 기법을 사용한다. 실제 비트 연산은 6번에서 구현한다.

### 풀이 코드 — `Ex05_BooleanMenu.asm`

```asm
INCLUDE Irvine32.inc

.data
menuText BYTE 0Dh,0Ah
         BYTE "1. x AND y",0Dh,0Ah
         BYTE "2. x OR y",0Dh,0Ah
         BYTE "3. NOT x",0Dh,0Ah
         BYTE "4. x XOR y",0Dh,0Ah
         BYTE "5. Exit program",0Dh,0Ah
         BYTE "Select: ",0

invalidMsg BYTE "Please select 1..5.",0
nameAND BYTE "Selected: AND",0
nameOR  BYTE "Selected: OR",0
nameNOT BYTE "Selected: NOT",0
nameXOR BYTE "Selected: XOR",0

; Record = selection byte (1) + procedure address (4)
CaseTable BYTE 1
          DWORD Name_AND
EntrySize = ($ - CaseTable)
          BYTE 2
          DWORD Name_OR
          BYTE 3
          DWORD Name_NOT
          BYTE 4
          DWORD Name_XOR
EntryCount = ($ - CaseTable) / EntrySize

.code
; AL holds a selection from 1 to 4
; Search table and indirectly call the matching name procedure
ShowOperation PROC USES ebx ecx edx
    mov ebx,OFFSET CaseTable
    mov ecx,EntryCount

SearchAgain:
    cmp al,BYTE PTR [ebx]
    jne NextEntry
    call NEAR PTR [ebx+1]  ; selected Name_* loads EDX with message address
    call WriteString
    call Crlf
    jmp SearchDone

NextEntry:
    add ebx,EntrySize
    loop SearchAgain
SearchDone:
    ret
ShowOperation ENDP

Name_AND PROC
    mov edx,OFFSET nameAND
    ret
Name_AND ENDP

Name_OR PROC
    mov edx,OFFSET nameOR
    ret
Name_OR ENDP

Name_NOT PROC
    mov edx,OFFSET nameNOT
    ret
Name_NOT ENDP

Name_XOR PROC
    mov edx,OFFSET nameXOR
    ret
Name_XOR ENDP

main PROC
MenuLoop:
    mov edx,OFFSET menuText
    call WriteString
    call ReadDec
    cmp eax,5
    je Done
    cmp eax,1
    jb Invalid
    cmp eax,4
    ja Invalid
    call ShowOperation
    jmp MenuLoop

Invalid:
    mov edx,OFFSET invalidMsg
    call WriteString
    call Crlf
    jmp MenuLoop
Done:
    exit
main ENDP
END main
```

### 핵심 해설

`CaseTable`의 각 행에 **메뉴 번호**와 **메시지 주소를 설정해 주는 프로시저 주소**를 보관한다. `Call NEAR PTR [ebx+1]`을 통해 찾은 프로시저를 간접 호출한다. 이 파일은 **연산 이름만 표시**하며 6번 프로그램에서 계산 기능을 완성한다.

**테스트:** 1~4를 차례대로 입력하여 선택한 연산 이름이 출력되는지 확인한다. 0, 6을 입력하면 오류 메시지, 5를 입력하면 종료되어야 한다.

---

## Exercise 6 — Boolean Calculator (2)

### 문제 요약

5번 계산기를 확장하여 `AND_op`, `OR_op`, `NOT_op`, `XOR_op`를 만든다. 피연산자는 **16진수 32비트 값**으로 입력받고, 결과 역시 16진수로 출력한다. 5번의 테이블 기반 선택도 유지한다.

### 풀이 코드 — `Ex06_BooleanCalculator.asm`

```asm
INCLUDE Irvine32.inc

.data
menuText BYTE 0Dh,0Ah
         BYTE "1. x AND y",0Dh,0Ah
         BYTE "2. x OR y",0Dh,0Ah
         BYTE "3. NOT x",0Dh,0Ah
         BYTE "4. x XOR y",0Dh,0Ah
         BYTE "5. Exit program",0Dh,0Ah
         BYTE "Select: ",0
invalidMsg BYTE "Please select 1..5.",0
promptX BYTE "Enter x (8-digit hex): ",0
promptY BYTE "Enter y (8-digit hex): ",0
resultMsg BYTE "Result (hex): ",0
msgAND BYTE "Operation: AND",0Dh,0Ah,0
msgOR  BYTE "Operation: OR",0Dh,0Ah,0
msgNOT BYTE "Operation: NOT",0Dh,0Ah,0
msgXOR BYTE "Operation: XOR",0Dh,0Ah,0

operand1 DWORD ?
resultValue DWORD ?

; Record: command (1) + function address (4) + message address (4)
CommandTable BYTE 1
             DWORD AND_op
             DWORD msgAND
CommandSize = ($ - CommandTable)
             BYTE 2
             DWORD OR_op
             DWORD msgOR
             BYTE 3
             DWORD NOT_op
             DWORD msgNOT
             BYTE 4
             DWORD XOR_op
             DWORD msgXOR
CommandCount = ($ - CommandTable) / CommandSize

.code
; EAX = menu selection (1..4)
; Look up both message and operation in table
DispatchOperation PROC USES ebx ecx edx
    mov ebx,OFFSET CommandTable
    mov ecx,CommandCount

SearchAgain:
    cmp al,BYTE PTR [ebx]
    jne NextEntry

    ; Save handler address before calling output routine
    ; Store function address on stack
    push DWORD PTR [ebx+1]
    mov edx,DWORD PTR [ebx+5]
    call WriteString
    pop ebx
    call ebx                   ; call selected operation
    jmp SearchDone

NextEntry:
    add ebx,CommandSize
    loop SearchAgain
SearchDone:
    ret
DispatchOperation ENDP

; Preserve operand and result in memory
; across calls to library output routines
AND_op PROC
    pushad
    mov edx,OFFSET promptX
    call WriteString
    call ReadHex
    mov operand1,eax

    mov edx,OFFSET promptY
    call WriteString
    call ReadHex
    and eax,operand1
    mov resultValue,eax

    mov edx,OFFSET resultMsg
    call WriteString
    mov eax,resultValue
    call WriteHex
    call Crlf
    popad
    ret
AND_op ENDP

OR_op PROC
    pushad
    mov edx,OFFSET promptX
    call WriteString
    call ReadHex
    mov operand1,eax

    mov edx,OFFSET promptY
    call WriteString
    call ReadHex
    or eax,operand1
    mov resultValue,eax

    mov edx,OFFSET resultMsg
    call WriteString
    mov eax,resultValue
    call WriteHex
    call Crlf
    popad
    ret
OR_op ENDP

NOT_op PROC
    pushad
    mov edx,OFFSET promptX
    call WriteString
    call ReadHex
    not eax
    mov resultValue,eax

    mov edx,OFFSET resultMsg
    call WriteString
    mov eax,resultValue
    call WriteHex
    call Crlf
    popad
    ret
NOT_op ENDP

XOR_op PROC
    pushad
    mov edx,OFFSET promptX
    call WriteString
    call ReadHex
    mov operand1,eax

    mov edx,OFFSET promptY
    call WriteString
    call ReadHex
    xor eax,operand1
    mov resultValue,eax

    mov edx,OFFSET resultMsg
    call WriteString
    mov eax,resultValue
    call WriteHex
    call Crlf
    popad
    ret
XOR_op ENDP

main PROC
MenuLoop:
    mov edx,OFFSET menuText
    call WriteString
    call ReadDec
    cmp eax,5
    je Done
    cmp eax,1
    jb Invalid
    cmp eax,4
    ja Invalid
    call DispatchOperation
    jmp MenuLoop

Invalid:
    mov edx,OFFSET invalidMsg
    call WriteString
    call Crlf
    jmp MenuLoop
Done:
    exit
main ENDP
END main
```

### 핵심 해설

계산기 선택 테이블의 한 행은 **명령 번호 → 메시지 → 실제 연산 프로시저**의 대응 관계를 가진다. 따라서 선택 절차도 테이블을 사용한다. `ReadHex`는 16진수로 읽은 값을 EAX에 돌려주고 `WriteHex`는 32비트 16진수 형태로 출력한다.

**예상 결과:** 아래 모든 값은 32비트 기준이다.

| 연산 | x | y | 결과 |
|---|---|---|---|
| AND | `F0F0F0F0` | `0FF00FF0` | `00F000F0` |
| OR | `0000FF00` | `00FF000F` | `00FFFF0F` |
| NOT | `00000000` | 사용 안 함 | `FFFFFFFF` |
| XOR | `AAAAAAAA` | `55555555` | `FFFFFFFF` |

---

## Exercise 7 — Probabilities and Colors

### 문제 요약

화면에 20개 줄을 출력하면서 줄마다 색상을 난수로 선택한다. 확률은 **흰색 30%, 파란색 10%, 녹색 60%**이며, 프로그램을 10번 실행해 대략적인 분포를 확인한다.

### 풀이 코드 — `Ex07_ProbabilitiesColors.asm`

```asm
INCLUDE Irvine32.inc

.data
lineText BYTE "Assembly language color test",0

.code
main PROC
    call Randomize
    mov ecx,20

PrintLine:
    push ecx
    mov eax,10
    call RandomRange         ; 0..9

    cmp eax,3
    jb UseWhite              ; 0,1,2 = 30%
    je UseBlue               ; 3 = 10%
    mov eax,green            ; 4..9 = 60%
    jmp SetColor

UseWhite:
    mov eax,white
    jmp SetColor

UseBlue:
    mov eax,blue

SetColor:
    call SetTextColor
    mov edx,OFFSET lineText
    call WriteString
    call Crlf
    pop ecx
    loop PrintLine

    mov eax,lightGray        ; restore normal text color
    call SetTextColor
    exit
main ENDP
END main
```

### 핵심 해설

동일한 확률을 가진 10개 난수 `0~9`를 세 범위로 나누면 `3:1:6` 확률 분포를 얻을 수 있다. 줄별 선택 결과는 서로 독립이므로 한 번 실행할 때 **흰색 6줄, 파란색 2줄, 녹색 12줄**이 반드시 나와야 하는 것은 아니다. 이는 20줄에 대한 기대 횟수일 뿐이다.

**테스트:** 10회 실행해 총 200줄 중 색상별 개수가 대체로 `60/20/120`에 가까워지는지 관찰한다. 표본이 작으므로 어느 정도의 차이는 정상이다.

---

## Exercise 8 — Message Encryption

### 문제 요약

§6.3.4의 단일 문자 XOR 암호화 예제를 수정하여, **여러 문자로 이루어진 키를 반복 사용**한다. 평문 각 바이트에 키의 대응 바이트를 XOR하고, 같은 연산을 다시 적용하여 복호화한다.

### 풀이 코드 — `Ex08_MessageEncryption.asm`

```asm
INCLUDE Irvine32.inc

BUFMAX = 128

.data
promptMsg BYTE "Enter plain text: ",0
cipherMsg BYTE "Cipher bytes (hex): ",0
decodeMsg BYTE "Decrypted text: ",0
spaceChar BYTE ' ',0

key BYTE "ABXmv#7",0
KEYLEN = LENGTHOF key - 1
buffer BYTE (BUFMAX+1) DUP(0)
bufSize DWORD ?

.code
; XOR first bufSize bytes of buffer with repeating key
; Two calls restore original plaintext
TranslateBuffer PROC USES eax ecx esi edi
    mov ecx,bufSize
    xor esi,esi              ; buffer index
    xor edi,edi              ; key index
    test ecx,ecx
    jz Finished

TranslateNext:
    mov al,key[edi]
    xor buffer[esi],al
    inc esi
    inc edi
    cmp edi,KEYLEN
    jne ContinueLoop
    xor edi,edi              ; wrap key index back to start

ContinueLoop:
    dec ecx
    jnz TranslateNext

Finished:
    ret
TranslateBuffer ENDP

; Ciphertext might contain null bytes or control characters
; Display individual bytes in hex rather than as a string
DisplayCipher PROC USES eax ecx edx esi
    mov edx,OFFSET cipherMsg
    call WriteString
    mov ecx,bufSize
    mov esi,OFFSET buffer

L1:
    test ecx,ecx
    jz Done
    push ecx
    push esi
    movzx eax,BYTE PTR [esi]
    call WriteHex             ; display single byte in 8-digit hex format
    mov edx,OFFSET spaceChar
    call WriteString
    pop esi
    pop ecx
    inc esi
    dec ecx
    jmp L1

Done:
    call Crlf
    ret
DisplayCipher ENDP

main PROC
    mov edx,OFFSET promptMsg
    call WriteString
    mov edx,OFFSET buffer
    mov ecx,BUFMAX
    call ReadString
    mov bufSize,eax

    call TranslateBuffer       ; encrypt
    call DisplayCipher

    call TranslateBuffer       ; decrypt with the same key
    mov edx,OFFSET decodeMsg
    call WriteString
    mov edx,OFFSET buffer
    call WriteString
    call Crlf

    exit
main ENDP
END main
```

### 핵심 해설

인덱스를 `0,1,...,KEYLEN-1,0,1,...`로 반복하는 것이 핵심이다. XOR에는 `(x XOR k) XOR k = x`라는 성질이 있으므로 같은 키로 두 번 처리하면 원래 데이터가 된다. 암호화한 결과를 `WriteString`으로 직접 표시하면 `00h`가 들어 있을 때 출력이 중단될 수 있어, 위 코드는 **암호문을 바이트별 16진수**로 출력한다(각 바이트가 8자리로 표시되는 간단한 방식).

**테스트:** 빈 문자열, 키보다 짧은 문자열, 키와 길이가 같은 문자열, 키 길이보다 긴 문자열(예: `Assembly language`)을 시험한다. 모든 경우 복호화된 문장이 입력과 같아야 한다.

---

## Exercise 9 — Validating a PIN

### 문제 요약

5자리 PIN을 **숫자 바이트 5개**로 받은 뒤, 자리마다 다른 허용 범위를 검사한다. 범위를 벗어난 첫 번째 자리의 **위치(1~5)를 EAX에 반환**, 전부 유효하면 **0을 반환**한다. 나머지 범용 레지스터를 보존하고 유효/무효 배열을 최소 4개 검사한다.

| 자리(왼쪽부터) | 최솟값 | 최댓값 |
|---|---:|---:|
| 1 | 5 | 9 |
| 2 | 2 | 5 |
| 3 | 4 | 8 |
| 4 | 1 | 4 |
| 5 | 3 | 6 |

### 풀이 코드 — `Ex09_ValidatePIN.asm`

```asm
INCLUDE Irvine32.inc

.data
minDigits BYTE 5,2,4,1,3
maxDigits BYTE 9,5,8,4,6

pinValid1 BYTE 5,2,4,1,3
pinBad1   BYTE 4,3,5,3,4  ; error at first digit
pinBad3   BYTE 6,3,9,2,5  ; error at third digit
pinBad5   BYTE 6,4,5,2,7  ; error at fifth digit
pinValid2 BYTE 9,5,8,4,6
results DWORD 5 DUP(?)

.code
; ESI = address of 5 numeric bytes (not ASCII digits)
; EAX = 0 if valid, else first bad position (1..5)
Validate_PIN PROC USES ebx ecx edx esi
    xor ebx,ebx              ; zero-based index
    mov ecx,5

CheckDigit:
    mov al,[esi+ebx]
    cmp al,minDigits[ebx]
    jb Invalid
    cmp al,maxDigits[ebx]
    ja Invalid
    inc ebx
    loop CheckDigit

    xor eax,eax              ; all digits valid
    ret

Invalid:
    lea eax,[ebx+1]         ; convert index into 1-based position
    ret
Validate_PIN ENDP

main PROC
    mov esi,OFFSET pinValid1
    call Validate_PIN
    mov results[0],eax       ; 0

    mov esi,OFFSET pinBad1
    call Validate_PIN
    mov results[4],eax       ; 1

    mov esi,OFFSET pinBad3
    call Validate_PIN
    mov results[8],eax       ; 3

    mov esi,OFFSET pinBad5
    call Validate_PIN
    mov results[12],eax      ; 5

    mov esi,OFFSET pinValid2
    call Validate_PIN
    mov results[16],eax      ; 0

    ; Inspect five DWORD values in results in debugger
    exit
main ENDP
END main
```

### 핵심 해설

자리별 허용 범위를 `minDigits`, `maxDigits` 두 배열로 선언했다. `JB`/`JA`는 바이트 숫자에 대한 unsigned 비교이며, 값이 범위를 벗어나면 **즉시 반환**하므로 첫 번째 잘못된 자리만 보고한다.

**예상 결과:** `results = {0,1,3,5,0}`. 문자 코드 형태의 PIN(`'5','2',...`)을 받으려면 별도로 ASCII 문자 `'0'`을 빼서 숫자값으로 변환해야 한다. 이 코드는 교재의 **BYTE 숫자 배열** 형식을 사용한다.

---

## Exercise 10 — Parity Checking

### 문제 요약

바이트 배열 전체에서 값이 1인 비트의 개수가 **짝수이면 EAX=1**, **홀수이면 EAX=0**을 반환한다. 배열 주소와 길이를 전달하고 EAX를 제외한 모든 범용 레지스터를 보존한다. 최소 10바이트짜리 짝수 패리티 배열과 홀수 패리티 배열을 각각 검사한다.

### 풀이 코드 — `Ex10_ParityCheck.asm`

```asm
INCLUDE Irvine32.inc

.data
; Pairing equal values makes the XOR accumulator zero
arrayEven BYTE 1,1,2,2,3,3,4,4,5,5
arrayOdd  BYTE 1,1,2,2,3,3,4,4,5,4

evenResult DWORD ?
oddResult  DWORD ?

.code
; ESI = address of array
; ECX = byte count
; EAX = 1 for even parity, 0 for odd parity
EvenParity PROC USES ebx ecx esi
    xor ebx,ebx            ; BL = XOR accumulator

CheckNext:
    test ecx,ecx
    jz Decide
    xor bl,BYTE PTR [esi]
    inc esi
    dec ecx
    jmp CheckNext

Decide:
    ; Loop instructions can overwrite PF.
    ; Recompute PF from the final XOR byte.
    test bl,bl             ; PF=1 means even number of set bits in BL
    setpe al               ; set AL=1 if PF=1, else 0
    movzx eax,al           ; zero-extend AL to 32-bit EAX
    ret
EvenParity ENDP

main PROC
    mov esi,OFFSET arrayEven
    mov ecx,LENGTHOF arrayEven
    call EvenParity
    mov evenResult,eax      ; expected: 1

    mov esi,OFFSET arrayOdd
    mov ecx,LENGTHOF arrayOdd
    call EvenParity
    mov oddResult,eax       ; expected: 0

    exit
main ENDP
END main
```

### 핵심 해설

모든 바이트를 XOR하면, 결과 바이트의 1비트 개수가 **원래 배열 전체의 1비트 개수와 동일한 짝홀성**을 가진다. 마지막에 `TEST BL,BL`을 실행하면 CPU의 **Parity Flag(PF)**가 누적 결과의 하위 8비트 패리티에 맞게 설정된다. `SETPE AL`은 PF가 1일 때 1을 대입한다.

교재는 루프에서 다른 명령이 PF를 변경하는 문제를 주의하라고 한다. 이 코드는 PF를 루프 내내 유지하려 하지 않고 **루프가 끝난 뒤 누적된 BL에서 PF를 다시 계산**해 이를 해결했다. 길이가 0인 배열의 패리티도 짝수(비트 1의 개수 0개)로 처리한다.

**예상 결과:** `evenResult=1`, `oddResult=0`. 10바이트 모두 `0`이면 1, 그중 한 바이트를 `1`로 바꾸면 0이 나와야 한다.

---

# 전체 문제 검증 체크리스트

| 번호 | 반드시 확인할 사항 | 이 문서의 기대 결과 |
|---|---|---|
| 1 | 서로 다른 범위의 두 배열, 상·하한 포함 여부, 모든 레지스터 보존 | 10개는 -20..20, 12개는 100..110 |
| 2 | 음수 포함, j/k 경계 포함, 재호출 안정성 | `6`, `51` |
| 3 | 각 점수 구간 및 경계값, 난수 10개 | A/B/C/D/F 기준대로 변환 |
| 4 | 350/250과 16/12의 경계, 학점 0/31 오류 | 지정 조건에 따른 가능/불가 |
| 5 | 표 기반 간접 호출, 1~4 선택 및 5 종료 | 연산명 표시, 정상 종료 |
| 6 | 네 비트 연산의 계산 결과, 8자리 16진수 표현 | 예시 표의 값과 일치 |
| 7 | 0..9의 난수를 3:1:6으로 분리 | 흰/파/초록 = 30/10/60% |
| 8 | 메시지 길이와 키 길이의 차이, 반복 키, 복호화 | 복호문이 평문과 동일 |
| 9 | 각 자리 범위, 최초 오류 위치 | `{0,1,3,5,0}` |
| 10 | 길이 10 이상의 짝·홀 패리티, PF 덮어쓰기 방지 | `{1,0}` |

