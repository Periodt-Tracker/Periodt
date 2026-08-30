// ─────────────────────────────────────────────────────────────────
//  parser.dart
//  Recursive-descent parser.
//  Input : flat list of Tokens (from Lexer)
//  Output: a single root RuleNode (the AST)
//
//  Grammar (EBNF):
//
//  expression  ::= comparison
//  comparison  ::= atom ( ('=' | '!=' | '>' | '<' | '>=' | '<=') atom )?
//  atom        ::= function_call | literal
//  function_call ::= AND_call | OR_call | NOT_call
//                  | PHASE_call | CYCLE_DAY_call | HAS_SYMPTOM_call
//  AND_call    ::= 'AND' '(' expression (',' expression)+ ')'
//  OR_call     ::= 'OR'  '(' expression (',' expression)+ ')'
//  NOT_call    ::= 'NOT' '(' expression ')'
//  PHASE_call  ::= 'PHASE' '(' ')'
//  CYCLE_DAY_call ::= 'CYCLE_DAY' '(' ')'
//  HAS_SYMPTOM_call ::= 'HAS_SYMPTOM' '(' string_literal ')'
//  literal     ::= string_literal | number_literal
// ─────────────────────────────────────────────────────────────────

import 'ast.dart';
import 'tokens.dart';

// ─────────────────────────────────────────────────────────────────
/// Thrown when the parser encounters unexpected tokens.
// ─────────────────────────────────────────────────────────────────
class ParseException implements Exception {
  final String message;
  final Token? token;
  const ParseException(this.message, {this.token});

  @override
  String toString() {
    if (token != null) {
      return 'ParseException at offset ${token!.offset} '
          "(near '${token!.lexeme}'): $message";
    }
    return 'ParseException: $message';
  }
}

// ─────────────────────────────────────────────────────────────────
/// Parses a token list into an AST.
///
/// Usage:
/// ```dart
/// final tokens = Lexer(src).tokenize();
/// final ast    = Parser(tokens).parse();
/// ```
// ─────────────────────────────────────────────────────────────────
class Parser {
  final List<Token> _tokens;
  int _pos = 0;

  /// Maximum nesting depth — guards against deeply nested expressions
  /// that could cause a stack overflow even in the recursive descent.
  static const int _maxDepth = 32;
  int _depth = 0;

  Parser(this._tokens);

  // ── Public API ────────────────────────────────────────────────

  /// Parses the full token stream and returns the root [RuleNode].
  /// Throws [ParseException] on any structural error.
  RuleNode parse() {
    final node = _parseExpression();
    _expect(TokenType.eof, 'Expected end of expression');
    return node;
  }

  // ── Grammar rules ─────────────────────────────────────────────

  RuleNode _parseExpression() {
    _guardDepth();
    _depth++;
    try {
      return _parseComparison();
    } finally {
      _depth--;
    }
  }

  /// comparison ::= atom ( op atom )?
  RuleNode _parseComparison() {
    final left = _parseAtom();

    final opTypes = {
      TokenType.equals,
      TokenType.notEquals,
      TokenType.gt,
      TokenType.lt,
      TokenType.gte,
      TokenType.lte,
    };

    if (opTypes.contains(_peek().type)) {
      final opToken = _advance();
      final right = _parseAtom();
      return ComparisonNode(left: left, op: opToken.lexeme, right: right);
    }

    return left;
  }

  /// atom ::= function_call | literal
  RuleNode _parseAtom() {
    final tok = _peek();

    switch (tok.type) {
      case TokenType.kAnd:
        return _parseAnd();
      case TokenType.kOr:
        return _parseOr();
      case TokenType.kNot:
        return _parseNot();
      case TokenType.kPhase:
        return _parsePhase();
      case TokenType.kCycleDay:
        return _parseCycleDay();
      case TokenType.kHasSymptom:
        return _parseHasSymptom();
      case TokenType.stringLiteral:
        _advance();
        return StringLiteralNode(tok.value as String);
      case TokenType.numberLiteral:
        _advance();
        return NumberLiteralNode(tok.value as num);
      default:
        throw ParseException(
          "Unexpected token '${tok.lexeme}'. "
          'Expected a function call (AND, OR, NOT, PHASE, CYCLE_DAY, HAS_SYMPTOM) '
          'or a literal value.',
          token: tok,
        );
    }
  }

  // ── Function-call parsers ────────────────────────────────────

  /// AND( expr, expr, … )  — requires ≥ 2 arguments
  AndNode _parseAnd() {
    _expectKeyword(TokenType.kAnd);
    _expectPunct(TokenType.lparen, "'(' after AND");
    final children = _parseArgList(minArgs: 2, funcName: 'AND');
    _expectPunct(TokenType.rparen, "')' to close AND(…)");
    return AndNode(children);
  }

  /// OR( expr, expr, … )  — requires ≥ 2 arguments
  OrNode _parseOr() {
    _expectKeyword(TokenType.kOr);
    _expectPunct(TokenType.lparen, "'(' after OR");
    final children = _parseArgList(minArgs: 2, funcName: 'OR');
    _expectPunct(TokenType.rparen, "')' to close OR(…)");
    return OrNode(children);
  }

  /// NOT( expr )  — exactly 1 argument
  NotNode _parseNot() {
    _expectKeyword(TokenType.kNot);
    _expectPunct(TokenType.lparen, "'(' after NOT");
    final child = _parseExpression();
    if (_peek().type == TokenType.comma) {
      throw ParseException(
        'NOT() accepts exactly one argument.',
        token: _peek(),
      );
    }
    _expectPunct(TokenType.rparen, "')' to close NOT(…)");
    return NotNode(child);
  }

  /// PHASE()  — no arguments
  PhaseNode _parsePhase() {
    _expectKeyword(TokenType.kPhase);
    _expectPunct(TokenType.lparen, "'(' after PHASE");
    _expectPunct(TokenType.rparen, "')' after PHASE(");
    return const PhaseNode();
  }

  /// CYCLE_DAY()  — no arguments
  CycleDayNode _parseCycleDay() {
    _expectKeyword(TokenType.kCycleDay);
    _expectPunct(TokenType.lparen, "'(' after CYCLE_DAY");
    _expectPunct(TokenType.rparen, "')' after CYCLE_DAY(");
    return const CycleDayNode();
  }

  /// HAS_SYMPTOM( "name" )  — exactly one string argument
  HasSymptomNode _parseHasSymptom() {
    _expectKeyword(TokenType.kHasSymptom);
    _expectPunct(TokenType.lparen, "'(' after HAS_SYMPTOM");

    final nameTok = _peek();
    if (nameTok.type != TokenType.stringLiteral) {
      throw ParseException(
        'HAS_SYMPTOM() requires a string literal argument, '
        "e.g. HAS_SYMPTOM(\"fatigue\")",
        token: nameTok,
      );
    }
    _advance();
    final name = nameTok.value as String;

    if (name.trim().isEmpty) {
      throw ParseException(
        'HAS_SYMPTOM() symptom name must not be empty.',
        token: nameTok,
      );
    }

    if (_peek().type == TokenType.comma) {
      throw ParseException(
        'HAS_SYMPTOM() accepts exactly one argument.',
        token: _peek(),
      );
    }

    _expectPunct(TokenType.rparen, "')' to close HAS_SYMPTOM(…)");
    return HasSymptomNode(name.toLowerCase());
  }

  // ── Shared helpers ────────────────────────────────────────────

  /// Parses a comma-separated list of expressions.
  List<RuleNode> _parseArgList({
    required int minArgs,
    required String funcName,
  }) {
    final args = <RuleNode>[_parseExpression()];

    while (_peek().type == TokenType.comma) {
      _advance(); // consume comma
      if (_peek().type == TokenType.rparen) {
        throw ParseException(
          'Trailing comma in $funcName() argument list.',
          token: _peek(),
        );
      }
      args.add(_parseExpression());
    }

    if (args.length < minArgs) {
      throw ParseException(
        '$funcName() requires at least $minArgs argument(s), '
        'but got ${args.length}.',
        token: _peek(),
      );
    }

    return args;
  }

  void _guardDepth() {
    if (_depth >= _maxDepth) {
      throw ParseException(
        'Expression exceeds maximum nesting depth of $_maxDepth. '
        'Simplify the rule.',
        token: _peek(),
      );
    }
  }

  // ── Token stream operations ───────────────────────────────────

  Token _peek() => _tokens[_pos];

  Token _advance() {
    final tok = _tokens[_pos];
    if (tok.type != TokenType.eof) _pos++;
    return tok;
  }

  Token _expect(TokenType type, String message) {
    if (_peek().type != type) {
      throw ParseException(message, token: _peek());
    }
    return _advance();
  }

  Token _expectKeyword(TokenType type) {
    return _expect(type, "Expected '${type.name.toUpperCase()}'");
  }

  Token _expectPunct(TokenType type, String hint) {
    return _expect(type, 'Expected $hint');
  }
}
