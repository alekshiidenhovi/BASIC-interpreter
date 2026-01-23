/// Represents the type of a token.
enum TokenType {
  numberLiteral,
  stringLiteral,
  identifier,
  endOfLine,
  comma,
  semicolon,
  equals,
  lessThan,
  lessThanOrEqual,
  greaterThan,
  greaterThanOrEqual,
  plus,
  minus,
  times,
  divide,
  notEqual,
  letKeyword,
  printKeyword,
  forKeyword,
  toKeyword,
  gotoKeyword,
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
    NumberLiteralToken(value: var v) => "NumberLiteralToken $v",
    StringLiteralToken(value: var s) => "StringLiteralToken $s",
    IdentifierToken() => "IdentifierToken",
    EndOfLineToken() => "EndOfLineToken",
    CommaToken() => "CommaToken",
    SemicolonToken() => "SemicolonToken",
    EqualsToken() => "EqualsToken",
    LessThanToken() => "LessThanToken",
    LessThanOrEqualToken() => "LessThanOrEqualToken",
    GreaterThanToken() => "GreaterThanToken",
    GreaterThanOrEqualToken() => "GreaterThanOrEqualToken",
    PlusToken() => "PlusToken",
    MinusToken() => "MinusToken",
    TimesToken() => "TimesToken",
    DivideToken() => "DivideToken",
    NotEqualToken() => "NotEqualToken",
    LetKeywordToken() => "LetKeywordToken",
    PrintKeywordToken() => "PrintKeywordToken",
    ForKeywordToken() => "ForKeywordToken",
    ToKeywordToken() => "ToKeywordToken",
    GotoKeywordToken() => "GotoKeywordToken",
    IfKeywordToken() => "IfKeywordToken",
    ThenKeywordToken() => "ThenKeywordToken",
    StepKeywordToken() => "StepKeywordToken",
    NextKeywordToken() => "NextKeywordToken",
    EndKeywordToken() => "EndKeywordToken",
    RemKeywordToken() => "RemKeywordToken",
  };

  /// Returns the type of the token.
  TokenType kind() => switch (this) {
    NumberLiteralToken() => TokenType.numberLiteral,
    StringLiteralToken() => TokenType.stringLiteral,
    IdentifierToken() => TokenType.identifier,
    EndOfLineToken() => TokenType.endOfLine,
    CommaToken() => TokenType.comma,
    SemicolonToken() => TokenType.semicolon,
    EqualsToken() => TokenType.equals,
    LessThanToken() => TokenType.lessThan,
    LessThanOrEqualToken() => TokenType.lessThanOrEqual,
    GreaterThanToken() => TokenType.greaterThan,
    GreaterThanOrEqualToken() => TokenType.greaterThanOrEqual,
    PlusToken() => TokenType.plus,
    MinusToken() => TokenType.minus,
    TimesToken() => TokenType.times,
    DivideToken() => TokenType.divide,
    NotEqualToken() => TokenType.notEqual,
    LetKeywordToken() => TokenType.letKeyword,
    PrintKeywordToken() => TokenType.printKeyword,
    ForKeywordToken() => TokenType.forKeyword,
    ToKeywordToken() => TokenType.toKeyword,
    GotoKeywordToken() => TokenType.gotoKeyword,
    IfKeywordToken() => TokenType.ifKeyword,
    ThenKeywordToken() => TokenType.thenKeyword,
    StepKeywordToken() => TokenType.stepKeyword,
    NextKeywordToken() => TokenType.nextKeyword,
    EndKeywordToken() => TokenType.endKeyword,
    RemKeywordToken() => TokenType.remKeyword,
  };

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) => other is Token && name == other.name;

  @override
  int get hashCode => name.hashCode;
}

/// Represents a number literal token, holds a [num] value.
///
/// The value hold by this token can be either an integer or a floating point, and either positive or negative.
class NumberLiteralToken extends Token {
  final num value;

  NumberLiteralToken(this.value);
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

/// Represents a times token.
final class TimesToken extends Token {}

/// Represents a divide token.
final class DivideToken extends Token {}

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

/// Represents a goto keyword token.
final class GotoKeywordToken extends Token {}

/// Represents a if keyword token.
final class IfKeywordToken extends Token {}

/// Represents a then keyword token.
final class ThenKeywordToken extends Token {}

/// Represents an end keyword token.
final class EndKeywordToken extends Token {}

/// Represents a remark keyword token.
final class RemKeywordToken extends Token {}
