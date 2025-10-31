enum Category {
  comma,
  endOfLine,
  equals,
  identifier,
  let,
  numberLiteral,
  print,
  stringLiteral,
}

class Token {
  final Category category;
  final String value;

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
