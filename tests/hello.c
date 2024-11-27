#include <stdio.h>
#include <riscv-pk/encoding.h>
#include "marchid.h"
#include <stdint.h>
#include "rocc.h"

/* ----------- CAM Functions -------------- */
static inline uint64_t CAM_lookup(char* input, int lenInput)
{
    // Implement the CAM lookup operation using custom instructions
}

static inline uint64_t CAM_lookup_and_write(uint64_t p, uint64_t c)
{
    printf("Looking up CAM\n");
    asm volatile ("fence");
    uint64_t value;
    ROCC_INSTRUCTION_DSS(0, value, p, c, 0);
    printf("CAM lookup completed %lu\n", value);
    return value;
}

static inline void CAM_write(int input, uint64_t value)
{
    // Implement the CAM write operation using custom instructions
}

static inline void CAM_reset()
{
    printf("Resetting CAM\n");
    ROCC_INSTRUCTION(0, 1);
    printf("CAM reset completed\n");
}

int main(void) {
  uint64_t marchid = read_csr(marchid);
  const char* march = get_march(marchid);
  printf("Hello world from core 0, a %s\n", march);

  // CAM_reset();
  uint64_t a = CAM_lookup_and_write(0, 3);
  printf("a: %lu\n", a);

  return 0;
}
