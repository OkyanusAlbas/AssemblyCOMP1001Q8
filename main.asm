.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode: DWORD

.data
    valueA DWORD 3, 2, 3, 1, 7, 5, 0, 8, 9, 2  ; Array A
    valueC DWORD 1, 3, 2, 5, 4, 6, 0, 4, 5, 8  ; Array C
    valueB DWORD 10 dup(0)                     ; Result array initialized to 0

.code
main PROC
    xor esi, esi                                 ; Index for valueA and valueC
    mov ecx, 10                                  ; Set loop counter to length of arrays (10)

L1:
    cmp esi, 10                                  ; Ensure we are within bounds
    jge ExitLoop                                 ; If index is 10 or greater, exit

    ; Calculate (A[i] * 3 + 1)
    mov eax, [valueA + esi * 4]                 ; Load A[i] into eax
    imul eax, 3                                  ; Multiply A[i] by 3
    add eax, 1                                   ; Add 1 to the result
    mov ebx, eax                                 ; Store (A[i] * 3 + 1) in ebx

    ; Calculate (C[i] * 2 + 3)
    mov eax, [valueC + esi * 4]                 ; Load C[i] into eax
    imul eax, 2                                  ; Multiply C[i] by 2
    add eax, 3                                   ; Add 3 to the result
    mov ecx, eax                                 ; Store (C[i] * 2 + 3) in ecx

    ; Add the two results
    add ebx, ecx                                 ; Add (A[i] * 3 + 1) + (C[i] * 2 + 3)

    ; Calculate (A[i] + C[i])
    mov eax, [valueA + esi * 4]                 ; Load A[i] into eax
    add eax, [valueC + esi * 4]                 ; Add A[i] + C[i]

    ; Divide (A[i] + C[i]) by 3 and store result in ebx
    xor edx, edx                                 ; Clear edx for division
    test eax, eax                                ; Check if the sum is zero
    jz SkipDivision                               ; If zero, skip division
    mov ecx, 3                                   ; Set divisor to 3
    idiv ecx                                     ; Divide (A[i] + C[i]) by 3, quotient in eax

SkipDivision:
    add ebx, eax                                 ; Combine with the previous result in ebx
    mov [valueB + esi * 4], ebx                  ; Store result in valueB[i]

    inc esi                                      ; Increment index for valueA and valueC
    jmp L1                                       ; Repeat for all elements

ExitLoop:
    INVOKE ExitProcess, 0                        ; Exit the process
main ENDP
END main
