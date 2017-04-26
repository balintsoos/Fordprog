%baseclass-preinclude "semantics.h"
%lsp-needed

%union
{
  std::string *text;
  expression_def *expDef;
}

%token <text> NUMBER

%token PROGRAM
%token BEGINNING
%token END

%token VARIABLE
%token NATURAL
%token BOOLEAN
%token NUMBER
%token TRUE
%token FALSE

%token IF
%token THEN
%token ELSE
%token ENDIF
%token WHILE
%token FOR
%token IN
%token DO
%token DONE
%token NOT
%token SKIP
%token READ
%token WRITE

%token DOTDOT
%token SEMICOLON
%token ASSIGN
%token OPENBRACKET
%token CLOSEBRACKET


%left AND OR
%left EQUALS
%left GREATER LESS
%left PLUS MINUS
%left ASTERISK DIV MOD

%type<expDef> exp

%%

start:
  PROGRAM VARIABLE declarations BEGINNING statements END
  {
    std::cout << "start -> PROGRAM VARIABLE declarations BEGINNING commands END" << std::endl;
  }
;

declarations:
  // empty
  {
    std::cout << "declarations -> empty" << std::endl;
  }
|
  declaration declarations
  {
    std::cout << "declarations -> declaration declarations" << std::endl;
  }
;

declaration:
  NATURAL VARIABLE SEMICOLON
  {
    std::cout << "declaration -> NATURAL VARIABLE SEMICOLON" << std::endl;
  }
|
  BOOLEAN VARIABLE SEMICOLON
  {
    std::cout << "declaration -> BOOLEAN VARIABLE SEMICOLON" << std::endl;
  }
;

statements:
  statement
  {
    std::cout << "statements -> statement" << std::endl;
  }
|
  statement statements
  {
    std::cout << "statements -> statement statements" << std::endl;
  }
;

statement:
  SKIP SEMICOLON
  {
    std::cout << "statement -> SKIP SEMICOLON" << std::endl;
  }
|
  assignment
  {
    std::cout << "statement -> assignment" << std::endl;
  }
|
  input
  {
    std::cout << "statement -> input" << std::endl;
  }
|
  output
  {
    std::cout << "statement -> output" << std::endl;
  }
|
  branch
  {
    std::cout << "statement -> branch" << std::endl;
  }
|
  loop
  {
    std::cout << "statement -> loop" << std::endl;
  }
;

assignment:
  VARIABLE ASSIGN expression SEMICOLON
  {
    std::cout << "assignment -> VARIABLE ASSIGN expression SEMICOLON" << std::endl;
  }
;

input:
  READ OPENBRACKET VARIABLE CLOSEBRACKET SEMICOLON
  {
    std::cout << "input -> READ OPENBRACKET VARIABLE CLOSEBRACKET SEMICOLON" << std::endl;
  }
;

output:
  WRITE OPENBRACKET expression CLOSEBRACKET SEMICOLON
  {
    std::cout << "output -> WRITE OPENBRACKET expression CLOSEBRACKET SEMICOLON" << std::endl;
  }
;

branch:
  IF expression THEN statements ENDIF
  {
    std::cout << "branch -> IF expression THEN statements ENDIF" << std::endl;
  }
|
  IF expression THEN statements ELSE statements ENDIF
  {
    std::cout << "branch -> IF expression THEN statements ELSE statements ENDIF" << std::endl;
  }
;

loop:
  WHILE expression DO statements DONE
  {
    std::cout << "loop -> WHILE expression DO statements DONE" << std::endl;
  }
|
  FOR VARIABLE IN expression DOTDOT expression DO statements DONE
  {
    std::cout << "loop -> FOR VARIABLE IN expression DOTDOT expression DO statements DONE" << std::endl;
  }
;

expression:
  NUMBER
  {
    std::cout << "expression -> NUMBER" << std::endl;
  }
|
  VARIABLE
  {
    std::cout << "expression -> VARIABLE" << std::endl;
  }
|
  expression PLUS expression
  {
    std::cout << "expression -> expression PLUS expression" << std::endl;
  }
|
  expression MINUS expression
  {
    std::cout << "expression -> expression MINUS expression" << std::endl;
  }
|
  expression ASTERISK expression
  {
    std::cout << "expression -> expression ASTERISK expression" << std::endl;
  }
|
  expression DIV expression
  {
    std::cout << "expression -> expression DIV expression" << std::endl;
  }
|
  expression MOD expression
  {
    std::cout << "expression -> expression MOD expression" << std::endl;
  }
|
  OPENBRACKET expression CLOSEBRACKET
  {
    std::cout << "expression -> OPENBRACKET expression CLOSEBRACKET" << std::endl;
  }
|
  TRUE
  {
    std::cout << "expression -> TRUE" << std::endl;
  }
|
  FALSE
  {
    std::cout << "expression -> FALSE" << std::endl;
  }
|
  expression GREATER expression
  {
    std::cout << "expression -> expression GREATER expression" << std::endl;
  }
|
  expression LESS expression
  {
    std::cout << "expression -> expression LESS expression" << std::endl;
  }
|
  expression AND expression
  {
    std::cout << "expression -> expression AND expression" << std::endl;
  }
|
  expression OR expression
  {
    std::cout << "expression -> expression OR expression" << std::endl;
  }
|
  expression EQUALS expression
  {
    std::cout << "expression -> expression EQUALS expression" << std::endl;
  }
|
  NOT expression
  {
    std::cout << "expression -> NOT expression" << std::endl;
  }
;
