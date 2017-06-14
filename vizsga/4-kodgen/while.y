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
%type <utasitas> deklaracio
%type <utasitas> deklaraciok
%type <utasitas> utasitas
%type <utasitas> utasitasok

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
        std::cout   << "extern be_egesz" << std::endl
                    << "extern ki_egesz" << std::endl
                    << "extern be_logikai" << std::endl
                    << "extern ki_logikai" << std::endl
                    << "global main" << std::endl << std::endl
                    << "section .bss" << std::endl
                    << $3->kod << std::endl
                    << "section .text" << std::endl
                    << "main:" << std::endl
                    << $5->kod
                    << "ret" << std::endl;
        delete $3;
        delete $5;
    }
;

deklaraciok:
    // ures
    {
        $$ = new utasitas_leiro( d_loc__.first_line, "");
    }
|
    deklaracio deklaraciok
    {
        $$ = new utasitas_leiro( $1->sor, $1->kod + $2->kod );
        delete $1;
        delete $2;
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
            szimb_tabla[*$2] = valtozo_leiro(d_loc__.first_line,Egesz,sorszam++);
            $$ = new utasitas_leiro( d_loc__.first_line, 
                szimb_tabla[*$2].cimke + " resb 4\n" );
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
            szimb_tabla[*$2] = valtozo_leiro(d_loc__.first_line,Logikai,sorszam++);
            $$ = new utasitas_leiro( d_loc__.first_line, 
                szimb_tabla[*$2].cimke + " resb 1\n" );
        }
        delete $2;
    }
;

utasitasok:
    utasitas
    {
        $$ = $1;
    }
|
    utasitas utasitasok
    {
        $$ = new utasitas_leiro( $1->sor, $1->kod + $2->kod );
        delete $1;
        delete $2;
    }
;

utasitas:
    URES PONTOSVESSZO
    {
        $$ = new utasitas_leiro( d_loc__.first_line, "nop\n" );
    }
|
    ertekadas
    {
        $$ = $1;
    }
|
    be
    {
        $$ = $1;
    }
|
    ki
    {
        $$ = $1;
    }
|
    elagazas
    {
        $$ = $1;
    }
|
    ciklus
    {
        $$ = $1;
    }
|
	forciklus
	{
        $$ = $1;
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
            std::string reg;
            if( $3->ktip == Egesz )
                reg = "eax";
            else
                reg = "al";
            $$ = new utasitas_leiro( d_loc__.first_line
                , $3->kod
                + "mov " + "[" + szimb_tabla[*$1].cimke + "],"  + reg + "\n" );
        }
        delete $3;    }
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
            std::string muvelet, reg;
            if( szimb_tabla[*$3].vtip == Egesz )
            {
                muvelet = "be_egesz";
                reg = "eax";
            }
            else
            {
                muvelet = "be_logikai";
                reg = "al";
            }
            $$ = new utasitas_leiro( d_loc__.first_line
                , "call " + muvelet + "\n"
                + "mov [" + szimb_tabla[*$3].cimke + "]," + reg + "\n" );
        }
        delete $3;
    }
;

ki:
    IR BALZAROJEL kifejezes JOBBZAROJEL PONTOSVESSZO
    {
        std::string muvelet;
        if( $3->ktip == Egesz )
            muvelet = "ki_egesz";
        else
            muvelet = "ki_logikai";
        $$ = new utasitas_leiro( d_loc__.first_line
            , $3->kod
            + "push eax\n"
            + "call " + muvelet + "\n"
            + "add esp,4\n" );
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
            std::stringstream out1;
            out1 << "Cimke" << Parser::sorszam++;
            std::string then = out1.str();
            std::stringstream out2;
            out2 << "Cimke" << Parser::sorszam++;
            std::string end = out2.str();
            $$ = new utasitas_leiro( $2->sor
                , $2->kod
                + "cmp al,1\n"
                + "je " + then + "\n"
                + "jmp " + end + "\n"
                + then + ":\n"
                + $4->kod
                + end + ":\n" );
        }
        delete $2;
        delete $4;
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
            std::stringstream out1;
            out1 << "Cimke" << Parser::sorszam++;
            std::string then = out1.str();
            std::stringstream out2;
            out2 << "Cimke" << Parser::sorszam++;
            std::string elsec = out2.str();
            std::stringstream out3;
            out3 << "Cimke" << Parser::sorszam++;
            std::string end = out3.str();
            $$ = new utasitas_leiro( $2->sor
                , $2->kod
                + "cmp al,1\n"
                + "je " + then + "\n"
                + "jmp " + elsec + "\n"
                + then + ":\n"
                + $4->kod
                + "jmp " + end + "\n"
                + elsec + ":\n"
                + $6->kod
                + end + ":\n" );
        }
        delete $2;
        delete $4;
        delete $6;
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
            std::stringstream out1;
            out1 << "Cimke" << Parser::sorszam++;
            std::string eleje = out1.str();
            std::stringstream out2;
            out2 << "Cimke" << Parser::sorszam++;
            std::string mag = out2.str();
            std::stringstream out3;
            out3 << "Cimke" << Parser::sorszam++;
            std::string end = out3.str();
            $$ = new utasitas_leiro( $2->sor
                , eleje + ":\n"
                + $2->kod
                + "cmp al,1\n"
                + "je " + mag + "\n"
                + "jmp " + end + "\n"
                + mag + ":\n"
                + $4->kod
                + "jmp " + eleje + "\n"
                + end + ":\n" );
        }
        delete $2;
        delete $4;
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
            std::stringstream out1;
            out1 << "Cimke" << Parser::sorszam++;
            std::string eleje = out1.str();
            std::stringstream out2;
            out2 << "Cimke" << Parser::sorszam++;
            std::string vege = out2.str();
            $$ = new utasitas_leiro( szimb_tabla[*$2].def_sora
				, $4->kod
				+ "mov " + "[" + szimb_tabla[*$2].cimke + "],eax\n"
				+ eleje + ":\n"
				+ $6->kod
				+ "cmp " + "[" + szimb_tabla[*$2].cimke + "],eax\n"
				+ "ja near " + vege + "\n"
				+ $8->kod
				+ "inc dword [" + szimb_tabla[*$2].cimke + "]\n"
				+ "jmp near " + eleje + "\n"
				+ vege + ":\n"
				);
        }
        delete $2;
        delete $4;
        delete $6;
 	}
;

kifejezes:
    SZAM
    {
        $$ = new kifejezes_leiro( d_loc__.first_line, Egesz, "mov eax," + *$1 + "\n");
        delete $1;
    }
|
    IGAZ
    {
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai, "mov al,1\n" );
    }
|
    HAMIS
    {
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai, "mov al,0\n" );
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
            std::string reg;
            if( vl.vtip == Egesz )
                reg = "eax";
            else
                reg = "al";
            $$ = new kifejezes_leiro( vl.def_sora, vl.vtip, "mov " + reg + ",[" + vl.cimke + "]\n" );
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
        $$ = new kifejezes_leiro( d_loc__.first_line, Egesz, $3->kod + "push eax\n" + $1->kod + "pop ebx\n" + "add eax,ebx\n" );
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
        $$ = new kifejezes_leiro( d_loc__.first_line, Egesz, $3->kod + "push eax\n" + $1->kod + "pop ebx\n" + "sub eax,ebx\n" );
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
        $$ = new kifejezes_leiro( d_loc__.first_line, Egesz, $3->kod + "push eax\n" + $1->kod + "pop ebx\n" + "mov edx,0\n" + "mul ebx\n" );
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
        $$ = new kifejezes_leiro( d_loc__.first_line, Egesz, $3->kod + "push eax\n" + $1->kod + "pop ebx\n" + "mov edx,0\n" + "div ebx\n" );
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
        $$ = new kifejezes_leiro( d_loc__.first_line, Egesz, $3->kod + "push eax\n" + $1->kod + "pop ebx\n" + "mov edx,0\n" + "div ebx\n" + "mov eax,edx\n" );
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
        std::stringstream out;
        out << "Cimke" << Parser::sorszam++;
        std::string cimke = out.str();
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai
            , $3->kod
            + "push eax\n"
            + $1->kod
            + "pop ebx\n"
            + "cmp eax,ebx\n"
            + "mov al,1\n"
            + "jb " + cimke + "\n"
            + "mov al,0\n"
            + cimke + ":\n" );
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
        std::stringstream out;
        out << "Cimke" << Parser::sorszam++;
        std::string cimke = out.str();
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai
            , $3->kod
            + "push eax\n"
            + $1->kod
            + "pop ebx\n"
            + "cmp eax,ebx\n"
            + "mov al,1\n"
            + "ja " + cimke + "\n"
            + "mov al,0\n"
            + cimke + ":\n" );
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
        std::stringstream out;
        out << "Cimke" << Parser::sorszam++;
        std::string cimke = out.str();
        std::string reg1,reg2;
        if( $1->ktip == Egesz )
        {
            reg1 = "eax";
            reg2 = "ebx";
        }
        else
        {
            reg1 = "al";
            reg2 = "bl";
        }
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai
            , $3->kod
            + "push eax\n"
            + $1->kod
            + "pop ebx\n"
            + "cmp " + reg1 + "," + reg2 + "\n"
            + "mov al,1\n"
            + "je " + cimke + "\n"
            + "mov al,0\n"
            + cimke + ":\n" );
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
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai,
            $3->kod + "push eax\n" + $1->kod + "pop ebx\n" + "and al,bl\n" );
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
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai,
            $3->kod + "push eax\n" + $1->kod + "pop ebx\n" + "or al,bl\n" );
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
        $$ = new kifejezes_leiro( d_loc__.first_line, Logikai,
            $2->kod + "xor al,1\n" );
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
		std::stringstream out1;
		std::stringstream out2;
        
		out1 << "Cimke" << Parser::sorszam++;
        std::string hamis_ag_cimke = out1.str();
		
		out2 << "Cimke" << Parser::sorszam++;
        std::string vege_cimke = out2.str();
        
        $$ = new kifejezes_leiro( d_loc__.first_line, $4->ktip
			, $2->kod
			+ "cmp al,1\n"
			+ "jne near " + hamis_ag_cimke + "\n"
			+ $4->kod
			+ "jmp " + vege_cimke + "\n"
			+ hamis_ag_cimke + ":\n"
			+ $6->kod
			+ vege_cimke + ":\n" );
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
