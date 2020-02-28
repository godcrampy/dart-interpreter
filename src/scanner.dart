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
  static const int BANG = 0x21;
  static const int EQUAL = 0x3D;
  static const int LESS = 0x3C;
  static const int GREATER = 0x3E;
  static const int NULL = 0x00;

  static const LF = 0xA;
  static const CR = 0xD;
  static const SP = 0x20;
  static const TAB = 0x9;

  static const DOUBLE_QUOTE = 0x22;

  static const ZERO = 0x30;
  static const NINE = 0x39;
  static const LETTER_A = 0x61;
  static const LETTER_Z = 0x7A;
  static const LETTER__CAP_A = 0x41;
  static const LETTER__CAP_Z = 0x5A;
  static const UNDERSCORE = 0x5F;

  static const Map<String, TokenType> _keywords = {
    "and": TokenType.AND,
    "class": TokenType.CLASS,
    "else": TokenType.ELSE,
    "false": TokenType.FALSE,
    "for": TokenType.FOR,
    "fun": TokenType.FUN,
    "if": TokenType.IF,
    "nil": TokenType.NIL,
    "or": TokenType.OR,
    "print": TokenType.PRINT,
    "return": TokenType.RETURN,
    "super": TokenType.SUPER,
    "this": TokenType.THIS,
    "true": TokenType.TRUE,
    "var": TokenType.VAR,
    "while": TokenType.WHILE
  };

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
      case BANG:
        _addToken(_match(EQUAL) ? TokenType.BANG : TokenType.BANG);
        break;
      case EQUAL:
        _addToken(_match(EQUAL) ? TokenType.EQUAL_EQUAL : TokenType.EQUAL);
        break;
      case LESS:
        _addToken(_match(EQUAL) ? TokenType.LESS_EQUAL : TokenType.LESS);
        break;
      case GREATER:
        _addToken(_match(EQUAL) ? TokenType.GREATER_EQUAL : TokenType.GREATER);
        break;
      case SLASH:
        if (_match(SLASH)) {
          while (_peek() != NULL && !_isAtEnd()) {
            _advance();
          }
        } else {
          _addToken(TokenType.SLASH);
        }
        break;
      case CR:
      case SP:
      case TAB:
        break;
      case LF:
        ++_line;
        break;
      case DOUBLE_QUOTE:
        _string();
        break;
      default:
        if (_isDigit(c)) {
          _digit();
        } else if (_isAlpha(c)) {
          _identifier();
        } else {
          error(_line, "Unexpected Charecter");
        }
    }
  }

  void _identifier() {
    while (_isAlpha(_peek())) {
      _advance();
    }

    String text = _source.substring(_start, _current);
    if (_keywords.containsKey(text)) {
      _addToken(_keywords[text]);
    } else {
      _addToken(TokenType.IDENTIFIER);
    }
  }

  void _digit() {
    while (_isDigit(_peek())) {
      _advance();
    }

    if (_peek() == DOT && _isDigit(_peekNext())) {
      _advance();
      while (_isDigit(_peek())) {
        _advance();
      }
    }

    double value = double.parse(_source.substring(_start, _current));
    _addToken(TokenType.NUMBER, literal: value);
  }

  void _string() {
    while (_peek() != DOUBLE_QUOTE && !_isAtEnd()) {
      if (_peek() == LF) ++_line;
      _advance();
    }

    if (_isAtEnd()) {
      error(_line, "Unterminated String!");
      return;
    }

    _advance();

    String value = _source.substring(_start + 1, _current - 1);
    _addToken(TokenType.STRING, literal: value);
  }

  int _advance() {
    ++_current;
    return _source.codeUnitAt(_current - 1);
  }

  bool _match(int expected) {
    if (_isAtEnd()) {
      return false;
    }
    if (_source.codeUnitAt(_current) != expected) return false;
    ++_current;
    return true;
  }

  int _peek() {
    if (_isAtEnd()) return NULL;
    return _source.codeUnitAt(_current);
  }

  int _peekNext() {
    if (_current + 1 >= _source.length) return NULL;
    return _source.codeUnitAt(_current + 1);
  }

  bool _isDigit(int c) {
    return c >= ZERO && c <= NINE;
  }

  bool _isAlpha(int c) {
    return (c >= LETTER__CAP_A && c <= LETTER__CAP_Z) ||
        (c >= LETTER_A && c <= LETTER_Z) ||
        c == UNDERSCORE;
  }

  void _addToken(TokenType type, {Object literal: null}) {
    String text = _source.substring(_start, _current);
    _tokens.add(Token(type, text, literal, _line));
  }

  bool _isAtEnd() {
    return _current >= _source.length;
  }
}
