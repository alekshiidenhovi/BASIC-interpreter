import 'package:basic_interpreter/basic_interpreter.dart';
import 'package:basic_interpreter/expressions.dart';
import 'package:basic_interpreter/operators.dart';
import 'package:basic_interpreter/statements.dart';
import 'package:test/test.dart';
import "dart:collection";

void main() {
  group("Printing", () {
    test('10 PRINT "HELLO, WORLD!"', () {
      final statements = SplayTreeMap<int, Statement>.from({
        10: PrintStatement([StringLiteralExpression("HELLO, WORLD!")]),
        20: EndStatement(),
      });
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["HELLO, WORLD!"]);
    });

    test('Two print statements', () {
      final statements = SplayTreeMap<int, Statement>.from({
        10: PrintStatement([StringLiteralExpression("HELLO, WORLD!")]),
        20: PrintStatement([StringLiteralExpression("HELLO, BASIC!")]),
        30: EndStatement(),
      });
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["HELLO, WORLD!", "HELLO, BASIC!"]);
    });

    test('10 PRINT "HELLO, WORLD!", "HELLO, BASIC!"', () {
      final statements = SplayTreeMap<int, Statement>.from({
        10: PrintStatement([
          StringLiteralExpression("HELLO, WORLD!"),
          StringLiteralExpression("HELLO, BASIC!"),
        ]),
        20: EndStatement(),
      });
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["HELLO, WORLD!\tHELLO, BASIC!"]);
    });
  });

  group("Variables", () {
    test('10 LET A = 5\n20 PRINT A', () {
      final statements = SplayTreeMap<int, Statement>.from({
        10: LetStatement("A", IntegerLiteralExpression(5)),
        20: PrintStatement([IdentifierExpression("A")]),
        30: EndStatement(),
      });
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["5"]);
    });

    test('10 LET A = 5.2\n20 PRINT A', () {
      final statements = SplayTreeMap<int, Statement>.from({
        10: LetStatement("A", FloatingPointLiteralExpression(5.2)),
        20: PrintStatement([IdentifierExpression("A")]),
        30: EndStatement(),
      });
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["5.2"]);
    });

    test('10 LET A = 42\n20 PRINT "A IS", A', () {
      final statements = SplayTreeMap<int, Statement>.from({
        10: LetStatement("A", IntegerLiteralExpression(42)),
        20: PrintStatement([
          StringLiteralExpression("A IS"),
          IdentifierExpression("A"),
        ]),
        30: EndStatement(),
      });
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["A IS\t42"]);
    });
  });

  group("If-then statements", () {
    test("If statement", () {
      final statements = SplayTreeMap<int, Statement>.from({
        10: LetStatement("A", IntegerLiteralExpression(5)),
        20: IfStatement(
          ComparisonExpression(
            IdentifierExpression("A"),
            IntegerLiteralExpression(5),
            ComparisonOperator.eq,
          ),
          PrintStatement([IdentifierExpression("A")]),
        ),
        30: EndStatement(),
      });
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["5"]);
    });
  });

  group("END statements", () {
    test("END statement", () {
      final statements = SplayTreeMap<int, Statement>.from({
        10: PrintStatement([StringLiteralExpression("This is printed")]),
        20: EndStatement(),
        30: PrintStatement([StringLiteralExpression("This is not executed")]),
      });
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), ["This is printed"]);
    });
  });

  group("REM statements", () {
    test("REM statement", () {
      final statements = SplayTreeMap<int, Statement>.from({
        10: RemarkStatement(),
        20: EndStatement(),
      });
      final interpreter = Interpreter(statements);
      expect(interpreter.interpret(), []);
    });
  });
}
