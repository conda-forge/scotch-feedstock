#include <stdio.h>
#include <stdlib.h>

#include <scotch.h>

int main() {
  int provided;
  size_t num_size = sizeof(SCOTCH_Num);

  // check scalar size
  printf("sizeof(SCOTCH_Num) = %lu\n", num_size);
  // expect 32 bit
  if (num_size != 4) {
    return 1;
  }
  return 0;
}
