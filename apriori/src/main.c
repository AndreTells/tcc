#include <stdlib.h>
#include <stdio.h>
#include "itemset.h"
#include <stdint.h>
#define NUM_ITEMS 64 // 64 because there are 64 bits -> at most 64 singleton
                     // sets

void generate_initial_candidates(uint64_t* generated_candidates){
  for(uint8_t i=0; i<NUM_ITEMS; i++)
    generated_candidates[i] = 1L<<i;
}

// returns how many candidates were generated
int generate_candidate(
  uint64_t *candidates,
  int num_candidates,
  uint64_t *generated_candidates){
  // TODO: add check to ensure that number of generated candidates does not
  // overflow the buffer

  int gen_i = 0;
  for(int i=0; i<num_candidates; i++)
    for(int j=i+1; j<num_candidates; j++){
      if(i==j)
        continue;
      bool joinable = joinable_itemsets(candidates[i], candidates[j]);

      if(joinable){
        generated_candidates[gen_i] = candidates[i] | candidates[j];
        gen_i++;
      }
    }
  return gen_i;
}

int apriori(
    int k,                            // max number of detected pattern set
  
    int eps,                         // min number of instances for a pattern to be valid
  
    uint64_t *data,                 // list of data collected

    uint8_t data_len,               // amount of items in the data list

    uint64_t *generated_candidates, // buffer in which to save the generated
                                    // candidates
  
    uint8_t max_valid_candidates   // maximum amount of candidates that'll fit
                                   // into the output buffer
  ){
  uint8_t gen_i = 0;

  uint64_t* initial_candidates = malloc(sizeof(uint64_t)*NUM_ITEMS);
  generate_initial_candidates(initial_candidates);

  uint8_t num_candidates = NUM_ITEMS;
  uint64_t* candidates = initial_candidates;

  for(int it=0; it<k;it++){
    uint64_t* valid_candidates = malloc(sizeof(uint64_t)*num_candidates);
    uint8_t valid_candidate_i = 0;
    for(int i=0; i<num_candidates; i++){
      uint8_t count = 0; 
      for(int j=0; j<data_len; j++){
        if(is_subset(data[j], candidates[i]))
          count++;

        // early stopping 
        if(count >= eps){
          valid_candidates[valid_candidate_i] = candidates[i];
          valid_candidate_i++;

          generated_candidates[gen_i] = candidates[i];
          gen_i++;
          if(gen_i == max_valid_candidates) {
            free(candidates);
            free(valid_candidates);
            return gen_i;
          }
          break;
        }
      }

    }
    free(candidates);

    if(it+1 != k){
      uint64_t* new_candidates = malloc(
        sizeof(uint64_t)*valid_candidate_i*(valid_candidate_i-1)
      );

      num_candidates = generate_candidate(valid_candidates, valid_candidate_i, new_candidates);
      candidates = new_candidates;

    } 

    free(valid_candidates);
    
  }
  
  return gen_i;
}

int main(void){
  uint64_t data[10] = {
    0b0100000010000000000000000000000000000000000000000000000000000001, 
    0b0000010001000000000000000000000000000000000000000000000000000001, 
    0b0101000010000000000000000000000000000000000000000000000000000001, 
    0b0001000010000010010000000000000000000000000000000000000000000001, 
    0b1000000010000010010000000000000000000000000000000000000000000000, 
    0b0100000010000000000000000000000000000000000000000000000000000001, 
    0b0000010001000000000000000000000000000000000000000000000000000001, 
    0b0101000010000000000000000000000000000000000000000000000000000001, 
    0b0001000010000010010000000000000000000000000000000000000000000001, 
    0b1000000010000010010000000000000000000000000000000000000000000000 
  };
  uint8_t data_len = 10;

  uint64_t* detected_patterns[100];

  uint8_t num_patterns = apriori(2,5,data,data_len,(uint64_t*)detected_patterns, 100);
  printf("%d\n", num_patterns);
  for(int i=0; i<num_patterns; i++)
    printf("%.64lb\n", detected_patterns[i]);

  return 0;
}
