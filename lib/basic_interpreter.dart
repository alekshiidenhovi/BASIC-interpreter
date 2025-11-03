import 'dart:collection';
import "statements.dart";
import "lexer.dart";
import "parser.dart";

class Interpreter {
  SplayTreeMap<int, Statement> programLines = SplayTreeMap();
  Map<String, num> variables = {};

  List<String> interpret(String code) {
    final lexer = Lexer(code);
    final parser = Parser(lexer.tokenize());

    programLines = parser.parse();
    List<String> outputLines = [];

    for (var entry in programLines.entries) {
      Statement statement = entry.value;
      if (statement is PrintStatement) {
        String output = statement.execute(variables);
        outputLines.add(output);
      } else {
        statement.execute(variables);
      }
    }

    return outputLines;
  }
}
