import "dart:io";

main(List<String> args) {
  if (args.length != 1) {
    print("Usage: generate_ast <output directory>");
    exit(1);
  }
  String outputDir = args[0];
  defineAst(outputDir, "Expr", [
    "Binary   : Expr left, Token operator, Expr right",
    "Grouping : Expr expression",
    "Literal  : Object value",
    "Unary    : Token operator, Expr right"
  ]);
}

void defineAst(String outputDir, String baseName, List<String> types) {
  String path = "$outputDir/$baseName.dart";
  File f = new File(path);
  IOSink sink = f.openWrite();

  sink.writeln('import "../../src/token.dart";');
  sink.writeln();
  sink.writeln("abstract class $baseName {");

  // * Base accept method
  sink.writeln("  R accept<R>(Visitor<R> visitor);");
  sink.writeln("}");
  sink.writeln();

  // * Visitor Interface
  sink.writeln("abstract class Visitor<R> {");
  for (String type in types) {
    String typeName = type.split(":")[0].trim();
    String baseNameLwr = baseName.toLowerCase();
    sink.writeln("  R visit$typeName$baseName($typeName $baseNameLwr);");
  }
  sink.writeln("}");
  sink.writeln();

  for (String type in types) {
    String className = type.split(":")[0].trim();
    String fields = type.split(":")[1].trim();
    defineType(sink, baseName, className, fields);
  }
  sink.close();
}

void defineType(
    IOSink sink, String baseName, String className, String fieldList) {
  sink.writeln("class $className extends $baseName {");

  List<String> fields = fieldList.split(", ");
  for (String field in fields) {
    sink.writeln("  $field;");
  }
  sink.writeln("");

  // * Constructor
  sink.writeln("  $className($fieldList) {");

  for (String field in fields) {
    String name = field.split(" ")[1];
    sink.writeln("    this.$name = $name;");
  }
  sink.writeln("  }");
  sink.writeln();

  // * Overriding the accept method
  sink.writeln("  @override");
  sink.writeln("  R accept<R>(Visitor<R> visitor) {");
  sink.writeln("    return visitor.visit$className$baseName(this);");
  sink.writeln("  }");

  sink.writeln("}");
  sink.writeln();
}
