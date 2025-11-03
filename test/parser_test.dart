import 'package:basic_interpreter/expressions.dart';
import 'package:basic_interpreter/parser.dart';
import 'package:basic_interpreter/statements.dart';
import 'package:basic_interpreter/tokens.dart';
import 'package:basic_interpreter/errors.dart';
import 'package:test/test.dart';

void main() {
  group("LET statements", () {
    test("Parse LET statement", () {
      final tokens = [
        Token(Category.numberLiteral, "10"),
        Token(Category.let, "LET"),
        Token(Category.identifier, "A"),
        Token(Category.equals, "="),
        Token(Category.numberLiteral, "5"),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[10], isA<LetStatement>());
    });

    test("Throw error if tokens are not in the correct order", () {
      final tokens = [
        Token(Category.numberLiteral, "10"),
        Token(Category.let, "LET"),
        Token(Category.equals, "="),
        Token(Category.identifier, "A"),
        Token(Category.numberLiteral, "5"),
      ];

      final parser = Parser(tokens);

      expect(parser.parse, throwsA(isA<UnexpectedTokenError>()));
    });

    test("Throw error if position is out of bounds", () {
      final tokens = [
        Token(Category.numberLiteral, "10"),
        Token(Category.let, "LET"),
        Token(Category.identifier, "A"),
        Token(Category.equals, "="),
      ];

      final parser = Parser(tokens);

      expect(parser.parse, throwsA(isA<MissingTokenError>()));
    });

    test("Two LET statements", () {
      final tokens = [
        Token(Category.numberLiteral, "10"),
        Token(Category.let, "LET"),
        Token(Category.identifier, "A"),
        Token(Category.equals, "="),
        Token(Category.numberLiteral, "5"),
        Token(Category.endOfLine, "\n"),
        Token(Category.numberLiteral, "20"),
        Token(Category.let, "LET"),
        Token(Category.identifier, "B"),
        Token(Category.equals, "="),
        Token(Category.numberLiteral, "10"),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[10], isA<LetStatement>());
      expect(program[20], isA<LetStatement>());
    });
  });
}
