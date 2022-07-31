%{
/*
Programa: Analisador lexico para a linguagem LF
Autores: Carlos Bravo, Markson Arguello e Pedro Ancelmo
Data: 21/07/2022
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lf.tab.h"

// Contadores de linha e coluna
int column = 1;
int line = 1;
int newColumn = 1;
int newLine = 1;

/*
  Modifica a coluna e linha antiga para a coluna e linha atual
*/
void update(){
  column = newColumn;
  line = newLine;
}

%}

LET [a-zA-Z_]
NUM [0-9]

ID {LET}({LET}|{NUM})*
INTNUM 0|([1-9]{NUM}*)
FLOATNUM {INTNUM}"."{INTNUM}

SINGLE_CMT \/\/.*

%x IN_CMT

%%
  /* Se leu /* entra no estado "IN_CMT" e ignora qualquer caractere dentro, exceto em caso de fechar comentario */
"/*" { update(); newColumn += 2; BEGIN(IN_CMT); }
<IN_CMT>"*/" { update(); newColumn += 2; BEGIN(INITIAL); }
<IN_CMT>. { update(); newColumn += 1; }
<IN_CMT>\n { update(); newColumn = 1; newLine += 1; }
{SINGLE_CMT} { update(); newColumn += strlen(yytext); }

  /* Numeros int e float */
{INTNUM} { 
  update();
  newColumn += strlen(yytext);
  yylval.intValue = atoi(yytext);
  return IntNum;
}

{FLOATNUM} { 
  update();
  newColumn += strlen(yytext);
  yylval.floatValue = atof(yytext);
  return FloatNum;
}


  /* Palavras reservadas */
if { update(); newColumn += 2; yylval.text = strdup(yytext); return If; }
else { update(); newColumn += 4; yylval.text = strdup(yytext); return Else; }
while { update(); newColumn += 5; yylval.text = strdup(yytext); return While; }
var { update(); newColumn += 3; yylval.text = strdup(yytext); return Var; }
const { update(); newColumn += 5; yylval.text = strdup(yytext); return Const; }
return { update(); newColumn += 6; yylval.text = strdup(yytext); return Return; }
fn { update(); newColumn += 2; yylval.text = strdup(yytext); return Fn; }
bool { update(); newColumn += 4; yylval.text = strdup(yytext); return Bool; }
int { update(); newColumn += 3; yylval.text = strdup(yytext); return Int; }
float { update(); newColumn += 5; yylval.text = strdup(yytext); return Float; }
true { update(); newColumn += 4; yylval.text = strdup(yytext); return True; }
false { update(); newColumn += 5; yylval.text = strdup(yytext); return False; }

"+" { update(); newColumn += 1; yylval.text = strdup(yytext); return Sum; }
"*" { update(); newColumn += 1; yylval.text = strdup(yytext); return Mult; }
"==" { update(); newColumn += 2; yylval.text = strdup(yytext); return Equals; }
"=" { update(); newColumn += 1; yylval.text = strdup(yytext); return EqSign; }
"(" { update(); newColumn += 1; yylval.text = strdup(yytext); return OpenPar; }
")" { update(); newColumn += 1; yylval.text = strdup(yytext); return ClosePar; }
"{" { update(); newColumn += 1; yylval.text = strdup(yytext); return OpenBra; }
"}" { update(); newColumn += 1; yylval.text = strdup(yytext); return CloseBra; }
";" { update(); newColumn += 1; yylval.text = strdup(yytext); return SemiColon; }
":" { update(); newColumn += 1; yylval.text = strdup(yytext); return Colon; }
"," { update(); newColumn += 1; yylval.text = strdup(yytext); return Comma; }

{ID} { update(); newColumn += strlen(yytext); yylval.text = strdup(yytext); return Id; }
" " { update(); newColumn += 1; }
\t { update(); newColumn += 4; }
\n { update(); newColumn = 1; newLine += 1; }

  /* Ultima regra, em caso de caractere invalido */
. { update(); return Invalid; }

%%
