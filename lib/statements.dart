import "expressions.dart";

/// An executable statement in the BASIC language.
sealed class Statement<T> {
  /// Executes the statement and returns a result.
  ///
  /// [variables] is a map of variable names to their numeric values.
  T execute(Map<String, num> variables);
}

/// A statement, which assigns the result of an expression to a variable.
class LetStatement extends Statement<void> {
  /// The identifier of the variable to assign.
  final String identifier;

  /// The expression whose value will be assigned to the identifier.
  final Expression expression;

  /// Creates a new [LetStatement].
  ///
  /// Requires the [identifier] to assign to and the [expression] to evaluate.
  LetStatement(this.identifier, this.expression);

  @override
  void execute(Map<String, num> variables) {
    variables[identifier] = expression.evaluate(variables);
  }
}

/// A statement, which evaluates a list of expressions and concatenates their string representations.
class PrintStatement extends Statement<String> {
  /// The list of expressions to evaluate and print.
  final List<Expression> arguments;

  /// Creates a new [PrintStatement].
  ///
  /// Requires a list of [arguments] to evaluate and print.
  PrintStatement(this.arguments);

  @override
  String execute(Map<String, num> variables) {
    return arguments.map((expr) => expr.evaluate(variables)).join("\t");
  }
}

/// A statement, which unconditionally jumps to a specified line number.
class GotoStatement extends Statement<int> {
  /// The line number to jump to.
  final int lineNumber;

  /// Creates a new [GotoStatement].
  ///
  /// Requires the [lineNumber] to jump to.
  GotoStatement(this.lineNumber);

  @override
  int execute(Map<String, num> variables) {
    return lineNumber;
  }
}

/// A statement, which conditionally jumps to a specified line number based on an expression's evaluation.
class IfStatement extends Statement<int?> {
  /// The comparison expression that determines whether to jump.
  final ComparisonExpression condition;

  /// The line number to jump to if the condition is true.
  final int lineNumber;

  /// Creates a new [IfStatement].
  ///
  /// Requires the [condition] to evaluate and the [lineNumber] to jump to if true.
  IfStatement(this.condition, this.lineNumber);

  @override
  int? execute(Map<String, num> variables) {
    return condition.evaluate(variables) ? lineNumber : null;
  }
}

/// A statement, which unconditionally ends the program.
class EndStatement extends Statement<void> {
  /// Creates a new [EndStatement].
  EndStatement();

  @override
  void execute(Map<String, num> variables) {
    throw Exception("END statement reached!");
  }
}

/// A statement, which represents a user comment.
class RemarkStatement extends Statement<void> {
  /// Creates a new [RemarkStatement].
  RemarkStatement();

  @override
  void execute(Map<String, num> variables) {
    // Do nothing.
  }
}
