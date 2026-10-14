# 3번. Simple Addition (1) --- 간단한 덧셈 (1)

## 1. 문제 설명

화면을 지우고 커서를 화면의 중앙 부근으로 이동시킨 다음, 사용자에게 정수
두 개를 입력받아 두 정수의 합을 계산하고 그 결과를 출력하는 프로그램을
작성한다.

## 2. 전체 어셈블리 코드 (MASM + Irvine32)

``` asm
INCLUDE Irvine32.inc

.data
    prompt1 BYTE "Enter the first integer: ", 0
    prompt2 BYTE "Enter the second integer: ", 0
    resultMsg BYTE "The sum is: ", 0

    num1 SDWORD ?
    num2 SDWORD ?
    sum  SDWORD ?

.code
main PROC
    ; 화면을 지운다.
    call Clrscr

    ; 커서를 화면 중앙 부근으로 이동한다.
    ; Gotoxy의 DH = 행(row), DL = 열(column)
    mov dh, 12
    mov dl, 25
    call Gotoxy

    ; 첫 번째 정수를 입력받는다.
    mov edx, OFFSET prompt1
    call WriteString
    call ReadInt
    mov num1, eax

    ; 다음 줄로 이동한다.
    call Crlf

    ; 두 번째 정수를 입력받는다.
    mov edx, OFFSET prompt2
    call WriteString
    call ReadInt
    mov num2, eax

    ; 두 정수를 더한다.
    mov eax, num1
    add eax, num2
    mov sum, eax

    ; 합계를 출력한다.
    call Crlf
    mov edx, OFFSET resultMsg
    call WriteString

    mov eax, sum
    call WriteInt
    call Crlf

    exit
main ENDP
END main
```

## 3. 코드 해설

| 코드 | 설명 |
|---|---|
| `call Clrscr` | 콘솔 화면을 지운다. |
| `mov dh, 12` | 커서가 위치할 행을 12로 설정한다. |
| `mov dl, 25` | 커서가 위치할 열을 25로 설정한다. |
| `call Gotoxy` | 지정한 행과 열로 커서를 이동한다. |
| `call ReadInt` | 부호 있는 정수를 입력받아 `EAX`에 저장한다. |
| `add eax, num2` | 두 번째 정수를 더한다. 결과는 `EAX`에 저장된다. |
| `call WriteInt` | `EAX`에 있는 정수를 출력한다. |

### 주요 명령어 및 프로시저

-   **`Clrscr`**: 화면을 지우는 Irvine32 프로시저
-   **`Gotoxy`**: 커서를 지정된 위치로 이동하는 Irvine32 프로시저
-   **`ReadInt`**: 부호 있는 정수를 입력받아 `EAX`에 저장하는 Irvine32
    프로시저
-   **`WriteInt`**: `EAX`에 있는 부호 있는 정수를 출력하는 Irvine32
    프로시저

`Gotoxy`는 행과 열을 각각 `DH`, `DL` 레지스터로 전달받는다. 여기서는 행
12, 열 25로 설정했으며, 실제 화면의 크기에 따라 중앙에 가까운 위치는
달라질 수 있다.

## 4. 실행 과정

사용자가 다음과 같이 입력한다고 가정한다.

``` text
Enter the first integer: 15
Enter the second integer: 27
```

### ① 화면 초기화 및 커서 이동

`Clrscr`로 화면을 지운 뒤, `Gotoxy`를 호출하여 커서를 지정된 위치로
옮긴다.

### ② 첫 번째 정수 입력

사용자가 `15`를 입력하면 `ReadInt`가 값을 `EAX`에 저장한다.

``` asm
mov num1, eax
```

이후 `num1 = 15`가 된다.

### ③ 두 번째 정수 입력

사용자가 `27`을 입력하면 값이 `EAX`에 들어오고, 다음 명령어를 통해
`num2`에 저장된다.

``` asm
mov num2, eax
```

이후 `num2 = 27`이 된다.

### ④ 두 정수의 덧셈

``` asm
mov eax, num1
add eax, num2
```

레지스터 값의 변화는 다음과 같다.

  명령어 실행 후      `EAX` 값
  ----------------- ----------
  `mov eax, num1`         `15`
  `add eax, num2`         `42`

계산 결과 `42`를 `sum`에 저장한다.

### ⑤ 합계 출력

`WriteString`으로 결과 안내 문구를 출력하고, `WriteInt`로 합계를
출력한다.

## 5. 예상 실행 결과

화면 중앙 부근에서 입력을 시작하며, 실제 출력 위치와 줄 간격은 콘솔
환경에 따라 달라질 수 있다.

``` text
                         Enter the first integer: 15
Enter the second integer: 27

The sum is: +42
```

> **참고:** Irvine32의 `WriteInt`는 부호 있는 정수를 출력하며, 양수 앞에
> `+` 기호가 표시될 수 있다.

## 정리

이 문제의 핵심은 `ReadInt`로 입력한 두 정수를 변수에 저장하고, `EAX`
레지스터에서 `add` 명령어로 합산한 뒤 `WriteInt`로 결과를 출력하는
것이다. `Clrscr`와 `Gotoxy`를 이용해 콘솔 화면과 커서 위치도 제어한다.
