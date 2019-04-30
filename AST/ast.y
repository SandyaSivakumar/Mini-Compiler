%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <ctype.h>
  
  void yyerror(char *);
  typedef struct Abstract_syntax_tree
  {
  	char *name;
  	struct Abstract_syntax_tree *left;
  	struct Abstract_syntax_tree *right;
  }node; 
  
  extern FILE *yyin;
  node* buildTree(char *,node *,node *);
  void printTree(node *);
  #define COUNT 10 
  #define YYSTYPE char*
  int count = 0;
%}

%start S
%token ID NUM T_lt T_gt T_lteq T_gteq T_neq T_eqeq T_and T_or T_incr T_decr T_not T_eq WHILE INT CHAR FLOAT VOID H MAINTOK INCLUDE BREAK CONTINUE IF ELSE COUT STRING FOR ENDL T_ques T_colon

%token T_pl T_min T_mul T_div
%left T_lt T_gt
%left T_pl T_min
%left T_mul T_div

%%
S
      : START {printf("Input accepted.\n");}
      ;

START
      : INCLUDE T_lt H T_gt MAIN 
      | INCLUDE "\"" H "\"" MAIN 
      ;

MAIN
      : VOID MAINTOK BODY 
      | INT MAINTOK BODY 
      ;

BODY
      : '{' C '}'
      ;

C
      : C statement ';' {printTree($2);printf("\n");printf("----------------------------------------------------------------\n");}
      | C LOOPS {printTree($2);printf("\n");printf("----------------------------------------------------------------\n");}
      | statement ';' {printTree($1);printf("\n");printf("----------------------------------------------------------------\n");}
      | LOOPS {printTree($1);printf("\n");printf("----------------------------------------------------------------\n");}
      ;

LOOPS
      : WHILE '(' COND ')' LOOPBODY {$$=buildTree("WHILE",$3,$5);}
      | FOR '(' ASSIGN_EXPR ';' COND ';' statement ')' LOOPBODY
      | IF '(' COND ')' LOOPBODY ELSE LOOPBODY 
      | IF '(' COND ')' LOOPBODY {$$=buildTree("IF",$3,$5);}
      
      ;


LOOPBODY
  	  : '{' LOOPC '}' {$$=$2;}
  	  | ';'
  	  | statement ';'
  	  ;

LOOPC
      : LOOPC statement ';' {$$=buildTree("SEQ",$1,$2);}
      | LOOPC LOOPS {$$=buildTree("SEQ",$1,$2);}
      | statement ';' {$$=$1;}
      | LOOPS {$$=$1;}
      ;

statement
      : ASSIGN_EXPR {$$ = $1;}
      | EXP {$$=$1;}
      | TERNARY_EXPR {$$=$1;}
      | PRINT
      ;

COND
      : LIT RELOP LIT {$$=buildTree($2,$1,$3);}
      | LIT {$$=$1;}
      | LIT RELOP LIT bin_boolop LIT RELOP LIT
      | un_boolop '(' LIT RELOP LIT ')'
      | un_boolop LIT RELOP LIT
      | LIT bin_boolop LIT
      | un_boolop '(' LIT ')'
      | un_boolop LIT
      ;

ASSIGN_EXPR
      : LIT T_eq EXP {$$=buildTree("=",$1,$3);}
      | TYPE LIT T_eq EXP {$$=buildTree("=",$2,$4);}
      ;

EXP
	  : ADDSUB {$$=$1;}
	  | EXP T_lt ADDSUB {$$=buildTree("<",$1,$3);}
	  | EXP T_gt ADDSUB {$$=buildTree(">",$1,$3);}
	  ;
	  
ADDSUB
      : TERM {$$=$1;}
      | EXP T_pl TERM {$$=buildTree("+",$1,$3);}
      | EXP T_min TERM {$$=buildTree("-",$1,$3);}
      ;

TERM
	  : FACTOR {$$=$1;}
      | TERM T_mul FACTOR {$$=buildTree("*",$1,$3);}
      | TERM T_div FACTOR {$$=buildTree("/",$1,$3);}
      ;
      
FACTOR
	  : LIT {$$=$1;}
	  | '(' EXP ')' {$$ = $2;}
  	  ;
      
TERNARY_EXPR
      : '(' COND ')' T_ques ternary_statement {$$=buildTree("?",$2,$5);}
      ;

ternary_statement
	  : statement T_colon statement {$$ = buildTree(":",$1,$3);}
	  ;

PRINT
      : COUT T_lt T_lt STRING 
      | COUT T_lt T_lt STRING T_lt T_lt ENDL 
      ;
LIT
      : ID {$$ = buildTree((char *)yylval,0,0);}
      | NUM {$$ = buildTree((char *)yylval,0,0);}
      ;
TYPE
      : INT 
      | CHAR 
      | FLOAT
      ;
RELOP
      : T_lt { $$ = "<";}
      | T_gt { $$ = ">";}
      | T_lteq { $$ = "<=";}
      | T_gteq { $$ = ">=";}
      | T_neq { $$ = "!=";}
      | T_eqeq { $$ = "==";}
      ;
bin_boolop
      : T_and 
      | T_or 
      ;

un_arop
      : T_incr 
      | T_decr 
      ;

un_boolop
      : T_not 
      ;


%%
int main(int argc,char *argv[])
{
  yyin = fopen("phase2_input.c","r");
  /*
  node *root,*temp;
  root = (node*)malloc(sizeof(node));
  temp = (node*)malloc(sizeof(node));
  */
  if(!yyparse())  //yyparse-> 0 if success
  {
    printf("Parsing Complete\n");
  }
  else
  {
    printf("Parsing failed\n");
  }
  fclose(yyin);
  return 0;
}


node* buildTree(char *op,node *left,node *right)
{
	node *new = (node*)malloc(sizeof(node));
	char *newstr = (char *)malloc(strlen(op)+1);
	strcpy(newstr,op);
	new->left=left;
	new->right=right;
	new->name=newstr;
	return (new);
}

void printTree(node *tree)
{
	if(tree->left || tree->right)
		printf("(");
	printf(" %s ",tree->name);
	if(tree->left)
		printTree(tree->left);
	if(tree->right)
		printTree(tree->right);
	if(tree->left || tree->right)
		printf(")");
	
}
/*
void printTree(node *tree,int space)
{
	if(tree == NULL)
		return;
	
	space += COUNT;
	
	printTree(tree->right, space);
	
	printf("\n");
	
	for(int i = COUNT ;i < space; i++)
		printf(" ");
	printf("%s\n",tree->name);
	
	printTree(tree->left, space);
}*/
