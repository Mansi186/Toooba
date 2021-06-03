int main(void) {
  int secure_world;
  asm volatile(
    "csrr %0, 0xFC0"
    : "=r" (secure_world) //output
    : //input
    : //clobbered
  );
  if(secure_world == 0) {
    return 0;
  } else {
    while(1);
  }
}
