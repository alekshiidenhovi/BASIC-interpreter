import 'dart:collection';
import "package:basic_interpreter/operators.dart";

import "expressions.dart";
import "tokens.dart";
import "statements.dart";
import "errors.dart";

/// Parses a list of tokens into executable statements.
class Parser {
  /// A list of tokens that represent the parsed elements of the input.
  final List<Token> tokens;

  /// The position, initialized to -1 to indicate an invalid or unset state.
  int position = -1;

  /// Creates a new [Parser] instance.
  ///
  /// The [tokens] argument is a list of tokens to parse.
  Parser(this.tokens);

  /// Parses the tokens into a program.
  ///
  /// Returns a [SplayTreeMap] where keys are line numbers and values are [Statement]s.
  SplayTreeMap<int, Statement> parse() {
    SplayTreeMap<int, Statement> program = SplayTreeMap();

    while (position < tokens.length) {
      position++;
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

  /// Parses a LET statement.
  ///
  /// Expects an identifier, an equals sign, and a number literal.
  /// Returns a [LetStatement] representing the parsed statement.
  Statement parseLetStatement() {
    position++;
    final identifierToken = expectToken(Category.identifier);
    position++;
    expectToken(Category.equals);
    position++;
    final numberToken = expectToken(Category.numberLiteral);
    final expression = NumberLiteralExpression(num.parse(numberToken.value));
    return LetStatement(identifierToken.value, expression);
  }

  /// Parses a PRINT statement.
  ///
  /// Expects a list of expressions separated by commas, ending with a newline.
  /// Returns a [PrintStatement] representing the parsed statement.
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
      position++;
      expectToken(Category.comma);
      position++;
    }

    position = endPosition - 1;
    return PrintStatement(arguments);
  }

  /// Parses a GOTO statement.
  ///
  /// equalsExpects a number literal representing the line number to jump to.
  /// Returns a [GotoStatement] representing the parsed statement.
  Statement parseGotoStatement() {
    position++;
    expectToken(Category.numberLiteral);
    final lineNumber = int.parse(tokens[position].value);
    return GotoStatement(lineNumber);
  }

  /// Parses an IF statement.
  ///
  /// Expects a condition (two expressions and an operator), followed by THEN and a line number.
  /// Returns an [IfStatement] representing the parsed statement.
  Statement parseIfStatement() {
    position++;
    final Expression<num> lhs = switch (tokens[position].category) {
      Category.numberLiteral => NumberLiteralExpression(
        num.parse(tokens[position].value),
      ),
      Category.identifier => IdentifierExpression(tokens[position].value),
      _ => throw InvalidTokenError(position, tokens[position].category),
    };

    position++;
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

    position++;
    expectToken(Category.then);
    position++;
    final lineNumber = int.parse(expectToken(Category.numberLiteral).value);
    final condition = ComparisonExpression(lhs, rhs, operator);
    return IfStatement(condition, lineNumber);
  }

  /// Expects a token of the given [category] and return it when matched.
  ///
  /// Otherwise, it throws an [UnexpectedTokenError] or [MissingTokenError].
  Token expectToken(Category category) {
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
