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

%token <text> Invalid
%token <text> If
%token <text> Else
%token <text> While
%token <text> Var
%token <text> Const
%token <text> Return
%token <text> Fn
%token <text> EqSign
%token <text> Bool
%token <text> Int
%token <text> Float
%token <text> True
%token <text> False
%token <text> Id
%token <intValue> IntNum
%token <floatValue> FloatNum
%token <text> Sum
%token <text> Mult
%token <text> Equals
%token <text> OpenPar
%token <text> ClosePar
%token <text> OpenBra
%token <text> CloseBra
%token <text> SemiColon
%token <text> Colon
%token <text> Comma

%left Equals
%left Sum
%left Mult

%%
program: { printf("program -> \u03B5\n"); }
        | program programStatement SemiColon { printf("program -> program programStatement %s\n", $3); }
;

programStatement: declConst { printf("programStatement -> declConst\n"); }
                | declVar { printf("programStatement -> declVar\n"); }
                | declFun { printf("programStatement -> declFun\n"); }
;

declId: Id Colon type { printf("declId -> %s %s type\n", $1, $2); }
;

declConst: Const declId atrValue { printf("declConst -> %s declId atrValue\n", $1); }
;

declVar: Var declId atrVar { printf("declVar -> %s declId atrVar\n", $1); }
;

atrVar: { printf("atrVar -> \u03B5\n"); }
      | atrValue { printf("atrVar -> atrValue\n"); }
;

number: IntNum { printf("number -> %d\n", $1); }
      | FloatNum { printf("number -> %f\n", $1); }
;

boolean: True { printf("boolean -> %s\n", $1); }
       | False { printf("boolean -> %s\n", $1); }
;

type: Int { printf("type -> %s\n", $1); }
    | Float { printf("type -> %s\n", $1); }
    | Bool { printf("type -> %s\n", $1); }
;

atrValue: EqSign exp { printf("atrValue -> %s exp\n", $1); }
;

declFun: Fn Id OpenPar funParam ClosePar Colon type OpenBra declVarFunc funStatements CloseBra { printf("declFun -> %s %s %s funParam %s %s type %s declVarFunc funStatements %s\n", $1, $2, $3, $5, $6, $8, $11); }
;

declVarFunc: { printf("declVarFunc -> \u03B5\n"); }
           | declVarFunc declConst SemiColon { printf("declVarFunc -> declVarFunc declConst %s\n", $3); }
           | declVarFunc declVar SemiColon { printf("declVarFunc -> declVarFunc declVar %s\n", $3); }
;

funParam: { printf("funParam -> \u03B5\n"); }
        | funParams { printf("funParam -> funParams\n"); }
;

funParams: declId { printf("funParams -> declId\n"); }
         | funParams Comma declId { printf("funParams -> funParams %s declId\n", $2); }
;

funStatements: { printf("funStatements -> \u03B5\n"); }
             | funStatements funStatement SemiColon { printf("funStatements -> funStatements funStatement %s\n", $3); }
;

funStatement: atribution { printf("funStatement -> atribution\n"); }
            | conditional { printf("funStatement -> conditional\n"); }
            | loop { printf("funStatement -> loop\n"); }
            | ret { printf("funStatement -> ret\n"); }
;

atribution: Id atrValue { printf("atribution -> %s atrValue\n", $1); }
;

conditional: If OpenPar condition ClosePar OpenBra funStatements CloseBra { printf("conditional -> %s %s condition %s %s funStatements %s\n", $1, $2, $4, $5, $7); }
           | If OpenPar condition ClosePar OpenBra funStatements CloseBra Else OpenBra funStatements CloseBra { printf("conditional -> %s %s condition %s %s funStatements %s %s %s funStatements %s\n", $1, $2, $4, $5, $7, $8, $9, $11); }
;

condition: exp Equals exp { printf("condition -> exp %s exp\n", $2); }
         | boolean Equals boolean { printf("condition -> boolean %s boolean\n", $2); }
         | boolean { printf("condition -> boolean\n"); }
;

loop: While OpenPar condition ClosePar OpenBra funStatements CloseBra { printf("loop -> %s %s condition %s %s funStatements %s\n", $1, $2, $4, $5, $7); }
;

ret: Return exp { printf("ret -> %s exp\n", $1); }
;

exp: exp Sum exp { printf("exp -> exp %s exp\n", $2); }
   | exp Mult exp { printf("exp -> exp %s exp\n", $2); }
   | OpenPar exp ClosePar { printf("exp -> %s exp %s\n", $1, $3); }
   | number { printf("exp -> number\n"); }
   | Id { printf("exp -> %s\n", $1); }
;
%%

int main(int argc, char **argv){
  yyparse();
  return 0;
}

int yyerror(char *s){
  fprintf(stderr, "Error: %s\n", s);
}