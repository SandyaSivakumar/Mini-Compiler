#!/bin/bash

lex icg_quad.l
yacc icg_quad.y
gcc y.tab.c -ll -ly -w
./a.out
