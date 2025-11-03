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

    int? firstLine = programLines.firstKey();
    if (firstLine == null) {
      throw Exception("Parser did not find any statements!");
    }

    int currentLine = firstLine;
    while (currentLine > 0) {
      Statement statement = programLines[currentLine]!;

      if (statement is GotoStatement) {
        currentLine = statement.execute(variables);
        continue;
      }

      if (statement is IfStatement) {
        int? jumpLine = statement.execute(variables);
        if (jumpLine != null) {
          currentLine = jumpLine;
        }
        continue;
      }

      if (statement is PrintStatement) {
        String output = statement.execute(variables);
        outputLines.add(output);
      } else {
        statement.execute(variables);
      }

      currentLine = programLines.keys.firstWhere(
        (lineNumber) => lineNumber > currentLine,
        orElse: () => -1,
      );
    }

    return outputLines;
  }
}
