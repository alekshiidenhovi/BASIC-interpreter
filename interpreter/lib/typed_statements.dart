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
  void execute(Context context) {
    context.setVariable(identifier, expression.evaluate(context));
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
  TypedStatement<T>? execute(Context context) {
    return condition.evaluate(context) ? thenStatement : null;
  }
}

/// A statement, which unconditionally ends the program.
class TypedEndStatement extends TypedStatement<void> {
  /// Creates a new [TypedEndStatement].
  TypedEndStatement();

  @override
  void execute(Context context) {
    throw Exception("END statement reached!");
  }
}

/// A statement, which represents a user comment.
class TypedRemarkStatement extends TypedStatement<void> {
  /// Creates a new [TypedRemarkStatement].
  TypedRemarkStatement();

  @override
  void execute(Context context) {
    // Do nothing.
  }
}
