(*User  declarations*)

%%
(*Declarations*)
%name boolean

%term
	ID of string
	| CONST of string
	| AND | OR | XOR | EQUALS | IMPLIES | NOT | IF | THEN | ELSE
	| RPAREN | LPAREN | TERM | EOF

%nonterm
	START
	| program | statement | formula
	| boolexp | bool | expression | booleanexp

%pos int

(*optional declarations *)
%eop EOF
%noshift EOF

%right IF THEN ELSE
%right IMPLIES
%left AND OR XOR EQUALS
%right NOT

%start START

%verbose

%%
(*Rules*)
START:	program										(program1; print("START: program\n"))
program:	statement								(statement1; print("program: statement, "))
			| statement program						(statement1; program1; print("program: statement program, "))
statement:	formula TERM							(formula1; print(";, "); print("statement: formula TERM, "))
formula:	IF formula THEN formula ELSE formula	(print("IF, "); formula1; print("THEN, "); formula2; print("ELSE, "); formula3; print("formula: IF formula THEN formula ELSE formula, "))
			| boolexp								(boolexp1; print("formula: boolexp, "))
boolexp:	bool IMPLIES boolexp					(bool1; print("IMPLIES, "); boolexp1; print("boolexp: bool IMPLIES boolexp, "))
			| bool									(bool1; print("boolexp: bool, "))
bool:		bool AND expression						(bool1; print("AND, "); expression1; print("bool: bool AND expression, "))
			| bool OR expression					(bool1; print("OR, "); expression1; print("bool: bool OR expression, "))
			| bool XOR expression					(bool1; print("XOR, "); expression1; print("bool: bool XOR expression, "))
			| bool EQUALS expression				(bool1; print("EQUALS, "); expression1; print("bool: bool EQUALS expression, "))
			| expression							(expression1; print("bool: expression, "))
expression:	NOT expression							(print("NOT, "); expression1; print("expression: NOT expression, "))
			| booleanexp							(booleanexp1; print("expression: booleanexp, "))
booleanexp:	LPAREN formula RPAREN					(print("(, "); formula1; print("), "); print("booleanexp: LPAREN formula RPAREN, "))
			| CONST									(print(CONST1^", "); print("booleanexp: CONST, "))
			| ID									(print(ID1^", "); print("booleanexp: ID, "))