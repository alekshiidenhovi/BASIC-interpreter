/// Represents the different categories of tokens that can be recognized during lexing.
enum Category {
  comma,
  endOfLine,
  equals,
  lessThan,
  lessThanOrEqual,
  greaterThan,
  greaterThanOrEqual,
  notEqual,
  identifier,
  let,
  numberLiteral,
  print,
  stringLiteral,
  goto,
  ifToken,
  then;

  /// Whether this token can be used as a comparison operator.
  bool isComparisonOperator() =>
      equals == this ||
      lessThan == this ||
      lessThanOrEqual == this ||
      greaterThan == this ||
      greaterThanOrEqual == this ||
      notEqual == this;
}

/// Represents a single token identified during the lexing process.
///
/// A token has a [category] indicating its type and a [value] which is the
/// actual string that the token represents.
class Token {
  /// The category of this token.
  final Category category;

  /// The string value of this token.
  final String value;

  /// Creates a new [Token] with the given [category] and [value].
  Token(this.category, this.value);

  @override
  String toString() {
    return "$category($value)";
  }

  @override
  bool operator ==(Object other) {
    return other is Token && other.category == category && other.value == value;
  }

  @override
  int get hashCode => Object.hash(category, value);
}
