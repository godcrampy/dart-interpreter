import 'dart:io';

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
    print(stdin.readLineSync());
  }
}

void run(String source) {
  print(source);
}

void error(int line, String message) {
  report(line, "", message);
}

void report(int line, String where, String message) {
  print("Error on line $line: $where => $message");
}
