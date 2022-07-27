/* simplest version of calculator */
%{
#include <stdio.h>

int yyerror(char *s);
int yylex();
%}

%union{
  int intValue;
  char* text;
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
%token Id
%token IntNum
%token FloatNum
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

type: Int
  | Float
  | Bool
  ;

value: True
  | False
  | IntNum
  | FloatNum
  ;

programStatement: declaration
  | function
  ;

declaration: Var Id Colon type
  | Var Id Colon type EqSign value
  | Const Id Colon type EqSign value
  ;

statements:
  | statements statement SemiColon
  ;

statement: attribution
  | conditional
  | loop
  | Return exp
  ;

calclist:
 | calclist exp EOL { printf("= %d\n", $2); }
 ;

exp: factor
 | exp ADD factor { $$ = $1 + $3; }
 | exp SUB factor { $$ = $1 - $3; }
 ;

factor: term
 | factor MUL term { $$ = $1 * $3; }
 | factor DIV term { $$ = $1 / $3; }
 ;

term: NUMBER
 | ABS term   { $$ = $2 >= 0? $2 : - $2; }
;
%%

int main(int argc, char **argv){
  yyparse();
  return 0;
}

int yyerror(char *s){
  fprintf(stderr, "error: %s\n", s);
}