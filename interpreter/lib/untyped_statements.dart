import "untyped_expressions.dart";

/// An executable statement in the BASIC language.
sealed class Statement<T> {}

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
  String toString() => "LET_STATEMENT $identifier = $expression";
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
  String toString() => "PRINT_STATEMENT $arguments";
}

/// A statement, which conditionally executed another statement based on an expression's evaluation.
class IfStatement<T> extends Statement {
  /// The comparison expression that determines whether to execute the [thenStatement].
  final Expression condition;

  /// The statement to execute if the condition is true.
  final Statement<T> thenStatement;

  /// Creates a new [IfStatement].
  ///
  /// Requires the [condition] to evaluate and the [thenStatement] to execute if true.
  IfStatement(this.condition, this.thenStatement);

  @override
  String toString() => "IF_STATEMENT $condition $thenStatement";
}

/// A statement, which executes a block of statements repeatedly.
class ForStatement<T> extends Statement<void> {
  /// The identifier of the variable to assign.
  final String loopVariableName;

  /// The expression whose evaluation will determine the start value of the loop.
  final Expression start;

  /// The expression whose evaluation will determine the end value of the loop.
  final Expression end;

  /// The expression whose evaluation will determine the step value of the loop.
  final Expression step;

  /// The statement to execute for each iteration of the loop.
  final Statement<T> body;

  /// Creates a new [ForStatement].
  ///
  /// Requires the [identifier] to assign to and the [expression] to evaluate.
  ForStatement(
    this.loopVariableName,
    this.start,
    this.end,
    this.step,
    this.body,
  );

  @override
  String toString() =>
      "FOR_STATEMENT $loopVariableName = $start TO $end STEP $step (BODY: $body)";
}

/// A statement, which unconditionally ends the program.
class EndStatement extends Statement<void> {
  /// Creates a new [EndStatement].
  EndStatement();

  @override
  String toString() => "END_STATEMENT";
}

/// A statement, which represents a user comment.
class RemarkStatement extends Statement<void> {
  /// Creates a new [RemarkStatement].
  RemarkStatement();

  @override
  String toString() => "REMARK_STATEMENT";
}
