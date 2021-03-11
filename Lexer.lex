(*User Declarations*)
structure Tokens = Tokens
	type pos = int							(*keep track of the position of current token*)
	type svalue = Tokens.svalue
	type ('a,'b) token = ('a,'b) Tokens.token  
	type lexresult = (svalue, pos) token
	
	val col = ref 0
	val curr = ref 0
	val yylineno = ref 1
	val count = ref 0
	val eof = fn () => (print("]\n"); Tokens.EOF(!yylineno, !col))
	val ret = fn (e : string) => if ((!count) = 0) then print("["^e) else print(", "^e)

%%
%header (functor booleanLexFun(structure Tokens: boolean_TOKENS));
alpha = [A-Za-z];
ws = [\ \t];

%%
\n				=> (curr := !col; col := 0; yylineno := !yylineno + 1; lex());
{ws}+			=> (curr := !col; col := (!col) + size(yytext); lex());
"AND"			=> (curr := !col; col := (!col) + 3; ret("AND \""^yytext^"\""); count := (!count) + 1; Tokens.AND(!yylineno,!curr));
"OR"			=> (curr := !col; col := (!col) + 2; ret("OR \""^yytext^"\""); count := (!count) + 1; Tokens.OR(!yylineno,!curr));
"XOR"			=> (curr := !col; col := (!col) + 3; ret("XOR \""^yytext^"\""); count := (!count) + 1; Tokens.XOR(!yylineno,!curr));
"EQUALS"		=> (curr := !col; col := (!col) + 6; ret("EQUALS \""^yytext^"\""); count := (!count) + 1; Tokens.EQUALS(!yylineno,!curr));
"NOT"			=> (curr := !col; col := (!col) + 3; ret("NOT \""^yytext^"\""); count := (!count) + 1; Tokens.NOT(!yylineno,!curr));
"IMPLIES"		=> (curr := !col; col := (!col) + 7; ret("IMPLIES \""^yytext^"\""); count := (!count) + 1; Tokens.IMPLIES(!yylineno,!curr));
"IF"			=> (curr := !col; col := (!col) + 2; ret("IF \""^yytext^"\""); count := (!count) + 1; Tokens.IF(!yylineno,!curr));
"THEN"			=> (curr := !col; col := (!col) + 4; ret("THEN \""^yytext^"\""); count := (!count) + 1; Tokens.THEN(!yylineno,!curr));
"ELSE"			=> (curr := !col; col := (!col) + 4; ret("ELSE \""^yytext^"\""); count := (!count) + 1; Tokens.ELSE(!yylineno,!curr));
"TRUE"|"FALSE"	=> (curr := !col; col := (!col) + size(yytext); ret("CONST \""^yytext^"\""); count := (!count) + 1; Tokens.CONST(yytext,!yylineno,!curr));
"("				=> (curr := !col; col := (!col) + 1; ret("LPAREN \""^yytext^"\""); count := (!count) + 1; Tokens.LPAREN(!yylineno,!curr));
")"				=> (curr := !col; col := (!col) + 1; ret("RPAREN \""^yytext^"\""); count := (!count) + 1; Tokens.RPAREN(!yylineno,!curr));
";"				=> (curr := !col; col := (!col) + 1; ret("TERM \""^yytext^"\""); count := (!count) + 1; Tokens.TERM(!yylineno,!curr));
{alpha}+		=> (curr := !col; col := (!col) + size(yytext); ret("ID \""^yytext^"\""); count := (!count) + 1; Tokens.ID(yytext,!yylineno,!curr));
.				=> (raise invalidTokenError("Unknown Token:"^Int.toString(!yylineno)^":"^Int.toString(!col)^":"^yytext));