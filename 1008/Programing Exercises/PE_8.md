# Color Matrix - 색상 조합 행렬

## 1. 문제 번역

전경색(foreground)과 배경색(background)의 모든 조합으로 문자 하나를 출력하는 프로그램을 작성한다.

- 전경색과 배경색은 각각 0~15의 16가지 값을 가진다.
- 가능한 조합은 16 × 16 = 256가지다.
- 중첩 반복문(nested loop)으로 모든 조합을 생성한다.

$$
\text{색상 값} = \text{전경색} + 16 \times \text{배경색}
$$

예: 전경색 2, 배경색 4라면 $2 + 16 \times 4 = 66$.

## 3. 전체 어셈블리 코드 (MASM + Irvine32)

```asm
INCLUDE Irvine32.inc

.data
    ch BYTE 'X'                 ; 출력할 문자

.code
main PROC
    call Clrscr                 ; 화면을 지운다.

    mov ebx, 0                  ; 전경색 번호 = 0

OuterLoop:
    mov esi, 0                  ; 배경색 번호 = 0

InnerLoop:
    ; 전경색과 배경색을 결합한다.
    mov eax, esi
    shl eax, 4                  ; 배경색을 상위 4비트로 이동
    add eax, ebx                ; 전경색을 하위 4비트에 결합
    call SetTextColor           ; 텍스트 색상 설정

    ; 문자 하나를 출력한다.
    mov al, ch
    call WriteChar

    ; 다음 배경색으로 이동한다.
    inc esi
    cmp esi, 16
    jl InnerLoop

    ; 한 행이 끝나면 줄을 바꾼다.
    call Crlf

    ; 다음 전경색으로 이동한다.
    inc ebx
    cmp ebx, 16
    jl OuterLoop

    ; 기본 색상으로 복원한다.
    mov eax, lightGray + (black * 16)
    call SetTextColor

    exit
main ENDP
END main
```

## 4. 코드 해석

### ① 바깥쪽 반복문
- `mov ebx, 0`: EBX에 전경색 번호를 저장한다.
- `OuterLoop`마다 `mov esi, 0`으로 배경색을 처음부터 다시 순회한다.

### ② 색상 조합 생성

| 명령어 | 설명 |
|---|---|
| `mov eax, esi` | 배경색 번호를 EAX에 넣는다. |
| `shl eax, 4` | 16을 곱하는 효과로 상위 4비트에 배치한다. |
| `add eax, ebx` | 전경색 번호를 하위 4비트에 더한다. |
| `call SetTextColor` | 결합된 값으로 색상을 설정한다. |

예: 배경색 3, 전경색 5라면 $(3 \times 16) + 5 = 53$이다.

### ③ 안쪽 반복문
- `inc esi` 후 `cmp esi, 16`, `jl InnerLoop`으로 배경색 0~15를 모두 처리한다.

### ④ 다음 전경색으로 이동
- 한 행이 끝나면 `Crlf`로 줄을 바꾼다.
- `inc ebx` 후 `cmp ebx, 16`, `jl OuterLoop`으로 전경색을 증가시킨다.

## 5. 실행 과정

| 전경색 (EBX) | 배경색 (ESI) | 출력 횟수 |
|---|---|---|
| 0 | 0~15 | 16회 |
| 1 | 0~15 | 16회 |
| ... | ... | ... |
| 15 | 0~15 | 16회 |

전체 출력 횟수는 $16 \times 16 = 256$회다.

## 6. 예상 실행 결과

콘솔에는 문자 `X`가 16행 × 16열로 출력된다. 각 행은 전경색이 같고, 행 안에서 배경색이 바뀐다. 텍스트만 보면 모두 `X`로 보이며, 색상 차이는 콘솔 화면에서 확인할 수 있다.

```text
XXXXXXXXXXXXXXXX   (전경색 0)
XXXXXXXXXXXXXXXX   (전경색 1)
...
XXXXXXXXXXXXXXXX   (전경색 15)
```

## 7. 핵심 정리

- **중첩 반복문**: 바깥 루프(전경색), 안쪽 루프(배경색)
- **시프트 + 덧셈**: `배경색 × 16 + 전경색`으로 색상 값 생성
- **SetTextColor**: EAX 하나로 전경색과 배경색을 동시에 설정
- **복원**: 종료 전 기본 색상(`lightGray + black * 16`)으로 되돌린다.

## 8. 주의사항

- 전경색과 배경색이 같으면(예: 둘 다 0) 문자가 보이지 않는다.
- 16행 × 16열 출력은 콘솔 높이에 따라 스크롤이 발생할 수 있다.
- 루프 내부에서 사용하는 레지스터(EBX, ESI)가 `SetTextColor`, `WriteChar`, `Crlf`에서 바뀌지 않는다는 Irvine32의 동작을 전제로 한다.