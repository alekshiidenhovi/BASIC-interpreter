/// A buffer for storing lines of code entered by the user. Multiline statements can then be collected and executed whenever they are complete.
class ReplBuffer {
  /// The lines of code collected so far.
  final List<String> _lines = [];

  /// The current depth of nested loops.
  int _depth = 0;

  /// Returns true if the buffer is still waiting for more input.
  bool addLine(String line) {
    _lines.add(line);
    final trimmed = line.trim().toUpperCase();
    if (trimmed.startsWith('FOR')) _depth++;
    if (trimmed.startsWith('NEXT')) _depth--;
    // Add DEF/END here later for functions
    return _depth > 0;
  }

  /// Resets the buffer to its initial state.
  void reset() {
    _lines.clear();
    _depth = 0;
  }

  /// Returns the collected code lines, joined with newlines.
  String flush() {
    final code = '${_lines.join('\n')}\n';
    reset();
    return code;
  }
}
