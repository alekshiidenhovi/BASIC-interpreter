import 'dart:collection';

class Interpreter {
  SplayTreeMap<int, String> programLines = SplayTreeMap();
  Map<String, num> variables = {};

  void parseLines(String code) {
    List<String> lines = code.split('\n');
    for (var line in lines) {
      int firstSpace = line.indexOf(' ');
      int lineNumber = int.parse(line.substring(0, firstSpace));
      String statement = line.substring(firstSpace + 1);
      programLines[lineNumber] = statement;
    }
  }

  List<String> interpret(String code) {
    parseLines(code);

    List<String> outputLines = [];

    for (var entry in programLines.entries) {
      final String statement = entry.value;

      if (statement.startsWith("PRINT")) {
        final String printStatement = statement.substring(6);
        final pattern = RegExp(r'"(.*?)"|([A-Z]\d?)');
        final matches = pattern.allMatches(printStatement);
        final outputs = matches.map((match) => match.group(1) ?? variables[match.group(2)!]);
        outputLines.add(outputs.join("\t"));
      }

      if (statement.startsWith("LET")) {
        final String variableStatement = statement.substring(4);
        final pattern = RegExp(r'([A-Z]\d?) ?= ?(\d+(\.\d+)?)');
        final match = pattern.firstMatch(variableStatement)!;
        
        final String variable = match.group(1)!;
        final num value = num.parse(match.group(2)!);
        variables[variable] = value;
      }
    }

    return outputLines;
  }
}
