lexer grammar LangLexer;

// This toy language illustrates how you can embed domain specific languages
// within an outer general language, like how a C# program can contain LINQ.

// Most of the "magic" for doing that takes place in the lexer.  I use the
// made-up verb "quasiquoting" to describe the escape sequence chosen.  It is
// implemented by switching to different "modes" in the ANTLR4 lexer.

// The two DSLs embedded in this grammar are a SQL and a CSV.  I cheesed the
// SQL one a bit by just letting it be anything (.*) until the closing quasiquote.
// The project this example is derived from just passed that on to SQLite to parse.
// The CSV DSL gets parsed for real including a separate CSV_HEADER step.

// The language this grammar describes uses the combination of characters, {|, as an
// escape to start other lexer modes.  Think of this lexer line as a conditional goto.
// It has to be high up to prevent a more general token from grabbing these characters.
OPEN_QUASIQUOTE : '{|' -> mode(QUASIQUOTE);

// Come to think of it, I should probably have put the comment rules above the quasiquote...
LINE_COMMENT: '//' ~[\r\n]* (('\r'? '\n') | EOF) -> skip;
BLOCK_COMMENT: '/*' .*? '*/' -> skip;

// All of these middle lexer rules, identifiers that don't start with CSV_* or SQL_*,
// form the tokens of the "outer language" the one not in quasiquotes.

// The same token literal will get different token numbers depending on which 
// lexer mode we're in.  For example COMMA and CSV_COMMA are both ',' but they
// are different tokens.  For this reason you should only refer to them by identifier
// and not by a literal in single quotes when writing rules for the parser grammar.

LET : 'let';
PLUS : '+';
MINUS : '-';
MULT : '*';
DIV : '/';
ASGN : '=';
IDENT  :   [a-zA-Z_] [a-zA-Z_0-9]* ;
INT :   [0-9]+ ;         // match integers
OPEN_PAR : '(';
CLOSE_PAR : ')';
OPEN_BRACE : '{';
CLOSE_BRACE : '}';
COLON : ':';
SEMICOLON : ';';
BAR : '|';
AMP : '&';
COMMA: ',';
DOT: '.';

WS  :   [ \t\r\n]+ -> skip ; // toss out whitespace

mode QUASIQUOTE;
QUASIQUOTE_CSV : 'CSV' -> mode(CSV_HEADER);
QUASIQUOTE_SQL : 'SQL' -> mode(SQLITE);
QUASIQUOTE_WS  :   [ \t]+ -> skip ; // toss out whitespace

mode CSV_HEADER;

CSV_HDR_OPEN_PAR : '(';
CSV_HDR_CLOSE_PAR : ')';
CSV_HDR_COLON : ':';
CSV_HDR_COMMA : ',';
CSV_HDR_ID  :   [a-zA-Z_] [a-zA-Z_0-9]* ;
CSV_HDR_NEWLINE : '\r'? '\n' -> mode(CSV);
CSV_HDR_WS  :   [ \t]+ -> skip ; // toss out whitespace

mode CSV;

CSV_CLOSE_QUASIQUOTE : '|}' -> mode(DEFAULT_MODE);

// TODO: Should CSV_TEXT be below CSV_WS and/or newline?

CSV_COMMA : ',';
CSV_TEXT   : ~[ ,\n\r"|}]+ ;
CSV_NEWLINE : '\r'? '\n';
CSV_STRING : '"' ('""'|~'"')* '"' ; // quote-quote is an escaped quote
CSV_WS  :   [ \t]+ -> skip ; // toss out whitespace

mode SQLITE;

SQL_CLOSE_QUASIQUOTE : '|}' -> mode(DEFAULT_MODE);
SQL_WS  :   [ \t\n]+ -> skip ; // toss out whitespace
SQL_ANYTHING : .+?;
