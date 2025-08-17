.section .note.GNU-stack,"",@progbits

.section .text
.global main

main:
    push %rbp
    mov %rsp, %rbp

    sub $300, %rsp

    mov %edi, -300(%rbp)
    mov %rsi, -296(%rbp)

    lea -256(%rbp), %rdi
    movb $0x41, %sil
    mov $256, %rdx
    call memset

    lea -288(%rbp), %rax
    mov %rax, %rdi
    lea .L.str(%rip), %rsi
    call string_create

    cmpl $2, -300(%rbp)
    jl .main.if.1.body
    jmp .main.if.1.after
.main.if.1.body:
    lea .L.str.1(%rip), %rdi
    mov $0, %rax
    call printf
    jmp .main.exit
.main.if.1.after:

    lea .L.str.3(%rip), %rdi
    mov -296(%rbp), %rax
    mov 8(%rax), %rdi
    lea .L.str.2(%rip), %rsi
    call fopen
    mov %rax, %rbx

    push %r12
.main.loop.1.body:
    lea -256(%rbp), %rdi
    mov $256, %rsi
    mov %rbx, %rdx
    call fgets
    mov %rax, %r12

    cmp $0, %r12
    je .main.loop.1.after

    lea -288(%rbp), %rdi
    lea -256(%rbp), %rsi
    call string_append_chars

    jmp .main.loop.1.body
.main.loop.1.after:
    pop %r12

    mov %rbx, %rdi
    call fclose

    lea .L.str.3(%rip), %rdi
    lea -288(%rbp), %rax
    mov 0(%rax), %rsi
    mov $0, %rax
    call printf

    lea -288(%rbp), %rdi
    call string_destroy

.main.exit:
    mov $0, %rax

    add $300, %rsp

    pop %rbp
    ret

.L.str:
    .string ""

.L.str.1:
    .string "Usage: jasm [file]\n"

.L.str.2:
    .string "r"

.L.str.3:
    .string "%s"
