# Recursive Procedure - 재귀 프로시저

*ECX와 LOOP 명령어로 재귀 횟수를 제어하는 직접 재귀 예제*

## 1. 문제 및 해석

**원문 요약:** 재귀 프로시저를 호출하는 프로그램을 작성한다. 프로시저가 실행될 때마다 카운터를 1 증가시켜 실행 횟수를 확인한다. ECX에 재귀 호출 횟수를 지정하고, 조건 분기 명령어 없이 `LOOP` 명령어만으로 재귀 호출이 정해진 횟수만큼 이루어지도록 구현한다.

**핵심 조건**
- 프로시저가 자기 자신을 호출하는 **직접 재귀(Direct Recursion)**를 사용한다.
- 프로시저가 실행될 때마다 `counter`를 1 증가시킨다.
- `ECX`로 재귀 횟수를 제어한다.
- `LOOP` 명령어만으로 재귀 종료 조건을 구현한다.

---

## 2. 전체 코드 (MASM + Irvine32)

```asm
INCLUDE Irvine32.inc

.data
    counter DWORD 0

.code
main PROC
    mov ecx, 5              ; 재귀 횟수 제어용 카운터
    call RecursiveProc

    mov eax, counter
    call WriteDec           ; 실행 횟수 출력
    call Crlf

    exit
main ENDP

RecursiveProc PROC
    inc counter             ; 호출될 때마다 실행 횟수 1 증가

    loop L1                 ; ECX 감소 후 0이 아니면 L1로 이동
    ret                     ; ECX가 0이면 복귀

L1:
    call RecursiveProc      ; 자기 자신을 다시 호출 (직접 재귀)
    ret
RecursiveProc ENDP

END main
```

---

## 3. 코드 해석

| 코드 | 설명 |
|------|------|
| `mov ecx, 5` | 재귀 호출 횟수를 제어할 카운터를 5로 설정한다. |
| `call RecursiveProc` | 프로시저를 처음 호출한다. |
| `inc counter` | 프로시저가 실행될 때마다 `counter`를 1 증가시킨다. |
| `loop L1` | `ECX`를 1 감소시키고, 0이 아니면 `L1`로 이동한다. |
| `call RecursiveProc` | `L1`에서 자기 자신을 다시 호출한다. |
| `WriteDec` | 최종 `counter` 값을 10진수로 출력한다. |

---

## 4. 실행 과정

| 단계 | 실행 내용 | ECX | counter |
|------|-----------|-----|---------|
| 1 | 최초 호출 후 `inc counter` | 5 | 1 |
| 2 | `loop` 실행 (감소 후 분기) | 4 | 1 |
| 3 | 재귀 호출 후 `inc counter` | 4 | 2 |
| 4 | `loop` 실행 | 3 | 2 |
| 5 | 재귀 호출 후 `inc counter` | 3 | 3 |
| 6 | `loop` 실행 | 2 | 3 |
| 7 | 재귀 호출 후 `inc counter` | 2 | 4 |
| 8 | `loop` 실행 | 1 | 4 |
| 9 | 재귀 호출 후 `inc counter` | 1 | 5 |
| 10 | `loop` 실행 (0이므로 분기하지 않음) | 0 | 5 |

`ECX`가 0이 되면 `loop`는 분기하지 않고 `ret`으로 돌아간다. 이후 상위 호출들도 차례로 `ret`하여 `main`으로 복귀한다.

---

## 5. 예상 실행 결과

```
5
```

---

## 6. 주의사항

- **`ECX = 0`으로 호출하면 안 된다.** `loop`는 먼저 `ECX`를 감소시키므로 `0`이 `FFFFFFFF`가 되어 약 42억 번 재귀하다가 스택 오버플로가 발생한다. 조건 분기를 쓰지 않는다는 제약이 있으므로, 호출 전에 `ECX`가 1 이상인지 보장해야 한다.
- `counter`는 전역 변수라 모든 호출이 공유한다.
- `RecursiveProc`는 `ECX`를 직접 바꾸지 않고 `loop`로만 감소시키므로, 재귀 깊이는 `ECX`가 제어한다.

---

## 7. 핵심 정리

- **직접 재귀:** 프로시저가 `call`로 자기 자신을 호출한다.
- **횟수 제어:** `ECX`에 재귀 횟수를 넣고 `LOOP`로 감소시킨다.
- **종료 조건:** `ECX`가 0이 되면 `LOOP`가 분기하지 않아 재귀가 끝난다.
- **카운터:** 호출마다 `inc counter`로 실행 횟수를 기록한다.