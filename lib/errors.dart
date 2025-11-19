import "tokens.dart";
import "expressions.dart";

/// Generic error that occurs during parsing.
///
/// This class serves as a base for all specific parser errors, providing common
/// properties like the token number, a descriptive message, and an error name.
sealed class ParserError extends Error {
  /// The number of the token where the error occurred.
  final int tokenNumber;

  /// A message describing the error.
  final String message;

  /// The name of the error.
  final String errorName;

  /// Creates a new [ParserError].
  ParserError(
    this.tokenNumber,
    this.message, [
    this.errorName = "Parser error",
  ]);

  @override
  String toString() {
    return "$errorName at token number $tokenNumber: $message";
  }
}

/// Represents an error when an unexpected token is encountered during parsing.
///
/// This error is raised when the parser finds a token that it did not expect,
/// given the current parsing state.
class UnexpectedTokenError extends ParserError {
  /// The category of the token that was actually found.
  final Category actualTokenCategory;

  /// The category of the token that was expected.
  final Category expectedTokenCategory;

  /// Creates a new [UnexpectedTokenError].
  UnexpectedTokenError(
    int tokenNumber,
    this.actualTokenCategory,
    this.expectedTokenCategory,
  ) : super(
        tokenNumber,
        "expected $expectedTokenCategory, got $actualTokenCategory!",
        "Unexpected token error",
      );
}

/// Represents an error when a required token is missing during parsing.
///
/// This error is raised when the parser expects a specific token but does not
/// find any token at the current position.
class MissingTokenError extends ParserError {
  /// The category of the token that was expected but not found.
  final Category expectedTokenCategory;

  /// Creates a new [MissingTokenError].
  MissingTokenError(int tokenNumber, this.expectedTokenCategory)
    : super(
        tokenNumber,
        "expected $expectedTokenCategory, no token was found!",
        "Missing token error",
      );
}

/// Represents an error when an invalid token is encountered during parsing.
///
/// This error is raised when the parser finds a token that is not valid in the
/// current context, even if it's not strictly an unexpected category.
class InvalidTokenError extends ParserError {
  /// The category of the token that was found to be invalid.
  final Category actualTokenCategory;

  /// Creates a new [InvalidTokenError].
  InvalidTokenError(int tokenNumber, this.actualTokenCategory)
    : super(tokenNumber, "got $actualTokenCategory!", "Invalid token error");
}

/// Generic error that occurs during lexing.
///
/// This class serves as a base for all specific lexer errors, providing common
/// properties like the character number, a descriptive message, and an error name.
sealed class LexerError extends Error {
  /// The number of the character where the error occurred.
  final int characterNumber;

  /// A message describing the error.
  final String message;

  /// The name of the error.
  final String errorName;

  /// Creates a new [LexerError].
  LexerError(
    this.characterNumber,
    this.message, [
    this.errorName = "Lexer error",
  ]);

  @override
  String toString() {
    return "$errorName at character number $characterNumber: $message";
  }
}

/// Represents an error when an invalid character is encountered during lexing.
class InvalidCharacterError extends LexerError {
  /// The character that was found to be invalid.
  final String actualCharacter;

  /// Creates a new [InvalidCharacterError].
  InvalidCharacterError(int characterNumber, this.actualCharacter)
    : super(
        characterNumber,
        "invalid character '$actualCharacter'",
        "Invalid character error",
      );
}

/// Generic error that occurs during interpretation.
///
/// This class serves as a base for all specific interpreter errors, providing
/// common properties like a descriptive message and an error name.
sealed class InterpreterError extends Error {
  /// A message describing the error.
  final String message;

  /// The name of the error.
  final String errorName;

  /// Creates a new [InterpreterError].
  InterpreterError(this.message, [this.errorName = "Interpreter error"]);

  @override
  String toString() {
    return "$errorName: $message";
  }
}

/// Represents an error during expression evaluation.
///
/// This error is raised when an expression cannot be evaluated due to various
/// reasons, such as missing identifiers or division by zero.
class ExpressionEvaluationError extends InterpreterError {
  /// The expression that could not be evaluated.
  final Expression expression;

  /// Creates a new [ExpressionEvaluationError].
  ExpressionEvaluationError(this.expression, String message, String errorName)
    : super(message, errorName);

  @override
  String toString() {
    return "Expression evaluation error: $expression - $message";
  }
}

/// Represents an error that occurs during the runtime execution of a program.
class RuntimeError extends InterpreterError {
  /// Creates a new [RuntimeError].
  RuntimeError(super.message, [super.errorName = "Runtime error"]);
}

/// Represents an error when a required identifier is missing during expression evaluation.
///
/// This error is raised when an expression references an identifier that has not
/// been defined in the current scope.
class MissingIdentifierError extends ExpressionEvaluationError {
  /// The identifier that was expected but not found.
  final String identifier;

  /// Creates a new [MissingIdentifierError].
  MissingIdentifierError(Expression expression, this.identifier)
    : super(
        expression,
        "missing identifier '$identifier'",
        "Missing identifier error",
      );
}

/// Represents an error when division by zero occurs during expression evaluation.
///
/// This error is raised when an attempt is made to divide a number by zero.
class DivisionByZeroError extends ExpressionEvaluationError {
  /// Creates a new [DivisionByZeroError].
  DivisionByZeroError(Expression expression)
    : super(expression, "division by zero", "Division by zero");
}
