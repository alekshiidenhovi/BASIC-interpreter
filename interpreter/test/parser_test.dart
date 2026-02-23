import 'package:basic_interpreter/parser.dart';
import 'package:basic_interpreter/untyped_statements.dart';
import 'package:basic_interpreter/untyped_expressions.dart';
import 'package:basic_interpreter/tokens.dart';
import 'package:basic_interpreter/errors.dart';
import 'package:test/test.dart';

void main() {
  group("LET statements", () {
    test("Parse LET statement", () {
      final tokens = [
        LetKeywordToken(),
        IdentifierToken("A"),
        EqualsToken(),
        IntegerLiteralToken(5),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[0],
        isA<LetStatement>()
            .having((p) => p.identifier, "identifier", "A")
            .having(
              (p) => p.expression,
              "expression",
              isA<IntegerConstantExpression>(),
            ),
      );
    });

    test("Throw error if tokens are not in the correct order", () {
      final tokens = [
        LetKeywordToken(),
        EqualsToken(),
        IdentifierToken("A"),
        FloatingPointLiteralToken(5),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);

      expect(parser.parse, throwsA(isA<UnexpectedTokenError>()));
    });

    test("Throw error if position is out of bounds", () {
      final tokens = [
        LetKeywordToken(),
        IdentifierToken("A"),
        EqualsToken(),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);

      expect(parser.parse, throwsA(isA<UnexpectedTokenError>()));
    });

    test("Two LET statements", () {
      final tokens = [
        LetKeywordToken(),
        IdentifierToken("A"),
        EqualsToken(),
        IntegerLiteralToken(5),
        EndOfLineToken(),
        LetKeywordToken(),
        IdentifierToken("B"),
        EqualsToken(),
        FloatingPointLiteralToken(10.5),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[0],
        isA<LetStatement>()
            .having((p) => p.identifier, "identifier", "A")
            .having(
              (p) => p.expression,
              "expression",
              isA<IntegerConstantExpression>(),
            ),
      );
      expect(
        program[1],
        isA<LetStatement>()
            .having((p) => p.identifier, "identifier", "B")
            .having(
              (p) => p.expression,
              "expression",
              isA<FloatingPointConstantExpression>(),
            ),
      );
    });
  });

  group("PRINT statements", () {
    test("Parse PRINT statement", () {
      final tokens = [
        PrintKeywordToken(),
        IdentifierToken("A"),
        CommaToken(),
        IdentifierToken("B"),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[0],
        isA<PrintStatement>().having(
          (p) => p.arguments.length,
          "argument count",
          equals(2),
        ),
      );
    });

    test("Invalid PRINT - two consecutive commas", () {
      final tokens = [
        PrintKeywordToken(),
        IdentifierToken("A"),
        CommaToken(),
        CommaToken(),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      expect(parser.parse, throwsA(isA<UnexpectedTokenError>()));
    });

    test("Two PRINT statements", () {
      final tokens = [
        PrintKeywordToken(),
        IdentifierToken("A"),
        EndOfLineToken(),
        PrintKeywordToken(),
        StringLiteralToken("Hello, BASIC!"),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[0],
        isA<PrintStatement>().having((p) => p.arguments, "arguments", [
          isA<IdentifierConstantExpression>().having(
            (p) => p.identifier,
            "identifier",
            "A",
          ),
        ]),
      );
      expect(
        program[1],
        isA<PrintStatement>().having((p) => p.arguments, "arguments", [
          isA<StringConstantExpression>().having(
            (p) => p.value,
            "value",
            "Hello, BASIC!",
          ),
        ]),
      );
    });
  });

  group("IF THEN statements", () {
    test("If with equals comparison operator", () {
      final tokens = [
        IfKeywordToken(),
        IdentifierToken("A"),
        EqualsToken(),
        IntegerLiteralToken(5),
        ThenKeywordToken(),
        PrintKeywordToken(),
        IdentifierToken("A"),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[0],
        isA<IfStatement>().having(
          (p) => p.thenStatement,
          "thenStatement",
          isA<PrintStatement>(),
        ),
      );
    });
  });

  group("END statements", () {
    test("Parse END statement", () {
      final tokens = [EndKeywordToken(), EndOfLineToken()];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[0], isA<EndStatement>());
    });
  });

  group("REMARK statements", () {
    test("Parse REM statement", () {
      final tokens = [
        RemKeywordToken(),
        IdentifierToken("This"),
        IdentifierToken("is"),
        IdentifierToken("a"),
        IdentifierToken("comment"),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[0], isA<RemarkStatement>());
    });
  });
}
