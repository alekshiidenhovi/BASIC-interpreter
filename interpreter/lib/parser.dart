import "tokens.dart";
import "errors.dart";
import "operators.dart";
import "untyped_expressions.dart";
import "untyped_statements.dart";

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

  /// The parsed program.
  List<Statement> program = [];

  /// Parses the tokens into a program.
  ///
  /// Returns a  list of [Statement]s.
  List<Statement> parse() {
    while (position < tokens.length) {
      final statement = parseStatement();
      storeStatement(statement);
      if (statement is EndStatement) {
        break;
      }
      expectToken(TokenType.endOfLine);
    }

    return program;
  }

  /// Attempty to parse a statement.
  ///
  /// Returns a [Statement] representing the parsed statement.
  Statement parseStatement() {
    final keywordToken = peekToken();
    final statement = switch (keywordToken) {
      LetKeywordToken() => parseLetStatement(),
      PrintKeywordToken() => parsePrintStatement(),
      IfKeywordToken() => parseIfStatement(),
      EndKeywordToken() => parseEndStatement(),
      RemKeywordToken() => parseRemarkStatement(),
      _ => throw UnexpectedTokenError(
        position,
        keywordToken.kind(),
        TokenTypeOptionMany([
          TokenType.letKeyword,
          TokenType.printKeyword,
          TokenType.ifKeyword,
          TokenType.endKeyword,
          TokenType.remKeyword,
        ]),
      ),
    };
    return statement;
  }

  /// Stores the statement in the program.
  void storeStatement(Statement statement) {
    program.add(statement);
  }

  /// Parses a LET statement.
  ///
  /// Expects an identifier, an equals sign, and a number literal.
  /// Returns a [LetStatement] representing the parsed statement.
  Statement parseLetStatement() {
    expectToken(TokenType.letKeyword);
    final identifierExpression = parseIdentifierFactor();
    expectToken(TokenType.equals);
    final expression = parseExpression(0);
    return LetStatement(identifierExpression.identifier, expression);
  }

  /// Parses a PRINT statement.
  ///
  /// Expects a list of expressions separated by commas, ending with a newline.
  /// Returns a [PrintStatement] representing the parsed statement.
  Statement parsePrintStatement() {
    expectToken(TokenType.printKeyword);
    final List<Expression> arguments = [];

    if (peekToken().kind() == EndOfLineToken().kind()) {
      return PrintStatement(arguments);
    }

    while (true) {
      arguments.add(parseExpression(0));

      if (peekToken().kind() == TokenType.comma) {
        consumeToken();
      } else {
        break;
      }
    }

    return PrintStatement(arguments);
  }

  /// Parses an IF statement.
  ///
  /// Expects a condition (two expressions and an operator), followed by THEN and a line number.
  /// Returns an [IfStatement] representing the parsed statement.
  Statement parseIfStatement() {
    expectToken(TokenType.ifKeyword);
    final Expression condition = parseExpression(0);
    expectToken(TokenType.thenKeyword);
    final thenStatement = parseStatement();
    return IfStatement(condition, thenStatement);
  }

  /// Parses an END statement.
  ///
  /// Expects an END keyword followed by an end of line.
  /// Returns an [EndStatement] representing the parsed statement.
  Statement parseEndStatement() {
    expectToken(TokenType.endKeyword);
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
    return RemarkStatement();
  }

  /// Parses an expression from the token stream,
  ///
  /// Uses the precedence climbing algorithm to parse the expression.
  ///
  /// The [minPrecedence] argument is the minimum precedence of the expression being parsed.
  /// Returns an [Expression] representing the parsed expression.
  Expression parseExpression(int minPrecedence) {
    var left = parseFactor();
    while (true) {
      final token = peekToken();
      final int? precedence = token.getBinaryOperatorPrecedence();
      if (precedence == null || precedence < minPrecedence) {
        break;
      }
      final operator = parseBinaryOperator();
      final right = parseExpression(precedence + 1);
      left = BinaryExpression(left, right, operator);
    }
    return left;
  }

  /// Parses a factor from the token stream.
  ///
  /// Supported factors:
  /// - Integer literal
  /// - Floating point literal
  /// - String literal
  /// - Identifier
  /// - Unary operator
  /// - Parenthesized expression
  ///
  /// Returns an [Expression] representing the parsed factor.
  Expression parseFactor() {
    final token = peekToken();
    return switch (token.kind()) {
      TokenType.integerLiteral => parseIntegerFactor(),
      TokenType.floatingPointLiteral => parseFloatingPointFactor(),
      TokenType.stringLiteral => parseStringFactor(),
      TokenType.identifier => parseIdentifierFactor(),
      TokenType.minus => parseUnaryFactor(),
      TokenType.openParen => parseParenthesizedExpression(),
      _ => throw UnexpectedTokenError(
        position,
        token.kind(),
        TokenTypeOptionMany([
          TokenType.integerLiteral,
          TokenType.floatingPointLiteral,
          TokenType.minus,
          TokenType.openParen,
          TokenType.stringLiteral,
          TokenType.identifier,
        ]),
      ),
    };
  }

  /// Parses an expression that evaluates to an integer.
  ///
  /// Returns an [Expression] of type [int] representing the parsed expression.
  IntegerConstantExpression parseIntegerFactor() {
    final token = consumeToken();
    return switch (token) {
      IntegerLiteralToken(value: var v) => IntegerConstantExpression(v),
      _ => throw UnexpectedTokenError(
        position,
        token.kind(),
        TokenTypeOptionOne(TokenType.integerLiteral),
      ),
    };
  }

  /// Parses an expression that evaluates to a floating point number.
  ///
  /// Returns an [Expression] of type [double] representing the parsed expression.
  FloatingPointConstantExpression parseFloatingPointFactor() {
    final token = consumeToken();
    return switch (token) {
      FloatingPointLiteralToken(value: var v) =>
        FloatingPointConstantExpression(v),
      _ => throw UnexpectedTokenError(
        position,
        token.kind(),
        TokenTypeOptionOne(TokenType.floatingPointLiteral),
      ),
    };
  }

  /// Parses a constant expression that evaluates to a string.
  ///
  /// Returns an [Expression] of type [String] representing the parsed expression.
  StringConstantExpression parseStringFactor() {
    final token = consumeToken();
    return switch (token) {
      StringLiteralToken(value: var v) => StringConstantExpression(v),
      _ => throw UnexpectedTokenError(
        position,
        token.kind(),
        TokenTypeOptionOne(TokenType.stringLiteral),
      ),
    };
  }

  /// Parses an identifier constant expression.
  ///
  /// Expects an identifier token and returns an [IdentifierToken] representing the parsed token.
  IdentifierConstantExpression parseIdentifierFactor() {
    final expectedIdentifierToken = expectToken(TokenType.identifier);
    return switch (expectedIdentifierToken) {
      IdentifierToken(value: var v) => IdentifierConstantExpression(v),
      _ => throw UnexpectedTokenError(
        position,
        expectedIdentifierToken.kind(),
        TokenTypeOptionOne(TokenType.identifier),
      ),
    };
  }

  /// Parses a parenthesized expression.
  ///
  /// Expects an open parenthesis token, an expression, and a close parenthesis token.
  /// Returns a [ParenthesizedExpression] representing the parsed expression.
  Expression parseParenthesizedExpression() {
    expectToken(TokenType.openParen);
    final expression = parseExpression(0);
    expectToken(TokenType.closeParen);
    return expression;
  }

  /// Parses a unary expression.
  ///
  /// Expects a unary operator and an expression.
  /// Returns a [UnaryExpression] representing the parsed expression.
  UnaryExpression parseUnaryFactor() {
    final unaryOperator = parseUnaryOperator();
    final expression = parseFactor();
    return UnaryExpression(expression, unaryOperator);
  }

  /// Parses a unary operator.
  ///
  /// Expects a unary operator token and returns a [UnaryOperator] representing the parsed token.
  UnaryOperator parseUnaryOperator() {
    final unaryOperatorToken = consumeToken();
    return switch (unaryOperatorToken) {
      MinusToken() => UnaryOperator.negate,
      _ => throw UnexpectedTokenError(
        position,
        unaryOperatorToken.kind(),
        TokenTypeOptionMany([TokenType.minus]),
      ),
    };
  }

  /// Parses a binary operator.
  ///
  /// Expects a binary operator token and returns a [BinaryOperator] representing the parsed token.
  BinaryOperator parseBinaryOperator() {
    final comparisonOperatorToken = consumeToken();
    return switch (comparisonOperatorToken) {
      EqualsToken() => ComparisonOperator.eq,
      NotEqualToken() => ComparisonOperator.neq,
      LessThanToken() => ComparisonOperator.lt,
      LessThanOrEqualToken() => ComparisonOperator.lte,
      GreaterThanToken() => ComparisonOperator.gt,
      GreaterThanOrEqualToken() => ComparisonOperator.gte,
      CaretToken() => ArithmeticOperator.exp,
      PlusToken() => ArithmeticOperator.add,
      MinusToken() => ArithmeticOperator.sub,
      TimesToken() => ArithmeticOperator.mul,
      DivideToken() => ArithmeticOperator.div,
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
          TokenType.caret,
          TokenType.plus,
          TokenType.minus,
          TokenType.times,
          TokenType.divide,
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
