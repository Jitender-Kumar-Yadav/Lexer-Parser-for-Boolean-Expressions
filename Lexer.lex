(*User Declarations*)
structure Tokens = Tokens
	type col = int							(*keep track of the column number of current token*)
	type pos = int							(*keep track of the position of current token*)
	type svalue = Tokens.svalue
	type ('a,'b) token = ('a,'b) Tokens.token  
	type lexresult = (svalue, pos) token
	
	val pos = ref 0
	val col = ref 0
	val count = ref 0
	val eof = fn () => print("]\n"); Tokens.EOF(!pos, !pos)
	val ret = fn (e : string) => if (count = 0) then print("["^e) else print(", "^e)

%%
(*Definitions*)
%header (functor booleanLexFun(structure Tokens: boolean_TOKENS));
%count										(*keep track of the line number*)
alpha = [A-Za-z];
ws = [\ \t];

%%
(*Rules*)
\n				=> (col = 0; lex());
{ws}+			=> (col = (!col) + size(yytext); lex());
"AND"			=> (col = (!col) + 3; Tokens.ret("AND \""^yytext^"\""); count = (!count) + 1; Tokens.AND(!pos,!pos));
"OR"			=> (col = (!col) + 2; Tokens.ret("OR \""^yytext^"\""); count = (!count) + 1; Tokens.OR(!pos,!pos));
"XOR"			=> (col = (!col) + 3; Tokens.ret("XOR \""^yytext^"\""); count = (!count) + 1; Tokens.XOR(!pos,!pos));
"EQUALS"		=> (col = (!col) + 6; Tokens.ret("EQUALS \""^yytext^"\""); count = (!count) + 1; Tokens.EQUALS(!pos,!pos));
"NOT"			=> (col = (!col) + 3; Tokens.ret("NOT \""^yytext^"\""); count = (!count) + 1; Tokens.NOT(!pos,!pos));
"IMPLIES"		=> (col = (!col) + 7; Tokens.ret("IMPLIES \""^yytext^"\""); count = (!count) + 1; Tokens.IMPLIES(!pos,!pos));
"IF"			=> (col = (!col) + 2; Tokens.ret("IF \""^yytext^"\""); count = (!count) + 1; Tokens.IF(!pos,!pos));
"THEN"			=> (col = (!col) + 4; Tokens.ret("THEN \""^yytext^"\""); count = (!count) + 1; Tokens.THEN(!pos,!pos));
"ELSE"			=> (col = (!col) + 4; Tokens.ret("ELSE \""^yytext^"\""); count = (!count) + 1; Tokens.ELSE(!pos,!pos));
"TRUE"|"FALSE"	=> (col = (!col) + size(yytext); Tokens.ret("CONST \""^yytext^"\""); count = (!count) + 1; Tokens.CONST(!pos,!pos));
"("				=> (col = (!col) + 1; Tokens.ret("LPAREN \""^yytext^"\""); count = (!count) + 1; Tokens.ret(" \""^yytext^"\""); count = (!count) + 1; Tokens.LPAREN(!pos,!pos));
")"				=> (col = (!col) + 1; Tokens.ret("RPAREN \""^yytext^"\""); count = (!count) + 1; Tokens.RPAREN(!pos,!pos));
";"				=> (col = (!col) + 1; Tokens.ret("TERM \""^yytext^"\""); count = (!count) + 1; Tokens.TERM(!pos,!pos));
{alpha}+		=> (col = (!col) + size(yytext); Tokens.ret("ID \""^yytext^"\""); count = (!count) + 1; Tokens.ID(yytext,!pos,!pos));
"."				=> (raise invalidTokenError("Unknown Token:"^Int.toString(yylineno)^":"^Int.toString(!col)^":"^yytext));