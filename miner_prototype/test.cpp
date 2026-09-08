// main.cpp
#include <clang-c/Index.h>
#include <iostream>
using namespace std;

int main(int argc, char* argv[], char* envp[]){
  CXIndex index = clang_createIndex(0, 0); //Create index
  CXTranslationUnit unit = clang_parseTranslationUnit(
    index,
    "file.cpp", nullptr, 0,
    nullptr, 0,
    CXTranslationUnit_None
  ); //Parse "file.cpp"


  if (unit == nullptr){
    std::cerr << "Unable to parse translation unit. Quitting.\n";
    return 0;
  }
  CXCursor cursor = clang_getTranslationUnitCursor(unit); //Obtain a cursor at the root of the translation unit

  clang_visitChildren(
  cursor, //Root cursor
  [](CXCursor current_cursor, CXCursor parent, CXClientData client_data){

    CXString current_display_name = clang_getCursorDisplayName(current_cursor);
    //Allocate a CXString representing the name of the current cursor

    CXCursorKind  current_type = clang_getCursorKind(current_cursor);

    cout << "type: " <<current_type << endl;
    if(current_type == CXCursor_CallExpr)
      cout << "calling them functions" << endl; 
    cout << "Visiting element " << clang_getCString(current_display_name) << "\n";
    //Print the char* value of current_display_name

    clang_disposeString(current_display_name);
    //Since clang_getCursorDisplayName allocates a new CXString, it must be freed. This applies
    //to all functions returning a CXString

    return CXChildVisit_Recurse;


  }, //CXCursorVisitor: a function pointer
  nullptr //client_data
  );
}
