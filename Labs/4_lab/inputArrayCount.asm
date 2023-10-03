# inputArrayCount.asm -- copied, can't get s.asm to work
.data
arrayA: .word 0, 0, 0, 0, 0, 0, 0, 0    # arrayA has 8 values
count:  .word 0                         # dummy value
space:  .asciiz "\n"
.text

main:
                                        # code to setup the variable mappings
    la      $t0,        arrayA          # t0 --> address arrayA
    la      $t8,        count           # t8 --> address count
    lw      $t9,        0($t8)          # $t9 --> initial value of count

# code for reading storing and printing
    add     $s3,        $t0,    $zero   # $s3 --> pointer to traverse arrayA
    addi    $s4,        $t0,    32      # s4 --> pointer to the next to last address

# reading storing loop
arrayloop:
    slt     $t1,        $s3,    $s4     # check if we have reached the end of array
    beq     $t1,        $zero,  out     # if reach the end go out
    li      $v0,        5               # system call code for read_int
    syscall 
    la      $t7,        0($v0)          # t7 --> user input
    sw      $t7,        0($s3)          # store it back to current index
    addi    $s3,        $s3,    4       # increment the index
    j       arrayloop

out:

# code for reading in the user value X
    li      $v0,        5               # system call code for read_int v0 --> users X input
    syscall 

# code for counting multiples of X in arrayA
    la      $t4,        0($v0)          # t4 --> user input
    addi    $t5,        $t4,    -1      # generating mask
    add     $s2,        $t0,    $zero   # starting address
    addi    $s0,        $t0,    32      # points to the 9th position

loop:
    slt     $t2,        $s2,    $s0
    beq     $t2,        $zero,  exit
    lw      $t3,        0($s2)
    and     $t4,        $t3,    $t5
    bne     $t4,        $zero,  skip
    addi    $t9,        $t9,    1
skip:
    addi    $s2,        $s2,    4
    j       loop
exit:


# code for printing result
    li      $v0,        1
    la      $a0,        0($t9)
    syscall 

    la      $t6,        count
    sw      $t9,        0($t6)          # storing data of count to memory

# code for terminating program
    li      $v0,        10
    syscall 