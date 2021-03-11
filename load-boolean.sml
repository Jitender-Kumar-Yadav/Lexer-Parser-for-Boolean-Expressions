structure booleanLrVals = booleanLrValsFun(structure Token = LrParser.Token)
structure booleanLex = booleanLexFun(structure Tokens = booleanLrVals.Tokens);
structure booleanParser =
	  Join(structure LrParser = LrParser
     	       structure ParserData = booleanLrVals.ParserData
     	       structure Lex = booleanLex)

fun invoke lexstream =
    	     	let fun print_error (s, linenum:int, col:int) =
					TextIO.output(TextIO.stdOut, "Syntax Error:" ^ (Int.toString linenum) ^ ":" ^ (Int.toString col) ^ ":" ^ s ^ "\n")
		in
		    booleanParser.parse(0, lexstream, print_error, ())
		end

fun stringToLexer str =
    let val done = ref false
    	val lexer =  booleanParser.makeLexer (fn _ => if (!done) then "" else (done:=true;str))
    in
	lexer
    end

fun parse (lexer) =
    let
		val dummyEOF = booleanLrVals.Tokens.EOF(0,0)
    	val (result, lexer) = invoke lexer
		val (nextToken, lexer) = booleanParser.Stream.get lexer
    in
        if booleanParser.sameToken(nextToken, dummyEOF) then result
		else (TextIO.output(TextIO.stdOut, "Warning: Unconsumed input \n"); result)
    end

val parseString = parse o stringToLexer

fun scanParse filename =
	let
		val file = TextIO.openIn filename
        val s = TextIO.inputAll file
        val _ = TextIO.closeIn file
    in
		(parseString(s)) 
	end
		handle invalidTokenError msg => print("\n"^msg^"\n");