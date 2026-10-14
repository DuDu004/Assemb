# 2번. Linking Array Items (배열 항목 연결하기)

## 1. 문제 설명

**Linking Array Items --- 배열 항목 연결하기**

시작 인덱스, 문자 배열, 링크 인덱스 배열이 주어졌을 때, 링크를 따라가며
문자를 올바른 순서로 찾고 새로운 배열에 순서대로 복사하는 프로그램을
작성한다.

-   배열의 인덱스는 `0`부터 시작한다.
-   문자 배열은 `BYTE` 형식으로 선언한다.
-   링크 배열은 `DWORD` 형식으로 선언한다.

### 주어진 데이터

  항목                    값
  ----------------------- -------------------
  시작 인덱스 (`start`)   `1`
  문자 배열 (`chars`)     `H A C E B D F G`
  인덱스                  `0 1 2 3 4 5 6 7`
  링크 배열 (`links`)     `0 4 5 6 2 3 7 0`

**예상 결과:** `ABCDEFGH`

## 2. 전체 어셈블리 코드 (MASM + Irvine32)

``` asm
INCLUDE Irvine32.inc

.data
    startIndex DWORD 1

    ; 문자 배열: 각 문자는 1바이트
    chars BYTE 'H', 'A', 'C', 'E', 'B', 'D', 'F', 'G'

    ; 링크 배열: 각 인덱스는 4바이트
    links DWORD 0, 4, 5, 6, 2, 3, 7, 0

    ; 결과 문자열: 문자 8개 + 문자열 종료 문자 0
    newArray BYTE 9 DUP(0)

.code
main PROC
    ; 시작 인덱스와 결과 배열 주소 설정
    mov esi, startIndex
    mov edi, OFFSET newArray

    ; 문자 8개를 처리
    mov ecx, LENGTHOF chars

L1:
    ; 현재 인덱스에 해당하는 문자를 결과 배열에 복사
    mov al, chars[esi]
    mov [edi], al
    inc edi

    ; 현재 인덱스의 링크를 따라 다음 인덱스로 이동
    mov esi, links[esi * TYPE links]

    ; 다음 문자 처리
    loop L1

    ; 완성된 문자열 출력
    mov edx, OFFSET newArray
    call WriteString
    call Crlf

    exit
main ENDP
END main
```

## 3. 코드 해설

  ------------------------------------------------------------------------
  코드                                 설명
  ------------------------------------ -----------------------------------
  `startIndex DWORD 1`                 탐색을 시작할 인덱스를 `1`로
                                       지정한다.

  `chars BYTE ...`                     문자 8개를 각각 1바이트씩 저장한다.

  `links DWORD ...`                    다음에 방문할 인덱스를 각각
                                       4바이트씩 저장한다.

  `newArray BYTE 9 DUP(0)`             문자 8개와 문자열 종료 문자 `0`을
                                       저장할 공간을 확보한다.

  `mov esi, startIndex`                `ESI`에 시작 인덱스 `1`을 저장한다.

  `mov edi, OFFSET newArray`           `EDI`에 결과 배열의 시작 주소를
                                       저장한다.

  `mov ecx, LENGTHOF chars`            반복 횟수를 문자 개수인 `8`로
                                       설정한다.

  `mov al, chars[esi]`                 현재 인덱스의 문자를 `AL`에
                                       저장한다.

  `mov [edi], al`                      해당 문자를 결과 배열에 복사한다.

  `inc edi`                            결과 배열의 다음 바이트 위치로
                                       이동한다.

  `mov esi, links[esi * TYPE links]`   현재 인덱스에 해당하는 링크 값을
                                       읽어 다음 인덱스로 이동한다.

  `loop L1`                            `ECX`를 1 감소시키고, 0이 아니면
                                       `L1`로 돌아간다.

  `call WriteString`                   결과 배열을 문자열로 출력한다.
  ------------------------------------------------------------------------

## 4. 핵심 개념: BYTE 배열과 DWORD 배열의 차이

문자 배열 `chars`는 `BYTE` 형식이므로 원소 하나의 크기는
**1바이트**이다. 따라서 `chars[esi]`로 인덱스에 해당하는 문자를 읽을 수
있다.

반면 링크 배열 `links`는 `DWORD` 형식이므로 원소 하나의 크기는
**4바이트**이다. 인덱스가 `ESI`일 때 해당 원소의 바이트 오프셋은 다음과
같다.

\[ `\text{주소 오프셋}`{=tex} = ESI `\times 4`{=tex} \]

MASM에서 `TYPE links`는 `4`이므로 다음 명령어가 현재 인덱스에 해당하는
링크 값을 읽는다.

``` asm
mov esi, links[esi * TYPE links]
```

예를 들어 `ESI = 1`이면 `links[1]`의 값인 `4`를 읽고, 다음 탐색 인덱스를
`4`로 변경한다.

## 5. 실행 과정

초기 인덱스는 `1`이다. 각 반복에서는 현재 인덱스의 문자를 결과 배열에
복사한 다음, 링크 배열에서 다음 인덱스를 가져온다.

    반복   현재 인덱스  읽은 문자    링크 값 (다음 인덱스) 결과 배열
  ------ ------------- ----------- ----------------------- ------------
       1             1      A                            4 `A`
       2             4      B                            2 `AB`
       3             2      C                            5 `ABC`
       4             5      D                            3 `ABCD`
       5             3      E                            6 `ABCDE`
       6             6      F                            7 `ABCDEF`
       7             7      G                            0 `ABCDEFG`
       8             0      H                            0 `ABCDEFGH`

총 8회 반복한 뒤 탐색을 종료한다. 마지막에 링크 값이 `0`이더라도 반복
횟수가 `LENGTHOF chars`, 즉 8회로 정해져 있으므로 추가 반복은 발생하지
않는다.

## 6. 예상 실행 결과

``` text
ABCDEFGH
```

## 정리

이 문제의 핵심은 **문자 배열에서 현재 인덱스의 문자를 복사하고, 링크
배열의 값을 이용해 다음 인덱스로 이동하는 것**이다.

-   `chars`는 `BYTE` 배열이므로 문자 하나씩 읽는다.
-   `links`는 `DWORD` 배열이므로 `TYPE links`를 이용해 원소 크기를
    고려한다.
-   `ESI`는 현재 인덱스, `EDI`는 결과 배열의 쓰기 위치, `ECX`는 반복
    횟수를 관리한다.
-   `newArray`의 마지막 바이트는 `0`으로 초기화되어 있으므로
    `WriteString`이 문자열 끝을 인식할 수 있다.
