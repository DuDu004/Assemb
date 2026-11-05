# Review Questions and Exercises

## Short Answer

### 1. Which statements belong in a procedure’s epilogue when the procedure has stack parameters and local variables?

**한글 번역**

프로시저에 스택 매개변수와 지역 변수가 있을 때, 프로시저의 에필로그(epilogue)에는 어떤 명령문이 포함되어야 하는가?

**정답**  
일반적인 핵심 명령은 `MOV ESP, EBP`, `POP EBP`, `RET n`이다. (`n`: 피호출자가 정리할 매개변수 바이트 수. C 호출 규약이면 `RET`만 사용.)  
저장한 레지스터를 복원하고, 지역 변수에 할당한 스택 공간을 해제한 다음, 이전 `EBP`를 복원하고 반환한다.

---
### 2. When a C function returns a 32-bit integer, where is the return value stored?

**한글 번역**

C 함수가 32비트 정수를 반환할 때, 반환값은 어디에 저장되는가?

**정답**  
`EAX` 레지스터.

---
### 3. How does a program using the STDCALL calling convention clean up the stack after a procedure call?

**한글 번역**

STDCALL 호출 규약을 사용하는 프로그램에서는 프로시저 호출 후 스택을 어떻게 정리하는가?

**정답**  
호출된 프로시저가 `RET n` 명령으로 매개변수 `n`바이트를 스택에서 제거한다.

---
### 4. How is the LEA instruction more powerful than the OFFSET operator?

**한글 번역**

`LEA` 명령어는 `OFFSET` 연산자보다 어떤 점에서 더 강력한가?

**정답**  
`LEA`는 레지스터와 변위 등을 이용한 유효 주소를 **실행 중에 계산**할 수 있지만, `OFFSET`은 **어셈블 시점에 결정되는 주소**를 나타낸다.

---
### 5. In the C++ example shown in Section 8.2.3, how much stack space is used by a variable of type int?

**한글 번역**

8.2.3절의 C++ 예제에서 `int`형 변수 하나가 사용하는 스택 공간은 얼마인가?

**정답**  
**4바이트(32비트).**

---
### 6. What advantages might the C calling convention have over the STDCALL calling convention?

**한글 번역**

C 호출 규약은 STDCALL 호출 규약에 비해 어떤 장점이 있는가?

**정답**  
**가변 개수의 인수(variable arguments)**를 전달할 수 있다. 호출자가 스택을 정리하므로 인수 개수가 호출마다 달라도 된다.

---
### 7. (True/False): When using the PROC directive, all parameters must be listed on the same line.

**한글 번역**

(참/거짓): `PROC` 지시어를 사용할 때 모든 매개변수를 반드시 같은 줄에 작성해야 한다.

**정답**  
**False (거짓).**

---
### 8. (True/False): If you pass a variable containing the offset of an array of bytes to a procedure that expects a pointer to an array of words, the assembler will flag this as an error.

**한글 번역**

(참/거짓): 워드 배열을 가리키는 포인터를 요구하는 프로시저에 바이트 배열의 오프셋이 들어 있는 변수를 전달하면, 어셈블러가 오류로 표시한다.

**정답**  
**False (거짓).**

---
### 9. (True/False): If you pass an immediate value to a procedure that expects a reference parameter, you can generate a general-protection fault.

**한글 번역**

(참/거짓): 참조 매개변수를 요구하는 프로시저에 즉시값을 전달하면 일반 보호 오류(general-protection fault)가 발생할 수 있다.

**정답**  
**True (참).**
