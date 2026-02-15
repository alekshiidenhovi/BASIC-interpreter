/// Execution context for the BASIC interpreter.
class Context {
  /// The variables stored in the context.
  Map<String, num> variables = {};

  /// The current statement index.
  int _statementIndex = 0;

  Context();

  /// Resets the context
  ///
  /// * Removes all variables from the context.
  /// * Resets the current statement index to 0.
  void reset() {
    variables = {};
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

  Context.withVariables(Map<String, num> initialVariables)
    : variables = Map.from(initialVariables);
}
