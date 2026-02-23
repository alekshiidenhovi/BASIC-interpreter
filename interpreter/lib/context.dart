import "errors.dart";

/// Execution context for the BASIC interpreter.
class Context {
  /// The variables stored in the context.
  Map<String, Object> _variables = {};

  /// The current statement index.
  int _statementIndex = 0;

  /// Default [Context] constructor.
  Context();

  /// Creates a new [Context] with the given [initialVariables].
  Context.withVariables(Map<String, num> initialVariables)
    : _variables = Map.from(initialVariables);

  /// Resets the context
  ///
  /// * Removes all variables from the context.
  /// * Resets the current statement index to 0.
  void reset() {
    _variables = {};
    _statementIndex = 0;
  }

  /// Increments the current statement index by 1.
  void incrementStatementCount() {
    _statementIndex++;
  }

  /// Returns the current statement index.
  int getStatementCount() {
    return _statementIndex;
  }

  void setVariable(String identifier, Object value) {
    _variables[identifier] = value;
  }

  T getVariable<T>(String identifier) {
    final value = _variables[identifier];
    if (value == null) {
      throw MissingIdentifierError(_statementIndex, identifier);
    }
    if (value is! T) {
      throw RuntimeTypeError(_statementIndex, identifier, T, value.runtimeType);
    }
    return value as T;
  }
}
