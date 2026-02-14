import 'package:basic_interpreter/basic_interpreter.dart';
import 'package:basic_interpreter/expressions.dart';
import 'package:basic_interpreter/operators.dart';
import 'package:basic_interpreter/statements.dart';
import 'package:test/test.dart';

void main() {
  group("Printing", () {
    test('PRINT "HELLO, WORLD!"', () {
      final List<Statement> statements = [
        PrintStatement([StringLiteralExpression("HELLO, WORLD!")]),
        EndStatement(),
      ];
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["HELLO, WORLD!"]);
    });

    test('Two print statements', () {
      final List<Statement> statements = [
        PrintStatement([StringLiteralExpression("HELLO, WORLD!")]),
        PrintStatement([StringLiteralExpression("HELLO, BASIC!")]),
        EndStatement(),
      ];
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["HELLO, WORLD!", "HELLO, BASIC!"]);
    });

    test('PRINT "HELLO, WORLD!", "HELLO, BASIC!"', () {
      final List<Statement> statements = [
        PrintStatement([
          StringLiteralExpression("HELLO, WORLD!"),
          StringLiteralExpression("HELLO, BASIC!"),
        ]),
        EndStatement(),
      ];
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["HELLO, WORLD!\tHELLO, BASIC!"]);
    });
  });

  group("Variables", () {
    test('LET A = 5\nPRINT A', () {
      final List<Statement> statements = [
        LetStatement("A", IntegerLiteralExpression(5)),
        PrintStatement([IdentifierExpression("A")]),
        EndStatement(),
      ];
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["5"]);
    });

    test('LET A = 5.2\nPRINT A', () {
      final List<Statement> statements = [
        LetStatement("A", FloatingPointLiteralExpression(5.2)),
        PrintStatement([IdentifierExpression("A")]),
        EndStatement(),
      ];
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["5.2"]);
    });

    test('LET A = 42\nPRINT "A IS", A', () {
      final List<Statement> statements = [
        LetStatement("A", IntegerLiteralExpression(42)),
        PrintStatement([
          StringLiteralExpression("A IS"),
          IdentifierExpression("A"),
        ]),
        EndStatement(),
      ];
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["A IS\t42"]);
    });
  });

  group("If-then statements", () {
    test("If statement", () {
      final List<Statement> statements = [
        LetStatement("A", IntegerLiteralExpression(5)),
        IfStatement(
          ComparisonExpression(
            IdentifierExpression("A"),
            IntegerLiteralExpression(5),
            ComparisonOperator.eq,
          ),
          PrintStatement([IdentifierExpression("A")]),
        ),
        EndStatement(),
      ];
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["5"]);
    });
  });

  group("END statements", () {
    test("END statement", () {
      final List<Statement> statements = [
        PrintStatement([StringLiteralExpression("This is printed")]),
        EndStatement(),
        PrintStatement([StringLiteralExpression("This is not executed")]),
      ];
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["This is printed"]);
    });
  });

  group("REM statements", () {
    test("REM statement", () {
      final List<Statement> statements = [RemarkStatement(), EndStatement()];
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), []);
    });
  });
}
