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

ALPHA=[A-Za-z]
DIGIT=[0-9]
WHITE_SPACE_CHAR=[\n\ \t\b\012]
STRING_TEXT=(\\\"|[^\n\"]|\\{WHITE_SPACE_CHAR}+\\)*


%%
" "	{}
<YYINITIAL> \n	{newline();}
<YYINITIAL> ","	{return tok(sym.COMMA, null);}
<YYINITIAL> ":" {return tok(sym.COLON, null);}
<YYINITIAL> "." {return tok(sym.DOT, null);}
<YYINITIAL> "/" {return tok(sym.DIVIDE, null);}
<YYINITIAL> "-" {return tok(sym.MINUS, null);}
<YYINITIAL> "+" {return tok(sym.PLUS, null);}
<YYINITIAL> "*" {return tok(sym.TIMES, null);}
<YYINITIAL> ">" {return tok(sym.GT, null);}
<YYINITIAL> "<" {return tok(sym.LT, null);}
<YYINITIAL> "<=" {return tok(sym.LE, null);}
<YYINITIAL> ">=" {return tok(sym.GE, null);}
<YYINITIAL> "<>" {return tok(sym.NEQ, null);}
<YYINITIAL> "(" {return tok(sym.LPAREN, null);}
<YYINITIAL> ")" {return tok(sym.RPAREN, null);}
<YYINITIAL> ";" {return tok(sym.SEMICOLON, null);}
<YYINITIAL> "[" {return tok(sym.LBRACK, null);}
<YYINITIAL> "]" {return tok(sym.RBRACK, null);}
<YYINITIAL> "{" {return tok(sym.LBRACE, null);}
<YYINITIAL> "}" {return tok(sym.RBRACE, null);}
<YYINITIAL> "&" {return tok(sym.AND, null);}
<YYINITIAL> "|" {return tok(sym.OR, null);}
<YYINITIAL> "=" {return tok(sym.EQ, null);}
<YYINITIAL> ":=" {return tok(sym.ASSIGN, null);}


. { err("Illegal character: " + yytext()); }

<YYINITIAL> [0-9]+ {return tok(sym.INT, Integer.parseInt(yytext()));}
<YYINITIAL> \"{STRING_TEXT}\" {
  return tok(sym.STRING, yytext());
}

<YYINITIAL> {ALPHA}({ALPHA}|{DIGIT}|_)* {return tok(sym.ID, yytext());}
