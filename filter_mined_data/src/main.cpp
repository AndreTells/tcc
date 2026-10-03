#include <stdlib.h>
#include <string.h>
#include <set>
#include <iostream>
#include <fstream>
using namespace std;

#define GLIBC_FNCT_LIST_ENV_VAR_NAME "GLIBC_FUNCTIONS_LIST_PATH"
#define GLIBC_FNCT_LIST_ENV_VAR_NAME_SIZE 25
#define FILTER_FEATURE "Callee" 
#define FILTER_FEATURE_SIZE 6
#define MAX_NAME_LENGTH 2000
#define NULL_GUARD(x, msg) if((x) == NULL) {cerr<< msg <<endl; return -1;}

char* get_caller_callee_list_path(int argc, char* argv[]){
  if(argc != 2){
    cerr << "incorrect number of command line arguments provided" << endl;
    return NULL;
  }

  return argv[1];
}

char* get_glibc_function_list_path(char* envp[]){
  if(envp == NULL)
    return NULL;

  char** it =envp;

  while( *it!= NULL){
    char* env_var = strtok(*it,"=");
    if(strncmp(GLIBC_FNCT_LIST_ENV_VAR_NAME, env_var, 25) == 0)
      return strtok(NULL,"=");

    it+=1;
  }
  return NULL;
}

set<string> get_registered_functions(char* glibc_fnct_list_path){
  ifstream file(glibc_fnct_list_path);
  set<string> out = {};
  string line;
  while(getline(file,line)){
    out.insert(line);
  }
  file.close();
  return out;
}

void filter_file(char* target_file,set<string> registered_functions){
  ifstream file(target_file);
  string line;
  //read csv header
  getline(file, line);

  const char* header_str = line.c_str();
  int col_i;

  char* col_name = strtok((char*)header_str, ",");
  for(col_i=0; col_name != NULL ;col_i++){
    if(strncmp(FILTER_FEATURE,col_name,FILTER_FEATURE_SIZE)==0)
      break;

    col_name = strtok(NULL, ",");
  }

  if(col_name==NULL){
    cerr<<"failed to find targeted feature name";
    return;
  }

  char line_str[MAX_NAME_LENGTH];
  while(getline(file, line)){
    strcpy(line_str,line.c_str());
    //discard the cols before the target feature
    for(int i=0; i<col_i; i++)
      strtok((char*)line_str, ",");

    char* callee_str= strtok(NULL,",");

    if(registered_functions.find(callee_str) != registered_functions.end()){
      cout << line << endl;
    }
  }

  file.close();
}

int main(int argc, char* argv[], char* envp[]){
  char* glibc_fnct_list_path = get_glibc_function_list_path(envp);
  NULL_GUARD(glibc_fnct_list_path, "failed to find glibc function list path");

  char* target_file = get_caller_callee_list_path(argc, argv);
  NULL_GUARD(target_file, "failed to find path to file to be analysed");

  set<string> registered_functions = get_registered_functions(glibc_fnct_list_path);

  filter_file(target_file, registered_functions);
  return 0;
}
