import 'dart:io';
import './src/scanner.dart';
import './src/token.dart';
import './src/parser.dart';
import './src/expr.dart';
import './src/ast_printer.dart';

bool hadError = false;

main(List<String> args) {
  if (args.length > 1) {
    print("Usage: main [script]");
    exit(64);
  } else if (args.length == 1) {
    try {
      File f = new File(args[0]);
      run(f.readAsStringSync());
    } on FileSystemException {
      print("Error: File does not exist");
    }
  } else {
    runPrompt();
  }
}

void runPrompt() {
  print("Welcome to interpreter v0.1.0");
  while (true) {
    stdout.write("> ");
    String text = stdin.readLineSync();
    Scanner s = Scanner(text);
    List<Token> tokens = s.scanTokens();
    Parser p = new Parser(tokens);
    Expr expression = p.parse();

    if (hadError) return;

    print(new AstPrinter().print(expression));
  }
}

void run(String source) {
  print(source);
  Scanner s = Scanner(source);
  List<Token> tokens = s.scanTokens();
  Parser p = new Parser(tokens);
  Expr expression = p.parse();

  if (hadError) return;

  print(new AstPrinter().print(expression));
}

void error(dynamic tokenOrLine, String message) {
  if (tokenOrLine is int) {
    report(tokenOrLine, "", message);
  } else {
    // tokenOrLine is Token
    if (tokenOrLine.type == TokenType.EOF) {
      report(tokenOrLine.line, " at end", message);
    } else {
      report(tokenOrLine.line, " at '" + tokenOrLine.lexeme + "'", message);
    }
  }
}

void report(int line, String where, String message) {
  print("Error on line $line: $where => $message");
  hadError = true;
}
