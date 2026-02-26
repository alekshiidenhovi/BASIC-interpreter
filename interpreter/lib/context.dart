import "builtins.dart";
import "data_structures.dart";
import "errors.dart";
import "typed_expressions.dart";

/// Execution context for the BASIC interpreter.
class Context {
  /// The variables stored in the context.
  Stack<Scope<Object>> _variables = Stack();
  Stack<Scope<(List<String>, TypedExpression)>> _functions = Stack();

  /// The current statement index.
  int _statementIndex = 0;

  /// Default [Context] constructor.
  Context() {
    reset();
  }

  /// Creates a new [Context] with the given [initialVariables].
  Context.withVariables(Map<String, num> initialVariables) {
    _variables.push(Scope());
    _functions.push(Scope());
    for (final variable in initialVariables.entries) {
      _variables.peek.declare(variable.key, variable.value);
    }
  }

  /// Resets the context
  ///
  /// * Removes all variables from the context.
  /// * Resets the current statement index to 0.
  void reset() {
    _variables = Stack()..push(Scope());
    _functions = Stack()..push(Scope());
    _statementIndex = 0;
    _registerBuiltinFunctions();
  }

  /// Adds a new scope to the stack.
  void createNewScope() {
    _variables.push(Scope());
    _functions.push(Scope());
  }

  /// Removes the top scope from the stack.
  void removeTopScope() {
    _variables.pop();
    _functions.pop();
  }

  /// Increments the current statement index by 1.
  void incrementStatementCount() {
    _statementIndex++;
  }

  /// Returns the current statement index.
  int getStatementCount() {
    return _statementIndex;
  }

  /// Sets the value of a variable in the context.
  void declareVariable(String identifier, Object value) {
    _variables.peek.declare(identifier, value);
  }

  /// Sets the value of a function in the context to the innermost scope.
  void declareFunction(
    String identifier,
    List<String> arguments,
    TypedExpression expression,
  ) {
    _functions.peek.declare(identifier, (arguments, expression));
  }

  /// Returns the value of a variable in the context from the innermost scope.
  T lookupVariable<T>(String identifier) {
    for (final scope in _variables.topToBottom) {
      final value = scope.lookup(identifier);
      if (value == null) continue;
      if (value is! T) {
        throw RuntimeTypeError(
          _statementIndex,
          identifier,
          T,
          value.runtimeType,
        );
      }
      return value as T;
    }
    throw MissingIdentifierError(_statementIndex, identifier);
  }

  /// Returns the value of a function in the context from the innermost scope.
  (List<String>, TypedExpression)? lookupFunction(String identifier) {
    for (final scope in _functions.topToBottom) {
      final value = scope.lookup(identifier);
      if (value != null) return value;
    }
    return null;
  }

  /// Stores built-in functions.
  void _registerBuiltinFunctions() {
    declareFunction("SQR", [
      "X",
    ], TypedNativeExpression((context) => builtinSqr(context)));
  }
}
