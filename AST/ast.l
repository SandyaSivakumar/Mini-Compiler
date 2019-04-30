%{
    #include<string.h>
    #include<stdio.h>
    #include "y.tab.h"
%}

alpha [A-Za-z_]
digit [0-9]

%%
[ \t\n] ;
":" {return T_colon;}
"?" {return T_ques;}
"while" {return WHILE;}
"for" {return FOR;}
"if" {return IF;}
"else" {return ELSE;}
"cout" {return COUT;}
"endl" {return ENDL;}
"break" {return BREAK;}
"continue" {return CONTINUE;}
"int" {return INT;}
"float" {return FLOAT;}
"char" {return CHAR;}
"void" {return VOID;}
"#include" {return INCLUDE;}
"main()" {return MAINTOK;}
{digit}+    {yylval = (int)yytext; return NUM;}
{digit}+.{digit}+ {return FLOAT;}
{alpha}({alpha}|{digit})* {yylval = yytext;return ID;}
{alpha}({alpha}|{digit})*"\.h"?  {return H;}
\".*\" {return STRING;}
"<" {return T_lt;}
">"     {return T_gt;}
"="     {return T_eq;}
"<="    {return T_lteq;}
">="    {return T_gteq;}
"=="    {return T_eqeq;}
"!="    {return T_neq;}
"+"     {return T_pl;}
"-"     {return T_min;}
"*"     {return T_mul;}
"/"     {return T_div;}
"++"    {return T_incr;}
"--"    {return T_decr;}
"!"     {return T_neq;}
"||"    {return T_or;}
"&&"    {return T_and;}


.    return yytext[0];

%%
int yywrap (void)
{return 1;} 
