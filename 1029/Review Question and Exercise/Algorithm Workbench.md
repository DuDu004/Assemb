# Algorithm Workbench

## 1. Write a sequence of shift instructions that cause AX to be sign-extended into EAX. In other words, the sign bit of AX is copied into the upper 16 bits of EAX. Do not use the CWD instruction.[AX의 부호를 EAX로 확장]

**한글 해석:** `CWD`를 사용하지 않고, 시프트 명령어들로 AX의 부호 비트를 EAX의 상위 16비트에 복사하시오.

**정답:**
```asm
shl eax, 16
sar eax, 16
```
**풀이:** AX의 원래 16비트를 상위로 올린 뒤 산술 오른쪽 시프트로 부호를 확장합니다. 최종 하위 16비트도 원래 AX 값입니다.

## 2. Suppose the instruction set contained no rotate instructions. Show how you would use SHR and a conditional jump instruction to rotate the contents of the AL register 1 bit to the right.[SHR로 오른쪽 1비트 회전 구현]

**한글 해석:** 회전 명령어가 없다고 가정하고, `SHR`과 조건부 점프를 이용해 AL을 오른쪽으로 1비트 회전시키시오.

**정답:**
```asm
shr al, 1
jnc Done
or  al, 80h
Done:
```
**풀이:** `SHR`로 빠져나간 최하위 비트가 CF에 저장됩니다. CF=1이면 최상위 비트를 다시 1로 설정합니다.

## 3. Write a logical shift instruction that multiplies the contents of EAX by 16.[EAX에 16을 곱하기]

**한글 해석:** 논리 시프트 명령어 하나로 EAX에 16을 곱하시오.

**정답:**
```asm
shl eax, 4
```
**풀이:** 왼쪽으로 4비트 이동하면 2⁴=16배가 됩니다(32비트 범위를 넘는 비트는 버려짐).

## 4. Write a logical shift instruction that divides EBX by 4.[EBX를 4로 나누기]

**한글 해석:** 논리 시프트 명령어 하나로 EBX를 4로 나누시오.

**정답:**
```asm
shr ebx, 2
```
**풀이:** 부호 없는 값을 오른쪽으로 2비트 이동하면 4로 나눈 몫이 됩니다.

## 5. Write a single rotate instruction that exchanges the high and low halves of the DL register[DL의 상·하위 절반 교환]

**한글 해석:** 회전 명령어 하나로 DL의 상위 4비트와 하위 4비트를 교환하시오.

**정답:**
```asm
rol dl, 4
```
**풀이:** 8비트 레지스터를 4비트 회전하면 두 니블이 서로 바뀝니다.

## 6. Write a single SHLD instruction that shifts the highest bit of the AX register into the lowest bit position of DX and shifts DX one bit to the left.[SHLD로 AX의 최상위 비트를 DX로 이동]

**한글 해석:** `SHLD` 명령어 하나로 AX의 최상위 비트를 DX의 최하위 비트로 넣고, DX를 왼쪽으로 1비트 이동시키시오.

**정답:**
```asm
shld dx, ax, 1
```
**풀이:** DX는 왼쪽으로 1비트 이동하고 빈 최하위 비트에는 AX의 비트 15가 들어갑니다. AX는 변하지 않습니다.

## 7. Write a sequence of instructions that shift three memory bytes to the right by 1 bit position. Use the following test data[메모리 바이트 3개를 오른쪽으로 1비트 이동]

**한글 해석:** `byteArray BYTE 81h,20h,33h`의 세 바이트를 하나의 24비트 값으로 간주하여 오른쪽으로 1비트 이동시키시오.

**정답:**
```asm
.data
byteArray BYTE 81h, 20h, 33h
.code
shr byteArray[2], 1
rcr byteArray[1], 1
rcr byteArray[0], 1
```
**풀이:** 최상위 바이트부터 `SHR` → `RCR` → `RCR` 순서로 처리해 바이트 사이의 비트를 CF로 전달합니다. 결과는 `C0h,90h,19h`입니다(리틀 엔디언 기준).

## 8. Write a sequence of instructions that shift three memory words to the left by 1 bit position. Use the following test data[메모리 워드 3개를 왼쪽으로 1비트 이동]

**한글 해석:** `wordArray WORD 810Dh, 0C064h, 93ABh`의 세 워드를 하나의 48비트 값으로 간주하여 왼쪽으로 1비트 이동시키시오.

**정답:**
```asm
.data
wordArray WORD 810Dh, 0C064h, 93ABh
.code
shl wordArray[0], 1
rcl wordArray[2], 1
rcl wordArray[4], 1
```
**풀이:** 최하위 워드부터 처리하며 CF를 다음 워드로 전달합니다. 결과는 `021Ah,80C9h,2757h`입니다. 워드 배열의 인덱스 오프셋은 0, 2, 4바이트입니다.

## 9. Write instructions that multiply 5 by 3 and store the result in a 16-bit variable val1.[-5 × 3을 16비트 변수에 저장]

**한글 해석:** -5와 3을 곱한 결과를 16비트 변수 `val1`에 저장하시오.

**정답:**
```asm
.data
val1 SWORD ?
.code
mov ax, -5
mov bx, 3
imul bx
mov val1, ax
```
**풀이:** 부호 있는 곱셈 결과는 -15이며, AX에는 `FFF1h`가 저장됩니다.

## 10. Write instructions that divide 276 by 10 and store the result in a 16-bit variable val1.[-276 ÷ 10을 16비트 변수에 저장]

**한글 해석:** -276을 10으로 나눈 몫을 16비트 변수 `val1`에 저장하시오.

**정답:**
```asm
.data
val1 SWORD ?
.code
mov ax, -276
cwd
mov bx, 10
idiv bx
mov val1, ax
```
**풀이:** `CWD`로 AX의 부호를 DX까지 확장하고 `IDIV`로 부호 있는 나눗셈을 합니다. 몫은 -27(`FFE5h`), 나머지는 -6입니다.

## 11. Implement the following C++ expression in assembly language, using 32-bit unsigned operands[32비트 부호 없는 수식 구현]

**한글 해석:** 32비트 부호 없는 피연산자로 `val1 = (val2 * val3) / (val4 - 3)`을 구현하시오.

**정답:**
```asm
.data
val1 DWORD ?
val2 DWORD ?
val3 DWORD ?
val4 DWORD ?
.code
mov eax, val2
mul val3              ; EDX:EAX = val2 * val3
mov ebx, val4
sub ebx, 3
div ebx              ; EAX = 몫
mov val1, eax
```
**풀이:** `MUL`의 64비트 곱을 `EDX:EAX`에 유지한 채 `DIV`로 나눕니다. `val4 - 3`이 0이 아니어야 하고, 몫이 32비트에 들어가야 합니다.

## 12. Implement the following C++ expression in assembly language, using 32-bit signed operands[32비트 부호 있는 수식 구현]

**한글 해석:** 32비트 부호 있는 피연산자로 `val1 = (val2 / val3) * (val1 + val2)`를 구현하시오.

**정답:**
```asm
.data
val1 SDWORD ?
val2 SDWORD ?
val3 SDWORD ?
.code
mov eax, val2
cdq
idiv val3             ; EAX = val2 / val3
mov ebx, val1
add ebx, val2
imul eax, ebx
mov val1, eax
```
**풀이:** `CDQ`와 `IDIV`로 부호 있는 정수 나눗셈을 수행한 뒤 합과 곱합니다. `val3`은 0이 아니어야 하며, 결과가 32비트 범위를 넘으면 잘릴 수 있습니다.

## 13. Write a procedure that displays an unsigned 8-bit binary value in decimal format. Pass the binary value in AL. The input range is limited to 0 to 99, decimal. The only procedure you can call from the book’s link library is WriteChar. The procedure should contain approximately eight instructions. Here is a sample call[8비트 값을 십진수로 출력하는 프로시저]

**한글 해석:** AL에 전달된 0~99 범위의 부호 없는 8비트 정수를 십진수로 출력하는 프로시저를 작성하시오. Irvine 라이브러리에서는 `WriteChar`만 호출할 수 있으며, 약 8개 명령어를 사용하시오.

**정답:**
```asm
showDecimal8 PROC
    aam                   ; AH = 십의 자리, AL = 일의 자리
    xchg al, ah           ; AL = 십의 자리
    add ax, 3030h         ; 두 자리 모두 ASCII 변환
    push ax
    call WriteChar        ; 십의 자리 출력
    pop ax
    mov al, ah
    call WriteChar        ; 일의 자리 출력
    ret
showDecimal8 ENDP
```
**풀이:** `AAM`으로 10진수 두 자리를 분리합니다. 예를 들어 65는 `65`로 출력됩니다. 항상 두 자리로 출력하므로 5는 `05`가 됩니다. `AAM`은 32비트 모드에서 사용 가능하며 64비트 모드에서는 사용할 수 없습니다.

## 14. Challenge: Suppose AX contains 0072h and the Auxiliary Carry flag is set as a result of adding two unknown ASCII decimal digits. Use the Intel 64 and IA-32 Instruction Set Reference to determine what output the AAA instruction would produce. Explain your answer[AAA의 실행 결과]

**한글 해석:** AX=`0072h`이고 이전 ASCII 십진수 덧셈으로 보조 캐리 플래그(AF)가 1인 상태라고 가정하시오. `AAA` 명령어 실행 후의 결과를 구하고 설명하시오.

**정답:**
```asm
; 실행 전: AX = 0072h, AF = 1
 aaa
; 실행 후: AX = 0108h, AF = 1, CF = 1
```
**풀이:** AF=1이므로 AL에 6을 더하고 AH에 1을 더합니다. `72h + 06h = 78h`, 이후 `AL AND 0Fh`를 적용하여 AL=`08h`, AH=`01h`가 됩니다. 따라서 AX=`0108h`입니다. `AAA`는 64비트 모드에서 지원되지 않습니다.

## 15.  Challenge: Using only SUB, MOV, and AND instructions, show how to calculate x = n mod y, assuming that you are given the values of n and y. You can assume that n is any 32-bit unsigned integer, and y is a power of 2[SUB, MOV, AND만으로 나머지 계산]

**한글 해석:** `SUB`, `MOV`, `AND` 명령어만 사용하여 `x = n mod y`를 계산하시오. `n`은 32비트 부호 없는 정수이고 `y`는 2의 거듭제곱입니다.

**정답:**
```asm
; n, y, x는 DWORD 변수라고 가정
mov eax, y
sub eax, 1
and eax, n
mov x, eax
```
**풀이:** `y`가 2의 거듭제곱이면 `n mod y = n AND (y - 1)`입니다. 단, `y`는 0이 아닌 2의 거듭제곱이어야 합니다.

## 16. Challenge: Using only SAR, ADD, and XOR instructions (but no conditional jumps), write code that calculates the absolute value of the signed integer in the EAX register. Hints: A number can be negated by adding 1 to it and then forming its one’s complement. Also, if you XOR an integer with all 1s, its 1s are reversed. On the other hand, if you XOR an integer with all zeros, the integer is unchanged.[SAR, ADD, XOR만으로 절댓값 계산]

**한글 해석:** 조건부 점프 없이 `SAR`, `ADD`, `XOR`만 사용하여 EAX에 저장된 부호 있는 정수의 절댓값을 계산하시오.

**정답:**
```asm
xor edx, edx
add edx, eax
sar edx, 31        ; 음수면 FFFFFFFFh, 아니면 0
xor eax, edx
xor edx, -1
add edx, 1
add eax, edx
```
**풀이:** 음수일 때는 EAX의 비트를 반전한 뒤 1을 더하고, 음수가 아니면 값을 그대로 유지합니다. 단, 최솟값 `80000000h`(-2³¹)의 양수 절댓값은 32비트 부호 있는 정수로 표현할 수 없습니다.

