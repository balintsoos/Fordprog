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

{DIGIT}+    std::cout << "szamkonstans: " << YYText() << std::endl;

program     std::cout << "kucsszo: " << YYText() << std::endl;
begin       std::cout << "kucsszo: " << YYText() << std::endl;
end         std::cout << "kucsszo: " << YYText() << std::endl;
natural     std::cout << "kucsszo: " << YYText() << std::endl;
bool        std::cout << "kucsszo: " << YYText() << std::endl;

true        std::cout << "kucsszo: " << YYText() << std::endl;
false       std::cout << "kucsszo: " << YYText() << std::endl;

div         std::cout << "kucsszo: " << YYText() << std::endl;
mod         std::cout << "kucsszo: " << YYText() << std::endl;
and         std::cout << "kucsszo: " << YYText() << std::endl;
or          std::cout << "kucsszo: " << YYText() << std::endl;
not         std::cout << "kucsszo: " << YYText() << std::endl;
skip        std::cout << "kucsszo: " << YYText() << std::endl;

if          std::cout << "kucsszo: " << YYText() << std::endl;
then        std::cout << "kucsszo: " << YYText() << std::endl;
else        std::cout << "kucsszo: " << YYText() << std::endl;
endif       std::cout << "kucsszo: " << YYText() << std::endl;

while       std::cout << "kucsszo: " << YYText() << std::endl;
for         std::cout << "kucsszo: " << YYText() << std::endl;
in          std::cout << "kucsszo: " << YYText() << std::endl;
do          std::cout << "kucsszo: " << YYText() << std::endl;
done        std::cout << "kucsszo: " << YYText() << std::endl;
read        std::cout << "kucsszo: " << YYText() << std::endl;
write       std::cout << "kucsszo: " << YYText() << std::endl;

".."        std::cout << "pontpont" << std::endl;
";"         std::cout << "utasitas vege" << std::endl;
"+"         std::cout << "plusz" << std::endl;
"-"         std::cout << "minusz" << std::endl;
"*"         std::cout << "szorzas" << std::endl;
":="        std::cout << "ertekadas" << std::endl;
"="         std::cout << "egyenlo" << std::endl;
"<"         std::cout << "kisebb" << std::endl;
">"         std::cout << "nagyobb" << std::endl;
"("         std::cout << "balzarojel" << std::endl;
")"         std::cout << "jobbzarojel" << std::endl;

({LETTER}|_)({LETTER}|{DIGIT}|_)*    std::cout << "azonosito: " << YYText() <<std::endl;

{WS}+       // whitespaces

. {
    std::cerr << lineno() << ". sor: Lexikalis hiba!" << std::endl;
    exit(1);
}

%%
