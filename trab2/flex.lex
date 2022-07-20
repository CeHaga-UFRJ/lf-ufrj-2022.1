LET [a-zA-Z_]
NUM [0-9]
ESP [ \t\n]

ID {LET}({LET}|{NUM})*
INTNUM 0|([1-9]{NUM}*)
FLOATNUM {INTNUM}"."{INTNUM}

%%
{INTNUM} printf("<INTNUM>:%s ", yytext);
{FLOATNUM} printf("<FLOATNUM>:%s ", yytext);

if printf("<IF> ");
else printf("<ELSE> ");
while printf("<WHILE> ");
var printf("<VAR> ");
const printf("<CONST> ");
return printf("<RETURN> ");
fn printf("<FN> ");
bool printf("<BOOL> ");
int printf("<INT> ");
float printf("<FLOAT> ");
bool printf("<BOOL> ");

{ID} printf("<ID>:%s ", yytext);
{ESP} {}
%%

int main()
{
  yylex();
  printf("\n");
  return 0;
}
