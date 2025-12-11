Python Parser Project 
-
Class: CS 4450
Author: Ming Lin

In this project I implemented a parser for Python language.
The goal was to design a simplified, Python-like grammar using ANTLR4, generate a lexer and parser, 
and then test it against the sample programs. This is not meant to be a complete parser for python, but rather a sample to learn
about the features of language implementation.I also added a small GUI tool to make testing easier.

Requirements for Windows:
-

1.Install Python and Java
-

I used Python 3.11+, but any recent Python 3 version should work.

Download Python here:
    https://www.python.org/downloads/

Check installation:

    python --version

Java version 11+ should be able to use Antlr4

Download Java here:
    https://adoptium.net/

Check installation:
    
    java --version


2.Install ANTLR4 Runtime for Python
-

Run this

    pip install antlr4-python3-runtime

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Overview
-

ParserThree.g4 defines a small subset of Python that supports:

variable assignments

arithmetic expressions

boolean logic (and, or, not)

comparison operators (<, <=, ==, etc.)

lists ([1, 2, 3])

if / elif / else blocks

while loops

for loops (for x in expr:)

triple-quoted comments

single-line # comments

the ... placeholder

The grammar is new line sensitive but not scope indentation-sensitive like real Python. Meaning that it'll parse even if not perfectly indentented within a scope(if statement for example) Blocks are recognized based on NEWLINE groups instead of INDENT/DEDENT. This is enough to imitate the python parser for simple programs.

File Structure
-
ParserThree.g4          → grammar file (lexer + parser rules)
gen/                    → generated lexer/parser from ANTLR
run.py                  → GUI to run parser
project_deliverable_3.py  → Test codes

How to Build the Parser
-

Download the src code

1.Remove any old gen directory if applies.
    
    rmdir /s /q gen
or

    run rm_antlr.bat


2.Generate the lexer and parser

    antlr4 -Dlanguage=Python3 ParserThree.g4 -o gen
or

    run build_antlr.bat


3.Run the run.py:
    
    python run.py
Or

    python run.py [sample code]

How the GUI Works 
-

The GUI lets you type or paste code into a box and click Parse.

If the input has errors, only the error messages show.

If it is valid, it prints the token list and a readable parse tree.

It also catches lexer errors .

This ended up being very helpful when debugging grammar rules.


How to Read the Parse Tree
-


The parse tree shows how ANTLR understands your code.
Every grammar rule becomes a node in the tree.

For example, an assignment like:

    arith_op1 = expr


might appear in form of tokens:

    assignment:
        arith_op1
        =
        expr


The indentation shows which pieces belong together.
Nested rules appear under their parent rule, so you can easily tell how the expression was grouped and whether the grammar handled operator precedence correctly (for example, * before +).

The parse tree is mainly a debugging tool—it helps you verify that the grammar is working the way you expect.

