/// Execution context for the BASIC interpreter.
class Context {
  Map<String, num> variables = {};

  Context();

  Context.withVariables(Map<String, num> initialVariables)
    : variables = Map.from(initialVariables);
}
