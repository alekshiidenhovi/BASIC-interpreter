import "operators.dart";
import "errors.dart";

/// Represents an abstract expression that can be evaluated given a set of variables.
///
/// The type parameter `T` represents the return type of the expression when evaluated.
sealed class Expression<T> {
  /// Evaluates the expression using the provided [variables].
  ///
  /// The [variables] map should contain mappings from variable names (Strings) to their
  /// numerical values (num).
  T evaluate(Map<String, num> variables);
}

/// Represents a literal number within an expression.
///
/// This expression always evaluates to its constant [value].
class NumberLiteralExpression extends Expression<num> {
  /// The numerical value of this literal.
  final num value;

  /// Creates a new [NumberLiteralExpression] with the given [value].
  NumberLiteralExpression(this.value);

  @override
  num evaluate(Map<String, num> variables) {
    return value;
  }
}

/// Represents a literal string within an expression.
///
/// This expression always evaluates to its constant [value].
class StringLiteralExpression extends Expression<String> {
  /// The string value of this literal.
  final String value;

  /// Creates a new [StringLiteralExpression] with the given [value].
  StringLiteralExpression(this.value);

  @override
  String evaluate(Map<String, num> variables) {
    return value;
  }
}

/// Represents a variable identifier within an expression.
///
/// This expression evaluates to the numerical value associated with the [identifier]
/// in the provided variables map.
class IdentifierExpression extends Expression<num> {
  /// The name of the identifier.
  final String identifier;

  /// Creates a new [IdentifierExpression] with the given [identifier].
  IdentifierExpression(this.identifier);

  @override
  num evaluate(Map<String, num> variables) {
    final value = variables[identifier];
    if (value == null) {
      throw MissingIdentifierError(this, identifier);
    }
    return value;
  }
}

/// Represents a comparison operation between two numerical expressions.
///
/// This expression evaluates to a boolean indicating whether the [lhs] and [rhs]
/// satisfy the given [operator].
class ComparisonExpression extends Expression<bool> {
  /// The left-hand side of the comparison.
  final Expression<num> lhs;

  /// The right-hand side of the comparison.
  final Expression<num> rhs;

  /// The comparison operator to apply to the [lhs] and [rhs].
  final ComparisonOperator operator;

  /// Creates a new [ComparisonExpression] with the given [lhs], [rhs], and [operator].
  ComparisonExpression(this.lhs, this.rhs, this.operator);

  @override
  bool evaluate(Map<String, num> variables) {
    num leftValue = lhs.evaluate(variables);
    num rightValue = rhs.evaluate(variables);

    return switch (operator) {
      ComparisonOperator.eq => leftValue == rightValue,
      ComparisonOperator.neq => leftValue != rightValue,
      ComparisonOperator.gt => leftValue > rightValue,
      ComparisonOperator.lt => leftValue < rightValue,
      ComparisonOperator.gte => leftValue >= rightValue,
      ComparisonOperator.lte => leftValue <= rightValue,
    };
  }
}

/// Represents an arithmetic operation between two numerical expressions.
///
/// This expression evaluates to a numerical value resulting from applying the given [operator]
/// to the numerical values of the [lhs] and [rhs] expressions.
class ArithmeticExpression extends Expression<num> {
  /// The left-hand side of the arithmetic expression.
  final Expression<num> lhs;

  /// The right-hand side of the arithmetic expression.
  final Expression<num> rhs;

  /// The arithmetic operator to apply to the [lhs] and [rhs].
  final ArithmeticOperator operator;

  /// Creates a new [ArithmeticExpression] with the given [lhs], [rhs], and [operator].
  ArithmeticExpression(this.lhs, this.rhs, this.operator);

  @override
  num evaluate(Map<String, num> variables) {
    num leftValue = lhs.evaluate(variables);
    num rightValue = rhs.evaluate(variables);

    return switch (operator) {
      ArithmeticOperator.add => leftValue + rightValue,
      ArithmeticOperator.sub => leftValue - rightValue,
      ArithmeticOperator.mul => leftValue * rightValue,
      ArithmeticOperator.div =>
        rightValue == 0
            ? throw DivisionByZeroError(this)
            : leftValue / rightValue,
    };
  }
}
