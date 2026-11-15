// main.cpp
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <clang-c/Index.h>
using namespace std;

int get_function_name_end(const char* fn_name){
  int i;
  for(i=0; fn_name[i]!=0; i++)
    if(fn_name[i]=='(')
      break;
  return i;
}

CXChildVisitResult visitor(CXCursor current_cursor, CXCursor parent, CXClientData client_data){
    if (clang_Location_isFromMainFile (clang_getCursorLocation (current_cursor)) == 0) {
      return CXChildVisit_Continue;
    }

    CXCursorKind  current_type = clang_getCursorKind(current_cursor);

    if(current_type != CXCursor_FunctionDecl)
      return CXChildVisit_Recurse;

    CXSourceLocation loc = clang_getCursorLocation(current_cursor);
    CXFile cursorFile;
    clang_getSpellingLocation(loc, &cursorFile, NULL, NULL, NULL);

    CXString file_name_cx = clang_getFileName(cursorFile);
    const char* file_name = clang_getCString(file_name_cx);

    CXString current_display_name = clang_getCursorDisplayName(current_cursor);
    const char* func_identifier = clang_getCString(current_display_name);

    int i = get_function_name_end(func_identifier);

    cout.write(func_identifier, i) <<  endl;

    clang_disposeString(current_display_name);
    clang_disposeString(file_name_cx);

    clang_visitChildren(
      current_cursor,
      visitor,
      nullptr ); 

    return CXChildVisit_Continue;
}


int main(int argc, char* argv[], char* envp[]){
  if(argc != 2){
    cout << "Incorrect number of command line arguments. Found " << argc << " expected 2" << endl;
    return -1;
  }

  char* glibc_path = getenv("GLIBC_PATH");
  size_t path_size = strlen(glibc_path);
  char* include_path = (char*) malloc((path_size+9)*sizeof(char));

  strcpy(include_path, glibc_path);
  strcat(include_path, "/include");

  CXIndex index = clang_createIndex(0, 1); //Create index
  const char* const args[2] = {"-isystem" , include_path};
  CXTranslationUnit unit = clang_parseTranslationUnit(
    index, argv[1],
    args,2,
    nullptr,0,
    CXTranslationUnit_None
  );

  if (unit == nullptr){
    cerr << "Failed parsing" << endl;
    return -1;
  }

  CXCursor cursor = clang_getTranslationUnitCursor(unit);

  clang_visitChildren(
    cursor, //Root cursor
    visitor, 
    nullptr
  );

  clang_disposeTranslationUnit(unit);
  clang_disposeIndex(index);
}
