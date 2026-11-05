
.686
.model flat, stdcall
.stack 4096
option casemap:none

GetStdHandle PROTO STDCALL :DWORD
WriteConsoleA PROTO STDCALL :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
ExitProcess PROTO STDCALL :DWORD

includelib kernel32.lib

.data
    msg BYTE "Student ID: 2023964045", 13, 10
        BYTE "Name: Choi Young Woo", 13, 10
    msgLen EQU ($ - msg)

    written DWORD ?

.code
main PROC
    invoke GetStdHandle, -11
    mov ebx, eax

    ; 학번과 이름 출력
    invoke WriteConsoleA, ebx, ADDR msg, msgLen, ADDR written, 0

    ; 프로그램 종료
    invoke ExitProcess, 0

main ENDP
END main
