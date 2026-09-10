Review Question
=============

1. In 32-bit mode, aside from the stack pointer (ESP), what other register points to variables on the stack?   
       [ 번역: 32비트 모드에서 스택 포인터(ESP) 이외에, 스택에 있는 변수들을 가리키는 또 다른 레지스터는 무엇인가? ]

       Answer: EBP (Base Pointer Register)
>x86에서 스택을 사용할 때 대표적으로 다음 두 레지스터가 사용됨.   
>- ESP (Extended Stack Pointer): 현재 스택의 꼭대기(top)를 가리킴   
>- EBP (Extended Base Pointer): 현재 함수의 스택 프레임을 기준으로 변수나 매개변수에 접근할 때 사용
<hr/>

2. Name at least four CPU status flags.   
[ 번역: CPU 상태 플래그를 최소 4개 쓰시오. ]

        Answer: CF (Carry Flag), 
                ZF (Zero Flag),
                SF (Sign Flag),
                OF (Overflow Flag)
                AC (Auxiliary Carry Flag)
                PF (Parity Flag)
>- CF (Carry Flag) — 자리올림/빌림 발생
>- ZF (Zero Flag) — 연산 결과가 0
>- SF (Sign Flag) — 연산 결과가 음수
>- OF (Overflow Flag) — 부호 있는 연산에서 오버플로
>- PF (Parity Flag) — 결과의 하위 바이트에서 1의 개수가 짝수
>- AF (Auxiliary Carry Flag) — 비트 3에서 비트 4로 carry/borrow 발생


<hr/>

3. Which flag is set when the result of an unsigned arithmetic operation is too large to fit into the destination?   
[ 번역: 부호 없는(unsigned) 산술 연산의 결과가 목적지(destination)에 저장할 수 있는 범위를 초과할 때 설정되는 플래그는 무엇인가? ]

        Answer: CF (Carry Flag)
<hr/>
    

4. Which flag is set when the result of a signed arithmetic operation is either too large or too small to fit into the destination?   
[ 번역: 부호 있는(signed) 산술 연산의 결과가 목적지(destination)에 저장할 수 있는 범위보다 너무 크거나 작을 때 설정되는 플래그는 무엇인가? ]

        Answer: OF (Overflow Flag)
> 연산 종류	범위를 벗어났을 때   
>- Unsigned: CF   
>- Signed: OF
<hr/>

5. (True/False): When a register operand size is 32 bits and the REX prefix is used, the R8D register is available for programs to use.   
[ 번역: (참/거짓) 레지스터 피연산자의 크기가 32비트이고 REX prefix가 사용되면, R8D 레지스터를 프로그램에서 사용할 수 있다. ]

        Answer: True
>- R8   → 64-bit
>- R8D  → 32-bit
>- R8W  → 16-bit
>- R8B  → 8-bit

<hr/>

6. Which flag is set when an arithmetic or logical operation generates a negative result?   
[ 번역: 산술 또는 논리 연산의 결과가 음수이면 어떤 플래그가 설정되는가? ]

        Answer: SF (Sign Flag)
<hr/>

7. Which part of the CPU performs floating-point arithmetic?   
[ 번역: CPU의 어느 부분이 부동소수점 연산을 수행하는가? ]

        Answer: FPU (Floating-Point Unit)
>FPU는 <strong>Floating-Point Unit(부동소수점 연산 장치)</strong>의 약자로, 실수와 같은 부동소수점 값에 대한 덧셈, 뺄셈, 곱셈, 나눗셈 등의 연산을 담당한다.
<hr/>

8. On a 32-bit processor, how many bits are contained in each floating-point data register?   
[ 번역: 32비트 프로세서에서 각각의 부동소수점 데이터 레지스터에는 몇 비트가 포함되어 있는가? ]

        Answer: 80 bits
>전통적인 x86 프로세서의 x87 부동소수점 레지스터는 80비트 크기.   
> 이 레지스터들은 32비트 프로세서에서도 정수용 레지스터의 크기인 32비트와 관계없이 80비트의 확장 정밀도 부동소수점 값을 저장할 수 있다.
<hr/>

9. (True/False): The x86-64 instruction set is backward-compatible with the x86 instruction set.   
[ 번역: (참/거짓) x86-64 명령어 집합은 x86 명령어 집합과 하위 호환된다. ]

        Answer: True
>x86-64는 기존 x86 명령어 집합을 확장한 형태이므로 기존 x86 프로그램과 명령어를 지원한다. 새로운 64비트 기능을 제공하면서 기존 x86 소프트웨어와의 호환성을 유지한다.
<hr/>

10. (True/False): In current 64-bit chip implementations, all 64 bits are used for addressing.   
[ 번역: (참/거짓) 현재의 64비트 칩 구현에서는 64비트 전체가 주소 지정(addressing)에 사용된다. ]

        Answer: False
> 64비트 프로세서라고 해서 실제 메모리 주소에 64비트 전체를 항상 사용하는 것은 아니다.
<hr/>

11. (True/False): The Itanium instruction set is completely different from the x86 instruction set.   
[ 번역: (참/거짓) Itanium 명령어 집합은 x86 명령어 집합과 완전히 다르다. ]

        Answer: True
<hr/>

12. (True/False): Static RAM is usually less expensive than dynamic RAM.   
[ 번역: (참/거짓) 정적 RAM(SRAM)은 일반적으로 동적 RAM(DRAM)보다 저렴하다. ]

        Answer: False
> SRAM은 더 빠르고 별도의 refresh가 필요 없지만, 비트당 더 많은 회로와 공간이 필요하여 DRAM보다 비싸다.
>- SRAM: 빠름, 비쌈, 캐시 메모리에 주로 사용
>- DRAM: 상대적으로 느림, 저렴함, 주기적인 refresh 필요, 주기억장치에 주로 사용
<hr/>

13. (True/False): The 64-bit RDI register is available when the REX prefix is used.   
[ 번역: (참/거짓) REX prefix가 사용되면 64비트 RDI 레지스터를 사용할 수 있다. ]

        Answer: True
> RDI (Destination Index)​는 x86-64에서 사용할 수 있는 64비트 범용 레지스터이다.
<hr/>

14. (True/False): In native 64-bit mode, you can use 16-bit real mode, but not the virtual-8086 mode.   
[ 번역: (참/거짓) 네이티브 64비트 모드에서는 16비트 리얼 모드를 사용할 수 있지만, Virtual-8086 모드는 사용할 수 없다. ]

        Answer: False
>x86 프로세서에는 여러 실행 모드가 존재한다.
>- Real Mode: 초기 x86의 16비트 실행 환경
>- Protected Mode: 보호 기능을 제공하는 실행 모드
>- Virtual-8086 Mode: Protected Mode에서 8086 환경을 가상으로 실행
>- 64-bit Mode: x86-64의 64비트 실행 환경

>네이티브 64-bit mode에서는 Real Mode나 Virtual-8086 mode로 직접 전환하여 사용할 수 없다.
<hr/>

15. (True/False): The x86-64 processors have 4 more general-purpose registers than the x86 processors.   
[ 번역: (참/거짓) x86-64 프로세서는 x86 프로세서보다 범용 레지스터를 4개 더 가지고 있다. ]

        Answer: False
>- x86      → 8개
>- x86-64   → 16개
>즉, 4개가 아니라 8개가 더 많다.
<hr/>

16. (True/False): The 64-bit version of Microsoft Windows does not support virtual-8086 mode.   
[ 번역: (참/거짓) Microsoft Windows의 64비트 버전은 Virtual-8086 mode를 지원하지 않는다. ]

        Answer: True
> x86의 Virtual-8086 mode는 32비트 Protected Mode 환경에서 16비트 8086 프로그램을 실행하기 위해 사용되는 기능이다.
<hr/>

17. (True/False): DRAM can only be erased using ultraviolet light.   
[ 번역: (참/거짓) DRAM은 자외선(UV)을 사용해야만 지울 수 있다. ]

        Answer: False
>- DRAM → 전기적으로 읽기/쓰기
>- EPROM → 자외선을 이용해 삭제 가능
<hr/>

18. (True/False): In 64-bit mode, you can use up to eight floating-point registers.   
[ 번역: (참/거짓) 64비트 모드에서는 최대 8개의 부동소수점 레지스터를 사용할 수 있다. ]

        Answer: False
>x86-64에서는 부동소수점 및 SIMD 연산에 사용되는 XMM 레지스터를 사용할 수 있다.   
64비트 모드에서는 기존의 XMM0~XMM7뿐만 아니라 XMM8~XMM15도 사용할 수 있다.

>XMM0 ~ XMM15 = 16개의 XMM 레지스터
<hr/>

19. (True/False): A bus is a plastic cable that is attached to the motherboard at both ends, but does not sit directly on the motherboard.   
[ 번역: (참/거짓) 버스(bus)는 양쪽 끝이 마더보드에 연결되어 있지만 마더보드 위에 직접 위치하지 않는 플라스틱 케이블이다. ]

        Answer: False
>컴퓨터에서 <strong>Bus(버스)</strong>는 CPU, 메모리, I/O 장치 등이 데이터를 주고받을 수 있도록 하는 통신 경로 또는 전기적 연결 구조를 의미한다.

>- Data Bus → 데이터 전달
>- Address Bus → 메모리 주소 전달
>- Control Bus → 제어 신호 전달
<hr/>

20. (True/False): CMOS RAM is the same as static RAM, meaning that it holds its value without any extra power or refresh cycles.   
[ 번역: (참/거짓) CMOS RAM은 정적 RAM과 동일하며, 추가적인 전원이나 refresh cycle 없이도 값을 유지한다. ]

        Answer: False
> CMOS RAM은 전원이 공급되는 동안 데이터를 유지하는 메모리이다. 따라서 전원이 완전히 끊기면 저장된 내용이 사라진다.
<hr/>

21. (True/False): PCI connectors are used for graphics cards and sound cards.   
[ 번역: (참/거짓) PCI 커넥터는 그래픽 카드와 사운드 카드를 연결하는 데 사용된다. ]

        Answer: True
><strong>PCI (Peripheral Component Interconnect)</strong>는 컴퓨터의 확장 카드를 연결하기 위한 인터페이스이다.
>- 그래픽 카드
>- 사운드 카드
>- 네트워크 카드
>- 기타 확장 카드
<hr/>

22. (True/False): The 8259A is a controller that handles external interrupts from hardware devices.   
[ 번역: (참/거짓) 8259A는 하드웨어 장치에서 발생하는 외부 인터럽트를 처리하는 컨트롤러이다. ]

        Answer: True
> Intel 8259A는 <strong>Programmable Interrupt Controller (PIC)</strong>이다.
<hr/>

23. (True/False): The acronym PCI stands for programmable component interface.   
[ 번역: (참/거짓) PCI는 "Programmable Component Interface"의 약자이다. ]

        Answer: False
> "Peripheral Component Interconnect"
>- Peripheral → 주변 장치
>- Component → 구성 요소
>- Interconnect → 상호 연결
<hr/>

24. (True/False): VRAM stands for virtual random access memory.   
[ 번역: (참/거짓) VRAM은 "Virtual Random Access Memory"의 약자이다. ]

        Answer: False
> Video Random Access Memory
<hr/>

25. At which level(s) can an assembly language program manipulate input/output?   
[ 번역: 어셈블리 언어 프로그램은 어느 수준(level)에서 입출력(I/O)을 조작할 수 있는가? ]

        Answer: 하드웨어 레벨, 운영체제 레벨
> 1. Hardware level
>- I/O 포트나 하드웨어 레지스터 등을 직접 조작
>- 장치와 직접 통신할 수 있음
> 2. Operating-system level
>- 운영체제가 제공하는 시스템 서비스나 API를 이용하여 I/O 수행
<hr/>

26. Why do game programs often send their sound output directly to the sound card’s hardware ports?   
[ 번역: 게임 프로그램은 왜 사운드 출력을 사운드 카드의 하드웨어 포트로 직접 보내는 경우가 많은가? ]

> 게임은 음악이나 효과음을 실시간으로 빠르게 처리해야 하는 경우가 많다.

> 운영체제의 여러 추상화 계층을 거쳐 사운드 장치에 데이터를 전달하면 추가적인 처리 과정과 시간이 발생할 수 있다.

> 사운드 카드의 하드웨어에 직접 접근할 시
>- 불필요한 소프트웨어 계층을 줄일 수 있고
>- 하드웨어를 빠르게 제어할 수 있으며
>- 게임의 실시간 사운드 처리 성능을 향상시킬 수 있다.

따라서 게임 프로그램에서는 속도와 낮은 오버헤드, 직접적인 하드웨어 제어를 위해 사운드 카드의 하드웨어 포트를 직접 사용
<hr/>
