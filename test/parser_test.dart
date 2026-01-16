import 'package:basic_interpreter/parser.dart';
import 'package:basic_interpreter/statements.dart';
import 'package:basic_interpreter/expressions.dart';
import 'package:basic_interpreter/tokens.dart';
import 'package:basic_interpreter/errors.dart';
import 'package:basic_interpreter/operators.dart';
import 'package:test/test.dart';

void main() {
  group("LET statements", () {
    test("Parse LET statement", () {
      final tokens = [
        NumberLiteralToken(10),
        LetKeywordToken(),
        IdentifierToken("A"),
        EqualsToken(),
        NumberLiteralToken(5),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[10],
        isA<LetStatement>()
            .having((p) => p.identifier, "identifier", "A")
            .having(
              (p) => p.expression,
              "expression",
              isA<NumberLiteralExpression>(),
            ),
      );
    });

    test("Throw error if tokens are not in the correct order", () {
      final tokens = [
        NumberLiteralToken(10),
        LetKeywordToken(),
        EqualsToken(),
        IdentifierToken("A"),
        NumberLiteralToken(5),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);

      expect(parser.parse, throwsA(isA<UnexpectedTokenError>()));
    });

    test("Throw error if position is out of bounds", () {
      final tokens = [
        NumberLiteralToken(10),
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
        NumberLiteralToken(10),
        LetKeywordToken(),
        IdentifierToken("A"),
        EqualsToken(),
        NumberLiteralToken(5),
        EndOfLineToken(),
        NumberLiteralToken(20),
        LetKeywordToken(),
        IdentifierToken("B"),
        EqualsToken(),
        NumberLiteralToken(10),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[10],
        isA<LetStatement>()
            .having((p) => p.identifier, "identifier", "A")
            .having(
              (p) => p.expression,
              "expression",
              isA<NumberLiteralExpression>(),
            ),
      );
      expect(
        program[20],
        isA<LetStatement>()
            .having((p) => p.identifier, "identifier", "B")
            .having(
              (p) => p.expression,
              "expression",
              isA<NumberLiteralExpression>(),
            ),
      );
    });
  });

  group("PRINT statements", () {
    test("Parse PRINT statement", () {
      final tokens = [
        NumberLiteralToken(10),
        PrintKeywordToken(),
        IdentifierToken("A"),
        CommaToken(),
        IdentifierToken("B"),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[10],
        isA<PrintStatement>().having(
          (p) => p.arguments.length,
          "argument count",
          equals(2),
        ),
      );
    });

    test("Invalid if - two consecutive commas", () {
      final tokens = [
        NumberLiteralToken(10),
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
        NumberLiteralToken(10),
        PrintKeywordToken(),
        IdentifierToken("A"),
        EndOfLineToken(),
        NumberLiteralToken(20),
        PrintKeywordToken(),
        StringLiteralToken("Hello, BASIC!"),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[10],
        isA<PrintStatement>().having((p) => p.arguments, "arguments", [
          isA<IdentifierExpression>().having(
            (p) => p.identifier,
            "identifier",
            "A",
          ),
        ]),
      );
      expect(
        program[20],
        isA<PrintStatement>().having((p) => p.arguments, "arguments", [
          isA<StringLiteralExpression>().having(
            (p) => p.value,
            "value",
            "Hello, BASIC!",
          ),
        ]),
      );
    });
  });

  group("GOTO statements", () {
    test("Parse GOTO statement", () {
      final tokens = [
        NumberLiteralToken(10),
        GotoKeywordToken(),
        NumberLiteralToken(20),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[10],
        isA<GotoStatement>().having((p) => p.lineNumber, "lineNumber", 20),
      );
    });
  });

  group("IF THEN statements", () {
    test("If with equals comparison operator", () {
      final tokens = [
        NumberLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken("A"),
        EqualsToken(),
        NumberLiteralToken(5),
        ThenKeywordToken(),
        NumberLiteralToken(40),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[20],
        isA<IfStatement>().having(
          (p) => p.condition,
          "condition",
          isA<ComparisonExpression>()
              .having(
                (p) => p.lhs,
                "lhs",
                isA<IdentifierExpression>().having(
                  (p) => p.identifier,
                  "identifier",
                  "A",
                ),
              )
              .having((p) => p.operator, "operator", ComparisonOperator.eq)
              .having(
                (p) => p.rhs,
                "rhs",
                isA<NumberLiteralExpression>().having(
                  (p) => p.value,
                  "value",
                  5,
                ),
              ),
        ),
      );
    });

    test("If with greater than comparison operator", () {
      final tokens = [
        NumberLiteralToken(20),
        IfKeywordToken(),
        NumberLiteralToken(10),
        GreaterThanToken(),
        NumberLiteralToken(5),
        ThenKeywordToken(),
        NumberLiteralToken(40),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[20],
        isA<IfStatement>().having(
          (p) => p.condition,
          "condition",
          isA<ComparisonExpression>()
              .having(
                (p) => p.lhs,
                "lhs",
                isA<NumberLiteralExpression>().having(
                  (p) => p.value,
                  "value",
                  10,
                ),
              )
              .having((p) => p.operator, "operator", ComparisonOperator.gt)
              .having(
                (p) => p.rhs,
                "rhs",
                isA<NumberLiteralExpression>().having(
                  (p) => p.value,
                  "value",
                  5,
                ),
              ),
        ),
      );
    });

    test("If with less than comparison operator", () {
      final tokens = [
        NumberLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken("A"),
        LessThanToken(),
        NumberLiteralToken(5),
        ThenKeywordToken(),
        NumberLiteralToken(40),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[20],
        isA<IfStatement>().having(
          (p) => p.condition,
          "condition",
          isA<ComparisonExpression>()
              .having(
                (p) => p.lhs,
                "lhs",
                isA<IdentifierExpression>().having(
                  (p) => p.identifier,
                  "identifier",
                  "A",
                ),
              )
              .having((p) => p.operator, "operator", ComparisonOperator.lt)
              .having(
                (p) => p.rhs,
                "rhs",
                isA<NumberLiteralExpression>().having(
                  (p) => p.value,
                  "value",
                  5,
                ),
              ),
        ),
      );
    });

    test("If with greater than or equal comparison operator", () {
      final tokens = [
        NumberLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken("A"),
        GreaterThanOrEqualToken(),
        NumberLiteralToken(5),
        ThenKeywordToken(),
        NumberLiteralToken(40),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[20],
        isA<IfStatement>().having(
          (p) => p.condition,
          "condition",
          isA<ComparisonExpression>()
              .having(
                (p) => p.lhs,
                "lhs",
                isA<IdentifierExpression>().having(
                  (p) => p.identifier,
                  "identifier",
                  "A",
                ),
              )
              .having((p) => p.operator, "operator", ComparisonOperator.gte)
              .having(
                (p) => p.rhs,
                "rhs",
                isA<NumberLiteralExpression>().having(
                  (p) => p.value,
                  "value",
                  5,
                ),
              ),
        ),
      );
    });

    test("If with less than or equal comparison operator", () {
      final tokens = [
        NumberLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken("A"),
        LessThanOrEqualToken(),
        NumberLiteralToken(5),
        ThenKeywordToken(),
        NumberLiteralToken(40),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[20],
        isA<IfStatement>().having(
          (p) => p.condition,
          "condition",
          isA<ComparisonExpression>()
              .having(
                (p) => p.lhs,
                "lhs",
                isA<IdentifierExpression>().having(
                  (p) => p.identifier,
                  "identifier",
                  "A",
                ),
              )
              .having((p) => p.operator, "operator", ComparisonOperator.lte)
              .having(
                (p) => p.rhs,
                "rhs",
                isA<NumberLiteralExpression>().having(
                  (p) => p.value,
                  "value",
                  5,
                ),
              ),
        ),
      );
    });

    test("If with not equal comparison operator", () {
      final tokens = [
        NumberLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken("A"),
        NotEqualToken(),
        NumberLiteralToken(5),
        ThenKeywordToken(),
        NumberLiteralToken(40),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(
        program[20],
        isA<IfStatement>().having(
          (p) => p.condition,
          "condition",
          isA<ComparisonExpression>()
              .having(
                (p) => p.lhs,
                "lhs",
                isA<IdentifierExpression>().having(
                  (p) => p.identifier,
                  "identifier",
                  "A",
                ),
              )
              .having((p) => p.operator, "operator", ComparisonOperator.neq)
              .having(
                (p) => p.rhs,
                "rhs",
                isA<NumberLiteralExpression>().having(
                  (p) => p.value,
                  "value",
                  5,
                ),
              ),
        ),
      );
    });
  });

  group("END statements", () {
    test("Parse END statement", () {
      final tokens = [
        NumberLiteralToken(10),
        EndKeywordToken(),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[10], isA<EndStatement>());
    });
  });
}
