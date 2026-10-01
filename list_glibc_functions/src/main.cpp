// main.cpp
#include <iostream>
#include <clang-c/Index.h>
using namespace std;

int main(int argc, char* argv[]){
  if(argc != 2){
    cout << "Incorrect number of command line arguments. Found " << argc << " expected 2" << endl;
    return -1;
  }

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

      CXCursorKind  current_type = clang_getCursorKind(current_cursor);

      if(current_type != CXCursor_FunctionDecl)
        return CXChildVisit_Recurse;

      CXString current_display_name = clang_getCursorDisplayName(current_cursor);
      const char* func_identifier = clang_getCString(current_display_name);
      int i;
      for(i=0; func_identifier[i]!=0; i++)
        if(func_identifier[i]=='(')
          break;
      cout.write(func_identifier, i) << endl;

      clang_disposeString(current_display_name);
      return CXChildVisit_Recurse;
    }, 
    nullptr
  );
}
