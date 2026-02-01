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
        IntegerLiteralToken(10),
        LetKeywordToken(),
        IdentifierToken("A"),
        EqualsToken(),
        IntegerLiteralToken(5),
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
              isA<IntegerLiteralExpression>(),
            ),
      );
    });

    test("Throw error if tokens are not in the correct order", () {
      final tokens = [
        IntegerLiteralToken(10),
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
        IntegerLiteralToken(10),
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
        IntegerLiteralToken(10),
        LetKeywordToken(),
        IdentifierToken("A"),
        EqualsToken(),
        IntegerLiteralToken(5),
        EndOfLineToken(),
        IntegerLiteralToken(20),
        LetKeywordToken(),
        IdentifierToken("B"),
        EqualsToken(),
        FloatingPointLiteralToken(10.5),
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
              isA<IntegerLiteralExpression>(),
            ),
      );
      expect(
        program[20],
        isA<LetStatement>()
            .having((p) => p.identifier, "identifier", "B")
            .having(
              (p) => p.expression,
              "expression",
              isA<FloatingPointLiteralExpression>(),
            ),
      );
    });
  });

  group("PRINT statements", () {
    test("Parse PRINT statement", () {
      final tokens = [
        IntegerLiteralToken(10),
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

    test("Invalid PRINT - two consecutive commas", () {
      final tokens = [
        IntegerLiteralToken(10),
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
        IntegerLiteralToken(10),
        PrintKeywordToken(),
        IdentifierToken("A"),
        EndOfLineToken(),
        IntegerLiteralToken(20),
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
        IntegerLiteralToken(10),
        GotoKeywordToken(),
        IntegerLiteralToken(20),
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
        IntegerLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken("A"),
        EqualsToken(),
        IntegerLiteralToken(5),
        ThenKeywordToken(),
        IntegerLiteralToken(40),
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
                isA<IntegerLiteralExpression>().having(
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
        IntegerLiteralToken(20),
        IfKeywordToken(),
        IntegerLiteralToken(10),
        GreaterThanToken(),
        IntegerLiteralToken(5),
        ThenKeywordToken(),
        IntegerLiteralToken(40),
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
                isA<IntegerLiteralExpression>().having(
                  (p) => p.value,
                  "value",
                  10,
                ),
              )
              .having((p) => p.operator, "operator", ComparisonOperator.gt)
              .having(
                (p) => p.rhs,
                "rhs",
                isA<IntegerLiteralExpression>().having(
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
        IntegerLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken("A"),
        LessThanToken(),
        IntegerLiteralToken(5),
        ThenKeywordToken(),
        IntegerLiteralToken(40),
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
                isA<IntegerLiteralExpression>().having(
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
        IntegerLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken("A"),
        GreaterThanOrEqualToken(),
        IntegerLiteralToken(5),
        ThenKeywordToken(),
        IntegerLiteralToken(40),
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
                isA<IntegerLiteralExpression>().having(
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
        IntegerLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken("A"),
        LessThanOrEqualToken(),
        IntegerLiteralToken(5),
        ThenKeywordToken(),
        IntegerLiteralToken(40),
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
                isA<IntegerLiteralExpression>().having(
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
        IntegerLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken("A"),
        NotEqualToken(),
        IntegerLiteralToken(5),
        ThenKeywordToken(),
        IntegerLiteralToken(40),
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
                isA<IntegerLiteralExpression>().having(
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
        IntegerLiteralToken(10),
        EndKeywordToken(),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[10], isA<EndStatement>());
    });
  });

  group("REMARK statements", () {
    test("Parse REM statement", () {
      final tokens = [
        IntegerLiteralToken(10),
        RemKeywordToken(),
        IdentifierToken("This"),
        IdentifierToken("is"),
        IdentifierToken("a"),
        IdentifierToken("comment"),
        EndOfLineToken(),
      ];

      final parser = Parser(tokens);
      final program = parser.parse();

      expect(program[10], isA<RemarkStatement>());
    });
  });
}
