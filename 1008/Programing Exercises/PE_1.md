# 1번. Draw Text Colors (텍스트 색상 출력)

## 1. 문제 설명

**Draw Text Colors --- 텍스트 색상 출력**

반복문(`loop`)을 사용하여 **동일한 문자열을 네 가지 서로 다른 색상으로
출력**하는 프로그램을 작성한다.

-   교재의 링크 라이브러리에 포함된 `SetTextColor` 프로시저를 호출한다.
-   색상은 자유롭게 선택할 수 있다.
-   전경색(Foreground Color)만 변경하는 방식이 가장 간단하다.

## 2. 어셈블리 코드 (MASM + Irvine32)

``` asm
INCLUDE Irvine32.inc

.data
    message BYTE "Assembly Programming", 0

    ; 출력에 사용할 네 가지 전경색
    colors DWORD lightRed, lightGreen, lightBlue, yellow

.code
main PROC
    ; ESI: 현재 색상의 주소
    ; ECX: 반복 횟수 (4회)
    mov esi, OFFSET colors
    mov ecx, LENGTHOF colors

L1:
    ; 현재 색상 값을 EAX에 저장하고 색상 변경
    mov eax, [esi]
    call SetTextColor

    ; 문자열 출력
    mov edx, OFFSET message
    call WriteString
    call Crlf

    ; 다음 색상으로 이동 (DWORD = 4바이트)
    add esi, TYPE colors

    ; ECX를 감소시키고 0이 아니면 L1로 이동
    loop L1

    ; 밝은 회색 전경색과 검은색 배경색으로 복원
    mov eax, lightGray + (black * 16)
    call SetTextColor

    exit
main ENDP
END main
```

## 3. 코드 해설

  --------------------------------------------------------------------------------------------
  코드                                                     의미
  -------------------------------------------------------- -----------------------------------
  `INCLUDE Irvine32.inc`                                   Irvine32 라이브러리의 선언과 기능을
                                                           사용한다.

  `message BYTE "Assembly Programming", 0`                 출력할 문자열을 선언한다. 마지막
                                                           `0`은 문자열의 끝을 나타낸다.

  `colors DWORD lightRed, lightGreen, lightBlue, yellow`   네 가지 색상 값을 배열에 저장한다.

  `mov esi, OFFSET colors`                                 `ESI`에 색상 배열의 시작 주소를
                                                           저장한다.

  `mov ecx, LENGTHOF colors`                               배열 원소 개수인 `4`를 반복 횟수로
                                                           설정한다.

  `mov eax, [esi]`                                         현재 위치의 색상 값을 `EAX`로
                                                           가져온다.

  `call SetTextColor`                                      `EAX`에 지정된 색상 값으로 텍스트
                                                           색상을 변경한다.

  `mov edx, OFFSET message`                                `EDX`에 문자열의 시작 주소를
                                                           저장한다.

  `call WriteString`                                       문자열을 출력한다.

  `call Crlf`                                              줄을 바꾼다.

  `add esi, TYPE colors`                                   `ESI`를 다음 색상 원소로 이동한다.
                                                           `DWORD`이므로 4바이트 증가한다.

  `loop L1`                                                `ECX`를 1 감소시킨 후, 0이 아니면
                                                           `L1`로 돌아간다.

  `exit`                                                   프로그램을 종료한다.
  --------------------------------------------------------------------------------------------

## 4. 핵심 개념

-   **`LENGTHOF colors`**: 배열의 원소 개수를 반환한다. 여기서는
    `4`이다.
-   **`TYPE colors`**: 배열 원소 하나의 크기를 바이트 단위로 반환한다.
    여기서는 `4`이다.
-   **`loop L1`**: `ECX`를 자동으로 감소시키고, 0이 아니면 지정된
    레이블로 이동한다. 따라서 별도의 `dec ecx` 명령이 필요하지 않다.
-   **`SetTextColor`**: Irvine32 라이브러리의 프로시저로, `EAX`에 전달한
    색상 속성을 이용해 콘솔 텍스트 색상을 바꾼다.

## 5. 실행 과정

반복문이 실행될 때마다 `ESI`가 다음 색상 원소를 가리킨다.

    반복 `EAX`에 전달되는 색상   실행 결과
  ------ ----------------------- ---------------------------
     1회 `lightRed`              빨간색 계열로 문자열 출력
     2회 `lightGreen`            초록색 계열로 문자열 출력
     3회 `lightBlue`             파란색 계열로 문자열 출력
     4회 `yellow`                노란색으로 문자열 출력

각 반복에서는 다음 순서로 작업한다.

1.  현재 색상 값을 `EAX`에 저장한다.
2.  `SetTextColor`를 호출해 텍스트 색상을 변경한다.
3.  `WriteString`으로 문자열을 출력한다.
4.  `Crlf`로 줄을 바꾼다.
5.  `ESI`를 다음 색상으로 이동하고 `loop`로 반복한다.

## 6. 예상 실행 결과

콘솔에는 동일한 문자열이 네 줄 출력되며, 각 줄의 글자색은 서로 다르다.

``` text
Assembly Programming
Assembly Programming
Assembly Programming
Assembly Programming
```

> **참고:** 실제 글자색은 Irvine32 라이브러리의 색상 상수와 콘솔 환경에
> 따라 달라질 수 있다.
