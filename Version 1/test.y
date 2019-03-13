%{
#include <stdio.h>
#include <iostream>
#include <string.h>
#include "node.hpp"
#include <vector>

using namespace std;
int scope_count=0;
ast test;
ast test1;
unordered_map <string,int> size_map;
const char *s = "Hello, World!";   

class test123{
	int a;
	public:
	test123(){
		a=5;
	}
	void print_func(){
		cout<<"A is "<<a<<"\n";
	}

};



void yyerror(const char *error_msg);

int counter = 0;
extern FILE *yyin;
extern FILE *yyout; 
extern int yylineno;
extern "C"
{       
        int yyparse(void);
        int yylex(void);  
        int yywrap()
        {
                return 1;
        }

}
%}

%union {
	char* str;
	class node* node;
}

%token <str> ID NUM INT FLOAT CHAR DOUBLE VOID AMP DM DP '+' '-' '*' '(' ')' '[' ']'
%token FOR WHILE IF ELSE 


%right ','
%right '='
%left AND OR
%left  LE GE EQ NE LT GT 
%left '+' '-'
%left '*' '/' '%'	
%right	DP DM 
%left '(' ')'

%type<str> type func_call array_st_usage
%type<node> array_st assignment_st assignment_st_t assignment_st_f
%start init


%%
init
	: init declaration
	| init func_declaration 
	| 
	;

declaration
	: type assignment_st ';' {
		// cout<<"BIG SCOPE\n";
		$2->set_size(size_map[$1]);
		$2->set_type($1);
		// $2->disp_node(); 
		test1.insert(*$2);}
	| assignment_st ';' {

	}
	| type array_st';'{
		$2->set_size($2->get_size()*size_map[$1]);
		$2->set_type($1);
		// $2->disp_node(); 
		test1.insert(*$2);
	}
	;
 
array_st
	: ID '[' NUM ']' {$$ = new node(yylineno,$1,"","",$3);}
	;

array_st_usage
	: ID '[' NUM ']' 
	{
	vector<string> temp1{$1,$2,$3,$4};
    $$ = conversion(temp1);
	}	
	;

func_declaration
	: type ID '(' arg_list_optional ')' compound_st
	;
func_call
	:ID '(' arg_list_call ')'';'
	;

compound_st 
	: '{' statement_structure CLOSE {scope_count+=1;}
	;
CLOSE 
	: '}' {scope_count-=1;}
statement_structure 
	: statement_structure statement
	| statement
	;

statement
	: declaration
	| while_stmt
	| for_stmt
	| if_stmt
	;

for_stmt: FOR '(' assignment_st_for ';' expression_for ';' assignment_st_for ')' statement 
	|
 	FOR '(' assignment_st_for ';' expression_for ';' assignment_st_for ')' compound_st 
 	;
while_stmt: WHILE '(' expression ')' statement
	| WHILE '(' expression ')' compound_st
	;

start_if_stmt : IF '(' expression ')' statement; 
start_if_compound_st: IF '(' expression ')' compound_st; 
if_stmt : start_if_stmt
	| start_if_compound_st
	| start_if_stmt ELSE statement
	| start_if_stmt ELSE compound_st
	| start_if_compound_st ELSE statement
	| start_if_compound_st ELSE compound_st
	;	



arg_list_optional
	: arg_list_actual 
	| 
	;
arg_list_call
	:arg_list_call_actual
	|
	;
arg_list_call_actual
	:arg_list_call_actual ',' ID
	|ID
	;
arg_list_actual 
	: arg_list_actual ',' arg_final 
	| arg_final
	;

arg_final
	:type ID
	;

assignment_st_for
	: 
	|	assignment_st
	;

assignment_st
	:	ID '=' assignment_st	{$$ = new node(yylineno,$1,"",$3->get_value(),0);};
	|	assignment_st ',' assignment_st
	|	assignment_st '+' assignment_st_t
	|	assignment_st '-' assignment_st_t	
	|	assignment_st_t
	;

assignment_st_t
	:	assignment_st_t '*' assignment_st_f
	|	assignment_st_t '/' assignment_st_f
	|	assignment_st_t '%' assignment_st_f
	|	assignment_st_f
	;
assignment_st_f
	:	'(' assignment_st ')' 
		{
		vector<string> temp1{$1,$2->get_value(),$3};
		$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	'-' '(' assignment_st ')'
		{
		vector<string> temp1{$1,$2,$3->get_value(),$4};
		$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	DM ID
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	DP ID
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	DP NUM
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}	
	|	DM NUM
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	ID DP
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	ID DM
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	NUM DP
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	NUM DM
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	'+' NUM
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	'-' NUM	
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	'+' ID
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	'-' ID 
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	'*'ID
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	AMP ID
		{
			vector<string> temp1{$1,$2};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	ID
		{
			vector<string> temp1{$1};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	NUM
		{
			vector<string> temp1{$1};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	'*' assignment_st
		{
			vector<string> temp1{$1,$2->get_value()};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	array_st_usage	
		{	
			vector<string> temp1{$1};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	|	func_call
		{
			vector<string> temp1{$1};
			$$ = new node(yylineno,"","",conversion(temp1),0);
		}
	;



			




type
	: INT {$$=$1;}
	| FLOAT {$$=$1;}
	| CHAR {$$=$1;}
	| DOUBLE {$$=$1;}
	| VOID {$$=$1;}
	;

expression_for
	:
	| expression
	;

expression:  expression LE expression 
	| expression GE expression
	| expression NE expression
	| expression EQ expression
	| expression GT expression
	| expression LT expression
	| ID {printf("Value1 is %s\n",$1);}
	| NUM {printf("Value2 is %s\n",$1);}
	;
%%




void yyerror(const char *error_msg) {
	printf("error_msg: %s\n", error_msg);
}

int main(int argc, char *argv[]) {


    
	size_map["char"]=1;
	size_map["int"]=4;
	size_map["float"]=4;
	size_map["double"]=8;

	std:: string file_name(argv[1]);
	// cout<<"HELLO WORLD\n";
	yyin = fopen(argv[1], "r");
	char p[100];
	strcat(p,argv[1]);
	strcat(p,"_");
	strcat(p,"c.txt");
	yyout=fopen(p,"w");
	if (!yyparse()) {
		printf("successful\n");
	} else {
		printf("unsuccessful\n");
	}


	// test.insert(1,s,"int","",4,);
	// test.insert(3,s,"float","",4);
	// test.insert(2,s,"double","",8);


	// const char *s1 = "Hello, World!1";   
	// test.insert(4,s1,"int","",4);
	// test.insert(4,s1,"float","",4);
	// test.insert(5,s1,"double","",8);



// test.display();
	cout<<"TEST1 is \n";
	test1.display();
	fclose(yyin);
	fclose(yyout);

	return 0;
}


