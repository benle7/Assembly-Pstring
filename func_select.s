    # 318811304 Ben Levi

.section .rodata
format_d:       .string "%d"
format_s:       .string "%s"
format_c:       .string "%c"
format_print0:   .string "first pstring length: %d, second pstring length: %d\n"
format_print2:   .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
format_print3:   .string "length: %d, string: %s\n"
format_print4:   .string "length: %d, string: %s\n"
format_print5:   .string "compare result: %d\n"
format_print8:   .string "invalid option!\n"

.section .rodata
.align 8 
.L1:
    .quad .L0 # case 50
    .quad .L8 # case 51 
    .quad .L2 # case 52
    .quad .L3 # case 53 
    .quad .L4 # case 54
    .quad .L5 # case 55
    .quad .L8 # case 56
    .quad .L8 # case 57
    .quad .L8 # case 58
    .quad .L8 # case 59
    .quad .L0 # case 60


    .text
    .globl run_func
    .type   run_func, @function
    # %rdi - opt, %rsi - pstr1*, %rdx - pstr2*
run_func:
    pushq   %rbp
    movq    %rsp, %rbp
    
    sub $50, %rdi
    cmp $10, %rdi
    jg  .L8 # more than 60
    cmp $0, %rdi
    js  .L8 # less than 50
    sub $16, %rsp # Allocation and alignment.
    jmp *.L1(, %rdi, 8)
    
.L0:
    movq $0, %rax
    movq    %rsi, %rdi # pstr1 -> %rdi
    call    pstrlen # len1 -> %rax
    movq    %rdx, %rdi # pstr2 -> %rdi
    movq    %rax, %rdx # len1 -> %rdx
    movq    $0, %rax
    call    pstrlen # len2 -> %rax
    movq    $format_print0, %rdi
    movq    %rdx, %rsi # 2nd arg - len1
    movq    %rax, %rdx # 3rd arg - len2
    movq    $0, %rax
    call    printf
    jmp .L9   

.L2:
    movq    %rbx, %r9 # backup callee
    movq    %r12, %r10 # backup callee
    
    movq    %rsi, %rbx # backup pstr1* -> %rbx
    movq    %rdx, %r12 # backup pstr2* -> %r12
    movq    $format_s, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf # oldChar -> (%rsp)
    movq    $format_s, %rdi
    leaq    1(%rsp), %rsi
    movq    $0, %rax
    call    scanf # newChar -> (%rsp, 1)

    movq    %rbx, %rdi # pstr1* -> %rdi 
    movzbq   (%rsp), %rsi # oldChar -> %rsi
    leaq    1(%rsp), %rax
    movzbq    (%rax), %rdx # newChar -> %rdx
    call    replaceChar
    
    movq    $0, %rax
    movq    %r12, %rdi # pstr2* -> %rdi 
    movzbq   (%rsp), %rsi # oldChar -> %rsi
    leaq    1(%rsp), %rax
    movzbq    (%rax), %rdx # newChar -> %rdx
    call    replaceChar
    
    movq    $format_print2, %rdi
    movzbq    (%rsp), %rsi # oldChar
    leaq    1(%rsp), %rax
    movzbq    (%rax), %rdx # newChar
    addq    $1, %rbx
    addq    $1, %r12
    movq    %rbx, %rcx # str1
    movq    %r12, %r8 # str2
    
    movq    $0, %rax
    call    printf
    
    movq    %r9, %rbx # backup callee
    movq    %r10, %r12 # backup callee
    jmp .L9 

.L3:
    movq    %rbx, %r9 # backup callee
    movq    %r12, %r10 # backup callee
    
    movq    %rsi, %rbx # backup pstr1* -> %rbx
    movq    %rdx, %r12 # backup pstr2* -> %r12
    movq    $format_d, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf # i -> (%rsp)
    movq    $format_d, %rdi
    leaq    1(%rsp), %rsi
    movq    $0, %rax
    call    scanf # j -> (%rsp, 1)
    
    movq    %rbx, %rdi # pstr1* -> %rdi
    movq    %r12, %rsi # pstr1* -> %rsi
    movzbq  (%rsp), %rdx # i -> %rdx
    leaq    1(%rsp), %rax
    movzbq  (%rax), %rcx # j -> %rcx
    call    pstrijcpy
    
    movq    $format_print3, %rdi
    movzbq  (%rbx), %rsi # size1
    addq    $1, %rbx
    movq    %rbx, %rdx # str1   
    movq    $0, %rax
    call    printf
    
    movq    $format_print3, %rdi
    movzbq  (%r12), %rsi # size2
    addq    $1, %r12
    movq    %r12, %rdx # str2  
    movq    $0, %rax
    call    printf
    
    movq    %r9, %rbx # backup callee
    movq    %r10, %r12 # backup callee
    jmp .L9
    

.L4:
    movq    %rbx, %r9 # backup callee
    movq    %r12, %r10 # backup callee
    
    movq    %rsi, %rbx # backup pstr1* -> %rbx
    movq    %rdx, %r12 # backup pstr2* -> %r12
    
    movq    %rsi, %rdi
    call    swapCase
    movq    %rdx, %rdi
    call    swapCase
    
    movq    $format_print4, %rdi
    movzbq  (%rbx), %rsi # size1
    addq    $1, %rbx
    movq    %rbx, %rdx # str1   
    movq    $0, %rax
    call    printf
    
    movq    $format_print4, %rdi
    movzbq  (%r12), %rsi # size2
    addq    $1, %r12
    movq    %r12, %rdx # str12  
    movq    $0, %rax
    call    printf
    
    movq    %r9, %rbx # backup callee
    movq    %r10, %r12 # backup callee
    jmp .L9
    

.L5:
    movq    %rbx, %r9 # backup callee
    movq    %r12, %r10 # backup callee
    
    movq    %rsi, %rbx # backup pstr1* -> %rbx
    movq    %rdx, %r12 # backup pstr2* -> %r12
    movq    $format_d, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf # i -> (%rsp)
    movq    $format_d, %rdi
    leaq    1(%rsp), %rsi
    movq    $0, %rax
    call    scanf # j -> (%rsp, 1)
    
    movq    %rbx, %rdi # pstr1* -> %rdi
    movq    %r12, %rsi # pstr1* -> %rsi
    movzbq  (%rsp), %rdx # i -> %rdx
    leaq    1(%rsp), %rax
    movzbq  (%rax), %rcx # j -> %rcx
    movq    $0, %rax
    call    pstrijcmp
    
    movq    $format_print5, %rdi
    mov  %rax, %rsi # result cmp
    movq    $0, %rax
    call    printf
    
    movq    %r9, %rbx # backup callee
    movq    %r10, %r12 # backup callee
    jmp .L9


.L8:
    movq    $format_print8, %rdi
    movq    $0, %rax
    call    printf

.L9:   
    movq    %rbp, %rsp
    popq    %rbp
    ret
