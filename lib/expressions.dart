import "operators.dart";

sealed class Expression<T> {
  T evaluate(Map<String, num> variables);
}

class NumberLiteralExpression extends Expression<num> {
  final num value;

  NumberLiteralExpression(this.value);

  @override
  num evaluate(Map<String, num> variables) {
    return value;
  }
}

class StringLiteralExpression extends Expression<String> {
  final String value;

  StringLiteralExpression(this.value);

  @override
  String evaluate(Map<String, num> variables) {
    return value;
  }
}

class IdentifierExpression extends Expression<num> {
  final String identifier;

  IdentifierExpression(this.identifier);

  @override
  num evaluate(Map<String, num> variables) {
    return variables[identifier]!;
  }
}

class ComparisonExpression extends Expression<bool> {
  final Expression<num> lhs;
  final Expression<num> rhs;
  final ComparisonOperator operator;

  ComparisonExpression(this.lhs, this.rhs, this.operator);

  @override
  bool evaluate(Map<String, num> variables) {
    num leftValue = lhs.evaluate(variables);
    num rightValue = rhs.evaluate(variables);

    return switch (operator) {
      ComparisonOperator.equals => leftValue == rightValue,
    };
  }
}
