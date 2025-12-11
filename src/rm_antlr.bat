@echo off
echo Removing ANTLR parser for ParserThree.g4...

cd /d "%~dp0"

if not exist gen mkdir gen

rmdir /s /q gen
