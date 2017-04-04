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
%token NOT
%token SKIP
%token DONE
%token READ
%token WRITE

%token DOTDOT
%token SEMICOLON
%token ASSIGNMENT
%token OPENBRACKET
%token CLOSEBRACKET


%left AND OR
%left EQUALS
%left GREATER LESS
%left PLUS MINUS
%left ASTERISK DIV MOD

%%
