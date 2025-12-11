import tkinter as tk
from antlr4 import *
from antlr4.error.ErrorListener import ErrorListener
from antlr4.Token import Token

from gen.ParserThreeLexer import ParserThreeLexer as L
from gen.ParserThreeParser import ParserThreeParser


# ParserTree
def pretty_tree(node, parser, indent=0):
    rule_names = parser.ruleNames
    indent_str = "  " * indent

    # Leaf token
    if node.getChildCount() == 0:
        tx = node.getText()
        if tx == "<EOF>":
            return indent_str + "EOF"
        return indent_str + tx

    rule_name = rule_names[node.getRuleIndex()]
    out = f"{indent_str}{rule_name}:\n"

    for i in range(node.getChildCount()):
        child = node.getChild(i)
        out += pretty_tree(child, parser, indent + 1) + "\n"

    return out.rstrip("\n")


# ErrorDetection
class CollectingErrorListener(ErrorListener):
    def __init__(self):
        super().__init__()
        self.errors = []

    def syntaxError(self, recognizer, offendingSymbol, line, col, msg, e):
        self.errors.append(f"Line {line}:{col}  {msg}")


#Tokens
TOKEN_ID_TO_NAME = {
    getattr(L, name): name
    for name in dir(L)
    if name.isupper() and not name.startswith("T__")
}


def token_label(lexer, t: Token) -> str:
    ttype = t.type

    if ttype == Token.EOF:
        return "EOF"

    # Handle one-character tokens ("=", "+", "-", etc.)
    if hasattr(L, "T__0") and L.T__0 <= ttype <= getattr(L, "T__17", L.T__0 - 1):
        lit = lexer.literalNames[ttype] if ttype < len(lexer.literalNames) else None
        if lit:
            return lit.strip("'")
        return t.text

    # Named tokens: INT, FLOAT, NAME, IF, ELSE, etc.
    if ttype in TOKEN_ID_TO_NAME:
        return TOKEN_ID_TO_NAME[ttype]

    # Literal names as fallback
    if ttype < len(lexer.literalNames):
        lit = lexer.literalNames[ttype]
        if lit:
            return lit.strip("'")

    return t.text


#Run parser
def run_parser(text: str):
    input_stream = InputStream(text)

    # LEXER
    lexer = L(input_stream)
    lex_errors = CollectingErrorListener()
    lexer.removeErrorListeners()
    lexer.addErrorListener(lex_errors)

    tokens = CommonTokenStream(lexer)
    tokens.fill()

    # If lexer errors occur → stop immediately
    if lex_errors.errors:
        return tokens, lex_errors.errors, None, None, lexer

    # PARSER
    parser = ParserThreeParser(tokens)
    parse_errors = CollectingErrorListener()
    parser.removeErrorListeners()
    parser.addErrorListener(parse_errors)

    tree = parser.file_input()
    return tokens, parse_errors.errors, tree, parser, lexer


#GUI
def on_parse():
    output.delete("1.0", tk.END)
    text = text_input.get("1.0", "end-1c")

    tokens, errors, tree, parser, lexer = run_parser(text)

    # Show errors first — DO NOT SHOW ANYTHING ELSE
    if errors:
        output.insert(tk.END, "SYNTAX ERRORS:\n")
        for e in errors:
            output.insert(tk.END, e + "\n")
        return

    # VALID INPUT → show tokens
    output.insert(tk.END, "TOKENS:\n")
    for t in tokens.tokens:
        label = token_label(lexer, t)
        output.insert(tk.END, f"{label:<12} text={t.text!r}\n")

    # Show parse tree
    output.insert(tk.END, "\nPARSE TREE:\n")
    output.insert(tk.END, pretty_tree(tree, parser))


# GUI..
root = tk.Tk()
root.title("ParserThree Syntax Checker")

tk.Label(root, text="Enter code to parse:").pack(anchor="w")
text_input = tk.Text(root, height=10, width=80)
text_input.pack()

tk.Button(root, text="Parse", command=on_parse).pack(pady=5)

tk.Label(root, text="Output:").pack(anchor="w")
output = tk.Text(root, height=25, width=100)
output.pack()

root.mainloop()
