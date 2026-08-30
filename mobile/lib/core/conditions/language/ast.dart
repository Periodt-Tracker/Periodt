// ─────────────────────────────────────────────────────────────────
//  ast.dart
//  Immutable AST node hierarchy for the rule expression language.
//
//  Visitor pattern is used so the evaluator stays decoupled from
//  the node structure, and so future transformers (pretty-printers,
//  validators, optimisers) can be added without touching nodes.
// ─────────────────────────────────────────────────────────────────

// ── Visitor interface ─────────────────────────────────────────────

/// Every node accepts a [RuleVisitor] to keep the evaluator
/// decoupled from node internals.
abstract class RuleVisitor<T> {
  T visitAnd(AndNode node);
  T visitOr(OrNode node);
  T visitNot(NotNode node);
  T visitPhase(PhaseNode node);
  T visitCycleDay(CycleDayNode node);
  T visitHasSymptom(HasSymptomNode node);
  T visitStringLiteral(StringLiteralNode node);
  T visitNumberLiteral(NumberLiteralNode node);
  T visitComparison(ComparisonNode node);
}

// ── Base node ────────────────────────────────────────────────────

/// Root of every AST node.
abstract class RuleNode {
  const RuleNode();

  /// Accept a visitor — delegates to the concrete implementation.
  T accept<T>(RuleVisitor<T> visitor);

  /// Human-readable representation for debugging.
  String toDebugString({int indent = 0});
}

// ── Logical nodes ─────────────────────────────────────────────────

/// `AND(a, b, c…)` — true iff **all** children evaluate to true.
class AndNode extends RuleNode {
  final List<RuleNode> children;

  const AndNode(this.children);

  @override
  T accept<T>(RuleVisitor<T> v) => v.visitAnd(this);

  @override
  String toDebugString({int indent = 0}) {
    final pad = '  ' * indent;
    final childStr = children
        .map((c) => c.toDebugString(indent: indent + 1))
        .join('\n');
    return '${pad}AND(\n$childStr\n$pad)';
  }
}

/// `OR(a, b, c…)` — true iff **at least one** child evaluates to true.
class OrNode extends RuleNode {
  final List<RuleNode> children;

  const OrNode(this.children);

  @override
  T accept<T>(RuleVisitor<T> v) => v.visitOr(this);

  @override
  String toDebugString({int indent = 0}) {
    final pad = '  ' * indent;
    final childStr = children
        .map((c) => c.toDebugString(indent: indent + 1))
        .join('\n');
    return '${pad}OR(\n$childStr\n$pad)';
  }
}

/// `NOT(a)` — inverts the boolean result of its single child.
class NotNode extends RuleNode {
  final RuleNode child;

  const NotNode(this.child);

  @override
  T accept<T>(RuleVisitor<T> v) => v.visitNot(this);

  @override
  String toDebugString({int indent = 0}) {
    final pad = '  ' * indent;
    return '${pad}NOT(\n${child.toDebugString(indent: indent + 1)}\n$pad)';
  }
}

// ── Accessor nodes ────────────────────────────────────────────────

/// `PHASE()` — yields the current cycle phase string.
class PhaseNode extends RuleNode {
  const PhaseNode();

  @override
  T accept<T>(RuleVisitor<T> v) => v.visitPhase(this);

  @override
  String toDebugString({int indent = 0}) => '${'  ' * indent}PHASE()';
}

/// `CYCLE_DAY()` — yields the current cycle day number.
class CycleDayNode extends RuleNode {
  const CycleDayNode();

  @override
  T accept<T>(RuleVisitor<T> v) => v.visitCycleDay(this);

  @override
  String toDebugString({int indent = 0}) => '${'  ' * indent}CYCLE_DAY()';
}

// ── Symptom node ──────────────────────────────────────────────────

/// `HAS_SYMPTOM("name")` — checks the symptom engine.
class HasSymptomNode extends RuleNode {
  final String symptomName;

  const HasSymptomNode(this.symptomName);

  @override
  T accept<T>(RuleVisitor<T> v) => v.visitHasSymptom(this);

  @override
  String toDebugString({int indent = 0}) =>
      '${'  ' * indent}HAS_SYMPTOM("$symptomName")';
}

// ── Literal nodes ─────────────────────────────────────────────────

/// A quoted string literal, e.g. `"luteal"`.
class StringLiteralNode extends RuleNode {
  final String value;

  const StringLiteralNode(this.value);

  @override
  T accept<T>(RuleVisitor<T> v) => v.visitStringLiteral(this);

  @override
  String toDebugString({int indent = 0}) => '${'  ' * indent}"$value"';
}

/// A numeric literal, e.g. `20` or `3.14`.
class NumberLiteralNode extends RuleNode {
  final num value;

  const NumberLiteralNode(this.value);

  @override
  T accept<T>(RuleVisitor<T> v) => v.visitNumberLiteral(this);

  @override
  String toDebugString({int indent = 0}) => '${'  ' * indent}$value';
}

// ── Comparison node ───────────────────────────────────────────────

/// Binary comparison: `left op right`
///
/// [op] is one of: `=`, `!=`, `>`, `<`, `>=`, `<=`
class ComparisonNode extends RuleNode {
  final RuleNode left;
  final String op;
  final RuleNode right;

  const ComparisonNode({
    required this.left,
    required this.op,
    required this.right,
  });

  @override
  T accept<T>(RuleVisitor<T> v) => v.visitComparison(this);

  @override
  String toDebugString({int indent = 0}) {
    final pad = '  ' * indent;
    return '$pad$op(\n'
        '${left.toDebugString(indent: indent + 1)}\n'
        '${right.toDebugString(indent: indent + 1)}\n'
        '$pad)';
  }
}
