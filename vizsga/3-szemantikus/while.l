%option noyywrap c++ yylineno

%{
#include <iostream>
#include <stdlib.h>
#include "Parserbase.h"
%}

SZAMJEGY    [0-9]
WS          [ \t\n]
BETU        [a-zA-Z]

%%

program     return Parser::PROGRAM;
begin       return Parser::KEZDES;
end         return Parser::VEGE;
natural     return Parser::EGESZ; 
boolean     return Parser::LOGIKAI;
skip        return Parser::URES;
if          return Parser::HA;
then        return Parser::AKKOR;
else        return Parser::KULONBEN;
endif       return Parser::HA_VEGE;
while       return Parser::AMIG;
for         return Parser::FOR;
in          return Parser::IN;
do          return Parser::ADDIG;
done        return Parser::CIKLUS_VEGE;
read        return Parser::OLVAS;
write       return Parser::IR;
".."        return Parser::PONTPONT;
";"         return Parser::PONTOSVESSZO;
":="        return Parser::ERTEKADAS;
"="         return Parser::EGYENLO;
"<"         return Parser::KISEBB;
">"         return Parser::NAGYOBB;
"+"         return Parser::PLUSZ;
"-"         return Parser::MINUSZ;
"*"         return Parser::SZORZAS;
and         return Parser::ES;
or          return Parser::VAGY;
not         return Parser::NEM;
div         return Parser::OSZTAS; 
mod         return Parser::MARADEK;
"("         return Parser::BALZAROJEL;
")"         return Parser::JOBBZAROJEL;
"?"			return Parser::KERDOJEL;
":"			return Parser::KETTOSPONT;

{SZAMJEGY}+ return Parser::SZAM;
true        return Parser::IGAZ;
false       return Parser::HAMIS;

"#".*      // nem kell semmit csinalni
"@"[^@]*"@" // multiline comment

({BETU}|_)({BETU}|{SZAMJEGY}|_)*    return Parser::AZONOSITO;

{WS}+   // feher szokozok: semmi teendo

. {
    std::cerr << lineno() << ". sor: Lexikalis hiba!" << std::endl;
    exit(1);
}

%%
