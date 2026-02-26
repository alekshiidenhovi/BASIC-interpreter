import "typed_expressions.dart";
import "context.dart";

/// An executable statement in the BASIC language.
sealed class TypedStatement<T> {
  /// Executes the statement and returns a result.
  ///
  /// [variables] is a map of variable names to their numeric values.
  T execute(Context context);
}

/// A statement, which assigns the result of an expression to a variable.
class TypedLetStatement extends TypedStatement<void> {
  /// The identifier of the variable to assign.
  final String identifier;

  /// The expression whose value will be assigned to the identifier.
  final TypedExpression expression;

  /// Creates a new [TypedLetStatement].
  ///
  /// Requires the [identifier] to assign to and the [expression] to evaluate.
  TypedLetStatement(this.identifier, this.expression);

  @override
  String toString() => "TYPED_LET_STATEMENT $identifier = $expression";

  @override
  void execute(Context context) {
    context.declareVariable(identifier, expression.evaluate(context));
  }
}

/// A statement, which evaluates a list of expressions and concatenates their string representations.
class TypedPrintStatement extends TypedStatement<String> {
  /// The list of expressions to evaluate and print.
  final List<TypedExpression> arguments;

  /// Creates a new [TypedPrintStatement].
  ///
  /// Requires a list of [arguments] to evaluate and print.
  TypedPrintStatement(this.arguments);

  @override
  String toString() => "TYPED_PRINT_STATEMENT $arguments";

  @override
  String execute(Context context) {
    return arguments.map((expr) => expr.evaluate(context)).join("\t");
  }
}

/// A statement, which conditionally executed another statement based on an expression's evaluation.
class TypedIfStatement<T> extends TypedStatement {
  /// The comparison expression that determines whether to execute the [thenStatement].
  final TypedExpression condition;

  /// The statement to execute if the condition is true.
  final TypedStatement<T> thenStatement;

  /// Creates a new [TypedIfStatement].
  ///
  /// Requires the [condition] to evaluate and the [thenStatement] to execute if true.
  TypedIfStatement(this.condition, this.thenStatement);

  @override
  String toString() => "TYPED_IF_STATEMENT $condition $thenStatement";

  @override
  TypedStatement<T>? execute(Context context) {
    return condition.evaluate(context) ? thenStatement : null;
  }
}

/// A statement, which executes a block of statements repeatedly.
class TypedForStatement<T> extends TypedStatement<void> {
  /// The identifier of the variable to assign.
  final String loopVariableName;

  /// The expression whose evaluation will determine the start value of the loop.
  final TypedExpression<int> start;

  /// The expression whose evaluation will determine the end value of the loop.
  final TypedExpression<int> end;

  /// The expression whose evaluation will determine the step value of the loop.
  final TypedExpression<int> step;

  /// The statement to execute for each iteration of the loop.
  final TypedStatement<T> body;

  /// Creates a new [TypedForStatement].
  ///
  /// Requires the [identifier] to assign to and the [expression] to evaluate.
  TypedForStatement(
    this.loopVariableName,
    this.start,
    this.end,
    this.step,
    this.body,
  );

  @override
  String toString() =>
      "TYPED_FOR_STATEMENT $loopVariableName = $start TO $end STEP $step (BODY: $body)";

  @override
  void execute(Context context) {
    throw Exception("Execute method should not be called for FOR statements");
  }
}

/// A statement, which defines a callable function.
class TypedFunctionDeclarationStatement extends TypedStatement<void> {
  /// The identifier of the function.
  final String identifier;

  /// The arguments of the function.
  final List<String> arguments;

  /// The body of the function.
  final TypedExpression body;

  /// Creates a new [TypedFunctionDeclarationStatement].
  ///
  /// Requires the [name] of the function, the [parameters] of the function, and the [body] of the function.
  TypedFunctionDeclarationStatement(this.identifier, this.arguments, this.body);

  @override
  String toString() =>
      "TYPED_FUNCTION_DECLARATION $identifier($arguments) = $body";

  @override
  void execute(Context context) {
    context.declareFunction(identifier, arguments, body);
  }
}

/// A statement, which unconditionally ends the program.
class TypedEndStatement extends TypedStatement<void> {
  /// Creates a new [TypedEndStatement].
  TypedEndStatement();

  @override
  String toString() => "TYPED_END_STATEMENT";

  @override
  void execute(Context context) {
    throw Exception("Execute method should not be called for END statements");
  }
}

/// A statement, which represents a user comment.
class TypedRemarkStatement extends TypedStatement<void> {
  /// Creates a new [TypedRemarkStatement].
  TypedRemarkStatement();

  @override
  String toString() => "TYPED_REMARK_STATEMENT";

  @override
  void execute(Context context) {
    // Do nothing.
  }
}
