.section .text
.global set_gdtr
.type set_gdtr, @function
set_gdtr:
    # get size
    movl    $gdt_top, %eax
    movl    $gdt_bottom, %edx
    subl    %edx, %eax
    movw    %ax, gdtr

    # get address
    movl    $gdt_bottom, %eax
    movl    %eax, gdtr+2
    ret

#   flags & limit high 4 bits in %al
#   access byte in %dl
#   descriptor number in %ecx
#   limit = 0x0F FF FF
#   base = 0x00 00 00 00;
.global set_gdt_descr
.type set_gdt_descr, @function
set_gdt_descr:
    pushl   %edi
    pushl   %ebx
    pushl   %ecx

    # get memory address for current segment
    movl    $gdt_bottom, %edi

    # determine if we are making the null descriptor
    testl   %ecx, %ecx
    jz      set_null_descr

    # otw, set the pointer
    imull   $8, %ecx
    addl    %ecx, %edi

    # set the low four bytes of the descriptor
    # this will always be the same
    movl    $0x0000FFFF, %ebx
    movl    %ebx, (%edi)
    addl    $4, %edi
    
    # set up for the high four bytes now
    # stage it in %ebx
    xorl    %ebx, %ebx
    # flags and high limit
    orb     %al, %bh
    # access byte
    orb     %dl, %bl
    sall    $8, %ebx
    orb     $0xFF, %bl
    # mov to gdt seg
    movl    %ebx, (%edi)
    
    jmp     finish_gdt_seg

set_null_descr:
    movl    $0, %eax
    movl    %eax, (%edi)
    
    addl    $4, %edi
    movl    %eax, (%edi)

finish_gdt_seg:
    popl    %ecx
    popl    %ebx
    popl    %edi
    ret

.global set_tss_descriptor
.type set_tss_descriptor, @function
set_tss_descriptor:
    pushl   %ebx
    pushl   %edi
    pushl   %esi
    pushl   %ecx

    movl    $gdt_bottom, %edi

    imull   $8, %ecx
    addl    %ecx, %edi

    # set low four bytes
    movl    $tss, %ebx
    movl    $tss_limit, %esi
    subl    %ebx, %esi
    subl    $1, %esi
    sall    $16, %ebx
    xorw    %bx, %bx
    orw     %si, %bx

    movl    %ebx, (%edi)
    addl    $4, %edi

    # set high four bytes
    #   limit in %esi
    xorl    %ebx, %ebx
    movl    $tss, %ebx
    andl    $0xFF000000, %ebx

    movl    $tss, %edx
    andl    $0x00FF0000, %edx
    shrl    $16, %edx
    orb     %dl, %al

    movb    $0x00, %dh
    movb    $0x89, %dl
    shll    $8, %edx
    andl    $0x00FFFF00, %edx
    orl     %edx, %ebx

    movl    %ebx, (%edi)

    popl    %ecx
    popl    %esi
    popl    %edi
    popl    %ebx
    ret
