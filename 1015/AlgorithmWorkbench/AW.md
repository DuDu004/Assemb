# 어셈블리 언어 연습문제 1~10 풀이

## 1. ASCII 숫자를 이진 숫자 값으로 변환

**문제 해석:** AL에 들어 있는 ASCII 숫자 문자(`'0'`~`'9'`)를 대응하는 숫자 값(`00h`~`09h`)으로 바꾸는 **단일 명령어**를 작성하시오. AL이 이미 `00h`~`09h`이면 변경하지 않아야 한다.

**짧은 풀이:** ASCII 숫자는 상위 니블이 `3`이고 하위 니블이 숫자 값이다. 이미 변환된 숫자 역시 하위 니블이 숫자 값이므로 상위 4비트를 지우면 된다.

**답:**

```asm
and al, 0Fh
```

## 2. 32비트 메모리 피연산자의 패리티 계산

**문제 해석:** 32비트 메모리 피연산자의 패리티를 계산하는 명령어를 작성하시오. `B0 XOR B1 XOR B2 XOR B3` 공식을 사용하시오.

**짧은 풀이:** 32비트를 구성하는 네 바이트를 XOR하여 하나의 바이트로 합친다. 그 결과의 비트 패리티는 `TEST`가 설정하는 패리티 플래그(PF)로 확인할 수 있다. **PF=1은 짝수 패리티**를 의미한다.

**답:** (`value32 DWORD ?`가 선언되어 있다고 가정)

```asm
mov al, BYTE PTR mem
xor al, BYTE PTR mem+1
xor al, BYTE PTR mem+2
xor al, BYTE PTR mem+3
```

## 3. SetX에는 있고 SetY에는 없는 원소 구하기

**문제 해석:** 비트맵 집합 `SetX`와 `SetY`가 주어졌을 때, `SetX`에 속하지만 `SetY`에는 속하지 않는 원소를 나타내는 비트열을 EAX에 생성하시오.

**짧은 풀이:** 집합 차집합은 `SetX AND (NOT SetY)`이다. `AND`의 두 번째 피연산자로 직접 `NOT` 연산을 쓸 수 없으므로 레지스터에서 반전한다.

**답:** (`SetX`, `SetY`는 DWORD 변수)

```asm
mov eax, SetY
not eax
and eax, SetX
```

## 4. 부호 없는 DX ≤ CX이면 L1로 이동

**문제 해석:** 부호 없는 정수 DX가 CX보다 작거나 같으면 레이블 `L1`으로 점프하시오.

**짧은 풀이:** `CMP` 후 부호 없는 **이하** 조건인 `JBE`를 사용한다.

**답:**

```asm
cmp dx, cx
jbe L1
```

## 5. 부호 있는 AX > CX이면 L2로 이동

**문제 해석:** 부호 있는 정수 AX가 CX보다 크면 레이블 `L2`로 점프하시오.

**짧은 풀이:** 부호 있는 **초과** 조건이므로 `JG`를 사용한다.

**답:**

```asm
cmp ax, cx
jg L2
```

## 6. AL의 비트 0, 1을 지운 뒤 결과에 따라 분기

**문제 해석:** AL의 비트 0과 1을 먼저 0으로 만드시오. 그 결과가 0이면 `L3`, 아니면 `L4`로 점프하시오.

**짧은 풀이:** `11111100b`와 AND하면 하위 두 비트가 지워진다. `AND`는 결과에 따라 ZF를 설정하므로 추가 비교가 필요 없다.

**답:**

```asm
and al, 11111100b
jz  L3
jmp L4
```

## 7. AND 조건의 단락 평가

**문제 해석:** `val1 > ECX`이고 동시에 `ECX > EDX`이면 `X=1`, 그렇지 않으면 `X=2`로 설정하시오. `val1`, `X`는 32비트 변수이며 단락 평가를 사용하시오.

**짧은 풀이:** 첫 번째 조건이 거짓이면 두 번째 조건을 검사하지 않고 바로 `X=2`로 이동한다.

**답:**

```asm
mov eax, val1
    cmp val1, ecx
    jle ElsePart
    cmp ecx, edx
    jle ElsePart
    mov X,1
    jmp Done
ElsePart:
    mov X,2
Done:
```

## 8. OR 조건의 단락 평가

**문제 해석:** `EBX > ECX` 또는 `EBX > val1`이면 `X=1`, 그렇지 않으면 `X=2`로 설정하시오. 단락 평가를 사용하시오.

**짧은 풀이:** 첫 번째 조건이 참이면 두 번째 조건을 검사하지 않고 곧바로 `X=1`로 이동한다.

**답:**

```asm
cmp ebx, ecx
    jg ThenPart
    cmp ebx, val1
    jg ThenPart
    mov X, 2
    jmp Done
ThenPart:
    mov X,1
Done:
```

## 9. 복합 AND/OR 조건의 단락 평가

**문제 해석:** `(EBX > ECX AND EBX > EDX) OR (EDX > EAX)`이면 `X=1`, 그렇지 않으면 `X=2`로 설정하시오. 단락 평가를 사용하시오.

**짧은 풀이:** 첫 번째 AND 묶음이 모두 참이면 즉시 `X=1`이다. AND 묶음 중 하나라도 거짓이면 마지막 OR 조건 `EDX > EAX`를 검사한다.

**답:**

```asm
cmp ebx,ecx
    jle CheckOr
    cmp ebx, edx
    jg ThenPart
CheckOr:
    cmp cdx, eax
    jg ThenPart
    mov X,2
    jmp Done
ThenPart:
    mov X,1
Done:
```

## 10. WHILE 반복문과 복합 조건 구현

**문제 해석:** `A`, `B`, `N`은 부호 있는 32비트 정수이다. `N > 0`인 동안 반복한다. `N != 3`이면서 (`N < A` 또는 `N > B`)이면 `N`에서 2를 빼고, 그렇지 않으면 1을 뺀다.

**짧은 풀이:** 반복문 맨 앞에서 `N > 0`인지 검사한다. `N=3`이면 나머지 조건을 생략하고 1을 뺀다. `N!=3`일 때는 `N<A` 또는 `N>B` 중 하나라도 참이면 2를 뺀다.

**답:**

```asm
WhileLoop:
    cmp N, 0
    jle End10

    cmp N, 3
    je  SubOne10

    mov eax, N
    cmp eax, A
    jl  SubTwo10
    cmp eax, B
    jg  SubTwo10
Sub1:
    sub N, 1
    jmp While10
Sub2:
    sub N, 2
    jmp While10
EndWhile:
```

---

**참고:** 7~9번의 `>`는 문제에 부호 여부가 지정되지 않아 `JG`/`JLE`로 구현했다. 부호 없는 값이라면 각각 `JA`/`JBE`로 바꿔야 한다. 2번의 `TEST`는 32비트 전체가 아니라 XOR로 합친 **8비트 AL의 패리티**를 PF에 반영하며, 이는 원래 32비트의 전체 1비트 개수의 홀짝성과 동일하다.
