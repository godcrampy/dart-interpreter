import "../../src/token.dart";

abstract class Expr {
  R accept<R>(Visitor<R> visitor);
}

abstract class Visitor<R> {
  R visitBinaryExpr(Binary expr);
  R visitGroupingExpr(Grouping expr);
  R visitLiteralExpr(Literal expr);
  R visitUnaryExpr(Unary expr);
}

class Binary extends Expr {
  Expr left;
  Token operator;
  Expr right;

  Binary(Expr left, Token operator, Expr right) {
    this.left = left;
    this.operator = operator;
    this.right = right;
  }

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitBinaryExpr(this);
  }
}

class Grouping extends Expr {
  Expr expression;

  Grouping(Expr expression) {
    this.expression = expression;
  }

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitGroupingExpr(this);
  }
}

class Literal extends Expr {
  Object value;

  Literal(Object value) {
    this.value = value;
  }

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitLiteralExpr(this);
  }
}

class Unary extends Expr {
  Token operator;
  Expr right;

  Unary(Token operator, Expr right) {
    this.operator = operator;
    this.right = right;
  }

  @override
  R accept<R>(Visitor<R> visitor) {
    return visitor.visitUnaryExpr(this);
  }
}
