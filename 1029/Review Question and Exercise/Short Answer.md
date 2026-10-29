# Short Answer

## 1. SHR, SAR, ROL

**영문 문제:** In the following code sequence, show the value of AL after each shift or rotate instruction has executed.

**한국어 번역:** 다음 코드에서 각 시프트 또는 회전 명령어를 실행한 후 `AL`의 값을 구하시오.

```asm
mov al,0D4h
shr al,1     ; a  01101010b
mov al,0D4h
sar al,1     ; b  11101010b
mov al,0D4h
sar al,4     ; c  11111101b
mov al,0D4h
rol al,1     ; d  10101001b
```

**정답:** a. `6Ah` / b. `EAh` / c. `FDh` / d. `A9h`

**짧은 풀이:** `D4h = 11010100b`. `SHR`은 왼쪽에 0을 채우고, `SAR`은 부호 비트(1)를 유지하며, `ROL`은 왼쪽에서 밀려난 비트를 오른쪽 끝에 넣는다.

## 2. ROR, ROL, RCL, RCR

**영문 문제:** In the following code sequence, show the value of AL after each shift or rotate instruction has executed.

**한국어 번역:** 다음 코드에서 각 회전 명령어를 실행한 후 `AL`의 값을 구하시오. `STC`는 Carry Flag를 1로 설정한다.

```asm
mov al,0D4h
ror al,3     ; a  10011010b
mov al,0D4h
rol al,7     ; b  01101010b
stc
mov al,0D4h
rcl al,1     ; c  10101001b  CF:1
stc
mov al,0D4h
rcr al,3     ; d  00111010b  CF:1
```

**정답:** a. `9Ah` / b. `6Ah` / c. `A9h` / d. `3Ah`

**짧은 풀이:** `ROR`·`ROL`은 8비트 안에서 회전한다. `RCL`·`RCR`은 Carry Flag까지 포함한 9비트를 회전한다. c와 d는 각각 `STC`로 초기 CF가 1이다.

## 3. MUL 결과

**영문 문제:** What will be the contents of AX and DX after the following operation?

**한국어 번역:** 다음 연산을 수행한 후 `AX`와 `DX`의 값은 무엇인가?

```asm
mov dx,0
mov ax,222h
mov cx,100h
mul cx
```

**정답:** `AX = 2200h`, `DX = 0002h`

**짧은 풀이:** `0222h × 0100h = 00022200h`. 16비트 `MUL`의 32비트 결과는 `DX:AX`에 저장된다.

## 4. 8비트 DIV 결과

**영문 문제:** What will be the contents of AX after the following operation?

**한국어 번역:** 다음 연산을 수행한 후 `AX`의 값은 무엇인가?

```asm
mov ax,63h
mov bl,10h
div bl
```

**정답:** `AX = 0306h` (`AL = 06h`, `AH = 03h`)

**짧은 풀이:** `63h ÷ 10h = 6`, 나머지 `3`. 8비트 `DIV`는 몫을 `AL`, 나머지를 `AH`에 저장한다.

## 5. 32비트 DIV 결과

**영문 문제:** What will be the contents of EAX and EDX after the following operation?

**한국어 번역:** 다음 연산을 수행한 후 `EAX`와 `EDX`의 값은 무엇인가?

```asm
mov eax,123400h
mov edx,0
mov ebx,10h
div ebx
```

**정답:** `EAX = 00012340h`, `EDX = 00000000h`

**짧은 풀이:** `00123400h ÷ 10h = 00012340h`, 나머지는 0. 32비트 `DIV`는 `EDX:EAX`를 나누어 몫을 `EAX`, 나머지를 `EDX`에 저장한다.

> 원문에서 5번 뒤에 나열된 `DIV, IDIV, IMUL, MUL, RCL, RCR, ROL, ROR, SAL, SAR, SBB, SHL, SHLD, SHR, SHRD`는 별도의 계산 문제가 아니라 명령어 이름 목록으로 보아 정답 계산 대상에서 제외했다.

## 6. DIV에서 몫 오버플로

**영문 문제:** What will be the contents of AX and DX after the following operation?

**한국어 번역:** 다음 연산을 수행한 후 `AX`와 `DX`의 값은 무엇인가?

```asm
mov ax,4000h
mov dx,500h
mov bx,10h
div bx
```

**정답:** **나눗셈 오류(#DE)가 발생한다.** 정상적인 `AX`, `DX` 결과는 없다.

**짧은 풀이:** `DX:AX = 05004000h`이고, 이를 `10h`로 나누면 몫은 `00500400h`이다. 16비트 `DIV`의 몫은 `AX`(최대 `FFFFh`)에 들어가야 하므로 범위를 초과한다.

## 7. ADC와 Carry Flag

**영문 문제:** What will be the contents of BX after the following instructions execute?

**한국어 번역:** 다음 명령어들을 실행한 후 `BX`의 값은 무엇인가?

```asm
mov bx,5
stc
mov ax,60h
adc bx,ax
```

**정답:** `BX = 0066h`

**짧은 풀이:** `STC`가 CF를 1로 설정한다. `ADC`는 두 피연산자와 CF를 더하므로 `5 + 60h + 1 = 66h`이다.

## 8. 64비트 DIV

**영문 문제:** Describe the output when the following code executes in 64-bit mode.

**한국어 번역:** 다음 코드를 64비트 모드에서 실행할 때 발생하는 결과를 설명하시오.

```asm
.data
dividend_hi QWORD 00000108h
dividend_lo QWORD 33300020h
divisor QWORD 00000100h
.code
mov rdx,dividend_hi
mov rax,dividend_lo
div divisor
```

**정답:** **나눗셈 오류(#DE)가 발생한다.** 출력 명령어도 없으므로 정상적인 출력값은 없다.

**짧은 풀이:** `DIV`는 128비트 피제수 `RDX:RAX`를 `100h`로 나눈다. `RDX = 108h`가 제수 `100h` 이상이므로 몫이 64비트 `RAX`에 들어갈 수 없다.

## 9. 64비트 정수 뺄셈 코드 수정

**영문 문제:** The following program is supposed to subtract val2 from val1. Find and correct all logic errors (CLC clears the Carry flag).

**한국어 번역:** 다음 프로그램은 `val1`에서 `val2`를 빼려고 한다. 논리 오류를 모두 찾아 수정하시오. (`CLC`는 Carry Flag를 0으로 초기화한다.)

```asm
.data
val1 QWORD 20403004362047A1h
val2 QWORD 055210304A2630B2h
result QWORD 0
.code
mov cx,8
mov esi,val1
mov edi,val2
clc
top:
mov al,BYTE PTR[esi]
sbb al,BYTE PTR[edi]
mov BYTE PTR[esi],al
dec esi
dec edi
loop top
```

**정답(64비트 MASM 기준):**

```asm
.data
val1   QWORD 20403004362047A1h
val2   QWORD 055210304A2630B2h
result QWORD 0
.code
    lea rsi, val1
    lea rbx, val2
    lea rdi, result
    mov rcx, 8
    clc
top:
    mov al, BYTE PTR [rsi]
    sbb al, BYTE PTR [rbx]
    mov BYTE PTR [rdi], al
    inc rsi
    inc rbx
    inc rdi
    loop top
```

**짧은 풀이:** `LEA`로 변수의 주소를 가져오고, 결과는 `result`에 저장해야 한다. 리틀 엔디언이므로 낮은 주소(최하위 바이트)부터 처리하며, 주소를 감소시키는 `DEC` 대신 **CF를 바꾸지 않는 `INC`**를 사용한다. `SBB`는 이전 바이트의 Borrow를 CF로 이어받는다. `RCX`는 64비트 모드의 `LOOP` 카운터다.

**최종 결과:** `result = 1AEE1FD3EBFA16EFh`

## 10. 64비트 IMUL

**영문 문제:** What will be the hexadecimal contents of RAX after the following instructions execute in 64-bit mode?

**한국어 번역:** 다음 명령어를 64비트 모드에서 실행한 후 `RAX`에 저장된 16진수 값은 무엇인가?

```asm
.data
multiplicand QWORD 0001020304050000h
.code
imul rax,multiplicand,4
```

**정답:** `RAX = 0004080C10140000h`

**짧은 풀이:** `IMUL`의 세 피연산자 형식은 메모리 값에 즉시값 `4`를 곱한 뒤 결과를 `RAX`에 저장한다. `0001020304050000h × 4 = 0004080C10140000h`이다.

