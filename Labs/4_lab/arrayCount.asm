# arrayCount.asm
.data
arrayA: .word 1, 2, 3, 4, 5, 6, 7, 8# arrayA has 5 + 3 values
count:  .word 0                         # dummy value

.text
main:
                                        # code to setup the variable mappings
    la      $t0,    arrayA
    lw      $t8,    count

# code for reading in the user value X
    li      $v0,    5                   # system call code for read_int into $a0
    syscall 
    move    $t9,    $v0

# code for counting multiples of X in arrayA

    addi    $t1,    $t9,    -1          # get mask of X
    addi    $t2,    $t0,    0           # initial array element
    addi    $t3,    $t0,    32          # final array element

loop:
    slt     $t7,    $t2,    $t3         # $t3 > $t2
    beq     $t7,    $zero,  end         # go to end if $t2 > $t3
    lw      $t5,    0($t2)              # load element value
    and     $t4,    $t5,    $t1         # find remainder
    bne     $t4,    $zero,  skip        # if remainder != 0, then go to skip
    addi    $t8,    $t8,    1           # increment count if multiple
skip:
    addi    $t2,    $t2,    4           # move to next element
    j       loop                        # go back to loop
end:
    sw      $t8,    count

# code for printing result

    li      $v0,    1                   # system call code for print_int
    move    $a0,    $t8                 # integer to print
    syscall                             # print the integer

# code for terminating program
    li      $v0,    10
    syscall 