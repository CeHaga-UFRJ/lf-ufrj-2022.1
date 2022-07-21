%{
#include <stdio.h>
#include <stdlib.h>

typedef enum _TOKEN {
  Eof = 0,
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
  FloatNum
} TOKEN;

char* tokens[] = { "EOF", "IF", "ELSE", "WHILE", "VAR", "CONST", "RETURN", "FN", "BOOL", "INT", "FLOAT", "TRUE", "FALSE", "ID", "INTNUM", "FLOATNUM" };

%}

LET [a-zA-Z_]
NUM [0-9]
ESP [ \t\n]

ID {LET}({LET}|{NUM})*
INTNUM 0|([1-9]{NUM}*)
FLOATNUM {INTNUM}"."{INTNUM}

%%
{INTNUM} { return IntNum; }
{FLOATNUM} { return FloatNum; }

if { return If; }
else { return Else; }
while { return While; }
var { return Var; }
const { return Const; }
return { return Return; }
fn { return Fn; }
bool { return Bool; }
int { return Int; }
float { return Float; }
true { return True; }
false { return False; }

{ID} { return Id; }
{ESP} {}
%%

int main() {
  int token;

  while((token = (TOKEN)yylex()) != Eof){
    printf("%s %s\n", tokens[token], yytext);
  }

  printf("\n");
  
  return 0;
}
