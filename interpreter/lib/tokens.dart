/// Represents the type of a token.
enum TokenType {
  integerLiteral,
  floatingPointLiteral,
  stringLiteral,
  identifier,
  endOfLine,
  comma,
  semicolon,
  openParen,
  closeParen,
  equals,
  lessThan,
  lessThanOrEqual,
  greaterThan,
  greaterThanOrEqual,
  plus,
  minus,
  doubleMinus,
  times,
  divide,
  caret,
  notEqual,
  letKeyword,
  printKeyword,
  forKeyword,
  toKeyword,
  ifKeyword,
  thenKeyword,
  stepKeyword,
  nextKeyword,
  endKeyword,
  remKeyword,
}

/// Represents a token recognized during the lexing process.
sealed class Token {
  const Token();

  String get name => switch (this) {
    IntegerLiteralToken(value: var v) => "IntegerLiteralToken $v",
    FloatingPointLiteralToken(value: var v) => "FloatingPointLiteralToken $v",
    StringLiteralToken(value: var s) => "StringLiteralToken $s",
    IdentifierToken() => "IdentifierToken",
    EndOfLineToken() => "EndOfLineToken",
    CommaToken() => "CommaToken",
    SemicolonToken() => "SemicolonToken",
    OpenParenToken() => "OpenParenToken",
    CloseParenToken() => "CloseParenToken",
    EqualsToken() => "EqualsToken",
    LessThanToken() => "LessThanToken",
    LessThanOrEqualToken() => "LessThanOrEqualToken",
    GreaterThanToken() => "GreaterThanToken",
    GreaterThanOrEqualToken() => "GreaterThanOrEqualToken",
    PlusToken() => "PlusToken",
    MinusToken() => "MinusToken",
    DoubleMinusToken() => "DoubleMinusToken",
    TimesToken() => "TimesToken",
    DivideToken() => "DivideToken",
    CaretToken() => "CaretToken",
    NotEqualToken() => "NotEqualToken",
    LetKeywordToken() => "LetKeywordToken",
    PrintKeywordToken() => "PrintKeywordToken",
    ForKeywordToken() => "ForKeywordToken",
    ToKeywordToken() => "ToKeywordToken",
    IfKeywordToken() => "IfKeywordToken",
    ThenKeywordToken() => "ThenKeywordToken",
    StepKeywordToken() => "StepKeywordToken",
    NextKeywordToken() => "NextKeywordToken",
    EndKeywordToken() => "EndKeywordToken",
    RemKeywordToken() => "RemKeywordToken",
  };

  /// Returns the type of the token.
  TokenType kind() => switch (this) {
    IntegerLiteralToken() => TokenType.integerLiteral,
    FloatingPointLiteralToken() => TokenType.floatingPointLiteral,
    StringLiteralToken() => TokenType.stringLiteral,
    IdentifierToken() => TokenType.identifier,
    EndOfLineToken() => TokenType.endOfLine,
    CommaToken() => TokenType.comma,
    SemicolonToken() => TokenType.semicolon,
    OpenParenToken() => TokenType.openParen,
    CloseParenToken() => TokenType.closeParen,
    EqualsToken() => TokenType.equals,
    LessThanToken() => TokenType.lessThan,
    LessThanOrEqualToken() => TokenType.lessThanOrEqual,
    GreaterThanToken() => TokenType.greaterThan,
    GreaterThanOrEqualToken() => TokenType.greaterThanOrEqual,
    PlusToken() => TokenType.plus,
    MinusToken() => TokenType.minus,
    DoubleMinusToken() => TokenType.doubleMinus,
    TimesToken() => TokenType.times,
    DivideToken() => TokenType.divide,
    CaretToken() => TokenType.caret,
    NotEqualToken() => TokenType.notEqual,
    LetKeywordToken() => TokenType.letKeyword,
    PrintKeywordToken() => TokenType.printKeyword,
    ForKeywordToken() => TokenType.forKeyword,
    ToKeywordToken() => TokenType.toKeyword,
    IfKeywordToken() => TokenType.ifKeyword,
    ThenKeywordToken() => TokenType.thenKeyword,
    StepKeywordToken() => TokenType.stepKeyword,
    NextKeywordToken() => TokenType.nextKeyword,
    EndKeywordToken() => TokenType.endKeyword,
    RemKeywordToken() => TokenType.remKeyword,
  };

  @override
  String toString() => name;

  /// Returns the precedence of the binary operator represented by this token.
  ///
  /// Returns null if this token does not represent a binary operator.
  int? getBinaryOperatorPrecedence() {
    return switch (this) {
      CaretToken() => 55,
      TimesToken() || DivideToken() => 50,
      PlusToken() || MinusToken() => 45,
      LessThanToken() ||
      LessThanOrEqualToken() ||
      GreaterThanToken() ||
      GreaterThanOrEqualToken() => 35,
      EqualsToken() || NotEqualToken() => 30,
      _ => null,
    };
  }

  @override
  bool operator ==(Object other) => other is Token && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

/// Represents an integer literal token, holds a [int] value.
///
/// The integer value held by this token can be either positive or negative.
class IntegerLiteralToken extends Token {
  final int value;

  IntegerLiteralToken(this.value);
}

/// Represents a double-precision floating point literal token, holds a [double] value.
///
/// The floating point value held by this token can be either positive or negative.
class FloatingPointLiteralToken extends Token {
  final double value;

  FloatingPointLiteralToken(this.value);
}

/// Represents a string literal token, holds a [String] value.
class StringLiteralToken extends Token {
  final String value;

  StringLiteralToken(this.value);
}

/// Represents an identifier token, holds a [String] value.
class IdentifierToken extends Token {
  final String value;

  IdentifierToken(this.value);
}

/// Represents an end of line token.
final class EndOfLineToken extends Token {}

/// Represents a comma token.
final class CommaToken extends Token {}

/// Represents a semicolon token.
final class SemicolonToken extends Token {}

/// Represents an open parenthesis token.
final class OpenParenToken extends Token {}

/// Represents a close parenthesis token.
final class CloseParenToken extends Token {}

/// Represents an equals token.
final class EqualsToken extends Token {}

/// Represents a less than token.
final class LessThanToken extends Token {}

/// Represents a less than or equal token.
final class LessThanOrEqualToken extends Token {}

/// Represents a greater than token.
final class GreaterThanToken extends Token {}

/// Represents a greater than or equal token.
final class GreaterThanOrEqualToken extends Token {}

/// Represents a plus token.
final class PlusToken extends Token {}

/// Represents a minus token.j
final class MinusToken extends Token {}

/// Represents a double minus token.
final class DoubleMinusToken extends Token {}

/// Represents a times token.
final class TimesToken extends Token {}

/// Represents a divide token.
final class DivideToken extends Token {}

/// Represents a caret token.
final class CaretToken extends Token {}

/// Represents a not equal token.
final class NotEqualToken extends Token {}

/// Represents a let keyword token.
final class LetKeywordToken extends Token {}

/// Represents a print keyword token.
final class PrintKeywordToken extends Token {}

/// Represents a for keyword token.
final class ForKeywordToken extends Token {}

/// Represents a to keyword token.
final class ToKeywordToken extends Token {}

/// Represents a step keyword token.
final class StepKeywordToken extends Token {}

/// Represents a next keyword token.
final class NextKeywordToken extends Token {}

/// Represents a if keyword token.
final class IfKeywordToken extends Token {}

/// Represents a then keyword token.
final class ThenKeywordToken extends Token {}

/// Represents an end keyword token.
final class EndKeywordToken extends Token {}

/// Represents a remark keyword token.
final class RemKeywordToken extends Token {}
