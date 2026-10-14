# Random Strings - 무작위 문자열 생성

*MASM + Irvine32 · 대문자 A~Z로 구성된 길이 L의 랜덤 문자열 생성*

## 1. 문제 번역

길이가 $L$인 무작위 문자열을 생성하는 프로시저를 작성하시오. 문자열에는 영문 대문자 A부터 Z까지만 포함되어야 한다.

프로시저 호출 시 인수는 다음과 같이 전달한다.

| 레지스터 | 의미 |
|---|---|
| `EAX` | 생성할 문자열의 길이 $L$ |
| `EDX` | 생성된 문자열을 저장할 BYTE 배열의 주소 |

테스트 프로그램에서는 해당 프로시저를 20회 호출하고, 생성된 문자열을 콘솔 창에 출력한다.

---

## 2. 전체 어셈블리 코드 (MASM + Irvine32)

아래 코드는 문자열 길이를 10으로 설정하고, 무작위 대문자 문자열을 20개 출력한다.

```asm
INCLUDE Irvine32.inc

.data
    stringLength = 10

    ; 문자열 10글자와 종료 문자 0을 저장할 공간
    randomString BYTE stringLength + 1 DUP(0)

.code
main PROC
    ; 난수 생성기를 초기화한다.
    call Randomize

    ; 문자열을 20개 생성한다.
    mov ecx, 20

L1:
    ; 생성할 문자열의 길이를 EAX에 전달한다.
    mov eax, stringLength

    ; 문자열을 저장할 배열의 주소를 EDX에 전달한다.
    mov edx, OFFSET randomString

    ; 무작위 대문자 문자열을 생성한다.
    call GenerateRandomString

    ; 생성된 문자열을 출력한다.
    mov edx, OFFSET randomString
    call WriteString
    call Crlf

    loop L1

    exit
main ENDP


GenerateRandomString PROC
    ; 입력:
    ;   EAX = 생성할 문자열의 길이 L
    ;   EDX = 문자열을 저장할 배열의 주소
    ;
    ; 기능:
    ;   A부터 Z까지의 무작위 대문자로 문자열을 생성한다.
    ;   문자열 끝에 NULL 문자를 추가한다.

    ; 반복문에서 사용할 레지스터를 보존한다.
    push ebx
    push ecx
    push esi
    push edi

    ; 길이와 배열 주소를 별도 레지스터에 보관한다.
    mov ecx, eax
    mov edi, edx

    ; 각 문자를 하나씩 생성한다.
L2:
    ; 0부터 25까지의 난수를 생성한다.
    mov eax, 26
    call RandomRange

    ; 0~25를 ASCII 대문자 A~Z로 변환한다.
    add eax, 'A'

    ; 생성된 문자를 배열에 저장한다.
    mov [edi], al

    ; 다음 배열 위치로 이동한다.
    inc edi

    ; 남은 문자가 있으면 계속 반복한다.
    loop L2

    ; 문자열 끝에 NULL 문자를 추가한다.
    mov BYTE PTR [edi], 0

    ; 사용했던 레지스터를 복원한다.
    pop edi
    pop esi
    pop ecx
    pop ebx

    ret
GenerateRandomString ENDP

END main
```

---

## 3. 코드 해석

### 3.1 main 프로시저

| 코드 | 설명 |
|---|---|
| `call Randomize` | 난수 생성기를 초기화한다. |
| `mov ecx, 20` | 문자열 생성 횟수를 20회로 설정한다. |
| `mov eax, stringLength` | 생성할 문자열의 길이 10을 전달한다. |
| `mov edx, OFFSET randomString` | 문자열을 저장할 배열의 주소를 전달한다. |
| `call GenerateRandomString` | 무작위 대문자 문자열을 생성한다. |
| `call WriteString` | 생성된 문자열을 출력한다. |
| `call Crlf` | 줄을 바꾼다. |
| `loop L1` | 문자열 생성과 출력을 총 20회 반복한다. |

### 3.2 GenerateRandomString 프로시저

**① 레지스터 보존**

```asm
push ebx
push ecx
push esi
push edi
```

프로시저 내부에서 사용할 레지스터의 기존 값을 스택에 저장하고, 종료 직전에 `pop`으로 복원한다.

**② 문자열 길이와 배열 주소 저장**

```asm
mov ecx, eax
mov edi, edx
```

- `ECX`: 생성해야 할 문자의 개수
- `EDI`: 현재 문자를 저장할 배열 위치

**③ 무작위 문자 생성**

```asm
mov eax, 26
call RandomRange
add eax, 'A'
```

`RandomRange`는 0부터 25까지의 난수를 반환하고, `'A'`(65)를 더하면 대문자 범위에 대응한다.

| 난수 | 변환 (+65) | 문자 |
|---|---|---|
| 0 | 65 | A |
| 1 | 66 | B |
| 2 | 67 | C |
| ... | ... | ... |
| 25 | 90 | Z |

**④ 문자 저장 및 다음 위치 이동**

```asm
mov [edi], al
inc edi
```

`AL`의 문자를 배열에 저장하고, `EDI`를 1 증가시켜 다음 바이트 위치로 이동한다.

**⑤ 문자열 종료 문자 추가**

```asm
mov BYTE PTR [edi], 0
```

NULL 문자(0)를 추가한다. Irvine32의 `WriteString`은 이 값을 만날 때까지 출력한다.

---

## 4. 실행 과정 (길이 10 기준)

1. `main`에서 `EAX = 10`, `EDX = OFFSET randomString`을 설정한다.
2. `GenerateRandomString`이 길이 10을 `ECX`에 저장한다.
3. 반복문에서 `RandomRange(26)`을 호출해 0~25의 난수를 얻는다.
4. 난수에 `'A'`를 더해 대문자로 변환하고 배열에 저장한다.
5. 위 과정을 10회 반복해 문자 10개를 생성한다.
6. 배열 끝에 NULL 문자를 추가하고 호출한 곳으로 돌아간다.
7. `main`에서 완성된 문자열을 출력하고 다음 문자열을 생성한다.
8. 총 20개의 문자열이 출력되면 프로그램이 종료된다.

---

## 5. 예상 실행 결과

난수에 따라 실행할 때마다 결과가 달라진다. 아래는 출력 예시다.

```text
QJAMZKPWTR
BCXNYRLFHA
TZQWJEMKDP
HGFVANRUXC
MPQAZYTWKE
LCRXJBNVHS
WQEKTMZPFA
YHDCXLRNBG
FZMWQKJATE
NVRPCHXKLD
AKYFMWQZTE
XJBNRLCVPA
DTEQKZMHWF
RUXCAVNJLY
GPKWEMZBHQ
CLTNYXRAFD
ZMQHVPWKBE
BJAFRDXNUT
KWEZLYQPCM
VNHXGTARJK
```

---

## 6. 핵심 정리

- **입력 규약**: `EAX`에 길이, `EDX`에 버퍼 주소를 전달한다.
- **문자 생성**: `RandomRange(26)` + `'A'`로 A~Z 중 하나를 얻는다.
- **종료 처리**: 마지막에 NULL(0)을 기록해 문자열의 끝을 표시한다.
- **레지스터 보존**: 사용한 레지스터를 `push`/`pop`으로 보존해 호출자의 `ECX` 루프가 깨지지 않도록 한다.
- **주의**: 길이 `L = 0`일 때 `loop`는 먼저 `ECX`를 감소시키므로 `ECX`가 `FFFFFFFF`가 되어 무한 반복된다. 진입 전에 `test ecx, ecx` / `jz`로 검사하는 것이 안전하다.