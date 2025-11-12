import "tokens.dart";

/// Represents a generic error that can occur during parsing.
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
        "expected $expectedTokenCategory, got $actualTokenCategory!"
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
