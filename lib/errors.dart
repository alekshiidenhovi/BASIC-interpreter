import "tokens.dart";

sealed class ParserError extends Error {
  final int tokenNumber;
  final String message;
  final String errorName;

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

class UnexpectedTokenError extends ParserError {
  final Category actualTokenCategory;
  final Category expectedTokenCategory;

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

class MissingTokenError extends ParserError {
  final Category expectedTokenCategory;

  MissingTokenError(int tokenNumber, this.expectedTokenCategory)
    : super(
        tokenNumber,
        "expected $expectedTokenCategory, no token was found!",
        "Missing token error",
      );
}

class InvalidTokenError extends ParserError {
  final Category actualTokenCategory;

  InvalidTokenError(int tokenNumber, this.actualTokenCategory)
    : super(tokenNumber, "got $actualTokenCategory!", "Invalid token error");
}
