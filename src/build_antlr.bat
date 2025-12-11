echo Generating ANTLR parser for ParserThree.g4...

cd /d "%~dp0"

if not exist gen mkdir gen

java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 ParserThree.g4 -o gen

