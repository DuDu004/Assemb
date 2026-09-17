'/* AddTwo program */'

1.: main PROC
2.:     move eax, 5    ; move 5 to the eax register
3.:     add eax, 6     ; add 6 to the eax register
4.:
5.:     INVOKE ExitProcess, 0     ;end the program
6.: main ENDP




'/* Adding a Variable to Addtwo program */'

1.: .data               ; this is the data area
2.: sum DRWORD 0        ; create a variable named sum
3.: 
4.: .code
5.: main PROC     
6.:     move eax, 5     ; move 5 to eax register
7.:     add eax, 6      ; add 6 to the eax register
8.:     mov sum, eax
9.:
10.:    INVOKE ExitProcess, 0       ; end the program
11.:    main ENDP




; AddTwo.asm - adds two 32-bit integers
; Chapter 3 example

.386    ;minimum CPU required for this program
.model flat, stdcall    ; flat: generate code for protected mode
.stack 4096             ; stdcall: enables the calling of MS Widows functions.procedures from Irvine32 link lib
.code
main PROC
    mov eax, 5
    add eax, 6

    INVOKE ExitProcess, 0   ; INVOKE: called a procedure or function
main ENDP
END main