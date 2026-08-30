import 'package:periodt/core/forcast/backend/base.dart';

import 'tokens.dart';

// thrown when the lexer encounters unexpected characters.
//
class LexerException implements Exception {
  final String message;
  final int offset;
  const LexerException(this.message, {required this.offset});

  @override
  String toString() => 'LexerException at offset $offset: $message';
}

/// Scans [source] and returns a list of [Token]s ending with EOF.
///
/// usage:
/// ```dart
/// final tokens = Lexer('AND(PHASE()="luteal", HAS_SYMPTOM("fatigue"))').tokenize();
/// ```
///
class Lexer {
  final String _source;
  int _pos = 0;
  final List<Token> _tokens = [];

  Lexer(String source) : _source = source.trim();

  /// tokenises [_source] and returns the full token stream.
  ///
  List<Token> tokenize() {
    while (!_isAtEnd()) {
      _skipWhitespace();
      if (_isAtEnd()) break;
      _scanToken();
    }
    _tokens.add(Token(type: TokenType.eof, lexeme: '', offset: _pos));
    return List.unmodifiable(_tokens);
  }

  // ── Internals ─────────────────────────────────────────────────

  bool _isAtEnd() => _pos >= _source.length;

  String get _current => _source[_pos];

  String _advance() => _source[_pos++];

  bool _match(String expected) {
    if (_isAtEnd() || _source[_pos] != expected) return false;
    _pos++;
    return true;
  }

  void _skipWhitespace() {
    while (!_isAtEnd() && _current == ' ' ||
        (!_isAtEnd() && _current == '\t')) {
      _pos++;
    }
  }

  void _scanToken() {
    final start = _pos;
    final ch = _advance();

    switch (ch) {
      case '(':
        _emit(TokenType.lparen, '(', start);
      case ')':
        _emit(TokenType.rparen, ')', start);
      case ',':
        _emit(TokenType.comma, ',', start);

      // ── Comparison operators ─────────────────────────────────
      case '=':
        _emit(TokenType.equals, '=', start);
      case '!':
        if (_match('=')) {
          _emit(TokenType.notEquals, '!=', start);
        } else {
          throw LexerException(
            "Expected '=' after '!' but got '${_isAtEnd() ? 'EOF' : _current}'",
            offset: start,
          );
        }
      case '>':
        if (_match('=')) {
          _emit(TokenType.gte, '>=', start);
        } else {
          _emit(TokenType.gt, '>', start);
        }
      case '<':
        if (_match('=')) {
          _emit(TokenType.lte, '<=', start);
        } else {
          _emit(TokenType.lt, '<', start);
        }

      // ── String literal ───────────────────────────────────────
      case '"':
        _scanString(start);

      default:
        if (_isDigit(ch)) {
          _scanNumber(start);
        } else if (_isAlpha(ch) || ch == '_') {
          _scanIdentifierOrKeyword(start);
        } else {
          throw LexerException("Unexpected character '$ch'", offset: start);
        }
    }
  }

  // ── Literal scanners ─────────────────────────────────────────

  void _scanString(int start) {
    final buffer = StringBuffer();
    while (!_isAtEnd() && _current != '"') {
      if (_current == '\\') {
        _advance(); // skip backslash
        if (_isAtEnd()) {
          throw LexerException(
            'Unterminated escape sequence in string',
            offset: start,
          );
        }
        final escaped = _advance();
        switch (escaped) {
          case '"':
            buffer.write('"');
          case '\\':
            buffer.write('\\');
          case 'n':
            buffer.write('\n');
          case 't':
            buffer.write('\t');
          default:
            throw LexerException(
              "Unknown escape sequence '\\$escaped'",
              offset: _pos - 2,
            );
        }
      } else {
        buffer.write(_advance());
      }
    }

    if (_isAtEnd()) {
      throw LexerException('Unterminated string literal', offset: start);
    }
    _advance(); // consume closing "

    final raw = _source.substring(start, _pos);
    _tokens.add(
      Token(
        type: TokenType.stringLiteral,
        lexeme: raw,
        value: buffer.toString(),
        offset: start,
      ),
    );
  }

  void _scanNumber(int start) {
    while (!_isAtEnd() && _isDigit(_current)) {
      _advance();
    }
    bool isFloat = false;
    if (!_isAtEnd() &&
        _current == '.' &&
        _pos + 1 < _source.length &&
        _isDigit(_source[_pos + 1])) {
      isFloat = true;
      _advance(); // consume '.'
      while (!_isAtEnd() && _isDigit(_current)) {
        _advance();
      }
    }

    final lexeme = _source.substring(start, _pos);
    final num value = isFloat ? double.parse(lexeme) : int.parse(lexeme);

    _tokens.add(
      Token(
        type: TokenType.numberLiteral,
        lexeme: lexeme,
        value: value,
        offset: start,
      ),
    );
  }

  void _scanIdentifierOrKeyword(int start) {
    while (!_isAtEnd() && (_isAlphaNumeric(_current) || _current == '_')) {
      _advance();
    }
    final lexeme = _source.substring(start, _pos);
    final type = kKeywords[lexeme];
    if (type == null) {
      throw LexerException(
        "Unknown identifier '$lexeme'. "
        'Supported functions: ${kKeywords.keys.join(', ')}',
        offset: start,
      );
    }
    _emit(type, lexeme, start);
  }

  void _emit(TokenType type, String lexeme, int offset) {
    _tokens.add(Token(type: type, lexeme: lexeme, offset: offset));
  }

  static bool _isDigit(String ch) =>
      ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57;

  static bool _isAlpha(String ch) {
    final c = ch.codeUnitAt(0);
    return (c >= 65 && c <= 90) || (c >= 97 && c <= 122);
  }

  static bool _isAlphaNumeric(String ch) => _isAlpha(ch) || _isDigit(ch);
}
