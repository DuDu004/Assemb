# BetterRandomRange - 개선된 난수 범위 프로시저

*Irvine32 RandomRange를 활용한 M 이상 N 미만 난수 생성*

## 1. 문제 번역

Irvine32의 `RandomRange`는 **0 이상 N 미만**의 의사 난수를 생성한다. 이를 개선하여 **M 이상 N 미만**의 난수를 생성하는 `BetterRandomRange` 프로시저를 작성한다.

| 레지스터 | 의미 |
|---|---|
| `EBX` | 하한값 M |
| `EAX` | 상한 경계값 N |

테스트 프로그램은 반복문으로 **난수 50개**를 생성하여 각각 출력한다.

---

## 2. 전체 어셈블리 코드 (MASM + Irvine32)

```asm
INCLUDE Irvine32.inc

.data
    msg BYTE "Random value: ", 0

.code
main PROC
    ; 난수 생성기를 초기화한다.
    call Randomize

    ; 50회 반복한다.
    mov ecx, 50

L1:
    ; 난수 범위를 -300 이상 100 미만으로 설정한다.
    mov ebx, -300
    mov eax, 100

    ; BetterRandomRange를 호출한다.
    call BetterRandomRange

    ; 생성된 난수를 출력한다.
    mov edx, OFFSET msg
    call WriteString
    call WriteInt
    call Crlf

    loop L1

    exit
main ENDP


BetterRandomRange PROC
    ; 입력:
    ;   EBX = 하한값 M
    ;   EAX = 상한 경계값 N
    ; 출력:
    ;   EAX = M 이상 N 미만의 난수

    ; 난수 범위의 크기 N - M을 계산한다.
    sub eax, ebx

    ; 0 이상 (N - M) 미만의 난수를 생성한다.
    call RandomRange

    ; 난수에 하한값 M을 더하여 원하는 범위로 이동한다.
    add eax, ebx

    ret
BetterRandomRange ENDP

END main
```

---

## 3. 코드 해석

### main 프로시저

| 코드 | 설명 |
|---|---|
| `call Randomize` | 난수 생성기의 초기 상태를 설정한다. |
| `mov ecx, 50` | 반복 횟수를 50회로 설정한다. |
| `mov ebx, -300` | 하한값 M을 -300으로 설정한다. |
| `mov eax, 100` | 상한 경계값 N을 100으로 설정한다. |
| `call BetterRandomRange` | 지정된 범위의 난수를 생성한다. |
| `call WriteString` | `"Random value: "`를 출력한다. |
| `call WriteInt` | EAX에 저장된 난수를 출력한다. |
| `call Crlf` | 다음 줄로 이동한다. |
| `loop L1` | ECX를 1 감소시키고, 0이 아니면 L1로 돌아간다. |

### BetterRandomRange 프로시저

핵심은 기존 `RandomRange`를 활용해 난수의 **범위 크기를 만든 뒤 하한값만큼 이동**시키는 것이다.

```asm
sub eax, ebx      ; 범위 크기 N - M 계산
call RandomRange  ; 0 이상 (N - M) 미만의 난수 생성
add eax, ebx      ; 하한값 M을 더해 구간 이동
```

---

## 4. 실행 과정

`RandomRange`가 125를 반환했다고 가정하면 다음과 같다.

| 단계 | 명령어 | EAX 값 | 설명 |
|:---:|---|---:|---|
| 1 | `mov eax, 100` | 100 | 상한 경계값 N 설정 |
| 2 | `mov ebx, -300` | 100 | 하한값 M 설정 |
| 3 | `sub eax, ebx` | 400 | 범위 크기 계산 (100 - (-300)) |
| 4 | `call RandomRange` | 125 | 0 ~ 399 중 난수 생성 |
| 5 | `add eax, ebx` | -175 | 하한값을 더해 범위 이동 (125 + (-300)) |
| 6 | `ret` | -175 | 호출한 곳으로 복귀 |

이 과정을 50회 반복하여 매번 생성된 값을 출력한다.

---

## 5. 예상 실행 결과

난수는 실행할 때마다 달라지므로 아래는 가능한 출력의 **예시**이다.

```text
Random value: -175
Random value: 42
Random value: -298
Random value: 87
Random value: -63
Random value: -241
...
```

총 50개의 정수가 출력되며, 모든 값은 다음 조건을 만족해야 한다.

$$
-300 \leq \text{난수} < 100
$$

즉, 가능한 최솟값은 **-300**, 최댓값은 **99**이다.

---

## 6. 핵심 정리

> **결과 = RandomRange(N - M) + M**

- `sub eax, ebx`로 범위 크기 **N - M**을 구한다.
- `RandomRange`는 **0 ~ (N - M - 1)** 범위의 난수를 반환한다.
- `add eax, ebx`로 하한값 M만큼 구간을 이동한다.

### 주의사항

- 이 구현은 **N > M**인 유효한 범위를 전제로 한다.
- `RandomRange`는 범위 크기를 부호 없는 정수로 취급하므로, 범위가 양수이고 정수 표현 범위 안에 있는지 확인해야 한다.