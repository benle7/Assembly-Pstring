    # 318811304 Ben Levi

.section .rodata
format_d:       .string "%d"
format_s:       .string "%s"


    .text
    .globl run_main
    .type   run_main, @function
run_main:
    pushq   %rbp # %rsp -= 8
    movq    %rsp, %rbp
    
    sub $8, %rsp # Alignment.
    
    
    sub $514, %rsp # Allocation for 2 pstring (srting : 255, /0 : 1, size : 1).
    sub $6, %rsp # Alignment to 16.
    
    # pstring 1.
    movq    $format_d, %rdi # scanf %d.
    leaq    (%rsp), %rsi # scanf into top stack.
    
    movq    $0, %rax
    call    scanf # size 1.
    
    movq    $format_s, %rdi # scanf %s.
    leaq    1(%rsp), %rsi
         
    movq    $0, %rax
    call    scanf # string 1.

    mov    (%rsp), %sil # 1 byte to storage the size (max = 255).
    addq    %rsp, %rsi # end string.
    addq    $1, %rsi # enter \0 at next char.
    movq    $0, (%rsi)
    
    # pstring 2.
    movq    $format_d, %rdi # scanf %d.
    leaq    257(%rsp), %rsi # scanf into top + 257.
         
    movq    $0, %rax
    call    scanf # size 2.
    
    movq    $format_s, %rdi # scanf %s.
    leaq    258(%rsp), %rsi
         
    movq    $0, %rax
    call    scanf # string 2.
    
    movq    $0, %rsi
    mov    257(%rsp), %sil # 1 byte to storage the size (max = 255).
    addq    %rsp, %rsi
    addq    $257, %rsi
    addq    $1, %rsi # enter \0 at next char.
    movq    $0, (%rsi)
    
    
    # opt.
    sub $16, %rsp # Allocation and alignment for opt input.
    movq    $format_d, %rdi # scanf %d.
    leaq    (%rsp), %rsi
              
    movq    $0, %rax
    call    scanf # opt.
    
    movq    $0, %rdi
    mov    (%rsp), %dil # send opt to %rdi - 1st arg
    addq    $16, %rsp
    leaq    (%rsp), %rsi # send pstring1 address to %rsi - 2nd arg
    leaq    257(%rsp), %rdx # send pstring2 address to %rdx - 3rd arg
    
    call    run_func
    
    movq    %rbp, %rsp
    popq    %rbp
    ret
    