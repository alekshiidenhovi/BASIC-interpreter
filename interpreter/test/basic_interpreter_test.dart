import 'package:basic_interpreter/basic_interpreter.dart';
import 'package:basic_interpreter/operators.dart';
import 'package:basic_interpreter/typed_expressions.dart';
import 'package:basic_interpreter/typed_statements.dart';
import 'package:test/test.dart';

void main() {
  group("Printing", () {
    test('One print statement', () {
      final List<TypedStatement> statements = [
        TypedPrintStatement([TypedStringConstantExpression("HELLO, WORLD!")]),
        TypedEndStatement(),
      ];
      final interpreter = Interpreter();
      expect(interpreter.interpret(statements), ["HELLO, WORLD!"]);
    });

    test('Two print statements', () {
      final List<TypedStatement> statements = [
        TypedPrintStatement([
          TypedStringConstantExpression("HELLO, WORLD!"),
          TypedStringConstantExpression("HELLO, BASIC!"),
        ]),
        TypedEndStatement(),
      ];
      final interpreter = Interpreter();
      expect(interpreter.interpret(statements), [
        "HELLO, WORLD!\tHELLO, BASIC!",
      ]);
    });
  });

  group("Variables", () {
    test('LET A = 5\nPRINT A', () {
      final List<TypedStatement> statements = [
        TypedLetStatement("A", TypedIntegerConstantExpression(5)),
        TypedPrintStatement([TypedIdentifierConstantExpression("A")]),
        TypedEndStatement(),
      ];
      final interpreter = Interpreter();
      expect(interpreter.interpret(statements), ["5"]);
    });

    test('LET A = 5.2\nPRINT A', () {
      final List<TypedStatement> statements = [
        TypedLetStatement("A", TypedFloatingPointConstantExpression(5.2)),
        TypedPrintStatement([TypedIdentifierConstantExpression("A")]),
        TypedEndStatement(),
      ];
      final interpreter = Interpreter();
      expect(interpreter.interpret(statements), ["5.2"]);
    });

    test('LET A = 42\nPRINT "A IS", A', () {
      final List<TypedStatement> statements = [
        TypedLetStatement("A", TypedIntegerConstantExpression(42)),
        TypedPrintStatement([
          TypedStringConstantExpression("A IS"),
          TypedIdentifierConstantExpression("A"),
        ]),
        TypedEndStatement(),
      ];
      final interpreter = Interpreter();
      expect(interpreter.interpret(statements), ["A IS\t42"]);
    });
  });

  group("If-then statements", () {
    test("If statement", () {
      final List<TypedStatement> statements = [
        TypedLetStatement("A", TypedIntegerConstantExpression(5)),
        TypedIfStatement(
          TypedComparisonExpression(
            TypedIdentifierConstantExpression("A"),
            TypedIntegerConstantExpression(5),
            ComparisonOperator.eq,
          ),
          TypedPrintStatement([TypedIdentifierConstantExpression("A")]),
        ),
        TypedEndStatement(),
      ];
      final interpreter = Interpreter();
      expect(interpreter.interpret(statements), ["5"]);
    });
  });

  group("END statements", () {
    test("END statement", () {
      final List<TypedStatement> statements = [
        TypedPrintStatement([TypedStringConstantExpression("This is printed")]),
        TypedEndStatement(),
        TypedPrintStatement([
          TypedStringConstantExpression("This is not printed"),
        ]),
      ];
      final interpreter = Interpreter();
      expect(interpreter.interpret(statements), ["This is printed"]);
    });
  });

  group("REM statements", () {
    test("REM statement", () {
      final List<TypedStatement> statements = [
        TypedRemarkStatement(),
        TypedEndStatement(),
      ];
      final interpreter = Interpreter();
      expect(interpreter.interpret(statements), []);
    });
  });
}
