#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include "cluster.h"
#define NUM_ELEMENTS 64

typedef struct {
  uint8_t node1;
  uint8_t node2;
  uint8_t dist;
}cluster_graph_edge_t;

uint8_t _elem_dist(uint64_t elem1, uint64_t elem2){
  uint64_t diff = ~(elem1 ^ elem2);
  uint8_t num_diff = 0;
  for(int i=0; i<NUM_ELEMENTS; i++){
    num_diff += diff & 1;
    diff = diff >>1;
  }
  return NUM_ELEMENTS - num_diff;
}

cluster_graph_edge_t* build_edge_list(uint64_t* data, uint8_t data_len){
  cluster_graph_edge_t* dists = malloc(sizeof(cluster_graph_edge_t)*data_len*data_len);
  int it = 0;
  for(int i=0; i<data_len; i++)
    for(int j=i+1;j<data_len; j++){
      dists[it].node1 = i; 
      dists[it].node2 = j; 
      dists[it].dist = _elem_dist(data[i],data[j]);
      it++;
    }

  return dists;
}

uint64_t join_cluster_pattern(uint64_t pattern1, uint64_t pattern2){
  return pattern1 & pattern2;
}

// TODO output which set was united
// presuposes the edge list is ordered
// returns the id of the last edge that was taken into consideration
uint8_t clustering_it(
  uint8_t* node_clusters,
  uint64_t* cluster_patterns,
  uint8_t* cluster_size,
  cluster_graph_edge_t* edges,
  uint8_t num_edges,
  uint8_t num_nodes
  ){

  bool found_edge = false;
  uint8_t i = 0;
  uint64_t new_pattern = 0;
  uint8_t node1_cluster;
  uint8_t node2_cluster;

  for(i=0; i< num_edges; i++){
    //checking if nodes are not already in the same cluster
    uint8_t node1 = edges[i].node1;
    uint8_t node2 = edges[i].node2;

    node1_cluster = node_clusters[node1];
    node2_cluster = node_clusters[node2];

    if(node1_cluster == node2_cluster)
      continue;

    // check if the two clusters are joinable
    new_pattern = join_cluster_pattern(
      cluster_patterns[node1_cluster],
      cluster_patterns[node2_cluster]
    );
    if(new_pattern == 0)
      continue;

   found_edge = true;
    // if both conditions have been verified, stop searching
    break;
  }

  if(!found_edge)
    return i;

  // update cluster metadata

  // study how to best store sets
  for(int j=0; j<num_nodes; j++)
    if(node_clusters[j] == node2_cluster)
      node_clusters[j] = node1_cluster;

  cluster_size[node1_cluster] += cluster_size[node2_cluster];
  cluster_size[node2_cluster] = 0;

  cluster_patterns[node1_cluster] = new_pattern;
  cluster_patterns[node2_cluster] = 0;

  return i;
}

static int 
_cmpfunc(const void* p1, const void* p2){
  cluster_graph_edge_t* e1 = (cluster_graph_edge_t*) p1;
  cluster_graph_edge_t* e2 = (cluster_graph_edge_t*) p2;
  if(e1->dist == e2->dist)
    return 0;
  else if(e1->dist > e2->dist)
    return 1;
  return -1;
}

uint8_t cluster_pattern_find(
  uint8_t eps, // min number of elements to be a pattern
  uint64_t* data,
  uint8_t data_len,
  uint64_t* generated_patterns,
  uint8_t max_generated_patterns // maximum number of iterations of clustering that will be run
  ){
  // generate initial cluster config
  uint8_t gen_i=0;
  
  uint8_t* node_clusters = malloc(sizeof(uint8_t)*data_len);
  uint8_t* cluster_size = malloc(sizeof(uint8_t)*data_len);
  uint64_t* cluster_patterns = malloc(sizeof(uint64_t)*data_len);
  // each node starts off in its own cluster alone
  for(int i=0; i<data_len;i++){
    node_clusters[i] = i;
    cluster_patterns[i] = data[i];
    cluster_size[i] = 1;
  }

  // generate edge list
  cluster_graph_edge_t* edges = build_edge_list(data, data_len);
  // TODO: if data_len is large this is sure to overflow
  // only upper triangle of the dist matrix is filled in
  uint8_t num_edges = (data_len*(data_len - 1)) >> 1;

  // sort edge list
  qsort(
    edges,
    num_edges,
    sizeof(cluster_graph_edge_t),
    _cmpfunc // TODO make sorting function for cluster_graph_edge_t
  );

  // iterate through clustering algo until its done
  cluster_graph_edge_t* edges_it = edges;

  for(int i=0; i<max_generated_patterns; i++){
    uint8_t offset = clustering_it(
      node_clusters,
      cluster_patterns,
      cluster_size,
      edges_it,
      num_edges,
      data_len
    );

    // if a union was not made then the algorithm is done
    if(
      node_clusters[edges_it[offset].node1] != 
      node_clusters[edges_it[offset].node2]
    )
      break;

    //TODO: find a more optimized way to do this
    uint8_t new_cluster = node_clusters[edges_it[offset].node1];
    if(cluster_size[new_cluster] >= eps){
      bool already_detected = false;
      for(int j=0; j<gen_i; j++)
        if(cluster_patterns[new_cluster] == generated_patterns[j])
          already_detected = true;

      if(!already_detected){
        generated_patterns[gen_i] = cluster_patterns[new_cluster];
        gen_i++;
      }
    }

    // shorten list of edges considered
    num_edges -= offset+1;
    edges_it = &(edges[offset+1]);
    if(num_edges == 0)
      break;
  }

  // tear down 
  free(edges);
  free(cluster_size);
  free(cluster_patterns);
  free(node_clusters);
  return gen_i;
}
