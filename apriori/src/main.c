#include <stdio.h>
#include "itemset.h"
#include <stdint.h>
#define NUM_ITEMS 64 // 64 because there are 64 bits -> at most 64 singleton
                     // sets

void generate_initial_candidates(uint64_t generated_candidates[NUM_ITEMS]){
  for(uint8_t i=0; i<NUM_ITEMS; i++)
    generated_candidates[i] = 1L<<i;
}

// returns how many candidates were generated
int generate_candidate(
  uint64_t candidates[NUM_ITEMS],
  int num_candidates,
  uint64_t generated_candidates[NUM_ITEMS]){

  int gen_i = 0;
  for(int i=0; i<num_candidates; i++)
    for(int j=0; j<num_candidates; j++){
      if(i==j)
        continue;
      bool joinable = joinable_itemsets(candidates[i], candidates[j]);
      printf("%lb %lb %b\n",candidates[i],candidates[j], joinable);

      if(joinable){
        generated_candidates[gen_i] = candidates[i] | candidates[j];
        gen_i++;
      }
    }
  return gen_i;
}

/*int apriori(int eps, uint64_t *data, uint8_t data_len){
  uint64_t initial_candidates[NUM_ITEMS];
  generate_initial_candidates(initial_candidates);

}
*/
int main(void){
  return 0;
}
