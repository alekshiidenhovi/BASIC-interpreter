import "tokens.dart";

class Lexer {
  final String source;
  int position = 0;

  Lexer(this.source);

  List<Token> tokenize() {
    final RegExp numberPattern = RegExp(r'\d');
    final RegExp numberLiteralPattern = RegExp(r'(\d+(\.\d+)?)');
    final RegExp stringLiteralPattern = RegExp(r'"(.*?)"');

    List<Token> tokens = [];

    while (position < source.length) {
      String char = source[position];

      if (numberPattern.hasMatch(char)) {
        final match = numberLiteralPattern.matchAsPrefix(source, position);
        if (match != null) {
          tokens.add(Token(Category.numberLiteral, match.group(1)!));
          position = match.end;
          continue;
        }
      } else if (char == '"') {
        final match = stringLiteralPattern.matchAsPrefix(source, position);
        if (match != null) {
          tokens.add(Token(Category.stringLiteral, match.group(1)!));
          position = match.end;
          continue;
        }
      }

      position++;
    }

    return tokens;
  }
}
