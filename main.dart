import 'dart:io';

main(List<String> args) {
  if (args.length > 1) {
    print("Usage: main [script]");
    exit(64);
  } else if (args.length == 1) {
    File f = new File(args[0]);
    String s = f.readAsStringSync();
    print(s);
  } else {
    print("Welcome to interpreter v0.1.0");
    while (true) {
      stdout.write("> ");
      print(stdin.readLineSync());
    }
  }
}
