%option noyywrap c++ yylineno

%{
#include <iostream>
#include <cstdlib>
%}

DIGIT       [0-9]
WS          [ \t\n]
LETTER      [a-zA-Z]

%%

"#".*\n     // comment

{DIGIT}+    std::cout << "constant: " << YYText() << std::endl;

program     std::cout << "keyword: " << YYText() << std::endl;
begin       std::cout << "keyword: " << YYText() << std::endl;
end         std::cout << "keyword: " << YYText() << std::endl;
natural     std::cout << "keyword: " << YYText() << std::endl;
boolean     std::cout << "keyword: " << YYText() << std::endl;

true        std::cout << "keyword: " << YYText() << std::endl;
false       std::cout << "keyword: " << YYText() << std::endl;

div         std::cout << "keyword: " << YYText() << std::endl;
mod         std::cout << "keyword: " << YYText() << std::endl;
and         std::cout << "keyword: " << YYText() << std::endl;
or          std::cout << "keyword: " << YYText() << std::endl;
not         std::cout << "keyword: " << YYText() << std::endl;
skip        std::cout << "keyword: " << YYText() << std::endl;

if          std::cout << "keyword: " << YYText() << std::endl;
then        std::cout << "keyword: " << YYText() << std::endl;
else        std::cout << "keyword: " << YYText() << std::endl;
endif       std::cout << "keyword: " << YYText() << std::endl;

while       std::cout << "keyword: " << YYText() << std::endl;
for         std::cout << "keyword: " << YYText() << std::endl;
in          std::cout << "keyword: " << YYText() << std::endl;
do          std::cout << "keyword: " << YYText() << std::endl;
done        std::cout << "keyword: " << YYText() << std::endl;
read        std::cout << "keyword: " << YYText() << std::endl;
write       std::cout << "keyword: " << YYText() << std::endl;

".."        std::cout << "dotdot" << std::endl;
";"         std::cout << "semicolon" << std::endl;
"+"         std::cout << "plus" << std::endl;
"-"         std::cout << "minus" << std::endl;
"*"         std::cout << "asterisk" << std::endl;
":="        std::cout << "assignment" << std::endl;
"="         std::cout << "equals" << std::endl;
"<"         std::cout << "less" << std::endl;
">"         std::cout << "greater" << std::endl;
"("         std::cout << "openbracket" << std::endl;
")"         std::cout << "closebracket" << std::endl;

({LETTER}|_)({LETTER}|{DIGIT}|_)*    std::cout << "variable: " << YYText() <<std::endl;

{WS}+       // whitespaces

. {
    std::cerr << lineno() << ". sor: Lexikalis hiba!" << std::endl;
    exit(1);
}

%%
