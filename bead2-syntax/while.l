%option noyywrap c++ yylineno

%{
#include <iostream>
#include <cstdlib>
#include "Parserbase.h"
%}

DIGIT       [0-9]
WS          [ \t\n]
LETTER      [a-zA-Z]

%%

"#".*\n     // comment

{DIGIT}+    return Parser::NUMBER;

program     return Parser::PROGRAM;
begin       return Parser::BEGIN;
end         return Parser::END;
natural     return Parser::NATURAL;
boolean     return Parser::BOOLEAN;

true        return Parser::TRUE;
false       return Parser::FALSE;

div         return Parser::DIV;
mod         return Parser::MOD;
and         return Parser::AND;
or          return Parser::OR;
not         return Parser::NOT;
skip        return Parser::SKIP;

if          return Parser::IF;
then        return Parser::THEN;
else        return Parser::ELSE;
endif       return Parser::ENDIF;

while       return Parser::WHILE;
for         return Parser::FOR;
in          return Parser::IN;
do          return Parser::DO;
done        return Parser::DONE;
read        return Parser::READ;
write       return Parser::WRITE;

".."        return Parser::DOTDOT;
";"         return Parser::SEMICOLON;
"+"         return Parser::PLUS;
"-"         return Parser::MINUS;
"*"         return Parser::ASTERISK;
":="        return Parser::ASSIGNMENT;
"="         return Parser::EQUALS;
"<"         return Parser::LESS;
">"         return Parser::GREATER;
"("         return Parser::OPENBRACKET;
")"         return Parser::CLOSEBRACKET;

({LETTER}|_)({LETTER}|{DIGIT}|_)*    return Parser::VARIABLE;

{WS}+       // whitespaces

. {
    std::cerr << "Syntax Error on line" << lineno();
    exit(1);
}

%%
