# Short Answer

## 1. STRUCT 지시어의 목적

**영문 문제**

What is the purpose of the STRUCT directive?

**한글 번역**

`STRUCT` 지시어의 목적은 무엇인가?

**답**

여러 필드를 하나의 사용자 정의 구조체 자료형으로 정의하는 지시어다. `STRUCT`로 구조체 정의를 시작하고 `ENDS`로 끝낸다.

## 2. 구조체 변수 선언의 유효성 판단

**영문 문제**

Assume that the following structure has been defined:

```asm
RentalInvoice STRUCT
    invoiceNum BYTE 5 DUP(' ')
    dailyPrice WORD ?
    daysRented WORD ?
RentalInvoice ENDS
```

State whether or not each of the following declarations is valid:

```asm
a. rentals RentalInvoice <>
b. RentalInvoice rentals <>
c. march RentalInvoice <'12345',10,0>
d. RentalInvoice <,10,0>
e. current RentalInvoice <,15,0,0>
```

**한글 번역**

위와 같이 `RentalInvoice` 구조체가 정의되어 있다고 가정한다. 다음 a~e의 구조체 변수 선언이 각각 올바른지 판단하시오.

**답**

| 항목 | 유효 여부          | 이유                                                                           |
| ---- | ------------------ | ------------------------------------------------------------------------------ |
| a    | **유효 (Valid)**   | `변수명 구조체형 <>` 형식이며 필드의 기본 초기값을 사용한다.                   |
| b    | **무효 (Invalid)** | 변수명과 구조체형의 순서가 바뀌었다.                                           |
| c    | **유효 (Valid)**   | 필드 3개에 맞는 초기값을 지정한다. `'12345'`는 5바이트 문자열 필드에 들어간다. |
| d    | **무효 (Invalid)** | 구조체 변수 이름이 없다.                                                       |
| e    | **무효 (Invalid)** | 구조체의 필드는 3개인데 초기값은 4개다.                                        |

## 3. 매크로에서 데이터 선언 가능 여부

**영문 문제**

(True/False): A macro cannot contain data definitions.

**한글 번역**

참/거짓: 매크로에는 데이터 정의를 포함할 수 없다.

**답**

**False (거짓).** 매크로에는 `BYTE`, `DWORD` 같은 데이터 정의를 포함할 수 있다.

## 4. LOCAL 지시어의 목적

**영문 문제**

What is the purpose of the LOCAL directive?

**한글 번역**

`LOCAL` 지시어의 목적은 무엇인가?

**답**

매크로에서 `LOCAL`은 매크로를 확장할 때마다 **고유한 지역 레이블 이름**을 생성하여 중복 정의를 방지한다. 프로시저에서 사용할 때는 지역 변수를 선언한다.

## 5. 어셈블 과정의 메시지 출력 지시어

**영문 문제**

Which directive displays a message on the console during the assembly step?

**한글 번역**

어셈블 과정에서 콘솔에 메시지를 출력하는 지시어는 무엇인가?

**답**

**`ECHO` 지시어.** 프로그램 실행 중이 아니라 어셈블할 때 메시지를 출력한다.

## 6. 조건부 블록 종료 지시어

**영문 문제**

Which directive marks the end of a conditional block of statements?

**한글 번역**

조건부 문장 블록의 끝을 표시하는 지시어는 무엇인가?

**답**

**`ENDIF` 지시어.** `IF`로 시작한 조건부 어셈블 블록을 종료한다.

## 7. 상수 불리언 식의 관계 연산자

**영문 문제**

List all the relational operators that can be used in constant boolean expressions.

**한글 번역**

상수 불리언 식에서 사용할 수 있는 모든 관계 연산자를 나열하시오.

**답**

`EQ`(같음), `NE`(같지 않음), `LT`(작음), `LE`(작거나 같음), `GT`(큼), `GE`(크거나 같음).

## 8. 매크로의 & 연산자

**영문 문제**

What is the purpose of the & operator in a macro definition?

**한글 번역**

매크로 정의에서 `&` 연산자의 목적은 무엇인가?

**답**

**치환 연산자(Substitution Operator)**다. 문자나 문자열 안에서 매크로 매개변수를 실제 전달 인수로 치환하도록 한다.

## 9. 매크로의 ! 연산자

**영문 문제**

What is the purpose of the ! operator in a macro definition?

**한글 번역**

매크로 정의에서 `!` 연산자의 목적은 무엇인가?

**답**

**리터럴 문자 연산자(Literal-Character Operator)**다. 다음 문자를 매크로 구문 기호가 아닌 일반 문자로 취급하도록 한다.

## 10. 매크로의 % 연산자

**영문 문제**

What is the purpose of the % operator in a macro definition?

**한글 번역**

매크로 정의에서 `%` 연산자의 목적은 무엇인가?

**답**

**확장 연산자(Expansion Operator)**다. 상수식을 계산하여 텍스트 값으로 변환하거나 텍스트 매크로를 확장한다.

---
