%baseclass-preinclude "semantics.h"

%lsp-needed

%token PROGRAM
%token KEZDES
%token VEGE
%token EGESZ 
%token LOGIKAI
%token URES
%token HA
%token AKKOR
%token KULONBEN
%token HA_VEGE
%token AMIG
%token ADDIG
%token CIKLUS_VEGE
%token OLVAS
%token IR
%token PONTOSVESSZO
%token ERTEKADAS
%token BALZAROJEL
%token JOBBZAROJEL
%token <szoveg> SZAM
%token IGAZ
%token HAMIS
%token <szoveg> AZONOSITO
%token FOR
%token IN
%token PONTPONT
%token KERDOJEL
%token KETTOSPONT

%left ES VAGY
%left NEM
%left EGYENLO
%left KISEBB NAGYOBB
%left PLUSZ MINUSZ
%left SZORZAS OSZTAS MARADEK

%type <kif> kifejezes
%type <utasitas> ertekadas
%type <utasitas> be
%type <utasitas> ki
%type <utasitas> elagazas
%type <utasitas> ciklus
%type <utasitas> forciklus

%union
{
    std::string *szoveg;
    kifejezes_leiro *kif;
    utasitas_leiro *utasitas;
}

%%

start:
    PROGRAM AZONOSITO deklaraciok KEZDES utasitasok VEGE
    {
    }
;

deklaraciok:
    // ures
    {
    }
|
    deklaracio deklaraciok
    {
    }
;

deklaracio:
    EGESZ AZONOSITO PONTOSVESSZO
    {
        if( szimb_tabla.count(*$2) > 0 )
        {
            std::cerr << d_loc__.first_line << ".: A(z) '" << *$2 << "' valtozo mar definialva volt a "
            << szimb_tabla[*$2].def_sora << ". sorban." << std::endl;
            exit(1);
        }
        else
        {
            szimb_tabla[*$2] = valtozo_leiro(d_loc__.first_line,Egesz);
        }
        delete $2;
    }
|
    LOGIKAI AZONOSITO PONTOSVESSZO
    {
        if( szimb_tabla.count(*$2) > 0 )
        {
            std::cerr << d_loc__.first_line << ".: A(z) '" << *$2 << "' valtozo mar definialva volt a "
            << szimb_tabla[*$2].def_sora << ". sorban." << std::endl;
            exit(1);
        }
        else
        {
            szimb_tabla[*$2] = valtozo_leiro(d_loc__.first_line,Logikai);
        }
        delete $2;
    }
;

utasitasok:
    utasitas
    {
    }
|
    utasitas utasitasok
    {
    }
;

utasitas:
    URES PONTOSVESSZO
    {
    }
|
    ertekadas
    {
    }
|
    be
    {
    }
|
    ki
    {
    }
|
    elagazas
    {
    }
|
    ciklus
    {
    }
|
	forciklus
	{
	}
;

ertekadas:
    AZONOSITO ERTEKADAS kifejezes PONTOSVESSZO
    {
        if( szimb_tabla.count( *$1 ) == 0 )
        {
            std::cerr << d_loc__.first_line << ": A(z) '" << *$1 << "' valtozo nincs deklaralva." << std::endl;
            exit(1);
        }
        else if( szimb_tabla[*$1].vtip != $3->ktip )
        {
            std::cerr << d_loc__.first_line << ": Az ertekadas jobb- es baloldalan kulonbozo tipusu kifejezesek allnak." << std::endl;
            exit(1);
        }
        else
        {
            $$ = new utasitas_leiro( d_loc__.first_line );
        }
        delete $3;
    }
;

be:
    OLVAS BALZAROJEL AZONOSITO JOBBZAROJEL PONTOSVESSZO
    {
        if( szimb_tabla.count( *$3 ) == 0 )
        {
            std::cerr << d_loc__.first_line << ": A(z) '" << *$3 << "' valtozo nincs deklaralva." << std::endl;
            exit(1);
        }
        else
        {
            $$ = new utasitas_leiro( d_loc__.first_line );
        }
        delete $3;
    }
;

ki:
    IR BALZAROJEL kifejezes JOBBZAROJEL PONTOSVESSZO
    {
        $$ = new utasitas_leiro( d_loc__.first_line );
        delete $3;
    }
;

elagazas:
    HA kifejezes AKKOR utasitasok HA_VEGE
    {
        if( $2->ktip != Logikai )
        {
            std::cerr << d_loc__.first_line << ": Nem logikai tipusu az elagazas feltetele." << std::endl;
            exit(1);
        }
        else
        {
            $$ = new utasitas_leiro( $2->sor );
        }
        delete $2;
    }
|
    HA kifejezes AKKOR utasitasok KULONBEN utasitasok HA_VEGE
    {
        if( $2->ktip != Logikai )
        {
            std::cerr << d_loc__.first_line << ": Nem logikai tipusu az elagazas feltetele." << std::endl;
            exit(1);
        }
        else
        {
            $$ = new utasitas_leiro( $2->sor );
        }
        delete $2;
    }
;

ciklus:
    AMIG kifejezes ADDIG utasitasok CIKLUS_VEGE
    {
        if( $2->ktip != Logikai )
        {
            std::cerr << d_loc__.first_line << ": Nem logikai tipusu a ciklus feltetele." << std::endl;
            exit(1);
        }
        else
        {
            $$ = new utasitas_leiro( $2->sor );
        }
        delete $2;
    }
;

forciklus:
	FOR AZONOSITO IN kifejezes PONTPONT kifejezes ADDIG utasitasok CIKLUS_VEGE
	{
        if( szimb_tabla.count( *$2 ) == 0 )
        {
            std::cerr << d_loc__.first_line << ": A(z) '" << *$2 << "' valtozo nincs deklaralva." << std::endl;
            exit(1);
        }
        else if( szimb_tabla[*$2].vtip != Egesz )
        {
            std::cerr << d_loc__.first_line << ": A for ciklus valtozojanak egesz tipusunak kell lennie." << std::endl;
            exit(1);
        }
        else if( $4->ktip != Egesz || $6->ktip != Egesz )
        {
            std::cerr << d_loc__.first_line << ": A for ciklus intervallumaban csak egesz tipusu kifejezesek allhatnak." << std::endl;
            exit(1);			
        }
        else
        {
            $$ = new utasitas_leiro( szimb_tabla[*$2].def_sora );
        }
        delete $2;
        delete $4;
        delete $6;
 	}
;

kifejezes:
    SZAM
    {
        $$ = new kifejezes_leiro( d_loc__.first_line, Egesz );
        delete $1;
    }
|
    IGAZ
    {
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai );
    }
|
    HAMIS
    {
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai );
    }
|
    AZONOSITO
    {
        if( szimb_tabla.count( *$1 ) == 0 )
        {
            std::cerr << d_loc__.first_line << ": A(z) '" << *$1 << "' valtozo nincs deklaralva." << std::endl;
            exit(1);
        }
        else
        {
            valtozo_leiro vl = szimb_tabla[*$1];
            $$ = new kifejezes_leiro( vl.def_sora, vl.vtip );
            delete $1;
        }
    }
|
    kifejezes PLUSZ kifejezes
    {
        if( $1->ktip != Egesz )
        {
            std::cerr << $1->sor << ": A '+' operator baloldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        if( $3->ktip != Egesz )
        {
            std::cerr << $3->sor << ": A '+' operator jobboldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        $$ = new kifejezes_leiro( d_loc__.first_line, Egesz );
        delete $1;
        delete $3;
    }
|
    kifejezes MINUSZ kifejezes
    {
        if( $1->ktip != Egesz )
        {
            std::cerr << $1->sor << ": A '-' operator baloldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        if( $3->ktip != Egesz )
        {
            std::cerr << $3->sor << ": A '-' operator jobboldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        $$ = new kifejezes_leiro( d_loc__.first_line, Egesz );
        delete $1;
        delete $3;
    }
|
    kifejezes SZORZAS kifejezes
    {
        if( $1->ktip != Egesz )
        {
            std::cerr << $1->sor << ": A '*' operator baloldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        if( $3->ktip != Egesz )
        {
            std::cerr << $3->sor << ": A '*' operator jobboldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        $$ = new kifejezes_leiro( d_loc__.first_line, Egesz );
        delete $1;
        delete $3;
    }
|
    kifejezes OSZTAS kifejezes
    {
        if( $1->ktip != Egesz )
        {
            std::cerr << $1->sor << ": A 'div' operator baloldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        if( $3->ktip != Egesz )
        {
            std::cerr << $3->sor << ": A 'div' operator jobboldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        $$ = new kifejezes_leiro( d_loc__.first_line, Egesz );
        delete $1;
        delete $3;
    }
|
    kifejezes MARADEK kifejezes
    {
        if( $1->ktip != Egesz )
        {
            std::cerr << $1->sor << ": A 'mod' operator baloldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        if( $3->ktip != Egesz )
        {
            std::cerr << $3->sor << ": A 'mod' operator jobboldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        $$ = new kifejezes_leiro( d_loc__.first_line, Egesz );
        delete $1;
        delete $3;
    }
|
    kifejezes KISEBB kifejezes
    {
        if( $1->ktip != Egesz )
        {
            std::cerr << $1->sor << ": A '<' operator baloldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        if( $3->ktip != Egesz )
        {
            std::cerr << $3->sor << ": A '<' operator jobboldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai );
        delete $1;
        delete $3;
    }
|
    kifejezes NAGYOBB kifejezes
    {
        if( $1->ktip != Egesz )
        {
            std::cerr << $1->sor << ": A '>' operator baloldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        if( $3->ktip != Egesz )
        {
            std::cerr << $3->sor << ": A '>' operator jobboldalan nem egesz tipusu kifejezes all." << std::endl;
            exit(1);
        }
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai );
        delete $1;
        delete $3;
    }
|
    kifejezes EGYENLO kifejezes
    {
        if( $1->ktip != $3->ktip )
        {
            std::cerr << $1->sor << ": Az '=' operator jobb- es baloldalan kulonbozo tipusu kifejezesek allnak." << std::endl;
            exit(1);
        }
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai );
        delete $1;
        delete $3;
    }
|
    kifejezes ES kifejezes
    {
        if( $1->ktip != Logikai )
        {
            std::cerr << $1->sor << ": Az 'and' operator baloldalan nem logikai tipusu kifejezes all." << std::endl;
            exit(1);
        }
        if( $3->ktip != Logikai )
        {
            std::cerr << $3->sor << ": Az 'and' operator jobboldalan nem logikai tipusu kifejezes all." << std::endl;
            exit(1);
        }
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai );
        delete $1;
        delete $3;
    }
|
    kifejezes VAGY kifejezes
    {
        if( $1->ktip != Logikai )
        {
            std::cerr << $1->sor << ": Az 'or' operator baloldalan nem logikai tipusu kifejezes all." << std::endl;
            exit(1);
        }
        if( $3->ktip != Logikai )
        {
            std::cerr << $3->sor << ": Az 'or' operator jobboldalan nem logikai tipusu kifejezes all." << std::endl;
            exit(1);
        }
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai );
        delete $1;
        delete $3;
    }
|
    NEM kifejezes
    {
        if( $2->ktip != Logikai )
        {
            std::cerr << $2->sor << ": A 'NEM' operator utan nem logikai tipusu kifejezes all." << std::endl;
            exit(1);
        }
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai );
        delete $2;
    }
|
	BALZAROJEL kifejezes KERDOJEL kifejezes KETTOSPONT kifejezes JOBBZAROJEL
	{
		if( $2->ktip != Logikai )
        {
            std::cerr << $2->sor << ": A kerdojel-kettospont operator baloldalan nem logikai tipusu kifejezes all." << std::endl;
            exit(1);
        }
        if( $4->ktip != $6->ktip )
        {
            std::cerr << $4->sor << ": A kerdojel-kettospont operator jobb- es baloldalan kulonbozo tipusu kifejezesek allnak." << std::endl;
            exit(1);
        }
        $$ = new kifejezes_leiro( d_loc__.first_line, $4->ktip );
        delete $2;
		delete $4;
        delete $6;
	}
|
    BALZAROJEL kifejezes JOBBZAROJEL
    {
        $$ = $2;
    }
;
