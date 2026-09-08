#include <stdio.h>
#include "itemset.h"

bool is_subset(uint64_t itemset1,uint64_t itemset2){
  uint64_t comp_res = itemset1 & itemset2;
  return (comp_res==itemset2)?1:0;
}

bool joinable_itemsets(uint64_t itemset1,uint64_t itemset2){
  uint8_t num_diffs = 0;
  uint64_t diff = ~(itemset1 ^ itemset2);
  for(int i=0; i<64; i++){
    bool item_in_both = (diff & 1L) == 1L;

    if(!item_in_both){
      if(num_diffs == 2)
        return false;

      num_diffs++;
    }

    diff = diff >> 1;
  }

  return true;
}
