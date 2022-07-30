/* simplest version of calculator */
%{
#include <stdio.h>

int yyerror(char *s);
int yylex();
%}

%union{
  int intValue;
  char *text;
  float floatValue;
}

%start program

%token Invalid
%token If
%token Else
%token While
%token Var
%token Const
%token Return
%token Fn
%token EqSign
%token Bool
%token Int
%token Float
%token True
%token False
%token <text> Id
%token <intValue> IntNum
%token <floatValue> FloatNum
%token Sum
%token Mult
%token Equals
%token OpenPar
%token ClosePar
%token OpenBra
%token CloseBra
%token SemiColon
%token Colon
%token Comma

%%
program:
        | program programStatement SemiColon
;

programStatement: declConst
                | declVar
                | declFun
;

declConst: Const Id Colon type EqSign value { printf("Inicializou constante %s usando regra declConst\n", $2); }
;

declVar: Var Id Colon type atrVar { printf("Inicializou variavel %s usando regra declVar ", $2); }
;

atrVar: { printf("e não atribuiu valor\n"); }
      | EqSign value { printf("E atribuiu valor usando regra atrVar\n"); }

value: IntNum
     | FloatNum
     | True
     | False
;

type: Int
    | Float
    | Bool
;

declFun:
;

%%

int main(int argc, char **argv){
  yyparse();
  return 0;
}

int yyerror(char *s){
  fprintf(stderr, "Error: %s\n", s);
}