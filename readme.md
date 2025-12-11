Python Parser Project

Class: CS 4450

By:Ming Lin

In this project I implemented a parser for Python language.
The goal was to design a simplified, Python-like grammar using ANTLR4, generate a lexer and parser, 
and then test it against the sample programs. This is not meant to be a complete parser for python, but rather a sample to learn
about the features of language implementation.I also added a small GUI tool to make testing easier.

Requirements:

1. Install Python 3

I used Python 3.11+, but any modern Python 3 version should work.

https://www.python.org/downloads/

Make sure python or python3 works in your terminal:

python --version

2. Install ANTLR4

Run this:

pip install antlr4-python3-runtime
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

1. What the Project Does

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

2. File Structure
ParserThree.g4          → grammar file (lexer + parser rules)
gen/                    → generated lexer/parser from ANTLR
run.py                  → GUI to run parser
project_deliverable_3.py  → Test codes

3. How to Build the Parser

Have all the files in a single directory and move to that directory 

Remove any old gen directory if applies.
  rmdir /s /q gen


Generate the lexer and parser:
  antlr4 -Dlanguage=Python3 ParserThree.g4 -o gen


Run the run.py:

  -python run.py
Or
  -python run.py [sample code]

4. How the GUI Works 

The GUI lets you type or paste code into a box and click Parse.

If the input has errors, only the error messages show.

If it is valid, it prints the token list and a readable parse tree.

It also catches lexer errors .

This ended up being very helpful when debugging grammar rules.

5. Grammar Notes

A few choices I made while writing the grammar:

I kept assignments simple: only a single NAME on the left side.

Blocks are detected by NEWLINE sequences instead of indentation.

... is treated as an ELLIPSIS token because the sample code uses it.

Triple-quoted strings are skipped and treated as multi-line comments.

Reserved words (if, else, for, etc.) are matched before NAME to avoid conflicts.

These decisions were based on the professor’s project description and the structure of the provided deliverable programs.


6. How to Read the Parse Tree

Each rule in the grammar becomes a node. For example:

assignment:
  arith_op1
  =
  expr


Nested expressions show parent/child structure so it's easy to see how ANTLR grouped operations. The tree output is meant for debugging and verifying that precedence rules (like multiplication before addition) are working.

7. Known Limitations

This grammar does not attempt to match real Python perfectly.

No indentation or indentation levels are enforced.

It does not support function definitions, classes, tuples, f-strings, etc.

Comparison chaining (a < b < c) isn’t implemented; only one comparator is allowed.

These were intentionally out of scope for the assignment.
