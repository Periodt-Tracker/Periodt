// every syntactic unit the lexer can emit.
//
enum TokenType {
  // ── Punctuation ────────────────────────────────────────────────
  lparen, //  (
  rparen, //  )
  comma, //  ,
  equals, //  =
  notEquals, //  !=
  gt, //  >
  lt, //  <
  gte, //  >=
  lte, //  <=
  // ── Literals ───────────────────────────────────────────────────
  stringLiteral, //  "luteal"
  numberLiteral, //  42  /  3.14
  // ── Built-in logical functions ─────────────────────────────────
  kAnd, //  AND
  kOr, //  OR
  kNot, //  NOT
  // ── Built-in state accessors ───────────────────────────────────
  kPhase, //  PHASE
  kCycleDay, //  CYCLE_DAY
  // ── Built-in symptom function ──────────────────────────────────
  kHasSymptom, //  HAS_SYMPTOM
  // ── Sentinel ───────────────────────────────────────────────────
  eof,
}

// ─────────────────────────────────────────────────────────────────
/// A single token emitted by the [Lexer].
// ─────────────────────────────────────────────────────────────────
class Token {
  final TokenType type;
  final String lexeme; // original text as it appeared in the source
  final Object? value; // parsed value: String for strings, num for numbers
  final int offset; // character offset in the source string (for error msgs)

  const Token({
    required this.type,
    required this.lexeme,
    this.value,
    required this.offset,
  });

  @override
  String toString() {
    final v = value != null ? '($value)' : '';
    return 'Token(${type.name}$v @$offset)';
  }
}

// maps every recognised keyword/function name to its [TokenType].
//
const Map<String, TokenType> kKeywords = {
  'AND': TokenType.kAnd,
  'OR': TokenType.kOr,
  'NOT': TokenType.kNot,
  'PHASE': TokenType.kPhase,
  'CYCLE_DAY': TokenType.kCycleDay,
  'HAS_SYMPTOM': TokenType.kHasSymptom,
};
