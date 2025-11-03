import 'dart:collection';
import "expressions.dart";
import "tokens.dart";
import "statements.dart";

class Parser {
  final List<Token> tokens;
  int position = 0;

  Parser(this.tokens);

  SplayTreeMap<int, Statement> parse() {
    SplayTreeMap<int, Statement> program = SplayTreeMap();

    while (position < tokens.length) {
      final lineNumber = int.parse(tokens[position].value);
      position++;

      final keywordToken = tokens[position];

      final statement = switch (keywordToken.category) {
        Category.let => parseLetStatement(),
        _ => throw Exception("Unexpected token: ${tokens[position]}"),
      };

      position++;
      program[lineNumber] = statement;
    }

    return program;
  }

  Statement parseLetStatement() {
    position++;
    final identifier = tokens[position].value;
    position += 2;
    final assignedToken = tokens[position];
    final expression = NumberLiteralExpression(num.parse(assignedToken.value));
    return LetStatement(identifier, expression);
  }
}
