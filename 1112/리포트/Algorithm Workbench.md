# Algorithm Workbench

**기준:** MASM 32비트 / Irvine32 라이브러리. 9·10·12번은 64비트(MASM ML64 / Windows x64) 기준입니다. 명령어 조각이 요구된 문항은 필요한 선언이나 레지스터 초기화 조건을 함께 표시했습니다.

## 1. 32비트 Base-Index 피연산자의 예

**문제 해석:** 32비트 모드에서 베이스-인덱스(base-index) 형식의 메모리 피연산자 예를 작성하시오.

**짧은 풀이:** 베이스 레지스터와 인덱스 레지스터의 값을 더해 유효 주소를 계산한다.

**답:** (`EBX`는 시작 주소, `ESI`는 바이트 단위 오프셋이라고 가정)

```asm
mov eax, DWORD PTR [ebx + esi]
```

## 2. 32비트 Base-Index-Displacement 피연산자의 예

**문제 해석:** 32비트 모드에서 베이스-인덱스-변위(base-index-displacement) 형식의 메모리 피연산자 예를 작성하시오.

**짧은 풀이:** 두 레지스터 값에 상수 변위(여기서는 8바이트)를 더해 유효 주소를 계산한다.

**답:**

```asm
mov eax, DWORD PTR [ebx + esi + 8]
```

## 3. 2차원 DWORD 배열의 두 번째 행, 세 번째 열 접근

**문제 해석:** 3행 4열로 구성된 DWORD 2차원 배열에서 행과 열의 인덱스를 0부터 시작할 때, 두 번째 행의 세 번째 열을 가리키는 ESI·EDI 기반 주소 표현식을 작성하시오.

**짧은 풀이:** 두 번째 행은 행 인덱스 1, 세 번째 열은 열 인덱스 2이다. 한 행의 크기는 4 × 4 = 16바이트이므로 전체 오프셋은 1 × 16 + 2 × 4 = **24바이트**다. ESI에는 행의 바이트 오프셋을, EDI에는 열 인덱스를 넣는다.

**답:** (`myArray`는 DWORD형 3행 4열 배열)

```asm
mov esi, 16                 ; 두 번째 행의 바이트 오프셋
mov edi, 2                  ; 세 번째 열의 인덱스
mov eax, myArray[esi + edi*4]
```

## 4. CMPSW로 두 WORD 배열 비교

**문제 해석:** `CMPSW`를 사용하여 `sourcew`와 `targetw`라는 두 개의 16비트 정수 배열을 비교하는 명령어를 작성하시오.

**짧은 풀이:** ESI와 EDI에 두 배열의 시작 주소를 넣고, 방향 플래그를 0으로 초기화한다. `REPE CMPSW`는 해당 위치의 WORD들이 같을 동안 비교를 계속하며, 서로 다른 값이 나오면 중단한다.

**답:** (두 배열의 길이가 같고 1개 이상의 원소를 가진다고 가정)

```asm
mov esi, OFFSET sourcew
mov edi, OFFSET targetw
mov ecx, LENGTHOF sourcew
cld
repe cmpsw
jne NotEqual              ; 서로 다른 원소가 있음
; 여기에 도달하면 두 배열이 모두 같음
```

## 5. SCASW로 WORD 값 0100h 검색

**문제 해석:** `SCASW`를 사용하여 `wordArray`에서 16비트 값 `0100h`를 검색하고, 일치하는 원소의 주소를 EAX에 저장하시오.

**짧은 풀이:** `REPNE SCASW`로 값이 일치할 때까지 검색한다. DF=0이면 비교 후 EDI가 2바이트 증가하므로, 발견한 원소의 주소는 `EDI - 2`다. 발견하지 못하면 EAX를 -1로 설정한다.

**답:**

```asm
mov edi, OFFSET wordArray
mov ecx, LENGTHOF wordArray
mov ax, 0100h
cld
repne scasw
jnz NotFound
lea eax, [edi - 2]          ; 일치하는 WORD의 주소
jmp Done
NotFound:
mov eax, -1                 ; 미발견
Done:
```

## 6. Str_compare로 더 큰 문자열 출력

**문제 해석:** `Str_compare` 프로시저를 사용해 두 입력 문자열을 비교하고, 더 큰 문자열을 콘솔에 출력하시오.

**짧은 풀이:** 문자열을 사전식(문자 코드) 순서로 비교한다. `Str_compare`가 설정한 플래그를 바로 검사해 첫 번째 문자열이 크거나 같으면 첫 번째를, 그렇지 않으면 두 번째를 출력한다.

**답:** (`INCLUDE Irvine32.inc`를 사용한 32비트 코드 조각)

```asm
.data
str1 BYTE "Apple", 0
str2 BYTE "Banana", 0
.code
INVOKE Str_compare, ADDR str1, ADDR str2
jae FirstString
mov edx, OFFSET str2
jmp ShowString
FirstString:
mov edx, OFFSET str1
ShowString:
call WriteString              ; 출력: Banana
```

## 7. Str_trim으로 문자열 끝의 @ 제거

**문제 해석:** `Str_trim` 프로시저를 호출하여 문자열 끝에 연속으로 있는 모든 `@` 문자를 제거하시오.

**짧은 풀이:** 문자열의 주소와 제거할 문자 `@`를 매개변수로 전달한다. 문자열 중간에 있는 `@`는 제거하지 않는다.

**답:**

```asm
.data
msg BYTE "Hello@@@", 0
.code
INVOKE Str_trim, ADDR msg, '@'    ; 결과: "Hello"
```

## 8. Str_ucase를 소문자 변환 프로시저로 변경

**문제 해석:** Irvine32의 `Str_ucase` 프로시저를 수정하여 문자열의 모든 영문 대문자를 소문자로 변환하도록 하시오.

**짧은 풀이:** 원래 프로시저의 검사 범위를 `'a'`~`'z'`에서 `'A'`~`'Z'`로 변경하고, 비트 5를 1로 설정하는 `OR 20h`를 사용한다. 라이브러리 이름 충돌을 피하기 위해 수정본을 `Str_lcase`로 명명했다.

**답:**

```asm
Str_lcase PROC USES eax esi, pString:PTR BYTE
    mov esi, pString
L1:
    mov al, [esi]
    cmp al, 0
    je Done
    cmp al, 'A'
    jb NextChar
    cmp al, 'Z'
    ja NextChar
    or BYTE PTR [esi], 20h
NextChar:
    inc esi
    jmp L1
Done:
    ret
Str_lcase ENDP
```

## 9. 64비트 Str_trim 프로시저 작성

**문제 해석:** 문자열 끝에서 지정한 문자를 모두 제거하는 `Str_trim`의 64비트 버전을 작성하시오.

**짧은 풀이:** Windows x64 호출 규약에 따라 `RCX`에 문자열 주소, `DL`에 제거할 문자를 전달한다. 널 문자의 주소를 찾은 뒤, 끝에서부터 지정한 문자와 일치하면 그 자리를 널 문자로 바꾼다. 호출에 필요한 비휘발성 레지스터는 변경하지 않는다.

**답:** (ML64, Windows x64 기준)

```asm
; RCX = 널 종료 문자열의 주소
; DL  = 제거할 문자
Str_trim PROC
    mov r8, rcx               ; 문자열 시작 주소
    mov r9, rcx               ; 끝을 찾는 포인터
FindEnd:
    cmp BYTE PTR [r9], 0
    je TrimEnd
    inc r9
    jmp FindEnd
TrimEnd:
    cmp r9, r8                ; 빈 문자열이거나 모두 제거한 경우
    je Done
    cmp BYTE PTR [r9-1], dl
    jne Done
    dec r9
    mov BYTE PTR [r9], 0
    jmp TrimEnd
Done:
    ret
Str_trim ENDP
```

## 10. 64비트 Base-Index 피연산자의 예

**문제 해석:** 64비트 모드에서 베이스-인덱스(base-index) 메모리 피연산자의 예를 작성하시오.

**짧은 풀이:** 64비트 베이스 레지스터와 인덱스 레지스터를 합해 메모리의 유효 주소를 만든다.

**답:** (`RBX`는 기준 주소, `RSI`는 바이트 단위 오프셋)

```asm
mov rax, QWORD PTR [rbx + rsi]
```

## 11. 32비트 2차원 배열의 지정 원소를 EAX에 로드

**문제 해석:** `EBX`에 32비트 2차원 정수 배열 `myArray`의 행 인덱스, `EDI`에 열 인덱스가 있을 때 해당 원소를 EAX로 읽는 한 문장을 작성하시오.

**짧은 풀이:** 원소 주소는 `배열 시작 주소 + (행 × 전체 열 수 + 열) × 4`다. 다만 문제에는 **전체 열 수가 주어지지 않았고**, x86 메모리 피연산자는 두 인덱스에 각각 필요한 배율을 동시에 적용할 수 없다. 따라서 주어진 레지스터가 단순한 행·열 인덱스라면 한 개의 `MOV`만으로는 정확히 구현할 수 없다. 아래는 **4열을 가정한 실행 가능한 대안**이다.

**답:** (`myArray DWORD ...`로 선언된 4열 배열이라고 가정)

```asm
mov edx, ebx               ; 행 인덱스 복사
shl edx, 2                 ; 행 * 4열
add edx, edi               ; + 열 인덱스
mov eax, myArray[edx*4]    ; 해당 DWORD 원소 로드
```

**한 문장의 `MOV`가 가능한 조건:** EBX가 행 *인덱스*가 아니라 **이미 계산된 행의 바이트 오프셋**을 담고 있다면 `mov eax, myArray[ebx + edi*4]`를 사용할 수 있다. 이 조건은 원문에서 주어지지 않았다.

## 12. 64비트 2차원 배열의 지정 원소를 RAX에 로드

**문제 해석:** `RBX`에 64비트 2차원 정수 배열 `myArray`의 행 인덱스, `RDI`에 열 인덱스가 있을 때 해당 원소를 RAX로 읽는 한 문장을 작성하시오.

**짧은 풀이:** 원소 주소는 `배열 시작 주소 + (행 × 전체 열 수 + 열) × 8`이다. 11번과 마찬가지로 **열 개수가 주어지지 않았고**, x64 주소 지정 방식에서도 행과 열 인덱스에 각각 별도의 배율을 동시에 적용할 수 없다. 따라서 실제로 동작하려면 주소 계산이 추가로 필요하다. 아래는 **4열을 가정한 실행 가능한 대안**이다.

**답:** (ML64, `myArray QWORD ...`로 선언된 4열 배열이라고 가정)

```asm
mov r8, rbx                ; 행 인덱스 복사
shl r8, 2                  ; 행 * 4열
add r8, rdi                ; + 열 인덱스
lea rax, myArray           ; 배열 시작 주소
mov rax, QWORD PTR [rax + r8*8]
```

---

