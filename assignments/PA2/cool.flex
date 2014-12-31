/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

#define ADD_TO_STRING(c) \
    if (string_buf_ptr + 1 > &string_buf[MAX_STR_CONST - 1]) { \
        BEGIN(INVALID_STRING); \
        RETURN_ERROR("String constant too long"); \
    } else { \
        *string_buf_ptr = c; \
        string_buf_ptr++; \
    }

#define RETURN_ERROR(err) \
    cool_yylval.error_msg = err; \
    return ERROR;

int comment_lineno = 0;

%}

%Start STRING INVALID_STRING COMMENT
%%

<INITIAL>{
     /*
      *  Operators and symbols.
      */
    "("                                 return '(';
    ")"                                 return ')';
    "."                                 return '.';
    "@"                                 return '@';
    "~"                                 return '~';
    "*"                                 return '*';
    "/"                                 return '/';
    "+"                                 return '+';
    "-"                                 return '-';
    "<="                                return LE;
    "<"                                 return '<';
    "="                                 return '=';
    "<-"                                return ASSIGN;
    "{"                                 return '{';
    "}"                                 return '}';
    ":"                                 return ':';
    ";"                                 return ';';
    ","                                 return ',';
    "=>"                                return DARROW;

     /*
      * Keywords are case-insensitive except for the values true and false,
      * which must begin with a lower-case letter.
      */
    [cC][lL][aA][sS][sS]                return CLASS;
    [eE][lL][sS][eE]                    return ELSE;
    [fF][iI]                            return FI;
    [iI][fF]                            return IF;
    [iI][nN]                            return IN;
    [iI][nN][hH][eE][rR][iI][tT][sS]    return INHERITS;
    [iI][sS][vV][oO][iI][dD]            return ISVOID;
    [lL][eE][tT]                        return LET;
    [lL][oO][oO][pP]                    return LOOP;
    [pP][oO][oO][lL]                    return POOL;
    [tT][hH][eE][nN]                    return THEN;
    [wW][hH][iI][lL][eE]                return WHILE;
    [cC][aA][sS][eE]                    return CASE;
    [eE][sS][aA][cC]                    return ESAC;
    [nN][eE][wW]                        return NEW;
    [oO][fF]                            return OF;
    [nN][oO][tT]                        return NOT;
    t[rR][uU][eE]                       {   cool_yylval.boolean = true;
                                            return BOOL_CONST; }
    f[aA][lL][sS][eE]                   {   cool_yylval.boolean = false;
                                            return BOOL_CONST; }

     /*
      * Integers and identifiers
      */
    [A-Z][a-zA-Z0-9_]*                  {   cool_yylval.symbol = idtable.add_string(yytext);
                                            return TYPEID; }

    [a-z][a-zA-Z0-9_]*                  {   cool_yylval.symbol = idtable.add_string(yytext);
                                            return OBJECTID; }

    [0-9]+                              {   cool_yylval.symbol = inttable.add_string(yytext);
                                            return INT_CONST; }
}

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */
<INITIAL>{
    \"                              {   string_buf_ptr = string_buf;
                                        BEGIN(STRING); }
}

<STRING>{
    
    \"                              {   *string_buf_ptr = '\0';
                                        cool_yylval.symbol = stringtable.add_string(string_buf);
                                        BEGIN(INITIAL);
                                        return STR_CONST; }

    \n                              {   curr_lineno++;
                                        BEGIN(INITIAL);
                                        RETURN_ERROR("Unterminated string constant"); }

    <<EOF>>                         {   BEGIN(INITIAL);
                                        RETURN_ERROR("EOF in string constant"); }

    \\?\0                           {   BEGIN(INVALID_STRING);
                                        RETURN_ERROR("String contains null character"); }

    

    \\b                             ADD_TO_STRING('\b');
    \\t                             ADD_TO_STRING('\t');
    \\n                             ADD_TO_STRING('\n');
    \\f                             ADD_TO_STRING('\f');
    \\\n                            {   curr_lineno++;
                                        ADD_TO_STRING('\n'); }                          

    \\.                             ADD_TO_STRING(yytext[1]);
    .                               ADD_TO_STRING(yytext[0]);
}

<INVALID_STRING>{
    \"                              BEGIN(INITIAL);
    \n                              {   curr_lineno++;
                                        BEGIN(INITIAL); }
    \\\n                            curr_lineno++;
    .                               ;
}

 /*
  *  Comments.
  */

<INITIAL>{
    "--".*                          ;
    "*)"                            RETURN_ERROR("Unmatched *)");
    "(*"                            {   BEGIN(COMMENT);
                                        comment_lineno++; }
}

<COMMENT>{
    "(*"                        comment_lineno++;

    <<EOF>>                     {   BEGIN(INITIAL);
                                    RETURN_ERROR("EOF in comment"); } 

    "*)"                        {   comment_lineno--;   
                                    if (comment_lineno == 0) {
                                        BEGIN(INITIAL);
                                    }
                                }

    .                           ;
}
    


 /*
  *  Whitespace.
  */

\n                              curr_lineno++;
[\t\v\f\r ]                     ; 
.                               RETURN_ERROR(yytext);


%%
