import 'dart:collection';

import "expressions.dart";
import "tokens.dart";
import "statements.dart";
import "errors.dart";
import "operators.dart";

/// Parses a list of tokens into executable statements.
class Parser {
  /// A list of tokens that represent the parsed elements of the input.
  final List<Token> tokens;

  /// The position, initialized to -1 to indicate an invalid or unset state.
  int position = 0;

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
      final lineNumberToken = parseNumberLiteral();
      final keywordToken = peekToken();
      final statement = switch (keywordToken) {
        LetKeywordToken() => parseLetStatement(),
        PrintKeywordToken() => parsePrintStatement(),
        GotoKeywordToken() => parseGotoStatement(),
        IfKeywordToken() => parseIfStatement(),
        EndKeywordToken() => parseEndStatement(),
        _ => throw UnexpectedTokenError(
          position,
          keywordToken.kind(),
          TokenTypeOptionMany([
            TokenType.letKeyword,
            TokenType.printKeyword,
            TokenType.gotoKeyword,
            TokenType.ifKeyword,
            TokenType.endKeyword,
          ]),
        ),
      };
      final lineNumber = lineNumberToken.value.toInt();
      program[lineNumber] = statement;
    }

    return program;
  }

  /// Parses a LET statement.
  ///
  /// Expects an identifier, an equals sign, and a number literal.
  /// Returns a [LetStatement] representing the parsed statement.
  Statement parseLetStatement() {
    expectToken(TokenType.letKeyword);
    final identifierToken = parseIdentifier();
    expectToken(TokenType.equals);
    final numberLiteralToken = parseNumberLiteral();
    expectToken(TokenType.endOfLine);
    final expression = NumberLiteralExpression(numberLiteralToken.value);
    return LetStatement(identifierToken.value, expression);
  }

  /// Parses a PRINT statement.
  ///
  /// Expects a list of expressions separated by commas, ending with a newline.
  /// Returns a [PrintStatement] representing the parsed statement.
  Statement parsePrintStatement() {
    expectToken(TokenType.printKeyword);
    final List<Expression> arguments = [];

    if (peekToken().kind() == EndOfLineToken().kind()) {
      consumeToken();
      return PrintStatement(arguments);
    }

    while (true) {
      arguments.add(parseExpression());

      if (peekToken().kind() == TokenType.comma) {
        consumeToken();
      } else {
        break;
      }
    }

    expectToken(TokenType.endOfLine);
    return PrintStatement(arguments);
  }

  /// Parses a GOTO statement.
  ///
  /// Expects a number literal representing the line number to jump to.
  /// Returns a [GotoStatement] representing the parsed statement.
  Statement parseGotoStatement() {
    expectToken(TokenType.gotoKeyword);
    final lineNumberToken = parseNumberLiteral();
    expectToken(TokenType.endOfLine);
    final lineNumber = lineNumberToken.value.toInt();
    return GotoStatement(lineNumber);
  }

  /// Parses an IF statement.
  ///
  /// Expects a condition (two expressions and an operator), followed by THEN and a line number.
  /// Returns an [IfStatement] representing the parsed statement.
  Statement parseIfStatement() {
    expectToken(TokenType.ifKeyword);
    final Expression<num> lhs = parseNumExpression();
    final comparisonOperator = parseComparisonOperator();
    final Expression<num> rhs = parseNumExpression();
    expectToken(TokenType.thenKeyword);
    final numberLiteralToken = parseNumberLiteral();
    expectToken(TokenType.endOfLine);
    final lineNumber = numberLiteralToken.value.toInt();
    final condition = ComparisonExpression(lhs, rhs, comparisonOperator);
    return IfStatement(condition, lineNumber);
  }

  /// Parses an END statement.
  ///
  /// Expects an END keyword followed by an end of line.
  /// Returns an [EndStatement] representing the parsed statement.
  Statement parseEndStatement() {
    expectToken(TokenType.endKeyword);
    expectToken(TokenType.endOfLine);
    return EndStatement();
  }

  /// Parses an expression that evaluates to a number.
  ///
  /// Returns an [Expression] of type [num] representing the parsed expression.
  Expression<num> parseNumExpression() {
    final token = consumeToken();
    return switch (token) {
      NumberLiteralToken(value: var v) => NumberLiteralExpression(v),
      IdentifierToken(value: var i) => IdentifierExpression(i),
      _ => throw UnexpectedTokenError(
        position,
        token.kind(),
        TokenTypeOptionMany([
          TokenType.numberLiteral,
          TokenType.stringLiteral,
          TokenType.identifier,
        ]),
      ),
    };
  }

  /// Parses an expression that evaluates to a value.
  ///
  /// Returns an [Expression] representing the parsed expression.
  Expression parseExpression() {
    final token = consumeToken();
    return switch (token) {
      NumberLiteralToken(value: var v) => NumberLiteralExpression(v),
      StringLiteralToken(value: var s) => StringLiteralExpression(s),
      IdentifierToken(value: var i) => IdentifierExpression(i),
      _ => throw UnexpectedTokenError(
        position,
        token.kind(),
        TokenTypeOptionMany([
          TokenType.numberLiteral,
          TokenType.stringLiteral,
          TokenType.identifier,
        ]),
      ),
    };
  }

  /// Parses a number literal token.
  ///
  /// Expects a number literal token and returns a [NumberLiteralToken] representing the parsed token.
  NumberLiteralToken parseNumberLiteral() {
    final expectedNumberLiteralToken = expectToken(TokenType.numberLiteral);
    return switch (expectedNumberLiteralToken) {
      NumberLiteralToken(value: var v) => NumberLiteralToken(v),
      _ => throw UnexpectedTokenError(
        position,
        expectedNumberLiteralToken.kind(),
        TokenTypeOptionOne(TokenType.numberLiteral),
      ),
    };
  }

  /// Parses an identifier token.
  ///
  /// Expects an identifier token and returns an [IdentifierToken] representing the parsed token.
  IdentifierToken parseIdentifier() {
    final expectedIdentifierToken = expectToken(TokenType.identifier);
    return switch (expectedIdentifierToken) {
      IdentifierToken(value: var v) => IdentifierToken(v),
      _ => throw UnexpectedTokenError(
        position,
        expectedIdentifierToken.kind(),
        TokenTypeOptionOne(TokenType.identifier),
      ),
    };
  }

  /// Parses a comparison operator token
  ///
  /// Expects a comparison operator token and returns a [ComparisonOperator] representing the parsed token.
  ComparisonOperator parseComparisonOperator() {
    final comparisonOperatorToken = consumeToken();
    return switch (comparisonOperatorToken) {
      EqualsToken() => ComparisonOperator.eq,
      NotEqualToken() => ComparisonOperator.neq,
      LessThanToken() => ComparisonOperator.lt,
      LessThanOrEqualToken() => ComparisonOperator.lte,
      GreaterThanToken() => ComparisonOperator.gt,
      GreaterThanOrEqualToken() => ComparisonOperator.gte,
      _ => throw UnexpectedTokenError(
        position,
        comparisonOperatorToken.kind(),
        TokenTypeOptionMany([
          TokenType.equals,
          TokenType.notEqual,
          TokenType.lessThan,
          TokenType.lessThanOrEqual,
          TokenType.greaterThan,
          TokenType.greaterThanOrEqual,
        ]),
      ),
    };
  }

  /// Expects a token of the given [category] and return it when matched.
  ///
  /// Throws a [UnexpectedEndOfInputError] if the end of the token stream is reached.
  /// Throws an [UnexpectedTokenError] if the current token is not of the given [category].
  Token expectToken(TokenType expectedTokenType) {
    final currentToken = consumeToken();
    if (currentToken.kind() != expectedTokenType) {
      throw UnexpectedTokenError(
        position,
        currentToken.kind(),
        TokenTypeOptionOne(expectedTokenType),
      );
    }
    return currentToken;
  }

  /// Consumes the current token and returns it.
  ///
  /// Side effect: increments the current position by one.
  ///
  /// Throws an [UnexpectedEndOfInputError] if the end of the token stream is reached.
  Token consumeToken() {
    final token = peekToken();
    position++;
    return token;
  }

  /// Returns the current token without consuming it.
  ///
  /// Throws an [UnexpectedEndOfInputError] if the end of the token stream is reached.
  Token peekToken() {
    if (position >= tokens.length) {
      throw UnexpectedEndOfInputError(position);
    }
    return tokens[position];
  }
}
