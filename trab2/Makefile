lf:  lf.l lf.y
	bison -d lf.y
	flex lf.l
	gcc -o $@ lf.tab.c lex.yy.c -lfl