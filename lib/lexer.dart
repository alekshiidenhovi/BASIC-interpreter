import "tokens.dart";

class Lexer {
  final String source;
  int position = 0;

  Lexer(this.source);

  List<Token> tokenize() {
    final RegExp numberPattern = RegExp(r'\d');
    final RegExp numberLiteralPattern = RegExp(r'(\d+(\.\d+)?)');
    final RegExp stringLiteralPattern = RegExp(r'"(.*?)"');
    final RegExp keywordOrIdentifierPattern = RegExp(r'[A-Z]+');

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
      } else if (keywordOrIdentifierPattern.hasMatch(char)) {
        final match = keywordOrIdentifierPattern.matchAsPrefix(
          source,
          position,
        );
        if (match != null) {
          final keyword = match.group(0)!;
          final token = switch (keyword) {
            "LET" => Token(Category.let, keyword),
            "PRINT" => Token(Category.print, keyword),
            "GOTO" => Token(Category.goto, keyword),
            _ => Token(Category.identifier, keyword),
          };

          tokens.add(token);
          position = match.end;
          continue;
        }
      } else if (char == '=') {
        tokens.add(Token(Category.equals, char));
        position++;
        continue;
      } else if (char == ',') {
        tokens.add(Token(Category.comma, char));
        position++;
        continue;
      } else if (char == '\n') {
        tokens.add(Token(Category.endOfLine, char));
        position++;
        continue;
      }

      position++;
    }

    return tokens;
  }
}
