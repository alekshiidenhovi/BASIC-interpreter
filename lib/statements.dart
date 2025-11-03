import "expressions.dart";

sealed class Statement<T> {
  T execute(Map<String, num> variables);
}

class LetStatement extends Statement<void> {
  final String identifier;
  final Expression expression;

  LetStatement(this.identifier, this.expression);

  @override
  void execute(Map<String, num> variables) {
    variables[identifier] = expression.evaluate(variables);
  }
}

class PrintStatement extends Statement<String> {
  final List<Expression> arguments;

  PrintStatement(this.arguments);

  @override
  String execute(Map<String, num> variables) {
    return arguments.map((expr) => expr.evaluate(variables)).join("\t");
  }
}

class GotoStatement extends Statement<int> {
  final int lineNumber;

  GotoStatement(this.lineNumber);

  @override
  int execute(Map<String, num> variables) {
    return lineNumber;
  }
}

class IfStatement extends Statement<int?> {
  final ComparisonExpression condition;
  final int lineNumber;

  IfStatement(this.condition, this.lineNumber);

  @override
  int? execute(Map<String, num> variables) {
    return condition.evaluate(variables) ? lineNumber : null;
  }
}
