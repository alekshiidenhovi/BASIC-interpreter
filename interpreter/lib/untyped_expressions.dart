import "operators.dart";

/// Represents an base untyped expression.
sealed class Expression {
  const Expression();
}

/// Represents an untyped integer constant expression.
class IntegerConstantExpression extends Expression {
  /// The integer value of this constant.
  final int value;

  /// Creates a new [IntegerConstantExpression] with the given [value].
  const IntegerConstantExpression(this.value);

  @override
  String toString() => "(INTEGER_CONSTANT_EXPRESSION $value)";
}

/// Represents an untyped floating point constant expression.
class FloatingPointConstantExpression extends Expression {
  /// The floating point value of this constant.
  final double value;

  /// Creates a new [FloatingPointConstantExpression] with the given [value].
  const FloatingPointConstantExpression(this.value);

  @override
  String toString() => "(FLOATING_POINT_CONSTANT_EXPRESSION $value)";
}

/// Represents an untyped string constant expression.
///
/// This expression always evaluates to its constant [value].
class StringConstantExpression extends Expression {
  /// The string value of this constant.
  final String value;

  /// Creates a new [StringConstantExpression] with the given [value].
  const StringConstantExpression(this.value);

  @override
  String toString() => "(STRING_CONSTANT_EXPRESSION $value)";
}

/// Represents an untyped boolean constant expression.
class BooleanConstantExpression extends Expression {
  /// The boolean value of this constant.
  final bool value;

  /// Creates a new [BooleanConstantExpression] with the given [value].
  const BooleanConstantExpression(this.value);

  @override
  String toString() => "(BOOLEAN_CONSTANT_EXPRESSION $value)";
}

/// Represents an untyped constant identifier expression.
class IdentifierConstantExpression extends Expression {
  /// The name of the identifier.
  final String identifier;

  /// Creates a new [IdentifierConstantExpression] with the given [identifier].
  const IdentifierConstantExpression(this.identifier);

  @override
  String toString() => "(IDENTIFIER_CONSTANT_EXPRESSION $identifier)";
}

/// Represents an untyped unary expression.
class UnaryExpression extends Expression {
  /// The expression to evaluate.
  final Expression operand;

  /// The unary operator to apply to the [expression].
  final UnaryOperator operator;

  /// Creates a new [UnaryExpression] with the given [expression] and [operator].
  const UnaryExpression(this.operand, this.operator);

  @override
  String toString() => "(UNARY_EXPRESSION operator-$operator operand-$operand)";
}

/// Represents an untyped binary expression.
///

/// Represents an untyped binary operation between two expressions.
class BinaryExpression extends Expression {
  /// The left-hand side of the comparison.
  final Expression lhs;

  /// The right-hand side of the comparison.
  final Expression rhs;

  /// The comparison operator to apply to the [lhs] and [rhs].
  final BinaryOperator operator;

  /// Creates a new [BinaryExpression] with the given [lhs], [rhs], and [operator].
  const BinaryExpression(this.lhs, this.rhs, this.operator);

  @override
  String toString() =>
      "(BINARY_EXPRESSION operator-$operator lhs-$lhs rhs-$rhs)";
}
