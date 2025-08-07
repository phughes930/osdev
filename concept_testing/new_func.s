.global new_func
.type new_func, @function
new_func:
    addl    $10, %eax
    imull   $8, %eax
    ret
