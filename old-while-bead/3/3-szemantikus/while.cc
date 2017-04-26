#include <iostream>
#include <fstream>
#include <sstream>
#include "Parser.h"
#include <FlexLexer.h>
#include <stdlib.h>

using namespace std;

yyFlexLexer *fl;
int Parser::sorszam = 0;

int Parser::lex()
{
    int ret = fl->yylex();
    if( ret == Parser::AZONOSITO || ret == Parser::SZAM )
        d_val__.szoveg = new string(fl->YYText());
    d_loc__.first_line = fl->lineno();
    return ret;
}

void input_handler( ifstream& in, int argc, char* argv[] );

int main( int argc, char* argv[] )
{
    ifstream in;
    input_handler( in, argc, argv );
    fl = new yyFlexLexer(&in, &cout);
    Parser pars;
    pars.parse();
    return 0;
}

void input_handler( ifstream& in, int argc, char* argv[] )
{
    if( argc < 2 )
    {
        cerr << "A forditando fajl nevet parancssori parameterben kell megadni." << endl;
        exit(1);
    }
    in.open( argv[1] );
    if( !in )
    {
        cerr << "A " << argv[1] << "fajlt nem sikerult megnyitni." << endl;
        exit(1);
    }
}
