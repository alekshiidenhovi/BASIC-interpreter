/// Execution context for the BASIC interpreter.
class Context {
  /// The variables stored in the context.
  Map<String, num> variables = {};

  /// The current statement index.
  int statementIndex = 0;

  Context();

  Context.withVariables(Map<String, num> initialVariables)
    : variables = Map.from(initialVariables);
}
