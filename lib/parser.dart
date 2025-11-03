import 'dart:collection';
import "expressions.dart";
import "tokens.dart";
import "statements.dart";

class Parser {
  final List<Token> tokens;
  int position = -1;

  Parser(this.tokens);

  SplayTreeMap<int, Statement> parse() {
    SplayTreeMap<int, Statement> program = SplayTreeMap();

    while (position < tokens.length) {
      final lineNumberToken = expectToken(Category.numberLiteral);
      final lineNumber = int.parse(lineNumberToken.value);

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
    final identifierToken = expectToken(Category.identifier);
    expectToken(Category.equals);
    final numberToken = expectToken(Category.numberLiteral);
    final expression = NumberLiteralExpression(num.parse(numberToken.value));
    return LetStatement(identifierToken.value, expression);
  }

  Token expectToken(Category category) {
    position++;
    if (position >= tokens.length) {
      throw Exception("Unexpected end when looking for next token.");
    }

    final currentToken = tokens[position];
    if (currentToken.category != category) {
      throw Exception(
        "Expected token category $category, found ${currentToken.category}",
      );
    }
    return currentToken;
  }
}
