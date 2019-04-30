#!/bin/bash

lex symTbl.l
yacc -d symTbl.y
gcc lex.yy.c y.tab.c -ll -ly -w
./a.out < input.c
