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

  group("PRINT statements", () {
    test("Parse PRINT statement", () {
      final tokens = [
        Token(Category.numberLiteral, "10"),
        Token(Category.print, "PRINT"),
        Token(Category.identifier, "A"),
        Token(Category.comma, ","),
        Token(Category.identifier, "A"),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[10], isA<PrintStatement>());
    });

    test("Invalid if - two consecutive commas", () {
      final tokens = [
        Token(Category.numberLiteral, "10"),
        Token(Category.print, "PRINT"),
        Token(Category.identifier, "A"),
        Token(Category.comma, ","),
        Token(Category.comma, ","),
      ];

      final parser = Parser(tokens);
      expect(parser.parse, throwsA(isA<InvalidTokenError>()));
    });

    test("Two PRINT statements", () {
      final tokens = [
        Token(Category.numberLiteral, "10"),
        Token(Category.print, "PRINT"),
        Token(Category.identifier, "A"),
        Token(Category.endOfLine, "\n"),
        Token(Category.numberLiteral, "20"),
        Token(Category.print, "PRINT"),
        Token(Category.stringLiteral, "Hello, BASIC!"),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[10], isA<PrintStatement>());
      expect(program[20], isA<PrintStatement>());
    });
  });

  group("GOTO statements", () {
    test("Parse GOTO statement", () {
      final tokens = [
        Token(Category.numberLiteral, "10"),
        Token(Category.goto, "GOTO"),
        Token(Category.numberLiteral, "20"),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[10], isA<GotoStatement>());
    });
  });

  group("IF THEN statements", () {
    test("If with equals comparison operator", () {
      final tokens = [
        Token(Category.numberLiteral, "20"),
        Token(Category.ifToken, "IF"),
        Token(Category.identifier, "A"),
        Token(Category.equals, "="),
        Token(Category.numberLiteral, "5"),
        Token(Category.then, "THEN"),
        Token(Category.numberLiteral, "40"),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[20], isA<IfStatement>());
    });

    test("If with greater than comparison operator", () {
      final tokens = [
        Token(Category.numberLiteral, "20"),
        Token(Category.ifToken, "IF"),
        Token(Category.identifier, "A"),
        Token(Category.greaterThan, ">"),
        Token(Category.numberLiteral, "5"),
        Token(Category.then, "THEN"),
        Token(Category.numberLiteral, "40"),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[20], isA<IfStatement>());
    });

    test("If with less than comparison operator", () {
      final tokens = [
        Token(Category.numberLiteral, "20"),
        Token(Category.ifToken, "IF"),
        Token(Category.identifier, "A"),
        Token(Category.lessThan, "<"),
        Token(Category.numberLiteral, "5"),
        Token(Category.then, "THEN"),
        Token(Category.numberLiteral, "40"),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[20], isA<IfStatement>());
    });

    test("If with greater than or equal comparison operator", () {
      final tokens = [
        Token(Category.numberLiteral, "20"),
        Token(Category.ifToken, "IF"),
        Token(Category.identifier, "A"),
        Token(Category.greaterThanOrEqual, ">="),
        Token(Category.numberLiteral, "5"),
        Token(Category.then, "THEN"),
        Token(Category.numberLiteral, "40"),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[20], isA<IfStatement>());
    });

    test("If with less than or equal comparison operator", () {
      final tokens = [
        Token(Category.numberLiteral, "20"),
        Token(Category.ifToken, "IF"),
        Token(Category.identifier, "A"),
        Token(Category.lessThanOrEqual, "<="),
        Token(Category.numberLiteral, "5"),
        Token(Category.then, "THEN"),
        Token(Category.numberLiteral, "40"),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[20], isA<IfStatement>());
    });

    test("If with not equal comparison operator", () {
      final tokens = [
        Token(Category.numberLiteral, "20"),
        Token(Category.ifToken, "IF"),
        Token(Category.identifier, "A"),
        Token(Category.notEqual, "<>"),
        Token(Category.numberLiteral, "5"),
        Token(Category.then, "THEN"),
        Token(Category.numberLiteral, "40"),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[20], isA<IfStatement>());
    });
  });
}
