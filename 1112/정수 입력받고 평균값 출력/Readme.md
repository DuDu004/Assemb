- **학번:** 2023964045
- **이름:** 최영우
- **개발 환경:** Visual Studio, MASM (x86, 32비트)
- **사용 라이브러리:** C 표준 입출력 함수 `scanf`, `printf` (Irvine32 미사용)

## 1. 프로그램

**사용자로부터 정수 5개를 입력받고, 그 합계를 5로 나누어 평균을 출력하는 프로그램**.

## 2. 실행 과정

1. `ECX` 레지스터에 `5`를 저장하여 반복 횟수를 설정.
2. `printf`로 입력 안내 문구를 출력하고, `scanf`로 정수를 입력.
3. `ADD`를 이용해 입력한 숫자를 `sum` 변수에 누적.
4. `LOOP` 명령어로 위 과정을 총 5번 반복.
5. 합계를 `5`로 나누고 `printf`로 평균을 출력.

## 3. 주요 코드 설명

### (1) 변수 선언

```asm
.data
    msg BYTE "Enter number: ", 0
    inputFmt BYTE "%d", 0
    outputFmt BYTE "Average: %d", 10, 0

    num SDWORD ?
    sum SDWORD 0
```

- `num`: 사용자가 입력한 정수를 저장.
- `sum`: 5개 숫자의 합계를 저장하며 초기값은 0.

### (2) 숫자 입력 및 합계 계산

```asm
mov ecx, 5
mov sum, 0

L1:
    push ecx

    invoke printf, ADDR msg
    invoke scanf, ADDR inputFmt, ADDR num

    mov eax, num
    add sum, eax

    pop ecx
    loop L1
```

`ECX`는 반복 횟수를 관리. `LOOP L1`이 실행될 때마다 `ECX`가 1 감소하고, 0이 아니면 `L1`로 회귀. `printf`와 `scanf`를 호출하는 동안 카운터가 바뀌지 않도록 `PUSH`와 `POP`으로 `ECX`를 보관하고 복원.

### (3) 평균 계산 및 출력

```asm
mov eax, sum
cdq
mov ebx, 5
idiv ebx

invoke printf, ADDR outputFmt, eax
```

- `MOV EAX, sum`: 합계를 `EAX`에 저장.
- `CDQ`: 부호 있는 나눗셈을 위해 `EAX`의 부호를 `EDX`로 확장.
- `IDIV EBX`: 합계를 5로 나눕니다. **몫은 `EAX`, 나머지는 `EDX`**에 저장.
- `printf`: `EAX`에 저장된 **정수 몫**을 평균으로 출력.

