import "tokens.dart";
import "errors.dart";

/// A parser that parses a given source string into a value of type [T].
typedef LexerParser<T> = T Function(String source);

/// A lexer that tokenizes a given source string into a list of tokens.
class Lexer {
  /// The source string to tokenize.
  String source;

  /// The current position in the source string during tokenization, initialized to 0.
  int _position = 0;

  /// Creates a new [Lexer] instance with the given source string.
  Lexer(this.source);

  /// Tokenizes the source string into a list of [Token] objects.
  ///
  /// Returns a [List<Token>] representing the tokenized source code.
  List<Token> tokenize() {
    List<Token> tokens = [];

    final whitespaceParser = createWhitespaceParser();

    final parsers = [
      createNumberLiteralParser(),
      createStringLiteralParser(),
      createKeywordOrIdentifierParser(),
      createRegexParser(RegExp(r'^>='), GreaterThanOrEqualToken()),
      createRegexParser(RegExp(r'^<='), LessThanOrEqualToken()),
      createRegexParser(RegExp(r'^<>'), NotEqualToken()),
      createRegexParser(RegExp(r'^='), EqualsToken()),
      createRegexParser(RegExp(r'^<'), LessThanToken()),
      createRegexParser(RegExp(r'^>'), GreaterThanToken()),
      createRegexParser(RegExp(r'^\+'), PlusToken()),
      createRegexParser(RegExp(r'^\-'), MinusToken()),
      createRegexParser(RegExp(r'^\*'), TimesToken()),
      createRegexParser(RegExp(r'^/'), DivideToken()),
      createRegexParser(RegExp(r'^,'), CommaToken()),
      createRegexParser(RegExp(r'^;'), SemicolonToken()),
      createRegexParser(RegExp(r'^\n'), EndOfLineToken()),
    ];

    while (source.isNotEmpty) {
      source = whitespaceParser(source);
      if (source.isEmpty) break;

      bool matched = false;
      for (final parser in parsers) {
        try {
          final (remainingStr, token) = parser(source);
          tokens.add(token);
          source = remainingStr;
          matched = true;
          break;
        } catch (_) {
          continue;
        }
      }
      if (!matched) {
        throw UnmatchedStringError(_position, source);
      }
    }

    return tokens;
  }

  LexerParser<String> createWhitespaceParser() {
    return (String source) {
      final pattern = RegExp(r'^ ');
      final match = pattern.matchAsPrefix(source);

      if (match == null) return source;
      _position += match.end;
      return source.substring(match.end);
    };
  }

  LexerParser<(String, Token)> createNumberLiteralParser() {
    return (String source) {
      final pattern = RegExp(r'^(-?\d+(\.\d+)?)');
      final match = pattern.matchAsPrefix(source);
      if (match == null) {
        throw MissingRegexMatchError(_position, source, pattern);
      }
      final matchedStr = match.group(0);
      if (matchedStr == null) {
        throw MissingRegexGroupError(_position, source, pattern);
      }
      _position += matchedStr.length;
      return (
        source.substring(match.end),
        NumberLiteralToken(num.parse(matchedStr)),
      );
    };
  }

  LexerParser<(String, Token)> createStringLiteralParser() {
    return (String source) {
      final pattern = RegExp(r'^"(.*?)"');
      final match = pattern.matchAsPrefix(source);
      if (match == null) {
        throw MissingRegexMatchError(_position, source, pattern);
      }
      final fullMatch = match.group(0);
      final content = match.group(1);

      if (content == null || fullMatch == null) {
        throw MissingRegexGroupError(_position, source, pattern);
      }
      _position += fullMatch.length;
      return (source.substring(fullMatch.length), StringLiteralToken(content));
    };
  }

  LexerParser<(String, Token)> createKeywordOrIdentifierParser() {
    return (String source) {
      final pattern = RegExp(r'^[A-Za-z][A-Za-z0-9]*');
      final match = pattern.matchAsPrefix(source);
      if (match == null) {
        throw MissingRegexMatchError(_position, source, pattern);
      }
      final matchedStr = match.group(0);
      if (matchedStr == null) {
        throw MissingRegexGroupError(_position, source, pattern);
      }
      final uppercaseStr = matchedStr.toUpperCase();
      final token = switch (uppercaseStr) {
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
        "REM" => RemKeywordToken(),
        _ => IdentifierToken(matchedStr),
      };
      _position += uppercaseStr.length;
      return (source.substring(uppercaseStr.length), token);
    };
  }

  LexerParser<(String, Token)> createRegexParser(RegExp pattern, Token token) {
    return (String source) {
      final match = pattern.matchAsPrefix(source);
      if (match == null) {
        throw MissingRegexMatchError(_position, source, pattern);
      }
      final matchedStr = match.group(0);
      if (matchedStr == null) {
        throw MissingRegexGroupError(_position, source, pattern);
      }
      _position += matchedStr.length;
      return (source.substring(matchedStr.length), token);
    };
  }
}
