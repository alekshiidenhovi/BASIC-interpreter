import "tokens.dart";
import "types.dart";
import "untyped_expressions.dart";

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

class NonMatchingIdentifierError extends ParserError {
  final String expectedIdentifier;

  final String actualIdentifier;

  /// Creates a new [NonMatchingIdentifierError].
  NonMatchingIdentifierError(
    int tokenNumber,
    this.expectedIdentifier,
    this.actualIdentifier,
  ) : super(
        "Non-matching identifier error",
        "expected identifier $expectedIdentifier, got $actualIdentifier",
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

/// Generic error that occurs during type checking.
///
/// This class serves as a base for all specific type checking errors, providing
/// common properties like a descriptive message and an error name.
sealed class TypeCheckerError extends BASICInterpreterError {
  final int lineNumber;

  /// Creates a new [TypeCheckerError].
  TypeCheckerError(String detailedErrorName, String message, this.lineNumber)
    : super("Type checking error", detailedErrorName, message);

  @override
  String toString() {
    return "$detailedErrorName at line number $lineNumber: $message";
  }
}

sealed class BasicTypeOption {
  const BasicTypeOption();
}

class BasicTypeOptionOne extends BasicTypeOption {
  final BasicType type;

  const BasicTypeOptionOne(this.type);
}

class BasicTypeOptionMany extends BasicTypeOption {
  final List<BasicType> types;

  const BasicTypeOptionMany(this.types);
}

class NonMatchingTypeError extends TypeCheckerError {
  /// The expected type.
  final BasicTypeOption expectedType;

  /// The actual type.
  final BasicType actualType;

  /// Creates a new [NonMatchingTypeError].
  NonMatchingTypeError(int lineNumber, this.expectedType, this.actualType)
    : super("Non-matching type error", switch (expectedType) {
        BasicTypeOptionOne(type: var t) => "expected type $t, got $actualType",
        BasicTypeOptionMany(types: var ts) =>
          "expected one of ${ts.join(", ")}, got $actualType",
      }, lineNumber);
}

class MissingIdentifierError extends TypeCheckerError {
  final String identifier;

  MissingIdentifierError(int lineNumber, this.identifier)
    : super(
        "Missing identifier error",
        "missing identifier '$identifier'",
        lineNumber,
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
  RuntimeError(int lineNumber, String message)
    : super("Runtime error", message, lineNumber);
}

class RuntimeTypeError extends InterpretationError {
  /// The identifier that was expected but not found.
  final String identifier;

  /// The expected type.
  final Type expectedType;

  /// The actual type.
  final Type actualType;

  /// Creates a new [RuntimeTypeError].
  RuntimeTypeError(
    int lineNumber,
    this.identifier,
    this.expectedType,
    this.actualType,
  ) : super(
        "Runtime type error",
        "expected type $expectedType for identifier $identifier, got $actualType",
        lineNumber,
      );
}

/// Represents an error when division by zero occurs during expression evaluation.
///
/// This error is raised when an attempt is made to divide a number by zero.
class DivisionByZeroError extends InterpretationError {
  /// The expression that could not be evaluated.
  final Expression expression;

  /// Creates a new [DivisionByZeroError].
  DivisionByZeroError(int lineNumber, this.expression)
    : super(
        "Division by zero",
        "division by zero occurred for expression $expression",
        lineNumber,
      );
}

/// Represents an error when a negative square root is encountered during expression evaluation.
///
/// This error is raised when an attempt is made to take the square root of a negative number.
class NegativeSquareRootError extends InterpretationError {
  /// The negative number that could not be evaluated.
  final double negativeNumber;

  /// Creates a new [NegativeSquareRootError].
  NegativeSquareRootError(int lineNumber, this.negativeNumber)
    : super(
        "Negative square root",
        "square root of negative number $negativeNumber",
        lineNumber,
      );
}
