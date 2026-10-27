#include <string.h>
#include <clang-c/Index.h>
#include <iostream>

using namespace std;
char file_name[1000000];
char project_name[1000000];
char current_func[1000000];

void set_file_vars(char* argv[]){
  int len = strlen(argv[2]);
  char* project_folders = strstr(argv[1],argv[2]);
  if(project_folders == nullptr){
    cerr << "Failed to find projects folder" << endl;
    exit(-1);
  }

  project_folders +=len+1;
  int len_path = strlen(argv[1]);
  char* temp = (char*)malloc(sizeof(char)*len_path);
  strncpy(temp,project_folders,len_path);

  char* project_name_temp = strtok(temp,"/");

  strcpy(project_name,temp);
  int project_name_len = strlen(project_name);
  strcpy(file_name,temp+project_name_len+1);
}

int main(int argc, char* argv[]){
  if(argc != 3){
    cerr << "Incorrect number of command line arguments" << endl;
    return -1;
  }

  set_file_vars(argv);

  CXIndex index = clang_createIndex(0, 0); //Create index
  CXTranslationUnit unit = clang_parseTranslationUnit(
    index,
    argv[1], nullptr, 0,
    nullptr, 0,
    CXTranslationUnit_None
  );


  if (unit == nullptr){
    cerr << "Failed parsing" << endl;
    return -1;
  }


  CXCursor cursor = clang_getTranslationUnitCursor(unit); //Obtain a cursor at the root of the translation unit
  
  clang_visitChildren(
  cursor, //Root cursor
  [](CXCursor current_cursor, CXCursor parent, CXClientData client_data){

    CXString current_display_name = clang_getCursorDisplayName(current_cursor);
    CXCursorKind  current_type = clang_getCursorKind(current_cursor);

    if(current_type == CXCursor_FunctionDecl){
      strcpy(current_func,clang_getCString(current_display_name));
      for(int i=0; current_func[i] != '\0'; i++)
          if(current_func[i]=='('){
            current_func[i] = '\0';
            break;
          }

      return CXChildVisit_Recurse;
    }
    //Allocate a CXString representing the name of the current cursor

    else if(current_type == CXCursor_CallExpr){
      cout << project_name << ",";
      cout << file_name << ",";
      cout << current_func << ",";
      cout << clang_getCString(current_display_name) << endl;
    }
    //Print the char* value of current_display_name

    clang_disposeString(current_display_name);
    //Since clang_getCursorDisplayName allocates a new CXString, it must be freed. This applies
    //to all functions returning a CXString

    return CXChildVisit_Recurse;


  }, //CXCursorVisitor: a function pointer
  nullptr //client_data
  );

}
