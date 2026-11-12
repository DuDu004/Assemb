# Short Answer

## 1. Which Direction flag setting causes index registers to move backward through memory when executing string primitives?

**한글 번역**

문자열 기본 명령어(string primitives)를 실행할 때 인덱스 레지스터가 메모리의 역방향으로 이동하게 하는 방향 플래그(Direction Flag) 설정은 무엇인가?

**정답**

**DF = 1 (Set, `STD`)**. 인덱스 레지스터가 감소한다.

## 2. When a repeat prefix is used with STOSW, what value is added to or subtracted from the index register?

**한글 번역**

`STOSW`에 반복 접두사(repeat prefix)를 사용하면 인덱스 레지스터에 얼마를 더하거나 빼는가?

**정답**

**2바이트**. DF=0이면 `EDI += 2`, DF=1이면 `EDI -= 2`.

## 3. In what way is the CMPS instruction ambiguous?

**한글 번역**

`CMPS` 명령어는 어떤 점에서 모호한가?

**정답**

**비교 대상이 명령어에 명시되지 않고 `ESI`와 `EDI`에 암묵적으로 지정된다.** 따라서 명령어만으로는 어느 메모리 값을 기준으로 비교하는지, 특히 크기 비교 플래그를 어떻게 해석할지 혼동할 수 있다. `CMPS`는 `[ESI]`와 `[EDI]`를 비교하며, 비교 플래그는 `[ESI] - [EDI]`를 기준으로 설정된다.

## 4. When the Direction flag is clear and SCASB has found a matching character, where does EDI point?

**한글 번역**

방향 플래그가 0일 때 `SCASB`가 일치하는 문자를 찾았다면 `EDI`는 어디를 가리키는가?

**정답**

**일치하는 문자 바로 다음 바이트**를 가리킨다. (DF=0이면 비교 후 `EDI`가 1 증가함.)

## 5. When scanning an array for the first occurrence of a particular character, which repeat prefix would be best?

**한글 번역**

배열에서 특정 문자가 처음 등장하는 위치를 검색할 때 가장 적절한 반복 접두사는 무엇인가?

**정답**

**`REPNE` (`REPNZ`)**. 예: `REPNE SCASB`.

## 6. What Direction flag setting is used in the Str_trim procedure from Section 9.3?

**한글 번역**

9.3절의 `Str_trim` 프로시저는 어떤 방향 플래그 설정을 사용하는가?

**정답**

**방향 플래그를 설정하거나 변경하지 않는다.** 역방향 검색은 `DEC EDI`로 직접 처리하며 문자열 기본 명령어를 사용하지 않는다.

## 7. Why does the Str_trim procedure from Section 9.3 use the JNE instruction?

**한글 번역**

9.3절의 `Str_trim` 프로시저에서 `JNE` 명령어를 사용하는 이유는 무엇인가?

**정답**

**현재 문자가 제거 대상 문자와 다르면 역방향 탐색을 중단하고, 그 문자 바로 뒤에 널 문자(0)를 넣기 위해서**이다.

## 8. What happens in the Str_ucase procedure from Section 9.3 if the target string contains a digit?

**한글 번역**

9.3절의 `Str_ucase` 프로시저에서 대상 문자열에 숫자 문자가 포함되어 있으면 어떻게 되는가?

**정답**

**숫자는 변경되지 않는다.** 소문자 `a`~`z`에 해당하지 않으므로 그대로 두고 다음 문자로 이동한다.

## 9. If the Str_length procedure from Section 9.3 used SCASB, which repeat prefix would be most appropriate?

**한글 번역**

9.3절의 `Str_length` 프로시저가 `SCASB`를 사용한다면 어떤 반복 접두사가 가장 적절한가?

**정답**

**`REPNE` (`REPNZ`)**. 널 종료 문자(`00h`)를 만날 때까지 검색한다.

## 10. If the Str_length procedure from Section 9.3 used SCASB, how would it calculate and return the string length?

**한글 번역**

9.3절의 `Str_length` 프로시저가 `SCASB`를 사용한다면 문자열의 길이를 어떻게 계산하여 반환할 수 있는가?

**정답**

**`EDI`의 최종 주소 − 문자열 시작 주소 − 1**로 길이를 계산하여 `EAX`에 반환한다. `REPNE SCASB`가 널 문자까지 검사한 후 `EDI`는 널 문자 다음 위치를 가리키므로 1을 뺀다. (동일하게 `최초 ECX − 남은 ECX − 1`로 계산 가능.)

## 11. What is the maximum number of comparisons needed by the binary search algorithm when an array contains 1,024 elements?

**한글 번역**

원소가 1,024개인 배열에서 이진 탐색(binary search)에 필요한 최대 비교 횟수는 얼마인가?

**정답**

**교재 표 9-6의 답: 10회** (`log₂ 1024 = 10`).

## 12. In the FillArray procedure from the Binary Search example in Section 9.5, why must the Direction flag be cleared by the CLD instruction?

**한글 번역**

9.5절의 이진 탐색 예제에 있는 `FillArray` 프로시저에서 `CLD` 명령어로 방향 플래그를 반드시 0으로 설정해야 하는 이유는 무엇인가?

**정답**

**`STOSD`가 저장 후 `EDI`를 4바이트씩 증가시켜 배열을 앞에서 뒤로 채우도록 하기 위해서**이다. DF=1이면 주소가 감소한다.

## 13. In the BinarySearch procedure from Section 9.5, why could the statement at label L2 be removed without affecting the outcome?

**한글 번역**

9.5절의 `BinarySearch` 프로시저에서 레이블 `L2`의 명령문을 제거해도 결과가 달라지지 않는 이유는 무엇인가?

**정답**

**`L2`의 `CMP EDX, EDI`가 중복 비교이기 때문이다.** 바로 앞에서 실행한 `CMP EDX, EDI`의 플래그가 `JGE L2` 분기로 이동해도 그대로 유지되므로, `L2`에서 다시 비교하지 않고 `JLE L3`를 실행할 수 있다.

## 14. In the BinarySearch procedure from Section 9.5, how might the statement at label L4 be eliminated?

**한글 번역**

9.5절의 `BinarySearch` 프로시저에서 레이블 `L4`의 명령문을 어떻게 제거할 수 있는가?

**정답**

**두 군데의 `JMP L4`를 각각 `JMP L1`로 변경하고, `L4: JMP L1`을 삭제한다.** 이렇게 하면 불필요한 중간 점프가 제거된다.

---
