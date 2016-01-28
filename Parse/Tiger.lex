package Parse;
import ErrorMsg.ErrorMsg;

%%

%implements Lexer
%function nextToken
%type java_cup.runtime.Symbol
%char

%{
private void newline() {
  errorMsg.newline(yychar);
}

private void err(int pos, String s) {
  errorMsg.error(pos,s);
}

private void err(String s) {
  err(yychar,s);
}

private java_cup.runtime.Symbol tok(int kind) {
    return tok(kind, null);
}

private java_cup.runtime.Symbol tok(int kind, Object value) {
    return new java_cup.runtime.Symbol(kind, yychar, yychar+yylength(), value);
}

private ErrorMsg errorMsg;

Yylex(java.io.InputStream s, ErrorMsg e) {
  this(s);
  errorMsg=e;
}

%}

%eofval{
	{
	 return tok(sym.EOF, null);
        }
%eofval}

//uhh maybe this is comment?
//taken from gb
ALPHA=[A-Za-z]
DIGIT=[0-9]
WHITE_SPACE_CHAR=[\n\ \t\b\012]
STRING_TEXT=(\\\"|[^\n\"]|\\{WHITE_SPACE_CHAR}+\\)*


%%
" "	{}
\n	{newline();}
","	{return tok(sym.COMMA, null);}
. { err("Illegal character: " + yytext()); }

<YYINITIAL> [0-9]+ {return tok(sym.INT, Integer.parseInt(yytext()));}
<YYINITIAL> \"{STRING_TEXT}\" {
  return tok(sym.STRING, yytext());
}

<YYINITIAL> {ALPHA}({ALPHA}|{DIGIT}|_)* {return tok(sym.ID, yytext());}
