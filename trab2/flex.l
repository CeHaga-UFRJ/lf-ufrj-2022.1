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

int column = 0;
int line = 0;

%}

LET [a-zA-Z_]
NUM [0-9]

ID {LET}({LET}|{NUM})*
INTNUM 0|([1-9]{NUM}*)
FLOATNUM {INTNUM}"."{INTNUM}

SINGLE_CMT \/\/.*

%x IN_CMT

%%

"/*" { column += 2; BEGIN(IN_CMT); }
<IN_CMT>"*/" { column += 2; BEGIN(INITIAL); }
<IN_CMT>. { column += 1; }
<IN_CMT>\n { column = 0; line += 1; }
{SINGLE_CMT} { column += strlen(yytext); }

{INTNUM} { column += strlen(yytext); return IntNum; }
{FLOATNUM} { column += strlen(yytext); return FloatNum; }

if { column += 2; return If; }
else { column += 4; return Else; }
while { column += 5; return While; }
var { column += 3; return Var; }
const { column += 5; return Const; }
return { column += 6; return Return; }
fn { column += 2; return Fn; }
bool { column += 4; return Bool; }
int { column += 3; return Int; }
float { column += 5; return Float; }
true { column += 4; return True; }
false { column += 5; return False; }

"+" { column += 1; return Sum; }
"*" { column += 1; return Mult; }
"==" { column += 2; return Equals; }
"(" { column += 1; return OpenPar; }
")" { column += 1; return ClosePar; }
"{" { column += 1; return OpenBra; }
"}" { column += 1; return CloseBra; }
";" { column += 1; return SemiColon; }
":" { column += 1; return Colon; }

{ID} { column += strlen(yytext); return Id; }
" " { column += 1; }
\t { column += 4; }
\n { column = 0; line += 1; }

. { return Invalid; }

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
