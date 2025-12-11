echo Generating ANTLR parser for ParserThree.g4...

cd /d "%~dp0"

if not exist gen mkdir gen

antlr4 -Dlanguage=Python3 ParserThree.g4 -o gen
