import 'token.dart';
import '../main.dart';

class Scanner {
  static const int LEFT_PAREN = 0x28;
  static const int RIGHT_PAREN = 0x29;
  static const int LEFT_BRACE = 0x7B;
  static const int RIGHT_BRACE = 0x7D;
  static const int COMMA = 0x2C;
  static const int DOT = 0x2E;
  static const int MINUS = 0x2D;
  static const int PLUS = 0x2B;
  static const int SEMICOLON = 0x3B;
  static const int SLASH = 0x2F;
  static const int STAR = 0x2A;

  final String _source;
  final List<Token> _tokens = List<Token>();
  int _start = 0;
  int _current = 0;
  int _line = 1;

  Scanner(this._source);

  List<Token> scanTokens() {
    while (!_isAtEnd()) {
      _start = _current;
      _scanToken();
    }

    _tokens.add(new Token(TokenType.EOF, "", null, _line));
    return _tokens;
  }

  _scanToken() {
    int c = _advance();
    switch (c) {
      case LEFT_PAREN:
        _addToken(TokenType.LEFT_PAREN);
        break;
      case RIGHT_PAREN:
        _addToken(TokenType.RIGHT_PAREN);
        break;
      case LEFT_BRACE:
        _addToken(TokenType.LEFT_BRACE);
        break;
      case RIGHT_BRACE:
        _addToken(TokenType.RIGHT_BRACE);
        break;
      case COMMA:
        _addToken(TokenType.COMMA);
        break;
      case DOT:
        _addToken(TokenType.DOT);
        break;
      case MINUS:
        _addToken(TokenType.MINUS);
        break;
      case PLUS:
        _addToken(TokenType.PLUS);
        break;
      case SEMICOLON:
        _addToken(TokenType.SEMICOLON);
        break;
      case STAR:
        _addToken(TokenType.STAR);
        break;
      default:
        error(_line, "Unexpected Charecter");
    }
  }

  int _advance() {
    ++_current;
    return _source.codeUnitAt(_current - 1);
  }

  _addToken(TokenType type, {Object literal: null}) {
    String text = _source.substring(_start, _current);
    _tokens.add(Token(type, text, literal, _line));
  }

  bool _isAtEnd() {
    return _current >= _source.length;
  }
}
