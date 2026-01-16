import "tokens.dart";
import "errors.dart";
import "regex.dart";

/// A lexer that tokenizes a given source string into a list of tokens.
class Lexer {
  /// The source string to tokenize.
  final String source;

  /// The current position in the source string during tokenization.
  int _position = 0;

  /// Creates a new [Lexer] instance with the given source string.
  Lexer(this.source);

  /// Tokenizes the source string into a list of [Token] objects.
  ///
  /// Returns a [List<Token>] representing the tokenized source code.
  List<Token> tokenize() {
    List<Token> tokens = [];

    while (_position < source.length) {
      String char = source[_position];

      if (numberPattern.hasMatch(char) ||
          _isNegativeDigitPrefix(source, _position)) {
        final match = numberLiteralPattern.matchAsPrefix(source, _position);
        if (match == null) {
          throw MissingRegexMatchError(_position);
        }
        final group = match.group(1);
        if (group == null) {
          throw MissingRegexGroupError(_position);
        }
        tokens.add(NumberLiteralToken(num.parse(group)));
        _setPosition(match.end);
        continue;
      } else if (char == '"') {
        final match = stringLiteralPattern.matchAsPrefix(source, _position);
        if (match == null) {
          throw MissingRegexMatchError(_position);
        }
        final group = match.group(1);
        if (group == null) {
          throw MissingRegexGroupError(_position);
        }
        tokens.add(StringLiteralToken(group));
        _setPosition(match.end);
        continue;
      } else if (keywordOrIdentifierPattern.hasMatch(char)) {
        final match = keywordOrIdentifierPattern.matchAsPrefix(
          source,
          _position,
        );
        if (match == null) {
          throw MissingRegexMatchError(_position);
        }
        final group = match.group(0);
        if (group == null) {
          throw MissingRegexGroupError(_position);
        }
        final keyword = group.toUpperCase();
        final token = switch (keyword) {
          "LET" => LetKeywordToken(),
          "PRINT" => PrintKeywordToken(),
          "GOTO" => GotoKeywordToken(),
          "IF" => IfKeywordToken(),
          "THEN" => ThenKeywordToken(),
          "END" => EndKeywordToken(),
          "FOR" => ForKeywordToken(),
          "TO" => ToKeywordToken(),
          "STEP" => StepKeywordToken(),
          "NEXT" => NextKeywordToken(),
          _ => IdentifierToken(group),
        };

        tokens.add(token);
        _setPosition(match.end);
        continue;
      } else if (comparisonStartingOperatorPattern.hasMatch(char)) {
        final match = comparisonOperatorPattern.matchAsPrefix(
          source,
          _position,
        );
        if (match == null) {
          throw MissingRegexMatchError(_position);
        }
        final operator = match.group(0);
        if (operator == null) {
          throw MissingRegexGroupError(_position);
        }
        final token = switch (operator) {
          "=" => EqualsToken(),
          "<>" => NotEqualToken(),
          "<=" => LessThanOrEqualToken(),
          ">=" => GreaterThanOrEqualToken(),
          "<" => LessThanToken(),
          ">" => GreaterThanToken(),
          _ => throw InvalidCharacterError(_position, char),
        };
        tokens.add(token);
        _setPosition(match.end);
        continue;
      } else if (arithmeticOperatorPattern.hasMatch(char)) {
        final match = arithmeticOperatorPattern.matchAsPrefix(
          source,
          _position,
        );
        if (match == null) {
          throw MissingRegexMatchError(_position);
        }
        final operator = match.group(0);
        if (operator == null) {
          throw MissingRegexGroupError(_position);
        }
        final token = switch (operator) {
          "+" => PlusToken(),
          "-" => MinusToken(),
          "*" => TimesToken(),
          "/" => DivideToken(),
          _ => throw InvalidCharacterError(_position, char),
        };
        tokens.add(token);
        _setPosition(match.end);
        continue;
      } else if (char == ',') {
        tokens.add(CommaToken());
        _advance();
        continue;
      } else if (char == ';') {
        tokens.add(SemicolonToken());
        _advance();
        continue;
      } else if (char == '\n') {
        tokens.add(EndOfLineToken());
        _advance();
        continue;
      }

      _advance();
    }

    return tokens;
  }

  /// Advances the  current character position by one.
  void _advance() {
    _position++;
  }

  /// Set the current character position to the given position.
  void _setPosition(int position) {
    _position = position;
  }

  bool _isNegativeDigitPrefix(String source, int position) {
    final nextPosition = position + 1;
    if (nextPosition >= source.length) {
      return false;
    }
    final char = source[position];
    final nextChar = source[nextPosition];
    return char == '-' && numberPattern.hasMatch(nextChar);
  }

  /// Returns the current character position.
  int get position => _position;
}
