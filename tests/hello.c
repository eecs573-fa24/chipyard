#include <stdio.h>
#include <riscv-pk/encoding.h>
#include "marchid.h"
#include <stdint.h>
#include <malloc.h>

int main(void) {
  uint64_t marchid = read_csr(marchid);
  const char* march = get_march(marchid);
  printf("Hello world from core 0, a %s\n", march);

  struct mallinfo mi = mallinfo();
  printf("Total heap space: %d bytes\n", mi.arena);
  printf("Free heap space: %d bytes\n", mi.fordblks);
  
  return 0;
}
