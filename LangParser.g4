parser grammar LangParser;

options {
	tokenVocab = LangLexer;
}

/** The start rule; begin parsing here. */
prog:   stat* EOF ;


stat: (
        let_stmt
    |   expr
    ) SEMICOLON
    ;

let_stmt: LET var_name=IDENT (COLON var_type=type_annotation)? ASGN var_init=expr;

type_annotation: IDENT;

identifier: IDENT;

expr:
	    OPEN_QUASIQUOTE quasiquote #quasiquoteExpr
    |   lhs=expr op=(MULT|DIV|AMP) rhs=expr #binOpExpr1
    |   lhs=expr op=(PLUS|MINUS|BAR) rhs=expr #binOpExpr2
    |   call_expression #callExpr
    |   INT  #intExpr
    |   identifier #idExpr
    |   OPEN_PAR expr CLOSE_PAR #parenExpr
    |   lhs=identifier op=DOT rhs=identifier #dotExpr
    ;

call_expression: call_target_name=IDENT OPEN_PAR call_param_list CLOSE_PAR;
call_param_list: expr (COMMA expr)*;

quasiquote:
	   QUASIQUOTE_SQL SQL_ANYTHING* SQL_CLOSE_QUASIQUOTE #quasiQuoteSql
	|  QUASIQUOTE_CSV csv_header csv_row_list CSV_CLOSE_QUASIQUOTE #quasiQuoteCsv
    ;

csv_header: CSV_HDR_OPEN_PAR csv_params_list CSV_HDR_CLOSE_PAR CSV_HDR_NEWLINE;
csv_params_list: csv_param (CSV_HDR_COMMA csv_param)*;
csv_param: CSV_HDR_ID (CSV_HDR_COLON CSV_HDR_ID)?;
csv_row_list: csv_row+;
csv_row: csv_field (CSV_COMMA csv_field)* CSV_NEWLINE;
csv_field:  CSV_TEXT #csvTextField
        |   CSV_STRING #csvStringField
        |   #csvEmptyField
        ;
