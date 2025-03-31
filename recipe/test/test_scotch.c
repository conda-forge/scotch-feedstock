#include <stdio.h>
#include <stdlib.h>

#include <scotch.h>

int main() {
  int provided;
  size_t num_size = sizeof(SCOTCH_Num);
  size_t idx_size = sizeof(SCOTCH_Idx);

  // check scalar size
  printf("sizeof(SCOTCH_Num) = %lu\n", num_size);
  printf("sizeof(SCOTCH_Idx) = %lu\n", idx_size);
  // expect 32 bit
  if (num_size != (TEST_INTSIZE/8) && idx_size != (TEST_INTSIZE/8)) {
    return 1;
  }
  return 0;
}
