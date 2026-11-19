.686
.model flat, c
.stack 4096

printf PROTO C :PTR BYTE, :VARARG
scanf  PROTO C :PTR BYTE, :VARARG

includelib legacy_stdio_definitions.lib
includelib ucrt.lib

.data
    msg1 BYTE "First number: ", 0
    msg2 BYTE "Second number: ", 0

    inputFmt BYTE "%hd", 0
    resultFmt BYTE "%s = %d", 10, 0
    regFmt BYTE "AX=%04X BX=%04X CX=%04X DX=%04X", 10, 10, 0

    addMsg BYTE "ADD", 0
    subMsg BYTE "SUB", 0
    mulMsg BYTE "MUL", 0
    divMsg BYTE "DIV", 0
    zeroMsg BYTE "Cannot divide by zero.", 10, 0
    overflowMsg BYTE "Division overflow.", 10, 0

    num1 SWORD ?
    num2 SWORD ?

    result SDWORD ?

    regAX WORD ?
    regBX WORD ?
    regCX WORD ?
    regDX WORD ?

.code
main PROC

    ; 두 정수 입력
    invoke printf, ADDR msg1
    invoke scanf, ADDR inputFmt, ADDR num1

    invoke printf, ADDR msg2
    invoke scanf, ADDR inputFmt, ADDR num2

    ; 덧셈
    mov ax, num1
    mov bx, num2
    mov cx, 0
    mov dx, 0
    add ax, bx

    call SaveRegs
    movsx eax, ax
    mov result, eax

    invoke printf, ADDR resultFmt, ADDR addMsg, result
    call PrintRegs

    ; 뺄셈
    mov ax, num1
    mov bx, num2
    mov cx, 0
    mov dx, 0
    sub ax, bx

    call SaveRegs
    movsx eax, ax
    mov result, eax

    invoke printf, ADDR resultFmt, ADDR subMsg, result
    call PrintRegs

    ; 곱셈
    mov ax, num1
    mov bx, num2
    mov cx, 0
    mov dx, 0
    imul bx

    call SaveRegs

    movzx eax, ax
    movsx edx, dx
    shl edx, 16
    or eax, edx
    mov result, eax

    invoke printf, ADDR resultFmt, ADDR mulMsg, result
    call PrintRegs

    ; 나눗셈
    cmp num2, 0
    je DivZero

    mov ax, num1
    mov bx, num2
    mov cx, 0
    cwd

    cmp ax, 8000h
    jne DoDiv
    cmp bx, 0FFFFh
    je DivOverflow

DoDiv:
    idiv bx

    call SaveRegs
    movsx eax, ax
    mov result, eax

    invoke printf, ADDR resultFmt, ADDR divMsg, result
    call PrintRegs
    jmp Finish

DivZero:
    invoke printf, ADDR zeroMsg
    jmp Finish

DivOverflow:
    invoke printf, ADDR overflowMsg

Finish:
    xor eax, eax
    ret

main ENDP

SaveRegs PROC
    mov regAX, ax
    mov regBX, bx
    mov regCX, cx
    mov regDX, dx
    ret
SaveRegs ENDP

PrintRegs PROC
    movzx eax, regAX
    movzx ebx, regBX
    movzx ecx, regCX
    movzx edx, regDX

    invoke printf, ADDR regFmt, eax, ebx, ecx, edx
    ret
PrintRegs ENDP

END main