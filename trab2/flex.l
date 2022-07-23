%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum _TOKEN {
  Eof = 0,
  Invalid,
  If,
  Else,
  While,
  Var,
  Const,
  Return,
  Fn,
  Bool,
  Int,
  Float,
  True,
  False,
  Id,
  IntNum,
  FloatNum,
  // SingleCmt,
  // OpenMultiCmt,
  // CloseMultiCmt,
  // InMultiCmt,
  Sum,
  Mult,
  Equals,
  OpenPar,
  ClosePar,
  OpenBra,
  CloseBra,
  SemiColon,
  Colon
} TOKEN;

char* tokens[] = { "EOF", "ERROR", "IF", "ELSE", "WHILE", "VAR", "CONST", "RETURN", "FN", "BOOL", "INT", "FLOAT", "TRUE", "FALSE", "ID", "INTNUM", "FLOATNUM", /*"SINGLE_CMT", "OPEN_MULTI_CMT", "CLOSE_MULTI_CMT", "IN_MULTI_CMT",*/ "SUM", "MULT", "EQUALS", "OPENPAR", "CLOSEPAR", "OPENBRA", "CLOSEBRA", "SEMICOL", "COLON" };

int column = 1;
int line = 1;
int newColumn = 1;
int newLine = 1;

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

"/*" { update(); newColumn += 2; BEGIN(IN_CMT); }
<IN_CMT>"*/" { update(); newColumn += 2; BEGIN(INITIAL); }
<IN_CMT>. { update(); newColumn += 1; }
<IN_CMT>\n { update(); newColumn = 1; newLine += 1; }
{SINGLE_CMT} { update(); newColumn += strlen(yytext); }

{INTNUM} { update(); newColumn += strlen(yytext); return IntNum; }
{FLOATNUM} { update(); newColumn += strlen(yytext); return FloatNum; }

if { update(); newColumn += 2; return If; }
else { update(); newColumn += 4; return Else; }
while { update(); newColumn += 5; return While; }
var { update(); newColumn += 3; return Var; }
const { update(); newColumn += 5; return Const; }
return { update(); newColumn += 6; return Return; }
fn { update(); newColumn += 2; return Fn; }
bool { update(); newColumn += 4; return Bool; }
int { update(); newColumn += 3; return Int; }
float { update(); newColumn += 5; return Float; }
true { update(); newColumn += 4; return True; }
false { update(); newColumn += 5; return False; }

"+" { update(); newColumn += 1; return Sum; }
"*" { update(); newColumn += 1; return Mult; }
"==" { update(); newColumn += 2; return Equals; }
"(" { update(); newColumn += 1; return OpenPar; }
")" { update(); newColumn += 1; return ClosePar; }
"{" { update(); newColumn += 1; return OpenBra; }
"}" { update(); newColumn += 1; return CloseBra; }
";" { update(); newColumn += 1; return SemiColon; }
":" { update(); newColumn += 1; return Colon; }

{ID} { update(); newColumn += strlen(yytext); return Id; }
" " { update(); newColumn += 1; }
\t { update(); newColumn += 4; }
\n { update(); newColumn = 1; newLine += 1; }

. { update(); return Invalid; }

%%

int main() {
  int token;

  while((token = (TOKEN)yylex()) != Eof){
    printf("(%s,%s,%d,%d)\n", tokens[token], yytext, line, column);
    if(token == Invalid) break;
  }

  printf("\n");
  
  return 0;
}
