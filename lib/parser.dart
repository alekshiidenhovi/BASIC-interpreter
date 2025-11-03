import 'dart:collection';
import "package:basic_interpreter/operators.dart";

import "expressions.dart";
import "tokens.dart";
import "statements.dart";
import "errors.dart";

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
        Category.print => parsePrintStatement(),
        Category.goto => parseGotoStatement(),
        Category.ifToken => parseIfStatement(),
        _ => throw InvalidTokenError(position, keywordToken.category),
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

  Statement parsePrintStatement() {
    position++;

    final int endOfLineIndex = tokens.indexOf(
      Token(Category.endOfLine, "\n"),
      position,
    );
    final int endPosition = endOfLineIndex == -1
        ? tokens.length
        : endOfLineIndex;
    final List<Expression> arguments = [];

    while (position < endPosition) {
      final token = tokens[position];
      Expression expression = switch (token.category) {
        Category.numberLiteral => NumberLiteralExpression(
          num.parse(token.value),
        ),
        Category.stringLiteral => StringLiteralExpression(token.value),
        Category.identifier => IdentifierExpression(token.value),
        _ => throw InvalidTokenError(position, token.category),
      };
      arguments.add(expression);

      if (position + 1 >= endPosition) {
        break;
      }
      expectToken(Category.comma);
      position++;
    }

    position = endPosition - 1;
    return PrintStatement(arguments);
  }

  Statement parseGotoStatement() {
    expectToken(Category.numberLiteral);
    final lineNumber = int.parse(tokens[position].value);
    return GotoStatement(lineNumber);
  }

  Statement parseIfStatement() {
    position++;
    final Expression<num> lhs = switch (tokens[position].category) {
      Category.numberLiteral => NumberLiteralExpression(
        num.parse(tokens[position].value),
      ),
      Category.identifier => IdentifierExpression(tokens[position].value),
      _ => throw InvalidTokenError(position, tokens[position].category),
    };

    expectToken(Category.equals);
    ComparisonOperator operator = ComparisonOperator.equals;

    position++;
    final Expression<num> rhs = switch (tokens[position].category) {
      Category.numberLiteral => NumberLiteralExpression(
        num.parse(tokens[position].value),
      ),
      Category.identifier => IdentifierExpression(tokens[position].value),
      _ => throw InvalidTokenError(position, tokens[position].category),
    };

    expectToken(Category.then);
    final lineNumber = int.parse(expectToken(Category.numberLiteral).value);
    final condition = ComparisonExpression(lhs, rhs, operator);
    return IfStatement(condition, lineNumber);
  }

  Token expectToken(Category category) {
    position++;
    if (position >= tokens.length) {
      throw MissingTokenError(position, category);
    }

    final currentToken = tokens[position];
    if (currentToken.category != category) {
      throw UnexpectedTokenError(position, category, currentToken.category);
    }
    return currentToken;
  }
}
