import './expr.dart';

class AstPrinter implements Visitor<String> {
  String print(Expr expr) {
    return expr.accept(this);
  }

  @override
  String visitBinaryExpr(Binary expr) {
    return _parenthesize(expr.operator.lexeme, [expr.left, expr.right]);
  }

  @override
  String visitGroupingExpr(Grouping expr) {
    return _parenthesize("group", [expr.expression]);
  }

  @override
  String visitLiteralExpr(Literal expr) {
    if (expr.value == null) return "nil";
    return expr.value.toString();
  }

  @override
  String visitUnaryExpr(Unary expr) {
    return _parenthesize(expr.operator.lexeme, [expr.right]);
  }

  String _parenthesize(String name, List<Expr> exprs) {
    StringBuffer buffer = new StringBuffer();
    buffer.write("(");
    buffer.write(name);

    for (Expr expr in exprs) {
      buffer.write(" ");
      buffer.write(expr.accept(this));
    }
    buffer.write(")");

    return buffer.toString();
  }
}
