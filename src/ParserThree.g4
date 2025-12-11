grammar ParserThree;

// --------------------
// Parser rules
// --------------------

file_input
    : NEWLINE* (stmt (NEWLINE+ stmt)*)? NEWLINE* EOF
    ;

// statement
//  - assignment 
//  - bare expression 
//  - if / elif / else block
//  - while loop
//  - for loop
stmt
    : assignment
    | expr
    | if_stmt
    | while_stmt
    | for_stmt
    ;

// if / elif / else chains
if_stmt
    : IF expr ':' NEWLINE block
      (NEWLINE+ ELIF expr ':' NEWLINE block)*
      (NEWLINE+ ELSE ':' NEWLINE block)?
    ;

// while loop: while <expr> : <block>
while_stmt
    : WHILE expr ':' NEWLINE block
    ;

// for loop
for_stmt
    : FOR NAME IN expr ':' NEWLINE block
    ;

// A block 
block
    : stmt (NEWLINE+ stmt)*
    ;

// --------------------
// Expressions & assignments
// --------------------

// Assignment with =, +=, -=, *=, /=
assignment
    : target ('=' | '+=' | '-=' | '*=' | '/=') expr
    ;

target
    : NAME
    ;

// boolean logic
expr
    : orExpr
    ;

// or 
orExpr
    : andExpr (OR andExpr)*
    ;

// and 
andExpr
    : notExpr (AND notExpr)*
    ;

// not 
notExpr
    : NOT notExpr
    | compareExpr
    ;

// comparisons like a > b, a == b, a != b, etc.
compareExpr
    : addExpr (compOp addExpr)?
    ;

compOp
    : '<'
    | '>'
    | LE
    | GE
    | EQ
    | NE
    ;

// arithmetic precedence: +,- then *,/,% then unary -
addExpr
    : mulExpr (('+' | '-') mulExpr)*
    ;

mulExpr
    : unaryExpr (('*' | '/' | '%') unaryExpr)*
    ;

unaryExpr
    : '-' unaryExpr
    | primary
    ;

// literals, names, parenthesized expr, list literals, or ...
primary
    : literal
    | NAME
    | '(' expr ')'
    | listLiteral
    | ELLIPSIS              // handles the "..." line 
    ;

// Lists
listLiteral
    : '[' (expr (',' expr)* (',')?)? ']'
    ;

// Literals used in the project
literal
    : INT
    | FLOAT
    | STRING
    | TRUE
    | FALSE
    ;

// --------------------
// Lexer rules
// --------------------

// Numbers
FLOAT
    : DIGITS '.' DIGITS?
    | '.' DIGITS
    ;

INT
    : DIGITS
    ;

fragment DIGITS
    : [0-9]+
    ;

// Triple-quoted block string 
TRIPLE_STRING
    : '\'\'\'' ( ~'\'' | '\'' '\''? )* '\'\'\'' -> skip
    ;

// Strings: single or double quoted with basic escapes
STRING
    : '"'  ( ~["\\]  | '\\' . )* '"'
    | '\'' ( ~['\\] | '\\' . )* '\''
    ;

// Booleans as keywords
TRUE  : 'True';
FALSE : 'False';

// Keywords for control flow & boolean logic
IF    : 'if';
ELIF  : 'elif';
ELSE  : 'else';
WHILE : 'while';
FOR   : 'for';
IN    : 'in';
AND   : 'and';
OR    : 'or';
NOT   : 'not';

// Comparison operators 
LE : '<=';
GE : '>=';
EQ : '==';
NE : '!=';

// "..." line in the sample code
ELLIPSIS
    : '...'
    ;

// Identifiers 
NAME
    : [a-zA-Z_][a-zA-Z_0-9]*
    ;

// Newlines 
NEWLINE
    : ('\r'? '\n')+
    ;

// Skip spaces/tabs 
WS
    : [ \t]+ -> skip
    ;

// Skip comments
COMMENT
    : '#' ~[\r\n]* -> skip
    ;
