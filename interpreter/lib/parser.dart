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
      final lineNumberToken = parseIntegerLiteral();
      final keywordToken = peekToken();
      final statement = switch (keywordToken) {
        LetKeywordToken() => parseLetStatement(),
        PrintKeywordToken() => parsePrintStatement(),
        GotoKeywordToken() => parseGotoStatement(),
        IfKeywordToken() => parseIfStatement(),
        EndKeywordToken() => parseEndStatement(),
        RemKeywordToken() => parseRemarkStatement(),
        _ => throw UnexpectedTokenError(
          position,
          keywordToken.kind(),
          TokenTypeOptionMany([
            TokenType.letKeyword,
            TokenType.printKeyword,
            TokenType.gotoKeyword,
            TokenType.ifKeyword,
            TokenType.endKeyword,
            TokenType.remKeyword,
          ]),
        ),
      };
      final lineNumber = lineNumberToken.value;
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
    final numberExpression = parseNumExpression();
    expectToken(TokenType.endOfLine);
    return LetStatement(identifierToken.value, numberExpression);
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
    final lineNumberToken = parseIntegerLiteral();
    expectToken(TokenType.endOfLine);
    final lineNumber = lineNumberToken.value;
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
    final numberLiteralToken = parseIntegerLiteral();
    expectToken(TokenType.endOfLine);
    final lineNumber = numberLiteralToken.value;
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

  /// Parses a REM statement.
  ///
  /// Expects a REM keyword followed by an end of line.
  /// Returns a [RemarkStatement] representing the parsed statement.
  Statement parseRemarkStatement() {
    expectToken(TokenType.remKeyword);
    while (peekToken().kind() != TokenType.endOfLine) {
      consumeToken();
    }
    expectToken(TokenType.endOfLine);
    return RemarkStatement();
  }

  /// Parses an expression that evaluates to a number.
  ///
  /// Returns an [Expression] of type [num] representing the parsed expression.
  Expression<num> parseNumExpression() {
    final token = consumeToken();
    return switch (token) {
      IntegerLiteralToken(value: var v) => IntegerLiteralExpression(v),
      FloatingPointLiteralToken(value: var v) => FloatingPointLiteralExpression(
        v,
      ),
      IdentifierToken(value: var i) => IdentifierExpression(i),
      _ => throw UnexpectedTokenError(
        position,
        token.kind(),
        TokenTypeOptionMany([
          TokenType.integerLiteral,
          TokenType.floatingPointLiteral,
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
      IntegerLiteralToken(value: var v) => IntegerLiteralExpression(v),
      FloatingPointLiteralToken(value: var v) => FloatingPointLiteralExpression(
        v,
      ),
      StringLiteralToken(value: var s) => StringLiteralExpression(s),
      IdentifierToken(value: var i) => IdentifierExpression(i),
      _ => throw UnexpectedTokenError(
        position,
        token.kind(),
        TokenTypeOptionMany([
          TokenType.integerLiteral,
          TokenType.floatingPointLiteral,
          TokenType.stringLiteral,
          TokenType.identifier,
        ]),
      ),
    };
  }

  /// Parses an integer literal token.
  ///
  /// Expects an integer literal token and returns a [IntegerLiteralToken] representing the parsed token.
  IntegerLiteralToken parseIntegerLiteral() {
    final expectedNumberLiteralToken = expectToken(TokenType.integerLiteral);
    return switch (expectedNumberLiteralToken) {
      IntegerLiteralToken(value: var v) => IntegerLiteralToken(v),
      _ => throw UnexpectedTokenError(
        position,
        expectedNumberLiteralToken.kind(),
        TokenTypeOptionOne(TokenType.integerLiteral),
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
