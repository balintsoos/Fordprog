while: while.cc lex.yy.cc
	g++ -owhile while.cc lex.yy.cc

lex.yy.cc: while.l
	flex while.l

clean:
	rm -f lex.yy.cc while
