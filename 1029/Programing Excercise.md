# Programing Excercise

## 1. Display ASCII Decimal
`WriteScaled` 프로시저를 작성하여 ASCII 숫자 문자열의 오른쪽에서 `EBX`자리 앞에 소수점을 출력한다.

- `EDX`: 숫자 문자열의 시작 주소
- `ECX`: 문자열 길이
- `EBX`: 오른쪽에서 소수점까지의 자리 수
- 서로 길이가 다른 숫자 3개를 테스트한다.

### 어셈블리 코드 (32비트 MASM + Irvine32)

```asm
TITLE Display ASCII Decimal
INCLUDE Irvine32.inc

DECIMAL_OFFSET = 5

.data
decimal_one   BYTE "100123456789765"  ; 15자리
decimal_two   BYTE "12345678"         ; 8자리
decimal_three BYTE "98765"            ; 5자리

.code
main PROC
    mov edx, OFFSET decimal_one
    mov ecx, LENGTHOF decimal_one
    mov ebx, DECIMAL_OFFSET
    call WriteScaled
    call Crlf

    mov edx, OFFSET decimal_two
    mov ecx, LENGTHOF decimal_two
    mov ebx, 2
    call WriteScaled
    call Crlf

    mov edx, OFFSET decimal_three
    mov ecx, LENGTHOF decimal_three
    mov ebx, 3
    call WriteScaled
    call Crlf

    exit
main ENDP

; EDX = 숫자 주소, ECX = 길이, EBX = 소수점 위치
WriteScaled PROC USES esi edi
    mov esi, edx
    mov edi, ecx
    test edi, edi
    jz Done

L1:
    cmp edi, ebx
    jne PrintDigit
    mov al, '.'
    call WriteChar

PrintDigit:
    mov al, [esi]
    call WriteChar
    inc esi
    dec edi
    jnz L1

Done:
    ret
WriteScaled ENDP

END main
```

### 예상 실행 결과

```text
1001234567.89765
123456.78
98.765
```


## 2. Extended Subtraction Procedure

### 영문 문제

Create a procedure named Extended_Sub that subtracts two binary integers of arbitrary size. The storage size of the two integers must be the same, and their size must be a multiple of 32 bits. Write a test program that passes several pairs of integers, each at least 10 bytes long.

### 한글 번역

임의의 크기를 가진 두 이진 정수를 뺄셈하는 `Extended_Sub` 프로시저를 작성하시오. 두 정수의 저장 크기는 반드시 같아야 하며, 그 크기는 32비트의 배수여야 합니다. 각각의 정수가 최소 10바이트 이상인 여러 정수 쌍을 전달하는 테스트 프로그램을 작성하시오.

### 어셈블리 코드 (32비트 MASM + Irvine32)

```asm
TITLE Extended Subtraction Procedure
INCLUDE Irvine32.inc

.data
; DWORD는 낮은 자리부터 저장 (리틀 엔디언)
; Test 1: 12바이트 (3 DWORD)
num1A DWORD 00000000h, 00000000h, 00000001h
num1B DWORD 00000001h, 00000000h, 00000000h
result1 DWORD 3 DUP(?)

; Test 2: 16바이트 (4 DWORD)
num2A DWORD 12345678h, 23456789h, 3456789Ah, 456789ABh
num2B DWORD 01111111h, 02222222h, 03333333h, 04444444h
result2 DWORD 4 DUP(?)

; Test 3: 20바이트 (5 DWORD)
num3A DWORD 00000000h, 00000000h, 00000000h, 00000000h, 00000003h
num3B DWORD 00000001h, 00000000h, 00000000h, 00000000h, 00000001h
result3 DWORD 5 DUP(?)

msg1 BYTE "12 bytes: ", 0
msg2 BYTE "16 bytes: ", 0
msg3 BYTE "20 bytes: ", 0

.code
main PROC
    ; Test 1
    mov esi, OFFSET num1A
    mov edi, OFFSET num1B
    mov edx, OFFSET result1
    mov ecx, LENGTHOF num1A
    call Extended_Sub

    mov edx, OFFSET msg1
    call WriteString
    mov esi, OFFSET result1
    mov ecx, LENGTHOF result1
    call PrintBig
    call Crlf

    ; Test 2
    mov esi, OFFSET num2A
    mov edi, OFFSET num2B
    mov edx, OFFSET result2
    mov ecx, LENGTHOF num2A
    call Extended_Sub

    mov edx, OFFSET msg2
    call WriteString
    mov esi, OFFSET result2
    mov ecx, LENGTHOF result2
    call PrintBig
    call Crlf

    ; Test 3
    mov esi, OFFSET num3A
    mov edi, OFFSET num3B
    mov edx, OFFSET result3
    mov ecx, LENGTHOF num3A
    call Extended_Sub

    mov edx, OFFSET msg3
    call WriteString
    mov esi, OFFSET result3
    mov ecx, LENGTHOF result3
    call PrintBig
    call Crlf

    exit
main ENDP

; ESI = 첫 번째 정수 주소
; EDI = 두 번째 정수 주소
; EDX = 결과 저장 주소
; ECX = DWORD 개수
Extended_Sub PROC USES eax ecx edx esi edi
    test ecx, ecx
    jz Done
    clc                         ; 첫 뺄셈의 빌림은 0

L1:
    mov eax, [esi]
    sbb eax, [edi]              ; 이전 DWORD의 빌림 포함
    mov [edx], eax
    lea esi, [esi + 4]          ; LEA는 CF를 바꾸지 않음
    lea edi, [edi + 4]
    lea edx, [edx + 4]
    dec ecx                     ; DEC는 CF를 바꾸지 않음
    jnz L1

Done:
    ret
Extended_Sub ENDP

; ESI = 결과 배열 주소, ECX = DWORD 개수
; 높은 자리부터 8자리씩 16진수로 출력
PrintBig PROC USES ecx esi
    test ecx, ecx
    jz PrintDone
    lea esi, [esi + ecx*4 - 4]

L2:
    mov eax, [esi]
    push ecx
    push esi
    call WriteHex
    pop esi
    pop ecx
    sub esi, 4
    loop L2

PrintDone:
    ret
PrintBig ENDP

END main
```

### 실행 결과 (예상)

```text
12 bytes: 00000000FFFFFFFFFFFFFFFF
16 bytes: 41234567312345672123456711234567
20 bytes: 00000001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
```


## 3. Packed Decimal Conversion

### 영문 문제

Write a procedure named PackedToAsc that converts a 4-byte packed decimal integer to a string of ASCII decimal digits. Pass the packed integer and the address of a buffer holding the ASCII digits to the procedure. Write a short test program that passes at least 5 packed decimal integers to your procedure.

### 한글 번역

4바이트 packed decimal(압축 10진수) 정수를 ASCII 10진수 숫자 문자열로 변환하는 `PackedToAsc` 프로시저를 작성하시오.

프로시저를 호출할 때 packed 정수와 변환된 ASCII 숫자를 저장할 버퍼의 주소를 전달하시오.

서로 다른 packed decimal 정수를 최소 5개 전달하는 간단한 테스트 프로그램을 작성하시오.

### 어셈블리 코드

```asm
TITLE Packed Decimal Conversion
INCLUDE Irvine32.inc

.data
packedNums DWORD 12345678h, 00001234h, 98765432h, 13579246h, 00000000h
buffer BYTE 9 DUP(0)         ; 숫자 8자리 + NULL

.code
main PROC
    mov esi, OFFSET packedNums
    mov ecx, LENGTHOF packedNums

L1:
    push ecx
    push esi

    mov eax, [esi]           ; packed 정수
    mov edx, OFFSET buffer   ; 변환 결과 버퍼
    call PackedToAsc

    mov edx, OFFSET buffer
    call WriteString
    call Crlf

    pop esi
    pop ecx
    add esi, TYPE packedNums
    loop L1

    exit
main ENDP

; 입력: EAX = 4바이트 packed decimal, EDX = 버퍼 주소
; 출력: 버퍼에 ASCII 숫자 8자리 + NULL 저장
PackedToAsc PROC USES eax ebx ecx edi
    mov edi, edx
    mov BYTE PTR [edi+8], 0
    add edi, 7              ; 버퍼의 마지막 숫자 위치
    mov ecx, 8              ; 4바이트 = 숫자 8자리

L2:
    mov bl, al
    and bl, 0Fh             ; 오른쪽 4비트만 추출
    add bl, '0'             ; ASCII 숫자로 변환
    mov [edi], bl
    shr eax, 4              ; 다음 자리로 이동
    dec edi
    loop L2

    ret
PackedToAsc ENDP

END main
```

### 실행 결과 (예상)

```text
12345678
00001234
98765432
13579246
00000000
```



## 4. Encryption Using Rotate Operations

### 영문 문제

Write a procedure that performs simple encryption by rotating each plaintext byte a varying number of positions in different directions. For example, in the following array that represents the encryption key, a negative value indicates a rotation to the left and a positive value indicates a rotation to the right. The integer in each position indicates the magnitude of the rotation:

```asm
key BYTE -2, 4, 1, 0, -3, 5, 2, -4, -4, 6
```

Your procedure should loop through a plaintext message and align the key to the first 10 bytes of the message. Rotate each plaintext byte by the amount indicated by its matching key array value. Then, align the key to the next 10 bytes of the message and repeat the process. Write a program that tests your encryption procedure by calling it twice, with different data sets.

### 한글 번역

평문(plaintext)의 각 바이트를 서로 다른 방향과 비트 수만큼 회전시켜 간단한 암호화를 수행하는 프로시저를 작성하시오.

암호화 키 배열에서 **음수는 왼쪽 회전(`ROL`)**, **양수는 오른쪽 회전(`ROR`)**, **0은 회전하지 않음**을 뜻하며, 숫자의 절댓값은 회전할 비트 수를 나타냅니다.

```asm
key BYTE -2, 4, 1, 0, -3, 5, 2, -4, -4, 6
```

프로시저는 메시지의 첫 10바이트에 키의 10개 값을 순서대로 적용하고, 다음 10바이트부터 같은 키를 반복해서 적용해야 합니다. **서로 다른 두 문자열**로 암호화 프로시저를 호출하여 테스트하시오.

### 어셈블리 코드 (MASM + Irvine32)

```asm
TITLE Encryption Using Rotate Operations
INCLUDE Irvine32.inc

.data
key BYTE -2, 4, 1, 0, -3, 5, 2, -4, -4, 6

msg1 BYTE "HELLO WORLD!", 0
msg2 BYTE "ASSEMBLY LANGUAGE", 0

label1 BYTE "Test 1: ", 0
label2 BYTE "Test 2: ", 0

.code
main PROC
    ; Test 1
    mov esi, OFFSET msg1
    mov ecx, LENGTHOF msg1 - 1
    call EncryptRotate

    mov edx, OFFSET label1
    call WriteString
    mov esi, OFFSET msg1
    mov ecx, LENGTHOF msg1 - 1
    call ShowHex
    call Crlf

    ; Test 2
    mov esi, OFFSET msg2
    mov ecx, LENGTHOF msg2 - 1
    call EncryptRotate

    mov edx, OFFSET label2
    call WriteString
    mov esi, OFFSET msg2
    mov ecx, LENGTHOF msg2 - 1
    call ShowHex
    call Crlf

    exit
main ENDP

; ESI = 문자열 주소, ECX = 문자열 길이
EncryptRotate PROC USES ebx ecx edx esi
    mov edx, ecx            ; 남은 바이트 수
    test edx, edx
    jz EncryptDone
    xor ebx, ebx            ; 키 인덱스 (0~9)

NextByte:
    mov cl, key[ebx]
    test cl, cl
    jns RotateRight         ; 0 또는 양수

    neg cl
    rol BYTE PTR [esi], cl  ; 음수: 왼쪽 회전
    jmp NextIndex

RotateRight:
    ror BYTE PTR [esi], cl  ; 양수: 오른쪽 회전

NextIndex:
    inc esi
    inc ebx
    cmp ebx, LENGTHOF key
    jb KeepIndex
    xor ebx, ebx            ; 키를 처음부터 반복

KeepIndex:
    dec edx
    jnz NextByte

EncryptDone:
    ret
EncryptRotate ENDP

; ESI = 배열 주소, ECX = 바이트 개수
; 암호화 결과를 16진수로 출력
ShowHex PROC USES eax ebx ecx esi
    test ecx, ecx
    jz ShowDone

PrintLoop:
    movzx eax, BYTE PTR [esi]
    mov ebx, 1              ; 1바이트를 2자리 16진수로 출력
    push ecx
    push esi
    call WriteHexB
    mov al, ' '
    call WriteChar
    pop esi
    pop ecx

    inc esi
    loop PrintLoop

ShowDone:
    ret
ShowHex ENDP

END main
```

### 실행 결과 (예상)

암호화 결과에는 화면에 직접 표시하기 어려운 바이트가 있을 수 있으므로, 각 바이트를 **2자리 16진수**로 출력합니다.

```text
Test 1: 21 54 26 4C 7A 01 D5 F4 25 31 11 12
Test 2: 05 35 A9 45 6A 12 13 95 02 31 05 E4 A3 55 0A 3A 51
```


## 5. Prime Numbers

### 영문 문제

Write a program that generates all prime numbers between 2 and 1000, using the Sieve of Eratosthenes method. You can find many articles that describe the method for finding primes in this manner on the Internet. Display all the prime values.

### 한글 번역

**에라토스테네스의 체(Sieve of Eratosthenes)** 알고리즘을 사용하여 **2부터 1000까지의 모든 소수**를 생성하는 프로그램을 작성하시오. 인터넷에서 이 방법을 설명하는 다양한 자료를 참고할 수 있습니다. 찾아낸 **모든 소수를 화면에 출력**하시오.

### 어셈블리 코드

```asm
TITLE Prime Numbers
INCLUDE Irvine32.inc

.data
composite BYTE 1001 DUP(0)     ; 0: 소수 후보, 1: 합성수

.code
main PROC
    mov ebx, 2

SieveLoop:
    cmp ebx, 31              ; sqrt(1000) = 31.x
    ja PrintPrimes
    cmp composite[ebx], 1
    je NextBase

    mov ecx, ebx
    imul ecx, ebx            ; ECX = EBX * EBX

MarkLoop:
    cmp ecx, 1000
    ja NextBase
    mov composite[ecx], 1
    add ecx, ebx
    jmp MarkLoop

NextBase:
    inc ebx
    jmp SieveLoop

PrintPrimes:
    mov esi, 2
    xor edi, edi             ; 한 줄에 출력한 소수 개수

PrintLoop:
    cmp esi, 1000
    ja Done
    cmp composite[esi], 1
    je NextNumber

    push esi
    push edi
    mov eax, esi
    call WriteDec
    mov al, ' '
    call WriteChar
    pop edi
    pop esi

    inc edi
    cmp edi, 10
    jne NextNumber
    push esi
    call Crlf
    pop esi
    xor edi, edi

NextNumber:
    inc esi
    jmp PrintLoop

Done:
    call Crlf
    exit
main ENDP

END main
```

### 실행 결과 (예상)

소수 168개를 **한 줄에 10개씩** 출력합니다.

```text
2 3 5 7 11 13 17 19 23 29
31 37 41 43 47 53 59 61 67 71
73 79 83 89 97 101 103 107 109 113
127 131 137 139 149 151 157 163 167 173
179 181 191 193 197 199 211 223 227 229
233 239 241 251 257 263 269 271 277 281
283 293 307 311 313 317 331 337 347 349
353 359 367 373 379 383 389 397 401 409
419 421 431 433 439 443 449 457 461 463
467 479 487 491 499 503 509 521 523 541
547 557 563 569 571 577 587 593 599 601
607 613 617 619 631 641 643 647 653 659
661 673 677 683 691 701 709 719 727 733
739 743 751 757 761 769 773 787 797 809
811 821 823 827 829 839 853 857 859 863
877 881 883 887 907 911 919 929 937 941
947 953 967 971 977 983 991 997
```


## 6. Greatest Common Divisor (GCD)

### 영문 문제 (핵심 내용)

Implement the Euclidean GCD algorithm in assembly language. The greatest common divisor is the largest positive integer that divides both integers without a remainder. First use the absolute values of the two inputs, and then repeatedly compute the remainder and update the pair until the remainder is zero. Write a test program that calls the function with several different values and displays every result.

### 한글 번역

두 정수를 모두 나누어떨어지게 하는 가장 큰 양의 정수를 **최대공약수(GCD)**라고 한다. 주어진 두 정수의 절댓값을 구한 뒤, 나눗셈의 나머지를 반복해서 계산하는 **유클리드 호제법**을 어셈블리 언어로 구현하시오.

서로 다른 여러 정수 쌍으로 프로시저를 호출하고, 각 결과를 화면에 출력하는 테스트 프로그램을 작성하시오.

### 어셈블리 코드

```asm
TITLE Greatest Common Divisor (GCD)
INCLUDE Irvine32.inc

.data
msg1 BYTE "GCD(48, 18) = ", 0
msg2 BYTE "GCD(-42, 56) = ", 0
msg3 BYTE "GCD(270, 192) = ", 0
msg4 BYTE "GCD(0, 25) = ", 0
msg5 BYTE "GCD(81, 0) = ", 0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString
    mov eax, 48
    mov ebx, 18
    call GCD
    call WriteDec
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    mov eax, -42
    mov ebx, 56
    call GCD
    call WriteDec
    call Crlf

    mov edx, OFFSET msg3
    call WriteString
    mov eax, 270
    mov ebx, 192
    call GCD
    call WriteDec
    call Crlf

    mov edx, OFFSET msg4
    call WriteString
    mov eax, 0
    mov ebx, 25
    call GCD
    call WriteDec
    call Crlf

    mov edx, OFFSET msg5
    call WriteString
    mov eax, 81
    mov ebx, 0
    call GCD
    call WriteDec
    call Crlf

    exit
main ENDP

; EAX = 첫 번째 정수(x)
; EBX = 두 번째 정수(y)
; 반환값: EAX = 최대공약수
GCD PROC USES ebx edx
    test eax, eax
    jns XReady
    neg eax                 ; x의 절댓값
XReady:
    test ebx, ebx
    jns YReady
    neg ebx                 ; y의 절댓값
YReady:
    test ebx, ebx
    jz Done                 ; y = 0이면 x 반환

L1:
    xor edx, edx            ; EDX:EAX의 상위 32비트 초기화
    div ebx                 ; EDX = x mod y
    mov eax, ebx            ; x = y
    mov ebx, edx            ; y = 나머지
    test ebx, ebx
    jnz L1

Done:
    ret
GCD ENDP

END main
```

### 실행 결과 (예상)

```text
GCD(48, 18) = 6
GCD(-42, 56) = 14
GCD(270, 192) = 6
GCD(0, 25) = 25
GCD(81, 0) = 81
```


## 7. Bitwise Multiplication

### 영문 문제

Write a procedure named BitwiseMultiply that multiplies any unsigned 32-bit integer by EAX, using only shifting and addition. Pass the integer to the procedure in the EBX register, and return the product in the EAX register. Write a short test program that calls the procedure and displays the product. (We will assume that the product is never larger than 32 bits.)

This is a fairly challenging program to write. One possible approach is to use a loop to shift the multiplier to the right, keeping track of the number of shifts that occur before the Carry flag is set. The resulting shift count can then be applied to the SHL instruction, using the multiplicand as the destination operand. Then, the same process must be repeated until you find the last 1 bit in the multiplier.

### 한글 번역

시프트 연산과 덧셈만 사용하여 `EAX`에 들어 있는 값과 임의의 **부호 없는 32비트 정수**를 곱하는 `BitwiseMultiply` 프로시저를 작성하시오. 두 번째 정수는 `EBX` 레지스터로 전달하고, 곱셈 결과는 `EAX`에 반환해야 합니다.

프로시저를 호출하고 결과를 화면에 출력하는 간단한 테스트 프로그램을 작성하시오. 곱셈 결과는 32비트를 넘지 않는다고 가정합니다.

이 문제는 비교적 어렵습니다. 한 가지 방법은 곱하는 수를 오른쪽으로 시프트하며 `1`인 비트를 찾고, 그 위치만큼 곱해지는 수를 왼쪽으로 시프트한 값을 합계에 더하는 것입니다. 마지막 `1` 비트까지 반복합니다.

### 어셈블리 코드

```asm
TITLE Bitwise Multiplication
INCLUDE Irvine32.inc

.data
msg1 BYTE "12 * 13 = ", 0
msg2 BYTE "12345 * 6789 = ", 0
msg3 BYTE "4294967295 * 1 = ", 0
msg4 BYTE "75 * 0 = ", 0

.code
main PROC
    ; Test 1
    mov edx, OFFSET msg1
    call WriteString
    mov eax, 12
    mov ebx, 13
    call BitwiseMultiply
    call WriteDec
    call Crlf

    ; Test 2
    mov edx, OFFSET msg2
    call WriteString
    mov eax, 12345
    mov ebx, 6789
    call BitwiseMultiply
    call WriteDec
    call Crlf

    ; Test 3: 32비트 unsigned 최댓값
    mov edx, OFFSET msg3
    call WriteString
    mov eax, 0FFFFFFFFh
    mov ebx, 1
    call BitwiseMultiply
    call WriteDec
    call Crlf

    ; Test 4: 0을 곱하는 경우
    mov edx, OFFSET msg4
    call WriteString
    mov eax, 75
    mov ebx, 0
    call BitwiseMultiply
    call WriteDec
    call Crlf

    exit
main ENDP

; 입력: EAX = 첫 번째 수, EBX = 두 번째 수
; 반환: EAX = 곱셈 결과 (32비트)

BitwiseMultiply PROC USES ebx ecx
    mov ecx, eax           ; ECX = 현재 더할 값
    xor eax, eax           ; 결과 = 0

L1:
    test ebx, ebx
    jz Done                ; 곱하는 수가 0이면 종료

    test ebx, 1
    jz SkipAdd
    add eax, ecx           ; 하위 비트가 1이면 더함

SkipAdd:
    shl ecx, 1             ; 더할 값을 2배로
    shr ebx, 1             ; 다음 비트 확인
    jmp L1

Done:
    ret
BitwiseMultiply ENDP

END main
```

### 실행 결과 (예상)

```text
12 * 13 = 156
12345 * 6789 = 83810205
4294967295 * 1 = 4294967295
75 * 0 = 0
```


## 8. Add Packed Integers

### 영문 문제

Extend the AddPacked procedure from Section 7.6.1 so that it adds two packed decimal integers of arbitrary size (both lengths must be the same). Write a test program that passes AddPacked several pairs of integers: 4-byte, 8-byte, and 16-byte. We suggest that you use the following registers to pass information to the procedure:

- ESI - pointer to the first number
- EDI - pointer to the second number
- EDX - pointer to the sum
- ECX - number of bytes to add

### 한글 번역

7.6.1절의 `AddPacked` 프로시저를 확장하여 **임의의 크기를 가진 두 압축 10진수(Packed Decimal) 정수**를 더하도록 작성하시오. 두 정수의 길이는 같아야 합니다.

**4바이트, 8바이트, 16바이트** 크기의 정수 쌍을 각각 `AddPacked`에 전달하는 테스트 프로그램을 작성하시오.

다음 레지스터로 인수를 전달하는 것을 권장합니다.

- `ESI`: 첫 번째 정수의 주소
- `EDI`: 두 번째 정수의 주소
- `EDX`: 합계를 저장할 주소
- `ECX`: 더할 바이트 수

### 어셈블리 코드

```asm
TITLE Add Packed Integers
INCLUDE Irvine32.inc

.data
; Test 1: 4바이트 (최종 자리올림 발생)
num4A DWORD 99999999h
num4B DWORD 00000001h
sum4 BYTE 5 DUP(?)

; Test 2: 8바이트
num8A DWORD 99999999h, 12345678h
num8B DWORD 00000001h, 11111111h
sum8 BYTE 9 DUP(?)

; Test 3: 16바이트
num16A DWORD 99999999h, 99999999h, 12345678h, 11111111h
num16B DWORD 00000001h, 00000000h, 87654321h, 22222222h
sum16 BYTE 17 DUP(?)

msg4  BYTE "4 bytes: ", 0
msg8  BYTE "8 bytes: ", 0
msg16 BYTE "16 bytes: ", 0

.code
main PROC
    ; Test 1
    mov esi, OFFSET num4A
    mov edi, OFFSET num4B
    mov edx, OFFSET sum4
    mov ecx, SIZEOF num4A
    call AddPacked

    mov edx, OFFSET msg4
    call WriteString
    mov esi, OFFSET sum4
    mov ecx, SIZEOF num4A
    call PrintPacked
    call Crlf

    ; Test 2
    mov esi, OFFSET num8A
    mov edi, OFFSET num8B
    mov edx, OFFSET sum8
    mov ecx, SIZEOF num8A
    call AddPacked

    mov edx, OFFSET msg8
    call WriteString
    mov esi, OFFSET sum8
    mov ecx, SIZEOF num8A
    call PrintPacked
    call Crlf

    ; Test 3
    mov esi, OFFSET num16A
    mov edi, OFFSET num16B
    mov edx, OFFSET sum16
    mov ecx, SIZEOF num16A
    call AddPacked

    mov edx, OFFSET msg16
    call WriteString
    mov esi, OFFSET sum16
    mov ecx, SIZEOF num16A
    call PrintPacked
    call Crlf

    exit
main ENDP

; ESI = 첫 번째 Packed Decimal 주소
; EDI = 두 번째 Packed Decimal 주소
; EDX = 결과 주소 (ECX + 1바이트 확보)
; ECX = 입력 정수의 바이트 수
AddPacked PROC USES eax ecx esi edi edx
    clc
L1:
    mov al, [esi]
    adc al, [edi]       ; 이전 바이트의 자리올림 포함
    daa                 ; Packed Decimal로 보정
    mov [edx], al

    inc esi
    inc edi
    inc edx
    loop L1

    mov al, 0
    adc al, 0           ; 마지막 자리올림 (0 또는 1)
    mov [edx], al
    ret
AddPacked ENDP

; ESI = 결과 버퍼 주소
; ECX = 입력 바이트 수 (여기서는 4, 8, 16)
PrintPacked PROC USES eax ecx esi
    mov al, [esi + ecx] ; 추가 자리올림 바이트
    test al, al
    jz NoCarry
    add al, '0'
    push ecx
    push esi
    call WriteChar
    pop esi
    pop ecx

NoCarry:
    lea esi, [esi + ecx - 4]
    shr ecx, 2          ; DWORD 개수

PrintLoop:
    push ecx
    push esi
    mov eax, [esi]
    call WriteHex       ; Packed Decimal의 각 자리는 0~9
    pop esi
    pop ecx
    sub esi, 4
    loop PrintLoop
    ret
PrintPacked ENDP

END main
```

### 실행 결과 (예상)

```text
4 bytes: 100000000
8 bytes: 2345679000000000
16 bytes: 33333334000000000000000000000000
```