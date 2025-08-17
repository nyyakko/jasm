.section .note.GNU-stack,"",@progbits

.section .text

round_size:
    push %rbp
    mov %rsp, %rbp

    sub $8, %rsp

    mov %rdi, -8(%rbp)

    subq $1, -8(%rbp)
    movq -8(%rbp), %rax
    shrq %rax
    orq %rax, -8(%rbp)
    movq -8(%rbp), %rax
    shrq $2, %rax
    orq %rax, -8(%rbp)
    movq -8(%rbp), %rax
    shrq $4, %rax
    orq %rax, -8(%rbp)
    movq -8(%rbp), %rax
    shrq $8, %rax
    orq %rax, -8(%rbp)
    movq -8(%rbp), %rax
    shrq $16, %rax
    orq %rax, -8(%rbp)
    addq $1, -8(%rbp)
    movq -8(%rbp), %rax

    add $8, %rsp

    pop %rbp
    ret

string_realloc:
    push %rbp
    mov %rsp, %rbp

    sub $16, %rsp

    mov %rdi, -16(%rbp)
    mov %rsi, -8(%rbp)

    mov -16(%rbp), %rdi
    mov 0(%rdi), %rsi

    mov -8(%rbp), %rdx
    mov %rdx, 16(%rdi)

    push %rsi
    push %rdi
    mov 16(%rdi), %rdi
    call malloc
    pop %rdi
    pop %rsi
    mov %rax, 0(%rdi)

    push %rdi
    push %rsi
    mov 16(%rdi), %rdx
    mov 0(%rdi), %rdi
    mov $0, %rsi
    call memset
    pop %rsi
    pop %rdi

    push %rdi
    push %rsi
    mov 8(%rdi), %rdx
    mov 0(%rdi), %rdi
    mov %rsi, %rsi
    call memcpy
    pop %rsi
    pop %rdi

    mov %rsi, %rdi
    call free

    add $16, %rsp

    pop %rbp
    ret

.global string_destroy
.type string_destroy, @function
string_destroy:
    push %rbp
    mov %rsp, %rbp

    sub $8, %rsp

    mov %rdi, -8(%rbp)

    mov -8(%rbp), %rsi

    push %rsi
    mov (%rsi), %rdi
    call free
    pop %rsi

    movq $0, 0(%rsi)
    movq $0, 8(%rsi)
    movq $0, 16(%rsi)

    add $8, %rsp

    pop %rbp
    ret

.global string_create
.type string_create, @function
string_create:
    push %rbp
    mov %rsp, %rbp

    sub $8, %rsp

    mov %rsi, -8(%rbp)

    push %r12
    push %r13
    push %r14

    push %rax

    mov -8(%rbp), %rdi
    call strlen
    mov %rax, %r12

    mov %rax, %rdi
    call round_size
    mov %rax, %r13

    mov %rax, %rdi
    call malloc
    mov %rax, %r14

    mov %rax, %rdi
    mov -8(%rbp), %rsi
    mov %r12, %rdx
    call memcpy

    pop %rax

    mov %r14, 0(%rax)
    mov %r12, 8(%rax)
    mov %r13, 16(%rax)

    pop %r12
    pop %r13
    pop %r14

    add $8, %rsp

    pop %rbp
    ret

.global string_push
.type string_push, @function
string_push:
    push %rbp
    mov %rsp, %rbp

    sub $16, %rsp

    mov %rdi, -16(%rbp)
    mov %rsi, -8(%rbp)

    mov -16(%rbp), %rax
    mov 8(%rax), %rdi
    add $1, %rdi
    cmp 16(%rax), %rdi
    jg .string_push.if.1.body
    jmp .string_push.if.1.after
.string_push.if.1.body:
    call round_size
    mov -16(%rbp), %rdi
    mov %rax, %rsi
    call string_realloc
.string_push.if.1.after:

    mov -16(%rbp), %rax
    mov 0(%rax), %rsi
    add 8(%rax), %rsi

    mov -8(%rbp), %rdx
    movb %dl, (%rsi)

    mov -16(%rbp), %rax
    addq $1, 8(%rax)

    add $16, %rsp

    pop %rbp
    ret

.global string_pop
.type string_pop, @function
string_pop:
    push %rbp
    mov %rsp, %rbp

    sub $8, %rsp

    mov %rdi, -8(%rbp)

    mov -8(%rbp), %rax
    cmpq $0, 8(%rax)
    je .string_pop.if.1.after
.string_pop.if.1.body:
    mov 0(%rax), %rdi
    add 8(%rax), %rdi
    sub $1, %rdi
    movq $0, (%rdi)
    subq $1, 8(%rax)
.string_pop.if.1.after:

    add $8, %rsp

    pop %rbp
    ret

.global string_append_chars
.type string_append_chars, @function
string_append_chars:
    push %rbp
    mov %rsp, %rbp

    sub $16, %rsp

    mov %rdi, -16(%rbp)
    mov %rsi, -8(%rbp)

    mov -8(%rbp), %rdi
    call strlen
    push %r12
    mov %rax, %r12

    mov -16(%rbp), %rdi
    mov 8(%rdi), %rsi
    mov 16(%rdi), %rdx

    add %rax, %rsi
    cmp %rdx, %rsi
    jg .string_append.if.1.body
    jmp .string_append.if.1.after
.string_append.if.1.body:
    mov %rsi, %rdi
    call round_size
    mov -16(%rbp), %rdi
    mov %rax, %rsi
    call string_realloc
.string_append.if.1.after:

    mov -16(%rbp), %rdi
    mov 0(%rdi), %rsi
    add 8(%rdi), %rsi

    mov %rsi, %rdi
    mov -8(%rbp), %rsi
    mov %r12, %rdx
    call memcpy

    mov -16(%rbp), %rdi
    add %r12, 8(%rdi)

    pop %r12

    add $16, %rsp

    pop %rbp
    ret

.global string_append
.type string_append, @function
string_append:
    push %rbp
    mov %rsp, %rbp
    # ...
    pop %rbp
    ret
