# Simple Addition (2) - 간단한 덧셈 (2)

*반복문과 화면 초기화를 사용한 두 정수 합계 프로그램 (MASM + Irvine32)*

## 1. 문제 설명

앞선 문제 **Simple Addition (1)** 의 프로그램을 수정하여, 두 정수를 입력받아 합계를 출력하는 작업을 **총 3회 반복**하고, **각 반복이 끝날 때마다 화면을 지우는** 프로그램을 작성한다.

> **핵심 요구사항**
> - 동일한 작업을 반복문으로 3회 수행한다.
> - 각 반복이 끝날 때마다 화면을 지운다.

---

## 2. 전체 어셈블리 코드

```asm
INCLUDE Irvine32.inc

.data
    prompt1   BYTE "Enter the first integer: ", 0
    prompt2   BYTE "Enter the second integer: ", 0
    resultMsg BYTE "The sum is: ", 0

    num1 SDWORD ?
    num2 SDWORD ?

.code
main PROC
    ; 반복 횟수를 3회로 설정한다.
    mov ebx, 3

L1:
    ; 화면을 지우고 커서를 중앙 부근으로 이동한다.
    call Clrscr
    mov dh, 12
    mov dl, 25
    call Gotoxy

    ; 첫 번째 정수를 입력받는다.
    mov edx, OFFSET prompt1
    call WriteString
    call ReadInt
    mov num1, eax

    ; 두 번째 정수를 입력받는다.
    call Crlf
    mov edx, OFFSET prompt2
    call WriteString
    call ReadInt
    mov num2, eax

    ; 두 정수를 더한다.
    mov eax, num1
    add eax, num2

    ; 합계를 출력한다.
    call Crlf
    mov edx, OFFSET resultMsg
    call WriteString
    call WriteInt
    call Crlf

    ; 반복이 끝날 때마다 화면을 지운다.
    call WaitMsg
    call Clrscr

    ; 다음 반복으로 이동한다.
    dec ebx
    jnz L1

    exit
main ENDP
END main
```

---

## 3. 코드 해석

| 코드 | 설명 |
|------|------|
| `mov ebx, 3` | 반복 횟수를 3회로 설정한다. |
| `L1:` | 반복문의 시작 지점이다. |
| `call Clrscr` | 반복을 시작할 때 화면을 지운다. |
| `mov dh, 12` / `mov dl, 25` | 커서의 행과 열을 설정한다. |
| `call Gotoxy` | 지정한 위치로 커서를 이동한다. |
| `call ReadInt` | 사용자가 입력한 정수를 EAX에 저장한다. |
| `mov num1, eax` | 첫 번째 입력값을 저장한다. |
| `mov num2, eax` | 두 번째 입력값을 저장한다. |
| `mov eax, num1` | 첫 번째 정수를 EAX에 가져온다. |
| `add eax, num2` | 두 정수의 합계를 EAX에 계산한다. |
| `call WriteInt` | EAX에 저장된 합계를 출력한다. |
| `call WaitMsg` | 사용자가 키를 누를 때까지 기다린다. |
| `call Clrscr` | 해당 반복이 끝난 뒤 화면을 지운다. |
| `dec ebx` | 남은 반복 횟수를 1 감소시킨다. |
| `jnz L1` | EBX가 0이 아니면 `L1`로 돌아간다. |
| `exit` | 3회 반복이 끝나면 프로그램을 종료한다. |

### 💡 WaitMsg를 사용하는 이유

결과가 출력되자마자 화면을 지우면 사용자가 합계를 확인하기 어렵다. `WaitMsg`는 **결과를 확인할 시간**을 주기 위해 사용한다.

- `WaitMsg`를 호출하면 `Press any key to continue...` 메시지가 나타난다.
- 사용자가 키를 누르면 화면이 지워지고 다음 반복이 시작된다.

---

## 4. 실행 과정

예시 입력은 다음과 같다.

| 반복 | 첫 번째 정수 | 두 번째 정수 | 합계 |
|:---:|:---:|:---:|:---:|
| 1회 | 10 | 20 | 30 |
| 2회 | 15 | 25 | 40 |
| 3회 | 100 | 200 | 300 |

**실행 순서**

1. `EBX = 3`으로 설정하고 첫 번째 반복을 시작한다.
2. 두 정수를 입력받아 합계를 계산하고 출력한다.
3. `WaitMsg`로 사용자 입력을 기다린 뒤 화면을 지운다.
4. `EBX`를 감소시키고, 0이 아니면 다시 반복한다.
5. 세 번째 반복이 끝나 `EBX = 0`이 되면 반복문을 종료한다.

---

## 5. 예상 실행 결과

> 아래는 각 반복에서 화면에 표시되는 내용이다. 실제 프로그램에서는 매 반복이 끝날 때 화면이 지워진다.

**🔁 첫 번째 반복**

```text
Enter the first integer: 10
Enter the second integer: 20

The sum is: +30
Press any key to continue...
```

**🔁 두 번째 반복**

```text
Enter the first integer: 15
Enter the second integer: 25

The sum is: +40
Press any key to continue...
```

**🔁 세 번째 반복**

```text
Enter the first integer: 100
Enter the second integer: 200

The sum is: +300
Press any key to continue...
```

---

## 6. 핵심 정리

이번 문제의 핵심은 **반복 횟수 제어**와 **화면 초기화**이다.

- ✅ `EBX`를 반복 횟수 카운터로 사용한다.
- ✅ `dec ebx`로 횟수를 줄이고, `jnz L1`로 반복 여부를 결정한다.
- ✅ `WaitMsg`로 결과를 확인할 시간을 준다.
- ✅ `Clrscr`로 각 반복이 끝난 뒤 화면을 지운다.

### ⚠️ 주의사항

이 코드는 반복 횟수를 `EBX`에 저장하므로, 루프 안에서 `EBX`를 변경하는 프로시저를 호출하지 않는다는 전제에서 동작한다. Irvine32 라이브러리 프로시저 중에는 레지스터를 변경하는 것이 있을 수 있으므로, 더 안전하게 하려면 카운터를 메모리 변수에 저장하는 방법을 사용할 수 있다.

```asm
.data
    count DWORD 3

.code
    ; 반복 끝부분
    dec count
    jnz L1
```