Review Question and Exercise
=============
## Short Answer

1. Provide examples of three different instruction mnemonics.<br>
 [번역: 세 가지 다른 지시 연상법의 예를 제시하세요.]
    
        Answer: MOV,ADD, SUB
>(Mnemonic) - (의미)  
        1.MOV - 데이터 이동<br>
        2.ADD - 덧셈<br>
        3.SUB - 뺄셈<br>

2. What is a calling convention, and how is it used in assembly language declarations?<br>
 [번역: 호출 규약이란 무엇이며, 어셈블리 언어 선언에서 어떻게 사용되나요?]
    
        Answer:  
        Calling convention(호출 규약): 함수나 프로시저를 호출할 때 인자를 어떻게 전달하고, 반환값을 어떻게 전달하며, 스택과 레지스터를 누가 관리할지 등을 정한 규칙.

>프로시저 선언에서 "C", "STDCALL" 등의 형태로 호출 규약을 지정. MASM의 "PROTO" 선언에서는 이런 language-type을 지정.


3. How do you reserve space for the stack in a program?
<br>
 [번역: 프로그램에서 스택을 위해 공간을 어떻게 예약하나요?]
    
        Answer:  
        MASM에서는 .STACK directive를 사용하여 스택 공간을 예약할 수 있다.  
        ex) .STACK 2048 (2048 바이트 크기의 스택 영역을 정의)

> MASM의 .STACK은 스택 세그먼트를 정의하며, 크기를 생략하면 기본값은 1024바이트이다.  
>.STACK은 단순히 "현재 스택 포인터를 2048만큼 이동시킨다"는 의미가 아닌, 프로그램이 사용할 스택 영역 자체를 정의하는 directive

4. Explain why the term assembler language is not quite correct.
<br>
 [번역: 어셈블리어라는 용어가 왜 완전히 정확하지 않은지 설명하세요.]
    
        Answer:  
        Assembler는 프로그램(도구)의 이름이고, assembly language는 언어의 이름이기 때문에 "assembler language"라는 표현은 정확하지 않다.

>Assembly language = 언어  
Assembler = 그 언어를 기계어로 변환하는 프로그램


5. Explain the difference between big endian and little endian. Also, look up the origins of this
term on the Web.
<br>
 [번역: 빅 엔디안과 리틀 엔디안의 차이점을 설명하세요. 또한, 이 웹상의 용어의 기원을 찾아보세요.]
    
        Answer:
        차이점:  
        Big Endian은 가장 큰 자리의 바이트를 낮은 메모리 주소에 저장하고,  
        Little Endian은 가장 작은 자리의 바이트를 낮은 메모리 주소에 저장한다.  
          
        유래:  
        조너선 스위프트의 《걸리버 여행기》에서 Lilliput(릴리퍼트) 사람들이 삶은 달걀을 어느 쪽부터 깨먹어야 하는가를 가지고 싸우는 이야기에서 빗대어 컴퓨터 과학자 Danny Cohen이 1980년에 발표한 On Holy Wars and a Plea for Peace라는 글에서 사용하면서 알려지게 되었다.


6. Why might you use a symbolic constant rather than an integer literal in your code?
<br>
 [번역: 코드에서 정수 리터럴 대신 기호 상수를 사용하는 이유는 무엇인가요?]
    
        Answer:
        1. 코드가 읽기 쉬워진다. (숫자의 의미를 이해하기 용이해짐 [가독성+의미 전달])
        2. 숫자를 변경하기 쉽다. (정수값이 바뀌어도 상수의 값만 바꾸어주면 된다.)

7. How is a source file different from a listing file?
<br>
 [번역: 소스 파일은 리스팅 파일과 어떻게 다른가요?]
    
        Answer:  
        Source File은 내가 작성한 어셈블리 프로그램, 
        Listing File은 어셈블된 결과를 확인하거나 디버깅할 때 유용한 참고용 출력물
        
>Listing File은 어셈블러가 어셈블리 소스를 처리하면서 소스 코드와 변환 결과 등을 사람이 확인하기 좋게 기록한 파일.

8. How are data labels and code labels different?
<br>
 [번역: 데이터 라벨과 코드 라벨은 어떻게 다른가요?]
    
        Answer:
        Data label은 데이터가 저장된 메모리 위치를 나타내고(데이터의 주소에 붙인 이름),
        Code label은 실행할 명령어가 있는 메모리 위치를 나타낸다.(코드의 위치에 붙인 이름)

>Data label - 데이터를 저장하는 영역에서 특정 데이터의 위치에 이름을 붙임.
>Code label - 프로그램에서 특정 명령어가 시작되는 위치에 이름을 붙임.

9. (True/False): An identifier cannot begin with a numeric digit.
<br>
 [번역: (참/거짓): 식별자는 숫자로 시작할 수 없습니다.]
    
        Answer:
        True (참)

>Identifier(식별자)는 프로그램에서 변수, 상수, 프로시저, label 등에 붙이는 이름이며, 숫자는 뒤에 사용하는 것은 가능하다.

10. (True/False): A hexadecimal literal may be written as 0x3A.
<br>
 [번역: (참/거짓): 16진수 리터럴은 0x3A로 쓸 수 있습니다.]
    
        Answer:
        False (거짓)

>MASM에서 16진수는 3Ah처럼 표현이 되지만, 0x3A는 C/C++ 등에서 표현되는 16진수이다.

11. (True/False): Assembly language directives execute at runtime.
<br>
 [번역: (참/거짓): 어셈블리 언어 지시문은 실행 시점에 실행됩니다.]
    
        Answer:
        False (거짓)

>Directive(지시문)는 CPU가 아닌 어셈블러용 지시사항들이다. 따라서, 디렉티브는 어셈블리 타임에 처리되고, 런타임에는 실행되지 않는다.

12. (True/False): Assembly language directives can be written in any combination of uppercase and lowercase letters.
<br>
 [번역: (참/거짓): 어셈블리 언어 지시문은 대문자 그리고 소문자 조합으로 작성할 수 있습니다.]
    
        Answer:
        True (참)

>MASM에서는 대소문자를 구분하지 않는다.

13. Name the four basic parts of an assembly language instruction.
<br>
 [번역: 어셈블리 언어 명령어의 네 가지 기본 구성 요소를 말하세요.]
    
        Answer:
        1. Label
        2. Mnemonic
        3. Operand
        4. Comment

>-Label: 특정 메모리 위치에 붙인 이름  
>-Mnemonic: CPU가 수행할 연산을 나타내는 명령어의 이름  
>-Operand: 명령어가 어떤 떼이터를 대상으로 동작하는가를 나타냄  
>-Comment: 프로그램 사용자가 코드에 설명을 적어 놓는 부분

14. (True/False): MOV is an example of an instruction mnemonic.
<br>
 [번역: (참/거짓): MOV는 명령어 니모닉의 한 예입니다.]
    
        Answer:
        True (참)

>MOV는 데이터를 이동시키는 니모닉이다.  
ex) MOV EAX, EBX

15. (True/False): A code label is followed by a colon (:), but a data label does not end with a colon.
<br>
 [번역: (참/거짓): 코드 라벨은 콜론(:)으로 끝나지만, 데이터 라벨은 콜론으로 끝나지 않습니다.]
    
        Answer:
        True (참)

>MASM에서는 일반적으로 code label에는 콜론(:)을 붙이고, data label에는 콜론을 붙이지 않는다.

16. Show an example of a block comment.
<br>
 [번역: 블록 주석의 예를 보여주세요.]
    
        Answer:
        COMMENT !
        저는 지금 경성대학교에 다니는
        2학년생 입니다.
        현재 어셈블리프로그래밍을 배우고 있습니다.
        !

>"COMMENT" 지시문을 사용해서 여러 줄의 주석을 작성할 수 있다.  
"!"는 주석의 시작과 끝을 표시하는 구분 문자 역할을 한다.

17. Why is it not a good idea to use numeric addresses when writing instructions that access variables?
<br>
 [번역: 변수들에 접근하는 명령어를 작성할 때 숫자 주소를 사용하는 것이 왜 좋지 않은가요]
    
        Answer:
        숫자로 된 메모리 주소를 사용하면 프로그램의 유지보수가 어렵고, 데이터의 위치가 변경되었을 때 주소를 모두 수정해야 하기 때문이다.

18. What type of argument must be passed to the ExitProcess procedure?
<br>
 [번역: ExitProcess 프로시저에 전달해야 하는 인수는 어떤 종류여야 하나요?]
    
        Answer:
        ExitProcess에는 DWORD 타입의 종료 코드(exit code)를 전달한다.

>ExitProcess는 Windows 프로그램을 종료시키는 함수이며, 함수 선언은 다음과 같다.   
        >VOID ExitProcess(  
        UINT uExitCode  
        >);  
결국, UNIT은 32비트 unsigned integer이기에, MASM에서는 DWORD와 대응시켜 생각할 수 있다.

19. Which directive ends a procedure?
<br>
 [번역: 어떤 지시문이 절차를 종료합니까?]
    
        Answer:
        ENDP

>PROC은 Procedure를 시작하고, ENDP는 Procedure를 종료한다.

20. In 32-bit mode, what is the purpose of the identifier in the END directive?
<br>
 [번역: 32비트 모드에서 END 지시문에 있는 식별자의 목적은 무엇인가요?]
    
        Answer:
        32비트 MASM 프로그램에서  
        END 뒤의 identifier는 프로그램이 실행될 때 시작할, 프로그램의 시작점을 지정한다.

>END와 ENDP 비교  
>-main PROC => main Procedure 시작  
>-main ENDP => main Procedure 끝  
>-END main => 프로그램 종료 지시 + main을 entry point로 지정

21. What is the purpose of the PROTO directive?
<br>
 [번역: PROTO 지시문의 목적은 무엇인가요?]
    
        Answer:
        PROTO 디렉티브는 procedure의 프로토타입을 선언하여 procedure의 이름, 매게변수, 효출 규약 등을 어셈블러에게 미리 알려주는 역할이다.

22. (True/False): An Object file is produced by the Linker.
<br>
 [번역: (참/거짓): 링커는 오브젝트 파일을 생성합니다.]
    
        Answer:
        False (거짓)

23. (True/False): A Listing file is produced by the Assembler.
<br>
 [번역: (참/거짓): 어셈블러가 리스팅 파일을 생성합니다.]
    
        Answer:
        True (참)

>Listing file은 어셈블러가 생성하는 파일이다.  
어셈블러가 소스 코드를 처리하면서 소스 코드와 주소, 기계어 코드 등의 정보를 정리해서 listing file에 기록할 수 있다.

24. (True/False): A link library is added to a program just before producing an Executable file.
<br>
 [번역: (참/거짓): 링크 라이브러리는 실행 파일을 생성하기 직전에 프로그램에 추가됩니다.]
    
        Answer:
        True (참)

>Link library는 링커가 프로그램을 완성할 때 사용하는 라이브러리이다.  
즉 실행 파일을 만들기 위한 linking 과정에서 library가 사용된다.

25. Which data directive creates a 32-bit signed integer variable?
<br>
 [번역: 어떤 데이터 지시자가 32비트 부호 있는 정수 변수를 생성하나요?]
    
        Answer:
        SDWORD

>MASM에서는 signed integer(부호 있는 정수)를 나타내는 자료형으로 SDWORD 등을 사용할 수 있다.

26. Which data directive creates a 16-bit signed integer variable?
<br>
 [번역: 어떤 데이터 지시자가 16비트 부호 있는 정수 변수를 생성합니까?]
    
        Answer:
        SWORD

>WORD는 16비트이고, 앞에 S가 붙으면 signed를 의미한다.

27. Which data directive creates a 64-bit unsigned integer variable?
<br>
 [번역: 어떤 데이터 지시자가 64비트 부호 없는 정수 변수를 생성합니까?]
    
        Answer:
        QWORD

>64부호를 의미하는 'Q'가 붙고, 부호가 없는 unsigned이기에 'S'는 붙이지 않기에 QWORD가 된다.

28. Which data directive creates an 8-bit signed integer variable?
<br>
 [번역: 어떤 데이터 지시자가 8비트 부호 있는 정수 변수를 생성합니까?]
    
        Answer:
        SBYTE

>SBYTE = 8-bit signed integer

29. Which data directive creates a 10-byte packed BCD variable?
<br>
 [번역: 10바이트 패킹 BCD 변수를 생성하는 데이터 지시어는 무엇인가요?]
    
        Answer:
        TBYTE

>TBYTE는 10바이트(80비트) 데이터를 정의할 때 사용하며,  MASM에서 packed decimal/ packed BCD 값을 저장하는데 사용할 수 있다.  
BCD = Binary-Coded Decimal  
TBYTE는 10-Byte packed Decimal 저장에 사용