#ifndef ITEMSET_H
#include <stdint.h>
#include <stdbool.h>
#define ITEMSET_H

// typedef struct apriori_set_t apriori_set_t;

// <0 -> error happened
// 0 -> set 1 contains set 2
// 1 -> set 1 doesn't contain set 2
bool is_subset(uint64_t itemset1,uint64_t itemset2);

// 0 -> the two itemsets differ by at most one item
// 1 -> the two itemsets differ by more than one item
bool joinable_itemsets(uint64_t itemset1,uint64_t itemset2);

#endif
