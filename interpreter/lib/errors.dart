import "tokens.dart";
import "expressions.dart";

sealed class BASICInterpreterError extends Error {
  final String interpreterStepErrorName;

  final String detailedErrorName;

  final String message;

  BASICInterpreterError(
    this.interpreterStepErrorName,
    this.detailedErrorName,
    this.message,
  );
}

/// Generic error that occurs during parsing.
///
/// This class serves as a base for all specific parser errors, providing common
/// properties like the token number, a descriptive message, and an error name.
sealed class ParserError extends BASICInterpreterError {
  /// The number of the token where the error occurred.
  final int tokenNumber;

  /// Creates a new [ParserError].
  ParserError(String detailedErrorName, String message, this.tokenNumber)
    : super("Parser error", detailedErrorName, message);

  @override
  String toString() {
    return "$detailedErrorName at token number $tokenNumber: $message";
  }
}

/// Represents a token type option for the [UnexpectedTokenError] error.
sealed class TokenTypeOption {
  const TokenTypeOption();
}

/// Represents a single token type option for the [UnexpectedTokenError] error.
class TokenTypeOptionOne extends TokenTypeOption {
  final TokenType tokenType;

  const TokenTypeOptionOne(this.tokenType);
}

/// Represents multiple token type options for the [UnexpectedTokenError] error.
class TokenTypeOptionMany extends TokenTypeOption {
  final List<TokenType> tokenTypes;

  const TokenTypeOptionMany(this.tokenTypes);
}

/// Represents an error when an unexpected token is encountered during parsing.
///
/// This error is raised when the parser finds a token that it did not expect,
/// given the current parsing state.
class UnexpectedTokenError extends ParserError {
  /// The token that was actually found.
  final TokenType actualToken;

  /// The token that was expected.
  final TokenTypeOption expectedToken;

  /// Creates a new [UnexpectedTokenError].
  UnexpectedTokenError(int tokenNumber, this.actualToken, this.expectedToken)
    : super("Unexpected token error", switch (expectedToken) {
        TokenTypeOptionOne(tokenType: var t) =>
          "expected $t, got $actualToken!",
        TokenTypeOptionMany(tokenTypes: var ts) =>
          "expected one of ${ts.join(", ")}, got $actualToken!",
      }, tokenNumber);
}

/// Represents an error when an invalid token is encountered during parsing.
///
/// This error is raised when the parser finds a token that is not valid in the
/// current context, even if it's not strictly an unexpected category.
class InvalidTokenError extends ParserError {
  /// The token that was found to be invalid.
  final TokenType actualToken;

  /// Creates a new [InvalidTokenError].
  InvalidTokenError(int tokenNumber, this.actualToken)
    : super("Invalid token error", "got $actualToken!", tokenNumber);
}

/// Represents an error when the end of the input is encountered during parsing.
///
/// This error is raised when the parser encounters the end of the input before
/// it has encountered the expected end of statement token.
class UnexpectedEndOfInputError extends ParserError {
  /// Creates a new [UnexpectedEndOfInputError].
  UnexpectedEndOfInputError(int tokenNumber)
    : super(
        "Unexpected end of input error",
        "more tokens expected",
        tokenNumber,
      );
}

/// Generic error that occurs during lexing.
///
/// This class serves as a base for all specific lexer errors, providing common
/// properties like the character number, a descriptive message, and an error name.
sealed class LexerError extends BASICInterpreterError {
  /// The number of the character where the error occurred.
  final int characterNumber;

  /// Creates a new [LexerError].
  LexerError(String detailedErrorName, String message, this.characterNumber)
    : super("Lexer error", detailedErrorName, message);

  @override
  String toString() {
    return "$detailedErrorName at character number $characterNumber: $message";
  }
}

/// Represents an error when a regex match is missing during lexing.
class MissingRegexMatchError extends LexerError {
  /// The source string that could not be matched.
  final String source;

  /// The regex pattern that was expected but not found.
  final RegExp pattern;

  /// Creates a new [MissingRegexMatchError].
  MissingRegexMatchError(int characterNumber, this.source, this.pattern)
    : super(
        "Missing regex match error",
        "missing regex match, expected pattern '$pattern' to match '$source'",
        characterNumber,
      );
}

/// Represents an error when a regex group is missing during lexing.
class MissingRegexGroupError extends LexerError {
  /// The source string that could not be matched.
  final String source;

  /// The regex pattern that was expected but not found.
  final RegExp pattern;

  /// Creates a new [MissingRegexGroupError].
  MissingRegexGroupError(int characterNumber, this.source, this.pattern)
    : super(
        "Missing regex group error",
        "missing regex group",
        characterNumber,
      );
}

/// Represents an error when a string is not matched during lexing against any of the parsers.
class UnmatchedStringError extends LexerError {
  /// The source string that could not be matched.
  final String source;

  /// Creates a new [NonmatchingParserError].
  UnmatchedStringError(int characterNumber, this.source)
    : super(
        "Nonmatching parser error",
        "unmatched string '$source'",
        characterNumber,
      );
}

/// Generic error that occurs during interpretation.
///
/// This class serves as a base for all specific interpreter errors, providing
/// common properties like a descriptive message and an error name.
sealed class InterpretationError extends BASICInterpreterError {
  /// The line number where the error occurred.
  final int lineNumber;

  /// Creates a new [InterpretationError].
  InterpretationError(String detailedErrorName, String message, this.lineNumber)
    : super("Interpretation error", detailedErrorName, message);

  @override
  String toString() {
    return "$detailedErrorName at line number $lineNumber: $message";
  }
}

/// Represents an error that occurs during the runtime execution of a program.
class RuntimeError extends InterpretationError {
  /// Creates a new [RuntimeError].
  RuntimeError(int lineNumber, String message): super("Runtime error", message, lineNumber);
}

/// Represents an error when a required identifier is missing during expression evaluation.
///
/// This error is raised when an expression references an identifier that has not
/// been defined in the current scope.
class MissingIdentifierError extends InterpretationError {
  /// The expression that could not be evaluated.
  final Expression expression;
  /// The identifier that was expected but not found.
  final String identifier;

  /// Creates a new [MissingIdentifierError].
  MissingIdentifierError(int lineNumber, this.expression, this.identifier)
    : super(
        "Missing identifier error",
        "missing identifier '$identifier' for expression $expression",
        lineNumber,
      );
}

/// Represents an error when division by zero occurs during expression evaluation.
///
/// This error is raised when an attempt is made to divide a number by zero.
class DivisionByZeroError extends InterpretationError {
  /// The expression that could not be evaluated.
  final Expression<num> expression;

  /// Creates a new [DivisionByZeroError].
  DivisionByZeroError(int lineNumber, this.expression)
    : super("Division by zero", "division by zero occurred for expression $expression", lineNumber);
}
