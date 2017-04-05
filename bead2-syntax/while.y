%baseclass-preinclude <iostream>
%lsp-needed

%token PROGRAM
%token BEGIN
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

%%

start:
  PROGRAM VARIABLE declarations BEGIN statements END
  {
    std::cout << "start -> PROGRAM VARIABLE declarations BEGIN commands END" << std::endl;
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
  IF condition THEN statements ENDIF
  {
    std::cout << "branch -> IF condition THEN statements ENDIF" << std::endl;
  }
|
  IF condition THEN statements ELSE statements ENDIF
  {
    std::cout << "branch -> IF condition THEN statements ELSE statements ENDIF" << std::endif;
  }
;

loop:
  WHILE condition DO statements DONE
  {
    std::cout << "loop -> WHILE condition DO statements DONE" << std::endl;
  }
|
  FOR VARIABLE IN expression DOTDOT expression DO statements DONE
  {
    std::cout << "loop -> FOR VARIABLE IN expression DOTDOT expression DO statements DONE" << std::endl;
  }
;

expression:

condition:
