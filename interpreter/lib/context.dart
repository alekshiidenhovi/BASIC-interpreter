/// Execution context for the BASIC interpreter.
class Context {
  /// The variables stored in the context.
  Map<String, num> variables = {};

  /// The current statement index.
  int statementIndex = 0;

  Context();

  /// Resets the context
  ///
  /// * Removes all variables from the context.
  /// * Resets the current statement index to 0.
  void reset() {
    variables = {};
    statementIndex = 0;
  }

  Context.withVariables(Map<String, num> initialVariables)
    : variables = Map.from(initialVariables);
}
