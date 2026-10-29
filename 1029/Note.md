# Chapter 7. Integer Arithmetic

## 목차

1. [먼저 알아둘 용어와 레지스터](#0-먼저-알아둘-용어와-레지스터)
2. [7.1 Shift and Rotate Instructions](#71-shift-and-rotate-instructions--시프트와-회전)
3. [7.2 Shift and Rotate Applications](#72-shift-and-rotate-applications--응용)
4. [7.3 Multiplication and Division Instructions](#73-multiplication-and-division-instructions--곱셈과-나눗셈)
5. [7.4 Extended Addition and Subtraction](#74-extended-addition-and-subtraction--확장-덧셈과-뺄셈)
6. [7.5 ASCII and Unpacked Decimal Arithmetic](#75-ascii-and-unpacked-decimal-arithmetic)
7. [7.6 Packed Decimal Arithmetic](#76-packed-decimal-arithmetic)
8. [시험 직전 요약](#시험-직전-요약)

---

## 0. 먼저 알아둘 용어와 레지스터

| 용어                           | 뜻                              | 기억할 점                            |
| ------------------------------ | ------------------------------- | ------------------------------------ |
| bit / byte / word / doubleword | 1비트 / 8비트 / 16비트 / 32비트 | `BYTE`, `WORD`, `DWORD`              |
| MSB (Most Significant Bit)     | 최상위 비트                     | 부호 있는 수에서 부호 비트           |
| LSB (Least Significant Bit)    | 최하위 비트                     | 홀짝 여부 판단 등에 사용             |
| CF (Carry Flag)                | 자리올림·자리빌림 플래그        | Shift로 밀려나간 마지막 비트도 저장  |
| OF (Overflow Flag)             | 부호 있는 결과의 범위 초과      | CF와 의미가 다름                     |
| ZF (Zero Flag)                 | 연산 결과가 0이면 1             | 조건 분기에 사용                     |
| SF (Sign Flag)                 | 결과의 최상위 비트              | 부호 판단에 사용                     |
| PF (Parity Flag)               | 결과 하위 바이트의 짝수 패리티  | 비트 연산 결과 확인                  |
| unsigned / signed              | 부호 없는 / 부호 있는 정수      | `MUL`·`DIV` 대 `IMUL`·`IDIV`         |
| quotient / remainder           | 몫 / 나머지                     | 나눗셈에서 서로 다른 레지스터에 저장 |
| sign extension                 | 부호 확장                       | 음수의 부호 비트를 상위 비트에 복사  |
| logical shift                  | 논리 시프트                     | 빈자리를 0으로 채움                  |
| arithmetic shift               | 산술 시프트                     | 오른쪽 이동 시 부호 비트 유지        |
| rotate                         | 회전                            | 밀려난 비트를 반대편으로 다시 넣음   |
| BCD                            | Binary-Coded Decimal            | 10진 숫자 한 자리를 4비트로 표현     |

**레지스터 구조**

```text
EAX (32비트)
└── AX (하위 16비트)
    ├── AH (상위 8비트)
    └── AL (하위 8비트)

EDX:EAX = 상위 32비트 : 하위 32비트 (64비트 값)
DX:AX   = 상위 16비트 : 하위 16비트 (32비트 값)
```

[학습 보충] `10000000b`는 8비트에서 unsigned로 128, signed로 -128이다. **비트 패턴은 같아도 해석이 다르다.**

---

## 7.1 Shift and Rotate Instructions — 시프트와 회전

### 7.1.1 명령어 전체 비교

| 명령어 | 이름                       | 이동 방향 | 새로 채우는 비트          | CF                     |
| ------ | -------------------------- | --------- | ------------------------- | ---------------------- |
| `SHL`  | Shift Left                 | 왼쪽      | 오른쪽에 0                | 왼쪽에서 밀려난 비트   |
| `SHR`  | Shift Right                | 오른쪽    | 왼쪽에 0                  | 오른쪽에서 밀려난 비트 |
| `SAL`  | Shift Arithmetic Left      | 왼쪽      | 오른쪽에 0                | `SHL`과 동일           |
| `SAR`  | Shift Arithmetic Right     | 오른쪽    | 왼쪽에 기존 부호 비트     | 오른쪽에서 밀려난 비트 |
| `ROL`  | Rotate Left                | 왼쪽      | 기존 MSB를 LSB에 재삽입   | 기존 MSB               |
| `ROR`  | Rotate Right               | 오른쪽    | 기존 LSB를 MSB에 재삽입   | 기존 LSB               |
| `RCL`  | Rotate through Carry Left  | 왼쪽      | 기존 CF를 LSB에 삽입      | 기존 MSB               |
| `RCR`  | Rotate through Carry Right | 오른쪽    | 기존 CF를 MSB에 삽입      | 기존 LSB               |
| `SHLD` | Shift Left Double          | 왼쪽      | 다른 피연산자의 상위 비트 | 밀려난 비트            |
| `SHRD` | Shift Right Double         | 오른쪽    | 다른 피연산자의 하위 비트 | 밀려난 비트            |

기본 형식:

```asm
shl eax, 1      ; 즉시값으로 1비트 이동
shr eax, 3      ; 즉시값으로 3비트 이동
mov cl, 4
sar eax, cl     ; CL에 저장한 횟수만큼 이동
```

**중요:** 가변 이동 횟수에는 `CL`을 사용한다. `SHL eax, bl`처럼 쓰지 않는다.

### 7.1.2 SHL / SAL — 왼쪽 시프트

```text
시작: 10001111b
SHL 1: 00011110b    CF = 1
```

```asm
mov bl, 8Fh
shl bl, 1       ; BL = 1Eh, CF = 1

mov dl, 5
shl dl, 1       ; DL = 10 (5 × 2)

mov dl, 10
shl dl, 2       ; DL = 40 (10 × 4)
```

- `SHL`과 `SAL`의 동작은 같다.
- 왼쪽으로 `n`비트 이동하면 **값이 범위 내에 남는 경우** `2^n`을 곱한 효과가 있다.
- 밀려난 상위 비트는 소실되므로 항상 정확한 곱셈은 아니다.

### 7.1.3 SHR — 논리 오른쪽 시프트

```text
시작: 11010000b
SHR 1: 01101000b    CF = 0
```

```asm
mov al, 01000000b  ; 64
shr al, 3          ; AL = 00001000b = 8

mov dl, 32
shr dl, 1          ; DL = 16
```

- 왼쪽 빈자리를 **0**으로 채운다.
- 부호 없는 정수를 `2^n`으로 나누는 데 활용한다(나머지는 버림).

### 7.1.4 SAR — 산술 오른쪽 시프트

```text
시작: 11110000b (-16)
SAR 1: 11111000b (-8)
```

```asm
mov al, 0F0h      ; signed 8비트로 -16
sar al, 1         ; AL = F8h = -8

mov ax, -128
; AX의 부호를 EAX 전체로 확장하는 시프트 응용
shl eax, 16
sar eax, 16
```

- `SAR`는 기존 MSB(부호 비트)를 유지한다.
- 음수에 대해 `SAR`는 음의 무한대 방향으로 내림되는 효과가 있어, **0 방향으로 절삭하는 `IDIV`와 다를 수 있다**. [학습 보충]
- **비교:** `SHR 10000000b,1` → `01000000b`, `SAR 10000000b,1` → `11000000b`.

### 7.1.5 ROL / ROR — 비트 회전

```asm
mov al, 40h       ; 01000000b
rol al, 1         ; 10000000b, CF=0
rol al, 1         ; 00000001b, CF=1
rol al, 1         ; 00000010b, CF=0

mov al, 01h
ror al, 1         ; 10000000b, CF=1
ror al, 1         ; 01000000b, CF=0
```

`ROL`·`ROR`는 시프트와 달리 **비트를 버리지 않고 순환**시킨다.

```asm
mov ax, 6A4Bh
rol ax, 4         ; AX = A4B6h (4비트씩 회전)
rol ax, 4         ; AX = 4B6Ah
```

### 7.1.6 RCL / RCR — CF까지 포함한 회전

```text
RCL: [CF] ← MSB ... LSB ← [이전 CF]
RCR: [이전 CF] → MSB ... LSB → [CF]
```

```asm
clc                ; CF=0
mov bl, 88h
rcl bl, 1          ; BL=10h, CF=1
rcl bl, 1          ; BL=21h, CF=0

stc                ; CF=1
mov ah, 10h
rcr ah, 1          ; AH=88h, CF=0
```

- `CLC`: CF를 0으로 만든다.
- `STC`: CF를 1로 만든다.
- 여러 바이트/워드에 걸친 비트 이동에 유용하다.

### 7.1.7 Signed Overflow — 부호 오버플로

```asm
mov al, +127      ; 01111111b
rol al, 1         ; 11111110b, OF=1

mov al, -128      ; 10000000b
shr al, 1         ; 01000000b, OF=1
```

**핵심:** PDF에서는 **이동/회전 횟수가 1보다 크면 OF가 정의되지 않는다**고 강조한다. 따라서 여러 비트를 이동한 뒤 OF에 의존해서 판단하지 않는다. [학습 보충] 횟수가 1인 경우에도 명령어별 OF 의미가 다르므로 일반화하지 않는다.

### 7.1.8 SHLD / SHRD — 이중 정밀도 시프트

```asm
shld destination, source, count
shrd destination, source, count
```

- `SHLD`: 목적지를 왼쪽으로 이동하고, **source의 상위 비트**를 빈자리에 채운다.
- `SHRD`: 목적지를 오른쪽으로 이동하고, **source의 하위 비트**를 빈자리에 채운다.
- **source는 변경되지 않고 destination만 변경된다.**
- PDF의 예시처럼 16비트 또는 32비트 레지스터/메모리 쌍을 연결해 이동시킬 수 있다.

```asm
.data
wval WORD 9BA6h
.code
mov ax, 0AC36h
shld wval, ax, 4    ; wval = BA6Ah

mov ax, 234Bh
mov dx, 7654h
shrd ax, dx, 4      ; AX = 4234h, DX는 그대로
```

**배열 예제 이해하기**

```asm
.data
array DWORD 648B2165h, 8C943A29h, 6DFA4B86h, 91F76C04h, 8BAF9857h
.code
mov bl, 4
mov esi, OFFSET array
mov ecx, (LENGTHOF array) - 1
L1:
    push ecx
    mov eax, [esi + TYPE DWORD]
    mov cl, bl
    shrd [esi], eax, cl
    add esi, TYPE DWORD
    pop ecx
    loop L1
shr DWORD PTR [esi], 4
```

**동작 순서:** (1) 다음 DWORD를 EAX로 읽음 → (2) 현재 DWORD를 오른쪽 4비트 이동하면서 다음 DWORD의 하위 비트를 채움 → (3) 주소를 다음 DWORD로 이동 → (4) 마지막 DWORD는 `SHR`로 처리. 즉, 연속된 DWORD 배열 전체를 오른쪽으로 4비트 이동하는 구조이다. `PUSH/POP ECX`는 `CL`에 시프트 횟수를 넣는 동안 `LOOP` 카운터를 보호한다.

---

## 7.2 Shift and Rotate Applications — 응용

### 7.2.1 여러 바이트를 하나의 큰 정수처럼 이동

```asm
.data
ArraySize = 3
array BYTE ArraySize DUP(99h)
.code
mov esi, 0
shr array[esi+2], 1    ; 최상위 바이트를 먼저 이동
rcr array[esi+1], 1    ; CF를 다음 바이트에 연결
rcr array[esi], 1      ; CF를 최하위 바이트에 연결
```

**왜 `SHR` 다음 `RCR`일까?** 상위 바이트의 LSB가 CF에 들어가고, 다음 바이트가 `RCR`을 실행하면서 그 CF를 자신의 MSB로 받아야 전체 24비트가 연결된 상태로 이동하기 때문이다.

```text
이전: 99 99 99 (16진수, 상위 바이트 → 하위 바이트)
이후: 4C CC CC
```

### 7.2.2 Binary Multiplication — 시프트를 이용한 곱셈

`36 = 32 + 4 = 2^5 + 2^2`이므로 `x × 36 = (x << 5) + (x << 2)`.

```asm
mov eax, 123
mov ebx, eax
shl eax, 5        ; 123 × 32
shl ebx, 2        ; 123 × 4
add eax, ebx      ; EAX = 4428
```

**주의:** 시프트 과정에서 상위 비트가 소실되면 결과가 달라질 수 있다.

### 7.2.3 Displaying Binary Bits — 정수를 이진 ASCII 문자열로 변환

```asm
; 입력: EAX = 32비트 정수, ESI = 출력 버퍼 주소
; 출력: 버퍼에 문자 '0' 또는 '1' 32개 기록
BinToAsc PROC
    push ecx
    push esi
    mov ecx, 32
L1:
    shl eax, 1
    mov BYTE PTR [esi], '0'
    jnc L2                 ; CF=0이면 '0' 유지
    mov BYTE PTR [esi], '1'
L2:
    inc esi
    loop L1
    pop esi
    pop ecx
    ret
BinToAsc ENDP
```

- 가장 왼쪽 비트가 `SHL`을 통해 CF로 이동한다.
- `JNC`는 CF=0일 때 분기한다.
- **[학습 보충]** `WriteString`으로 출력하려면 버퍼에 **33바이트 이상** 확보하고, 32번째 문자 다음에 `0`(널 종료)을 별도로 기록해야 한다. 위 PDF 프로시저 자체는 널 종료를 기록하지 않는다.

### 7.2.4 Extracting File Date Fields — 파일 날짜 비트 추출

16비트 DOS 날짜 형식:

| 비트 | 필드        | 추출 방법                              |
| ---- | ----------- | -------------------------------------- |
| 0~4  | Day (일)    | `AND 00011111b`                        |
| 5~8  | Month (월)  | 오른쪽 5비트 시프트 후 `AND 00001111b` |
| 9~15 | Year (연도) | 오른쪽 9비트 시프트 후 `+1980`         |

```asm
mov al, dl
and al, 00011111b
mov day, al

mov ax, dx
shr ax, 5
and al, 00001111b
mov month, al

mov al, dh
shr al, 1
mov ah, 0
add ax, 1980
mov year, ax
```

**핵심:** `AND`는 필요한 비트만 남기는 **마스킹(masking)** 명령어다.

---

## 7.3 Multiplication and Division Instructions — 곱셈과 나눗셈

### 7.3.1 MUL — 부호 없는 곱셈

```asm
mul reg_or_mem     ; 곱하는 수 한 개만 명시
```

| 명시한 피연산자 크기 | 암묵적 피승수 | 전체 곱의 저장 위치 |
| -------------------- | ------------- | ------------------- |
| 8비트                | AL            | AX (16비트)         |
| 16비트               | AX            | DX:AX (32비트)      |
| 32비트               | EAX           | EDX:EAX (64비트)    |

```asm
mov al, 05h
mov bl, 10h
mul bl            ; AX = 0050h, CF=0

mov ax, 2000h
mov bx, 0100h
mul bx            ; DX:AX = 00200000h, CF=1

mov eax, 12345h
mov ebx, 1000h
mul ebx           ; EDX:EAX = 00000000:12345000h
```

**CF/OF:** 곱의 상위 절반이 0이면 0, 0이 아니면 1이다. [학습 보충] `MUL`에서 다른 상태 플래그는 결과 판정에 사용하지 않는다.

### 7.3.2 IMUL — 부호 있는 곱셈

**1피연산자 형식:** `MUL`과 결과 저장 레지스터가 같다. 단, signed로 곱한다.

```asm
mov al, -4
mov bl, 4
imul bl           ; AX = FFF0h (-16)

mov ax, -16
mov bx, 2
imul bx           ; DX:AX = FFFFFFF0h (-32)
```

**2피연산자 형식:** 결과를 목적지 크기로 잘라 저장한다.

```asm
mov ax, -16
mov bx, 2
imul bx, ax       ; BX = -32
imul bx, 2        ; BX = -64
```

**3피연산자 형식:** `imul destination, source, immediate`

```asm
.data
word1 SWORD 4
.code
imul bx, word1, -16  ; BX = -64
```

| 형식 | 예                 | 결과                            |
| ---- | ------------------ | ------------------------------- |
| 1개  | `imul bl`          | `AL × BL → AX`                  |
| 2개  | `imul ebx, eax`    | `EBX × EAX → EBX` (하위 32비트) |
| 3개  | `imul ebx, eax, 5` | `EAX × 5 → EBX` (하위 32비트)   |

**OF/CF:** 결과가 목적지 크기의 signed 범위에 들어가지 않으면 1이다. 특히 2·3피연산자 형식에서 반드시 확인할 것.

```asm
mov ax, -32000
imul ax, 2        ; 16비트 signed 범위 초과 → OF=1
```

**시험 핵심:** `MUL`은 unsigned, `IMUL`은 signed. `IMUL`의 2·3피연산자 형식은 결과를 목적지 크기로 제한한다.

### 7.3.3 Measuring Program Execution Times

```asm
.data
startTime DWORD ?
procTime1 DWORD ?
.code
call GetMseconds
mov startTime, eax
call FirstProcedureToTest
call GetMseconds
sub eax, startTime
mov procTime1, eax
```

- `GetMseconds`: 경과 시간을 밀리초 단위로 얻는 Irvine32 함수.
- **종료 시간 − 시작 시간 = 실행 시간**.
- 같은 방식으로 다른 프로시저의 실행 시간을 측정하여 비교할 수 있다.

### 7.3.4 DIV — 부호 없는 나눗셈

```asm
div reg_or_mem
```

| 나누는 수 | 피제수  | 몫  | 나머지 |
| --------- | ------- | --- | ------ |
| 8비트     | AX      | AL  | AH     |
| 16비트    | DX:AX   | AX  | DX     |
| 32비트    | EDX:EAX | EAX | EDX    |

```asm
mov ax, 0083h
mov bl, 2
div bl            ; AL = 41h (몫), AH = 01h (나머지)

mov dx, 0
mov ax, 8003h
mov cx, 0100h
div cx            ; AX = 0080h, DX = 0003h
```

**매우 중요:** 32비트 `DIV`를 사용할 때 피제수는 EAX **하나가 아니라 `EDX:EAX` 전체**다. 32비트 양수를 나눌 때 상위 32비트가 0이어야 한다면 다음처럼 설정한다.

```asm
mov eax, 100
mov edx, 0
mov ebx, 7
div ebx            ; EAX=14, EDX=2
```

### 7.3.5 Sign Extension — 부호 확장

| 명령어 | 변환          | 설명                  |
| ------ | ------------- | --------------------- |
| `CBW`  | AL → AX       | AL 부호를 AH에 확장   |
| `CWD`  | AX → DX:AX    | AX 부호를 DX에 확장   |
| `CDQ`  | EAX → EDX:EAX | EAX 부호를 EDX에 확장 |

```asm
mov al, -101       ; AL = 9Bh
cbw                ; AX = FF9Bh

mov ax, -101       ; AX = FF9Bh
cwd                ; DX:AX = FFFF:FF9Bh

mov eax, -101      ; EAX = FFFFFF9Bh
cdq                ; EDX:EAX = FFFFFFFF:FFFFFF9Bh
```

**왜 필요한가?** signed 정수의 음수 값을 큰 피제수로 해석할 때 부호를 유지하기 위해서다. 상위 레지스터를 무조건 0으로 만들면 음수가 양수로 잘못 해석될 수 있다.

### 7.3.6 IDIV — 부호 있는 나눗셈

`IDIV`의 피제수/몫/나머지 레지스터는 `DIV`와 같지만 signed로 해석한다.

```asm
mov al, -48
cbw
mov bl, 5
idiv bl           ; AL = -9, AH = -3

mov ax, -5000
cwd
mov bx, 256
idiv bx           ; AX = -19, DX = -136

mov eax, 50000
cdq
mov ebx, -256
idiv ebx          ; EAX = -195, EDX = +80
```

- 몫은 **0 방향으로 절삭**한다. [학습 보충]
- 나머지는 피제수와 같은 부호이거나 0이다. [학습 보충]
- `DIV`와 `IDIV`를 실행한 후 **산술 상태 플래그는 정의되지 않는다**.

### 7.3.7 Divide Overflow / Divide by Zero

**나눗셈 오류가 발생하는 두 상황**

1. 나누는 수가 0이다.
2. 몫이 결과 레지스터에 들어가지 않는다.

```asm
mov ax, 1000h
mov bl, 10h
div bl              ; 몫 0100h는 AL(8비트)에 못 들어감 → 예외
```

PDF에서 제시한 더 넓은 몫 레지스터 사용법:

```asm
mov eax, 1000h
cdq
mov ebx, 10h
div ebx             ; EAX = 00000100h
```

[학습 보충] 여기서는 EAX가 양수이므로 `CDQ` 결과 EDX가 0이 된다. 일반적인 **unsigned** 32비트 나눗셈에서는 `xor edx, edx`처럼 상위 절반을 0으로 준비하는 편이 의도가 명확하다.

```asm
mov ax, dividend
mov bl, divisor
cmp bl, 0
je NoDivideZero
div bl
jmp Done
NoDivideZero:
    ; 오류 처리
Done:
```

**주의:** 0 검사만으로 몫 범위 초과까지 막을 수 있는 것은 아니다.

### 7.3.8 Implementing Arithmetic Expressions — 수식 구현

**예제 1: `var4 = (var1 + var2) * var3`**

```asm
mov eax, var1
add eax, var2
mul var3
jc tooBig          ; 상위 32비트에 결과가 있으면 오류
mov var4, eax
jmp next
tooBig:
    ; 오류 처리
next:
```

[학습 보충] 덧셈 자체의 overflow까지 검사해야 하는 상황이라면 `ADD` 직후에도 별도 검사한다.

**예제 2: `var4 = (var1 * 5) / (var2 - 3)`**

```asm
mov eax, var1
mov ebx, 5
mul ebx           ; EDX:EAX = var1 * 5
mov ebx, var2
sub ebx, 3
div ebx           ; EAX = 몫
mov var4, eax
```

- 곱셈 결과가 `EDX:EAX`에 있으므로 64비트 피제수를 그대로 나눌 수 있다.
- 나누기 전 `EBX != 0`과 몫 범위를 확인해야 한다.

**예제 3: `var4 = (var1 * -5) / (-var2 % var3)`**

```asm
mov eax, var2
neg eax
cdq
idiv var3
mov ebx, edx      ; EBX = (-var2) % var3
mov eax, -5
imul var1         ; EDX:EAX = -5 * var1
idiv ebx
mov var4, eax
```

- `NEG`: 부호 반전.
- `%`는 나머지이므로 `IDIV` 후 **EDX**를 읽는다.
- `IDIV`는 몫을 EAX, 나머지를 EDX에 저장한다.
- 분모가 0인 경우와 부호 있는 나눗셈 범위 초과를 주의한다.

---

## 7.4 Extended Addition and Subtraction — 확장 덧셈과 뺄셈

### 7.4.1 ADC — Add with Carry

```text
ADC destination, source
결과 = destination + source + CF
```

```asm
mov dl, 0
mov al, 0FFh
add al, 0FFh       ; AL=FEh, CF=1
adc dl, 0          ; DL=01h (이전 자리올림 추가)
```

**사용 이유:** 여러 레지스터로 구성된 큰 정수에서 하위 부분의 자리올림을 상위 부분으로 전달한다.

```asm
; 64비트 덧셈 예: EDX:EAX += ECX:EBX
add eax, ebx
adc edx, ecx
```

### 7.4.2 SBB — Subtract with Borrow

```text
SBB destination, source
결과 = destination - source - CF
```

```asm
mov edx, 7
mov eax, 1
sub eax, 2         ; EAX=FFFFFFFFh, CF=1 (빌림)
sbb edx, 0         ; EDX=6
```

```asm
; 64비트 뺄셈 예: EDX:EAX -= ECX:EBX
sub eax, ebx
sbb edx, ecx
```

| 비교    | `ADD`     | `ADC`            | `SUB`     | `SBB`            |
| ------- | --------- | ---------------- | --------- | ---------------- |
| 연산    | A+B       | A+B+CF           | A−B       | A−B−CF           |
| 주 용도 | 일반 덧셈 | 다중 정밀도 덧셈 | 일반 뺄셈 | 다중 정밀도 뺄셈 |

---

## 7.5 ASCII and Unpacked Decimal Arithmetic

### 7.5.1 ASCII 숫자와 Unpacked Decimal

| 숫자 | ASCII 문자 코드 | Unpacked decimal |
| ---- | --------------- | ---------------- |
| 0    | `30h`           | `00h`            |
| 2    | `32h`           | `02h`            |
| 5    | `35h`           | `05h`            |
| 9    | `39h`           | `09h`            |

- ASCII 숫자의 상위 4비트는 `0011b`.
- Unpacked decimal 숫자의 상위 4비트는 `0000b`.
- 예: ASCII 문자열 `"3402"`는 `33h 34h 30h 32h`, unpacked는 `03h 04h 00h 02h`.

**명령어 비교**

| 명령어 | 풀네임                            | 사용 시점        |
| ------ | --------------------------------- | ---------------- |
| `AAA`  | ASCII Adjust after Addition       | `ADD`/`ADC` 이후 |
| `AAS`  | ASCII Adjust after Subtraction    | `SUB`/`SBB` 이후 |
| `AAM`  | ASCII Adjust after Multiplication | `MUL` 이후       |
| `AAD`  | ASCII Adjust before Division      | `DIV` 이전       |

> **[학습 보충]** 이들 명령어는 역사적인 x86 16/32비트 환경의 명령어이며, x86-64의 64비트 모드에서는 사용할 수 없다. PDF의 32비트 학습 환경에 맞춰 공부한다.

### 7.5.2 AAA — 덧셈 후 10진 조정

```asm
mov ah, 0
mov al, '8'       ; AL=38h
add al, '2'       ; AL=6Ah
; PDF의 표기와 달리 실제 합계는 38h+32h=6Ah
; AAA 실행 후 AL=00h, AH=01h
aaa
or ax, 3030h      ; AX=3130h → ASCII '1','0'
```

**해석:** 8+2=10 → 십의 자리 1을 AH에, 일의 자리 0을 AL에 정리한다. `OR 3030h`는 두 바이트를 ASCII 숫자로 바꾼다.

> **원본 표기 주의:** PDF 51쪽은 `ADD` 직후 `AX=006Ah`를 표시한다. 결과는 위 코드처럼 `6Ah`가 맞다.

### 7.5.3 ASCII 문자열 덧셈 알고리즘

PDF는 다음 두 고정 소수점 문자열을 더하는 `ASCII_add.asm`을 제시한다.

```asm
DECIMAL_OFFSET = 5
decimal_one BYTE "100123456789765"   ; 1001234567.89765
decimal_two BYTE "900402076502015"   ; 9004020765.02015
sum BYTE (SIZEOF decimal_one + 1) DUP(0), 0
```

**핵심 흐름**

1. 문자열의 **맨 오른쪽 자리**부터 계산한다.
2. 이전 자리에서 전달된 carry를 첫 번째 숫자에 더한다.
3. `AAA`로 10진 자릿수를 보정하고 carry를 저장한다.
4. 두 번째 숫자를 더한 뒤 다시 `AAA`로 보정한다.
5. `OR 30h`로 ASCII로 변환해 결과 버퍼에 저장한다.
6. 왼쪽으로 이동하며 반복하고 마지막 carry를 저장한다.

**원본의 주요 루프**

```asm
mov esi, SIZEOF decimal_one - 1
mov edi, SIZEOF decimal_one
mov ecx, SIZEOF decimal_one
mov bh, 0
L1:
    mov ah, 0
    mov al, decimal_one[esi]
    add al, bh
    aaa
    mov bh, ah
    or bh, 30h
    add al, decimal_two[esi]
    aaa
    or bh, ah
    or bh, 30h
    or al, 30h
    mov sum[edi], al
    dec esi
    dec edi
    loop L1
mov sum[edi], bh
```

**학습 포인트:** `ESI`는 입력 위치, `EDI`는 출력 위치, `ECX`는 반복 횟수, `BH`는 carry 관리에 쓰인다. `sum`은 맨 앞 자리올림을 고려하여 입력보다 1자리 크게 만든다. 소수점은 실제 문자열에 저장하지 않고 `DECIMAL_OFFSET`으로 위치를 암시한다.

### 7.5.4 AAS — 뺄셈 후 10진 조정

```asm
mov ah, 0
mov al, '8'
sub al, '9'       ; AL=FFh
aas                ; AX=FF09h
pushf              ; 플래그 저장
or al, 30h        ; AL='9'
popf               ; 플래그 복원
```

`AAS`는 unpacked decimal의 뺄셈 결과를 한 자리 10진수로 조정한다. `PUSHF`/`POPF`는 플래그 보존에 사용된다.

### 7.5.5 AAM — 곱셈 후 10진 조정

```asm
.data
AscVal BYTE 05h, 06h
.code
mov bl, AscVal
mov al, AscVal+1
mul bl             ; AX=001Eh (30)
aam                ; AX=0300h → 십의 자리 3, 일의 자리 0
```

**기억:** `AAM`은 AL에 있는 결과를 `AH=십의 자리`, `AL=일의 자리`로 나눈다(기본 10진 조정).

### 7.5.6 AAD — 나눗셈 전 10진 조정

```asm
mov ax, 0307h      ; AH=3, AL=7 → unpacked 37
aad                ; AX=0025h (37)
mov bl, 5
div bl             ; AL=7 (몫), AH=2 (나머지)
```

**기억:** `AAD`는 `AH × 10 + AL`을 AL에 합쳐 이진수로 만들고 AH를 0으로 만든다. [학습 보충]

---

## 7.6 Packed Decimal Arithmetic

### 7.6.1 Packed BCD란?

- **Unpacked:** 바이트 1개에 10진 숫자 1자리 저장 (`05h`).
- **Packed:** 바이트 1개에 10진 숫자 **2자리** 저장 (`45h` = 10진수 숫자 4와 5).
- 일반적인 16진 정수 연산과 BCD 자릿수 연산은 다르므로 보정 명령어가 필요하다.

| 명령어 | 의미                             | 실행 시점      |
| ------ | -------------------------------- | -------------- |
| `DAA`  | Decimal Adjust after Addition    | `ADD`/`ADC` 후 |
| `DAS`  | Decimal Adjust after Subtraction | `SUB`/`SBB` 후 |

> **[학습 보충]** `DAA`·`DAS`도 64비트 모드에서는 사용할 수 없다.

### 7.6.2 DAA — Packed BCD 덧셈

```asm
mov al, 35h
add al, 48h        ; AL=7Dh (이진 덧셈 결과)
daa                ; AL=83h (BCD: 35+48=83)
```

**PDF의 다중 바이트 BCD 덧셈 예제**

```asm
.data
packed_1 WORD 4536h
packed_2 WORD 7207h
sum DWORD ?
.code
mov sum, 0
mov esi, 0
mov al, BYTE PTR packed_1[esi]
add al, BYTE PTR packed_2[esi]
daa
mov BYTE PTR sum[esi], al

inc esi
mov al, BYTE PTR packed_1[esi]
adc al, BYTE PTR packed_2[esi]
daa
mov BYTE PTR sum[esi], al

inc esi
mov al, 0
adc al, 0
mov BYTE PTR sum[esi], al
```

**해석:** 하위 바이트부터 `ADD + DAA`, 상위 바이트는 `ADC + DAA`로 자리올림을 연결한다. `4536 + 7207 = 11743`이므로 결과 BCD 바이트는 하위부터 `43h, 17h, 01h`가 된다. (메모리의 little-endian 저장 순서)

### 7.6.3 DAS — Packed BCD 뺄셈

```asm
mov bl, 48h
mov al, 85h
sub al, bl         ; AL=3Dh
das                ; AL=37h (BCD: 85-48=37)
```

**구별:** `AAA`·`AAS`는 unpacked decimal, `DAA`·`DAS`는 packed decimal에 사용한다.

---

## 시험 직전 요약

### 1. 명령어 한눈에 보기

| 목적               | 명령어                     | 외워야 할 특징                |
| ------------------ | -------------------------- | ----------------------------- |
| 왼쪽 시프트        | `SHL`, `SAL`               | 오른쪽에 0, 왼쪽 끝은 CF      |
| 논리 오른쪽 시프트 | `SHR`                      | 왼쪽에 0                      |
| 산술 오른쪽 시프트 | `SAR`                      | 부호 비트 유지                |
| 순환 회전          | `ROL`, `ROR`               | 비트가 반대편으로 돌아옴      |
| CF 포함 회전       | `RCL`, `RCR`               | CF까지 함께 회전              |
| 두 피연산자 시프트 | `SHLD`, `SHRD`             | source 비트로 빈자리 채움     |
| unsigned 곱셈      | `MUL`                      | AX / DX:AX / EDX:EAX          |
| signed 곱셈        | `IMUL`                     | 1·2·3피연산자 형식            |
| unsigned 나눗셈    | `DIV`                      | 몫과 나머지 위치 구분         |
| signed 나눗셈      | `IDIV`                     | `CBW`·`CWD`·`CDQ` 준비        |
| 부호 확장          | `CBW`, `CWD`, `CDQ`        | AL→AX, AX→DX:AX, EAX→EDX:EAX  |
| carry 덧셈         | `ADC`                      | `dest += src + CF`            |
| borrow 뺄셈        | `SBB`                      | `dest -= src + CF`            |
| unpacked 10진 보정 | `AAA`, `AAS`, `AAM`, `AAD` | 덧셈·뺄셈·곱셈 후 / 나눗셈 전 |
| packed BCD 보정    | `DAA`, `DAS`               | 덧셈·뺄셈 후                  |

### 2. 나눗셈 레지스터 암기표 (최우선)

| 나누는 수 크기 | 피제수  | 몫  | 나머지 | signed 사전 준비 |
| -------------- | ------- | --- | ------ | ---------------- |
| 8비트          | AX      | AL  | AH     | `CBW`            |
| 16비트         | DX:AX   | AX  | DX     | `CWD`            |
| 32비트         | EDX:EAX | EAX | EDX    | `CDQ`            |

### 3. 자주 틀리는 10가지

1. `SHR`와 `SAR`는 **음수에서 다르게 동작**한다.
2. `ROL`·`ROR`는 밀려난 비트를 버리지 않는다.
3. `RCL`·`RCR`는 **이전 CF**가 결과에 들어간다.
4. `SHLD`·`SHRD`의 **source는 변경되지 않는다**.
5. `MUL`·`IMUL` 1피연산자 형식의 결과는 피연산자보다 **2배 넓은 위치**에 저장된다.
6. `DIV`·`IDIV`는 **몫뿐 아니라 나머지**도 계산한다.
7. `DIV`·`IDIV` 후 플래그 값은 믿지 않는다.
8. `IDIV`에서 음수 피제수를 쓸 때 **부호 확장**을 잊지 않는다.
9. `ADC`·`SBB`는 현재 **CF의 값까지** 계산한다.
10. `AAA/AAS`와 `DAA/DAS`는 각각 **unpacked / packed** 용도다.

### 4. 셀프 체크 (답 포함)

<details><summary>Q1. `mov al, 80h` 다음 `shr al,1`과 `sar al,1` 결과는?</summary>

`SHR` → `40h`, `SAR` → `C0h`.

</details>

<details><summary>Q2. `mov eax, -20`을 32비트 signed로 3으로 나누려면?</summary>

```asm
mov eax, -20
cdq
mov ebx, 3
idiv ebx       ; EAX=-6, EDX=-2
```

</details>

<details><summary>Q3. 16비트 나눗셈 후 나머지는 어디에 있는가?</summary>

`DX` (몫은 `AX`).

</details>

<details><summary>Q4. `ADD` 대신 `ADC`를 쓰는 이유는?</summary>

하위 자리에서 발생한 `CF`를 상위 자리 덧셈에 포함하기 위해서다.

</details>

<details><summary>Q5. `35h + 48h`의 packed BCD 결과를 얻는 명령어는?</summary>

`ADD` 후 `DAA`, 결과 `83h`.

</details>

---

## 원본 PDF 페이지별 찾아보기

| PDF 페이지 | 주제                                                  |
| ---------- | ----------------------------------------------------- |
| 2~4        | Shift/Rotate 명령어 목록, 논리·산술 시프트 개념       |
| 5~9        | SHL, SHR, SAL, SAR                                    |
| 10~13      | ROL, ROR, RCL, RCR, Signed Overflow                   |
| 14~17      | SHLD, SHRD, DWORD 배열 시프트                         |
| 19~23      | 다중 바이트 시프트, 이진 곱셈, 이진 문자열, 날짜 필드 |
| 25~33      | MUL, IMUL, 실행 시간 측정                             |
| 34~42      | DIV, 부호 확장, IDIV, 나눗셈 오류                     |
| 43~45      | 산술 수식 구현                                        |
| 47~48      | ADC, SBB                                              |
| 50~57      | ASCII 및 unpacked decimal, AAA/AAS/AAM/AAD            |
| 59~61      | Packed decimal, DAA/DAS                               |
| 63         | 챕터 목차 요약                                        |
| 64~65      | 참고 링크 및 리뷰/과제 안내                           |
