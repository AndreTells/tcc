#ifndef CLUSTER_H
#define CLUSTER_H
#include <stdint.h>

uint8_t cluster_pattern_find(
  uint8_t eps, // min number of elements to be a pattern
  uint64_t* data,
  uint8_t data_len,
  uint64_t* generated_patterns,
  uint8_t max_generated_patterns // maximum number of iterations of clustering that will be run
);
#endif
