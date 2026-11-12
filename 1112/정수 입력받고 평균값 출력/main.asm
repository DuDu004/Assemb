
.686
.model flat, c
.stack 4096

printf PROTO C :PTR BYTE, :VARARG
scanf PROTO C :PTR BYTE, :VARARG

includelib legacy_stdio_definitions.lib
includelib ucrt.lib

.data
    msg BYTE "Enter number: ", 0
    inputFmt BYTE "%d", 0
    outputFmt BYTE "Average: %d", 10, 0

    num SDWORD ?
    sum SDWORD 0

.code
main PROC
    mov ecx, 5
    mov sum, 0

L1:
    push ecx

    invoke printf, ADDR msg
    invoke scanf, ADDR inputFmt, ADDR num

    mov eax, num
    add sum, eax

    pop ecx
    loop L1

    mov eax, sum
    cdq
    mov ebx, 5
    idiv ebx

    invoke printf, ADDR outputFmt, eax

    xor eax, eax
    ret
main ENDP
END main
