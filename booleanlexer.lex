structure Tokens = Tokens
	type col = int
	type pos = int
	type svalue = Tokens.svalue
	type ('a,'b) token = ('a,'b) Tokens.token  
	type lexresult = (svalue, pos) token
	
	val pos = ref 0
	val col = ref 0
	val eof = fn () => Tokens.EOF(!pos, !pos)

%%
%header (functor booleanLexFun(structure Tokens: boolean_TOKENS));
%count
alpha = [A-Za-z];
ws = [\ \t];

%%
\n				=> (col = 0; lex());
{ws}+			=> (col = (!col) + size(yytext); lex());
"AND"			=> (col = (!col) + 3; Tokens.AND(!pos,!pos));
"OR"			=> (col = (!col) + 2; Tokens.OR(!pos,!pos));
"XOR"			=> (col = (!col) + 3; Tokens.XOR(!pos,!pos));
"EQUALS"		=> (col = (!col) + 6; Tokens.EQUALS(!pos,!pos));
"NOT"			=> (col = (!col) + 3; Tokens.NOT(!pos,!pos));
"IMPLIES"		=> (col = (!col) + 7; Tokens.IMPLIES(!pos,!pos));
"IF"			=> (col = (!col) + 2; Tokens.IF(!pos,!pos));
"THEN"			=> (col = (!col) + 4; Tokens.THEN(!pos,!pos));
"ELSE"			=> (col = (!col) + 4; Tokens.ELSE(!pos,!pos));
"TRUE"|"FALSE"	=> (col = (!col) + size(yytext); Tokens.CONST(!pos,!pos));
"("				=> (col = (!col) + 1, Tokens.LPAREN(!pos,!pos));
")"				=> (col = (!col) + 1, Tokens.RPAREN(!pos,!pos));
";"				=> (col = (!col) + 1, Tokens.TERM(!pos,!pos));
{alpha}+		=> (col = (!col) + size(yytext); Tokens.ID(yytext,!pos,!pos));
"."				=> (raise invalidTokenError("Unknown Token:"^Int.toString(yylineno)^":"^Int.toString(!col)^":"^yytext));