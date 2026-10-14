# Random Screen Locations - 무작위 화면 위치

## 1. 문제 번역

100밀리초의 시간 지연을 사용하면서, 화면의 무작위 위치 100곳에 문자 하나를 출력하는 프로그램을 작성하시오.

## 2. 전체 어셈블리 코드 (MASM + Irvine32)

```asm
INCLUDE Irvine32.inc

.data
    maxColumns BYTE ?
    maxRows    BYTE ?

.code
main PROC
    ; 난수 생성기를 초기화한다.
    call Randomize

    ; 콘솔 창의 최대 열(DL)과 행(DH)을 구한다.
    call GetMaxXY
    mov maxColumns, dl
    mov maxRows, dh

    ; 문자를 100회 출력한다.
    mov ecx, 100

L1:
    ; 무작위 열 좌표를 생성한다.
    movzx eax, maxColumns
    call RandomRange
    mov dl, al

    ; 무작위 행 좌표를 생성한다.
    movzx eax, maxRows
    call RandomRange
    mov dh, al

    ; 지정한 위치로 커서를 이동한다.
    call Gotoxy

    ; 별표 하나를 출력한다.
    mov al, '*'
    call WriteChar

    ; 100밀리초 대기한다.
    mov eax, 100
    call Delay

    loop L1

    ; 마지막에 커서를 화면 왼쪽 위로 이동한다.
    mov dh, 0
    mov dl, 0
    call Gotoxy

    exit
main ENDP
END main
```

## 3. 코드 해석

| 코드 | 설명 |
|---|---|
| `call Randomize` | 난수 생성기를 초기화한다. |
| `call GetMaxXY` | 콘솔 창의 최대 열(DL)과 행(DH)을 구한다. |
| `mov maxColumns, dl` | 최대 열 수를 저장한다. |
| `mov maxRows, dh` | 최대 행 수를 저장한다. |
| `mov ecx, 100` | 반복 횟수를 100회로 설정한다. |
| `movzx eax, maxColumns` | 열 수를 EAX에 0 확장하여 저장한다. |
| `call RandomRange` | 0 이상 최대 열 수 미만의 난수를 생성한다. |
| `mov dl, al` | 생성한 난수를 열 좌표로 설정한다. |
| `movzx eax, maxRows` | 행 수를 EAX에 0 확장하여 저장한다. |
| `call RandomRange` | 0 이상 최대 행 수 미만의 난수를 생성한다. |
| `mov dh, al` | 생성한 난수를 행 좌표로 설정한다. |
| `call Gotoxy` | DH(행), DL(열)로 커서를 이동한다. |
| `mov al, '*'` / `call WriteChar` | 별표 하나를 현재 위치에 출력한다. |
| `mov eax, 100` / `call Delay` | 100밀리초 동안 대기한다. |
| `loop L1` | 위 과정을 100회 반복한다. |

### GetMaxXY의 반환값

Irvine32의 `GetMaxXY`는 콘솔 창 크기를 다음과 같이 반환한다.

- **DL**: 최대 열 수 (X)
- **DH**: 최대 행 수 (Y)

예를 들어 콘솔 크기가 80열, 25행이라면 DL = 80, DH = 25가 된다. 화면 좌표는 0부터 시작하므로 유효한 좌표는 열 0~79, 행 0~24다.

## 4. 실행 과정

1. `GetMaxXY`로 현재 콘솔 창의 크기를 확인한다.
2. `RandomRange`로 무작위 열 좌표를 생성한다.
3. 다시 `RandomRange`로 무작위 행 좌표를 생성한다.
4. `Gotoxy`로 커서를 해당 위치로 이동한다.
5. `WriteChar`로 별표(*)를 출력한다.
6. `Delay`로 100밀리초 동안 대기한다.
7. `loop` 명령어로 다음 반복을 진행한다.

각 반복에서 행과 열을 독립적으로 무작위 선택하므로 같은 위치가 여러 번 선택될 수 있다. 따라서 100회 출력해도 별표가 찍힌 고유한 위치는 100개보다 적을 수 있다.

## 5. 예상 실행 결과

실행하면 별표가 화면 곳곳에 하나씩 나타난다.

```text
             *                    *
  *                       *
                   *               *
       *                     *
                            *
 *             *                  *
                   *       *
        *                  *
```

## 6. 핵심 정리

- **GetMaxXY**: 콘솔 창의 크기 확인 (DL = 열, DH = 행)
- **RandomRange**: 무작위 좌표 생성
- **Gotoxy**: 커서 위치 이동 (DH = 행, DL = 열)
- **WriteChar**: 문자 하나 출력
- **Delay**: 지정한 밀리초만큼 대기
- **loop**: 100회 반복