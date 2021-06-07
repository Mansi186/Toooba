int main(void) {
    int ret;
    //Loop that counts how long it takes for doing loads from DRAM 
    asm volatile (
        "li t0, 10;"
        "auipc t2, 0x100;"
        "srli t2, t2, 2;"
        "slli t2, t2, 2;"
        "addi t2, t2, 0x7FF;"
        "rdtime t1;"
        "loop: addi t0, t0, -1;"
        "slli t3, t0, 16;"
        "add t4, t2, t3;"
        "lw t4, 0(t4);"
        "bnez t0, loop;"
        "rdtime t0;"
        "sub %0, t0, t1"
        : "=r"(ret) //output
        : //input
        : "t0", "t1", "t2", "t3", "t4"//clobbered
    );
    return ret;
}
