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
;

condition:
  TRUE
  {
    std::cout << "condition -> TRUE" << std::endl;
  }
|
  FALSE
  {
    std::cout << "condition -> FALSE" << std::endl;
  }
|
  VARIABLE
  {
    std::cout << "condition -> VARIABLE" << std::endl;
  }
|
  expression EQUALS expression
  {
    std::cout << "condition -> expression EQUALS expression" << std::endl;
  }
|
  expression GREATER expression
  {
    std::cout << "condition -> expression GREATER expression" << std::endl;
  }
|
  expression LESS expression
  {
    std::cout << "condition -> expression LESS expression" << std::endl;
  }
|
  condition AND condition
  {
    std::cout << "condition -> condition AND condition" << std::endl;
  }
|
  condition OR condition
  {
    std::cout << "condition -> condition OR condition" << std::endl;
  }
|
  condition EQUALS condition
  {
    std::cout << "condition -> condition EQUALS condition" << std::endl;
  }
|
  NOT condition
  {
    std::cout << "condition -> NOT condition" << std::endl;
  }
|
  OPENBRACKET condition CLOSEBRACKET
  {
    std::cout << "condition -> OPENBRACKET condition CLOSEBRACKET" << std::endl;
  }
;
