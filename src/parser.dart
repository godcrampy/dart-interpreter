import './token.dart';
import './expr.dart';

class Parser {
  int _current = 0;
  List<Token> tokens;

  Parser(this.tokens);

  Expr _expression() {
    return _equality();
  }

  Expr _equality() {
    Expr expr = _comparision();

    while (_match([TokenType.BANG_EQUAL, TokenType.EQUAL_EQUAL])) {
      Token operator = _previous();
      Expr right = _comparision();
      expr = new Binary(expr, operator, right);
    }

    return expr;
  }

  Expr _comparision() {
    Expr expr = _addition();

    while (_match([
      TokenType.GREATER_EQUAL,
      TokenType.GREATER,
      TokenType.LESS_EQUAL,
      TokenType.LESS
    ])) {
      Token operator = _previous();
      Expr right = _addition();
      expr = new Binary(expr, operator, right);
    }

    return expr;
  }

  Expr _addition() {
    Expr expr = _multiplication();

    while (_match([TokenType.MINUS, TokenType.PLUS])) {
      Token operator = _previous();
      Expr right = _multiplication();
      expr = new Binary(expr, operator, right);
    }

    return expr;
  }

  Expr _multiplication() {
    Expr expr = _unary();

    while (_match([TokenType.SLASH, TokenType.STAR])) {
      Token operator = _previous();
      Expr right = _unary();
      expr = new Binary(expr, operator, right);
    }

    return expr;
  }

  Expr _unary() {
    if (_match([TokenType.BANG, TokenType.MINUS])) {
      Token operator = _previous();
      Expr right = _unary();
      return new Unary(operator, right);
    }

    return _primary();
  }

  Expr _primary() {
    if (_match([TokenType.FALSE])) return new Literal(false);
    if (_match([TokenType.TRUE])) return new Literal(true);
    if (_match([TokenType.NIL])) return new Literal(null);

    if (_match([TokenType.NUMBER, TokenType.STRING])) {
      return new Literal(_previous().literal);
    }

    if (_match([TokenType.LEFT_PAREN])) {
      Expr expr = _expression();
      // TODO: Error Handling
      // _consume(TokenType.RIGHT_PAREN, "Expect ')' after expression.");
      return new Grouping(expr);
    }
  }

  bool _match(List<TokenType> types) {
    for (TokenType type in types) {
      if (_check(type)) {
        _advance();
        return true;
      }
    }
    return false;
  }

  bool _check(TokenType type) {
    if (_isAtEnd()) return false;
    return _peek().type == type;
  }

  Token _advance() {
    if (!_isAtEnd()) ++_current;
    return _previous();
  }

  bool _isAtEnd() {
    return _peek().type == TokenType.EOF;
  }

  Token _peek() {
    return tokens.elementAt(_current);
  }

  Token _previous() {
    return tokens.elementAt(_current - 1);
  }
}
