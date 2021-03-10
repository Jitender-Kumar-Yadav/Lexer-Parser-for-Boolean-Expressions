(*User Declarations*)
structure Tokens = Tokens
	type pos = int							(*keep track of the position of current token*)
	type svalue = Tokens.svalue
	type ('a,'b) token = ('a,'b) Tokens.token  
	type lexresult = (svalue, pos) token
	
	val col = ref 15
	val count = ref 0
	val eof = fn () => (print("]\n"); Tokens.EOF(3, !col))
	val ret = fn (e : string) => if ((!count) = 0) then print("["^e) else print(", "^e)

%%
%header (functor booleanLexFun(structure Tokens: boolean_TOKENS));
%count
alpha = [A-Za-z];
ws = [\ \t];

%%
\n				=> (col := 0; lex());
{ws}+			=> (col := (!col) + size(yytext); lex());
"AND"			=> (col := (!col) + 3; ret("AND \""^yytext^"\""); count := (!count) + 1; Tokens.AND(!yylineno,!col));
"OR"			=> (col := (!col) + 2; ret("OR \""^yytext^"\""); count := (!count) + 1; Tokens.OR(!yylineno,!col));
"XOR"			=> (col := (!col) + 3; ret("XOR \""^yytext^"\""); count := (!count) + 1; Tokens.XOR(!yylineno,!col));
"EQUALS"		=> (col := (!col) + 6; ret("EQUALS \""^yytext^"\""); count := (!count) + 1; Tokens.EQUALS(!yylineno,!col));
"NOT"			=> (col := (!col) + 3; ret("NOT \""^yytext^"\""); count := (!count) + 1; Tokens.NOT(!yylineno,!col));
"IMPLIES"		=> (col := (!col) + 7; ret("IMPLIES \""^yytext^"\""); count := (!count) + 1; Tokens.IMPLIES(!yylineno,!col));
"IF"			=> (col := (!col) + 2; ret("IF \""^yytext^"\""); count := (!count) + 1; Tokens.IF(!yylineno,!col));
"THEN"			=> (col := (!col) + 4; ret("THEN \""^yytext^"\""); count := (!count) + 1; Tokens.THEN(!yylineno,!col));
"ELSE"			=> (col := (!col) + 4; ret("ELSE \""^yytext^"\""); count := (!count) + 1; Tokens.ELSE(!yylineno,!col));
"TRUE"|"FALSE"	=> (col := (!col) + size(yytext); ret("CONST \""^yytext^"\""); count := (!count) + 1; Tokens.CONST(yytext,!yylineno,!col));
"("				=> (col := (!col) + 1; ret("LPAREN \""^yytext^"\""); count := (!count) + 1; Tokens.LPAREN(!yylineno,!col));
")"				=> (col := (!col) + 1; ret("RPAREN \""^yytext^"\""); count := (!count) + 1; Tokens.RPAREN(!yylineno,!col));
";"				=> (col := (!col) + 1; ret("TERM \""^yytext^"\""); count := (!count) + 1; Tokens.TERM(!yylineno,!col));
{alpha}+		=> (col := (!col) + size(yytext); ret("ID \""^yytext^"\""); count := (!count) + 1; Tokens.ID(yytext,!yylineno,!col));
.				=> (raise invalidTokenError("Unknown Token:"^Int.toString(!yylineno)^":"^Int.toString(!col)^":"^yytext));