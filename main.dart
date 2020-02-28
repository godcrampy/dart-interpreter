import 'dart:io';
import './src/scanner.dart';
import './src/token.dart';

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
    // ! Temporary Code
    String text = stdin.readLineSync();
    Scanner s = Scanner(text);
    List<Token> a = s.scanTokens();
    a.forEach((e) => print(e));
    // ! /Temporary Code
  }
}

void run(String source) {
  print(source);
  // ! Temporary Code
  Scanner s = Scanner(source);
  List<Token> a = s.scanTokens();
  a.forEach((e) => print(e));
  // ! /Temporary Code
}

void error(int line, String message) {
  report(line, "", message);
}

void report(int line, String where, String message) {
  print("Error on line $line: $where => $message");
}
