import "operators.dart";
import "context.dart";

/// Represents a base typed expression.
///
/// The type parameter `T` represents the return type of the expression when evaluated.
sealed class TypedExpression<T> {
  const TypedExpression();

  /// Evaluates the expression using the provided [variables].
  ///
  /// The [context] object should contain mappings from variable names [String] to values of type [int], [double], or [String]
  T evaluate(Context context);
}

/// Represents a typed integer constant expression.
class TypedIntegerConstantExpression extends TypedExpression<int> {
  /// The integer value of this constant.
  final int value;

  /// Creates a new [TypedIntegerConstantExpression] with the given [value].
  const TypedIntegerConstantExpression(this.value);

  @override
  String toString() => "(TYPED_INTEGER_CONSTANT_EXPRESSION $value)";

  @override
  int evaluate(Context context) => value;
}

/// Represents a typed floating point constant expression.
class TypedFloatingPointConstantExpression extends TypedExpression<double> {
  /// The floating point value of this constant.
  final double value;

  /// Creates a new [TypedFloatingPointConstantExpression] with the given [value].
  const TypedFloatingPointConstantExpression(this.value);

  @override
  String toString() => "(TYPED_FLOATING_POINT_CONSTANT_EXPRESSION $value)";

  @override
  double evaluate(Context context) => value;
}

/// Represents a typed string constant expression.
///
/// This expression always evaluates to its constant [value].
class TypedStringConstantExpression extends TypedExpression<String> {
  /// The string value of this constant.
  final String value;

  /// Creates a new [TypedStringConstantExpression] with the given [value].
  const TypedStringConstantExpression(this.value);

  @override
  String toString() => "(TYPED_STRING_CONSTANT_EXPRESSION $value)";

  @override
  String evaluate(Context context) => value;
}

/// Represents a typed constant identifier expression.
///
/// This expression evaluates to the value associated with the [identifier]
/// in the provided variables map.
class TypedIdentifierConstantExpression<T> extends TypedExpression<T> {
  /// The name of the identifier.
  final String identifier;

  /// Creates a new [TypedIdentifierConstantExpression] with the given [identifier].
  const TypedIdentifierConstantExpression(this.identifier);

  @override
  String toString() => "(TYPED_IDENTIFIER_CONSTANT_EXPRESSION $identifier)";

  @override
  T evaluate(Context context) => context.getVariable<T>(identifier);
}

/// Represents a typed unary expression.
///
/// This expression evaluates to the result of applying the unary operator [operator] to the operand [operand].
class TypedUnaryExpression extends TypedExpression<num> {
  /// The expression to evaluate.
  final TypedExpression<num> operand;

  /// The unary operator to apply to the [expression].
  final UnaryOperator operator;

  /// Creates a new [TypedUnaryExpression] with the given [expression] and [operator].
  const TypedUnaryExpression(this.operand, this.operator);

  @override
  String toString() =>
      "(TYPED_UNARY_EXPRESSION operator-$operator operand-$operand)";

  @override
  num evaluate(Context context) {
    final num value = operand.evaluate(context);
    return switch (operator) {
      UnaryOperator.negate => -value,
    };
  }
}

/// Represents a comparison operation between two numerical expressions.
///
/// This expression evaluates to a boolean indicating whether the [lhs] and [rhs]
/// satisfy the given [operator].
class TypedComparisonExpression extends TypedExpression<bool> {
  /// The left-hand side of the comparison.
  final TypedExpression<num> lhs;

  /// The right-hand side of the comparison.
  final TypedExpression<num> rhs;

  /// The comparison operator to apply to the [lhs] and [rhs].
  final ComparisonOperator operator;

  /// Creates a new [TypedComparisonExpression] with the given [lhs], [rhs], and [operator].
  const TypedComparisonExpression(this.lhs, this.rhs, this.operator);

  @override
  String toString() =>
      "(TYPED_COMPARISON_EXPRESSION operator-$operator lhs-$lhs rhs-$rhs)";

  @override
  bool evaluate(Context context) {
    final leftValue = lhs.evaluate(context);
    final rightValue = rhs.evaluate(context);

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

/// Represents a comparison operation between two numerical expressions.
///
/// This expression evaluates to a boolean indicating whether the [lhs] and [rhs]
/// satisfy the given [operator].
class TypedArithmeticExpression extends TypedExpression<num> {
  /// The left-hand side of the arithmetic operation.
  final TypedExpression<num> lhs;

  /// The right-hand side of the arithmetic operation.
  final TypedExpression<num> rhs;

  /// The comparison operator to apply to the [lhs] and [rhs].
  final ArithmeticOperator operator;

  /// Creates a new [TypedArithmeticExpression] with the given [lhs], [rhs], and [operator].
  const TypedArithmeticExpression(this.lhs, this.rhs, this.operator);

  @override
  String toString() =>
      "(TYPED_ARITHMETIC_EXPRESSION operator-$operator lhs-$lhs rhs-$rhs)";

  @override
  num evaluate(Context context) {
    final leftValue = lhs.evaluate(context);
    final rightValue = rhs.evaluate(context);

    return switch (operator) {
      ArithmeticOperator.add => leftValue + rightValue,
      ArithmeticOperator.sub => leftValue - rightValue,
      ArithmeticOperator.mul => leftValue * rightValue,
      ArithmeticOperator.div => leftValue / rightValue,
    };
  }
}
