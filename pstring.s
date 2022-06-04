    # 318811304 Ben Levi

.section .rodata
format_print:       .string "invalid input!\n"


    .text
    .globl pstrlen
    .type   pstrlen, @function
pstrlen:
    pushq   %rbp
    movq    %rsp, %rbp
    
    movq    $0, %rax
    mov (%rdi), %al # because the first byte of pstring is the size.
    
    movq    %rbp, %rsp
    popq    %rbp
    ret


    .text
    .globl replaceChar
    .type   replaceChar, @function
replaceChar:
    pushq   %rbp
    movq    %rsp, %rbp
    
    push %rdi # backup start pstring
    movq    $0, %rcx # caller register.
    mov (%rdi), %cl # size
    cmp $0, %cl
    je  .fin_rep # if size = 0
.loop_rep:
    addq $1, %rdi # next char
    cmp %sil, (%rdi) # oldChar - 1Byte.
    je  .rep # if equal to oldChar.
    jmp .condition # else.
.rep:
    mov %dl, (%rdi) # change oldChar to newChar byte.
.condition:
    dec %cl # size--
    je  .fin_rep # if size = 0
    jmp .loop_rep   
.fin_rep:
    pop %rdi # return backup.
    movq %rdi, %rax # return pointer.
    
    movq    %rbp, %rsp
    popq    %rbp
    ret


    .text
    .globl pstrijcpy
    .type   pstrijcpy, @function
pstrijcpy:  # %rdi : pstring dst*, %rsi : pstring src*, %rdx(dl): i, %rcx(cl) : j
    pushq   %rbp
    movq    %rsp, %rbp
    movq    %rdi, %rax # need to return dst pstring. 
    push    %rax
    
    cmp $0, %rdx # i - 0
    js  .invalid_cpy
    cmp $0, %rcx # j - 0
    js  .invalid_cpy
    
    movq    $0, %rdi
    mov (%rax), %dil # size_dst
    cmp %dil, %dl # i - size_dst
    jns  .invalid_cpy
    cmp %dil, %cl # j - size_dst
    jns  .invalid_cpy
    
    movq    $0, %rdi
    mov (%rsi), %dil # size_src
    cmp %dil, %dl # i - size_src
    jns  .invalid_cpy
    cmp %dil, %cl # j - size_src
    jns  .invalid_cpy
    
    cmp %dl, %cl # j - i
    js  .invalid_cpy
    
    # %rax : dst*, %rsi : src*, %rdx(dl): i, %rcx(cl) : j
    leaq    1(%rax), %rax # dst += 1 (start)
    leaq    1(%rsi), %rsi # src += 1 (start)   
    leaq    (%rax, %rdx), %rax # dst += i
    leaq    (%rsi, %rdx), %rsi # src += i
    sub %dl, %cl # j = j - i
    movq    $0, %rdi
    
.loop_cpy:
    mov (%rsi), %dil
    mov %dil, (%rax) # copy src[k] to dst[k]
    dec %cl # (j-i)--
    js  .fin_cpy # j-i < 0 after dec.
    addq    $1, %rax # dst to next char
    addq    $1, %rsi # src to next char
    jmp .loop_cpy
                  
.invalid_cpy:
    movq    $format_print, %rdi
    movq    $0, %rax
    call    printf
    
.fin_cpy:
    pop     %rax
    movq    %rbp, %rsp
    popq    %rbp
    ret
    
    

    .text
    .globl swapCase
    .type   swapCase, @function
swapCase:
    pushq   %rbp
    movq    %rsp, %rbp
    movq    %rdi, %rax # need to return pstring point. 
    push    %rax
    
    mov (%rdi), %sil # size -> %sil
.loop_sw:
    movq    $0, %rax
    movq    $0, %rcx
    dec %sil # size--
    js  .fin_swap # size < 0
    addq    $1, %rdi # next char
    mov (%rdi), %al
    cmp $65, %al # cmp to A
    js  .loop_sw # if less than A (not let).
    mov $90, %cl
    cmp %al, %cl # cmp to Z
    js  .check_lower # if bigger than Z.
    add $32, (%rdi) # change to lower.
    jmp .loop_sw
    
.check_lower:
    cmp $97, %al # cmp to a.
    js  .loop_sw # if less than a (not let).
    mov $122, %cl
    cmp %al, %cl # cmp to z.
    js  .loop_sw # if bigger than z (not let).
    sub $32, (%rdi) # change to upper.
    jmp .loop_sw
    
.fin_swap:    
    pop %rax
    movq    %rbp, %rsp
    popq    %rbp
    ret



    .text
    .globl pstrijcmp
    .type   pstrijcmp, @function
pstrijcmp:
    pushq   %rbp
    movq    %rsp, %rbp
    
    cmp $0, %rdx # i - 0
    js  .invalid_cmp
    cmp $0, %rcx # j - 0
    js  .invalid_cmp
    
    movq    $0, %rax
    mov (%rdi), %al # size1
    cmp %al, %dl # i - size1
    jns  .invalid_cmp
    cmp %al, %cl # j - size1
    jns  .invalid_cmp
    
    movq    $0, %rax
    mov (%rsi), %al # size2
    cmp %al, %dl # i - size2
    jns  .invalid_cmp
    cmp %al, %cl # j - size2
    jns  .invalid_cmp
    
    cmp %dl, %cl # j - i
    js  .invalid_cmp
    
    # %rdi : pstring1, %rsi : pstring2, %rdx(dl): i, %rcx(cl) : j
    leaq    1(%rdi), %rdi # pstring1 += 1 (start)
    leaq    1(%rsi), %rsi # pstring2 += 1 (start)   
    leaq    (%rdi, %rdx), %rdi # pstring1 += i
    leaq    (%rsi, %rdx), %rsi # pstring2 += i
    sub %dl, %cl # j = j - i
    movq    $0, %rax
    movq    $0, %rdx
    
.loop_cmp:
    mov (%rsi), %dl
    cmp (%rdi), %dl # cmp pstring2[k] - pstring1[k]
    js  .put_pos # pstring2[k] come before
    cmp %dl, (%rdi) # cmp pstring1[k] - pstring2[k]
    js  .put_neg # pstring1[k] come before
    
    dec %cl # (j-i)--
    js  .fin_cmp # j-i < 0 after dec.
    addq    $1, %rdi # next char
    addq    $1, %rsi # next char
    jmp .loop_cmp
    
.put_neg:
    movq $-1, %rax
    jmp .fin_cmp
    
.put_pos:
    movq $1, %rax
    jmp .fin_cmp
            
.invalid_cmp:
    movq    $format_print, %rdi
    movq    $0, %rax
    call    printf
    movq $-2, %rax   
       
.fin_cmp:
    movq    %rbp, %rsp
    popq    %rbp
    ret
    