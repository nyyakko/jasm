.section .note.GNU-stack,"",@progbits

.section .text

skip_ws:
    push %rbp
    mov %rsp, %rbp

    sub $16, %rsp

    mov %rdi, -16(%rbp) # string pointer
    mov %rsi, -8(%rbp)  # cursor pointer

skip_ws.loop.1.check:
    mov -16(%rbp), %rdi
    mov (%rdi), %rdi

    mov -8(%rbp), %rsi
    addq (%rsi), %rdi

    movb (%rdi), %al
    xor %rdi, %rdi
    movb %al, %dil
    call isspace
    cmp $0, %rax

    je skip_ws.loop.1.after
skip_ws.loop.1.body:
    mov -8(%rbp), %rsi
    addq $1, (%rsi)
    jmp skip_ws.loop.1.check
skip_ws.loop.1.after:
    add $16, %rsp

    pop %rbp
    ret

.global lexicalize
.type lexicalize, @function
lexicalize:
    push %rbp
    mov %rsp, %rbp

    sub $16, %rsp

    mov %rdi, -16(%rbp) # string pointer
    movq $0, -8(%rbp)   # cursor

    push %r12
    mov -16(%rbp), %r12

lexicalize.loop.1.check:
    mov -8(%rbp), %rdx
    mov 8(%r12), %rax
    sub $1, %rax
    cmpq %rdx, %rax
    jle lexicalize.loop.1.after
lexicalize.loop.1.body:
    mov -16(%rbp), %rdi
    lea -8(%rbp), %rsi
    call skip_ws

    lea .L.str(%rip), %rdi
    mov 0(%r12), %rsi
    addq -8(%rbp), %rsi
    movb (%rsi), %sil
    mov $0, %rax
    call printf

    addq $1, -8(%rbp)

    jmp lexicalize.loop.1.check
lexicalize.loop.1.after:
    pop %r12

    add $16, %rsp

    pop %rbp
    ret

.L.str: .string "%c"
