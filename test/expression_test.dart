import "package:basic_interpreter/expressions.dart";
import "package:basic_interpreter/errors.dart";
import "package:basic_interpreter/operators.dart";
import "package:test/test.dart";

void main() {
  group("Number literal expressions", () {
    test("Positive number literal expression", () {
      final expression = NumberLiteralExpression(42);
      expect(expression.evaluate({}), 42);
    });

    test("Zero number literal expression", () {
      final expression = NumberLiteralExpression(0);
      expect(expression.evaluate({}), 0);
    });

    test("Negative number literal expression", () {
      final expression = NumberLiteralExpression(-42);
      expect(expression.evaluate({}), -42);
    });
  });

  group("String literals expressions", () {
    test("Evaluate string literal expression", () {
      final expression = StringLiteralExpression("Hello, BASIC!");
      expect(expression.evaluate({}), "Hello, BASIC!");
    });
  });

  group("Identifier expressions", () {
    test("Evaluate identifier expression", () {
      final expression = IdentifierExpression("A");
      expect(expression.evaluate({"A": 42}), 42);
    });

    test("Evaluate identifier expression with missing variable", () {
      final expression = IdentifierExpression("A");
      expect(
        () => expression.evaluate({}),
        throwsA(isA<MissingIdentifierError>()),
      );
    });
  });

  group("Comparison expressions", () {
    // ------------------------------------------------------------
    // Equality comparison
    // ------------------------------------------------------------
    group("Equality comparison", () {
      test("Equal number literals", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(42),
          ComparisonOperator.eq,
        );
        expect(expression.evaluate({}), true);
      });

      test("Inequal number literals", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(43),
          ComparisonOperator.eq,
        );
        expect(expression.evaluate({}), false);
      });

      test("One symbol, one literal, equal values", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.eq,
        );
        expect(expression.evaluate({"A": 42}), true);
      });

      test("One symbol, one literal, different values", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.eq,
        );
        expect(expression.evaluate({"A": 43}), false);
      });

      test("Same symbols, equal values", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("A"),
          ComparisonOperator.eq,
        );
        expect(expression.evaluate({"A": 42}), true);
      });

      test("Different symbols, same values", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.eq,
        );
        expect(expression.evaluate({"A": 42, "B": 42}), true);
      });

      test("Different symbols, different values", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.eq,
        );
        expect(expression.evaluate({"A": 42, "B": 43}), false);
      });
    });

    // ------------------------------------------------------------
    // Greater than comparison
    // ------------------------------------------------------------
    group("Greater than comparison", () {
      test("First number literal greater than second", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(44),
          NumberLiteralExpression(43),
          ComparisonOperator.gt,
        );
        expect(expression.evaluate({}), true);
      });

      test("First number literal less than second", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(43),
          NumberLiteralExpression(44),
          ComparisonOperator.gt,
        );
        expect(expression.evaluate({}), false);
      });

      test("First number literal equal to second", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(44),
          NumberLiteralExpression(44),
          ComparisonOperator.gt,
        );
        expect(expression.evaluate({}), false);
      });

      test("One symbol, one literal, symbol greater than literal", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.gt,
        );
        expect(expression.evaluate({"A": 43}), true);
      });

      test("One symbol, one literal, symbol less than literal", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.gt,
        );
        expect(expression.evaluate({"A": 41}), false);
      });

      test("One symbol, one literal, symbol equal to literal", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.gt,
        );
        expect(expression.evaluate({"A": 42}), false);
      });

      test("Same symbols, first greater than second", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.gt,
        );
        expect(expression.evaluate({"A": 43, "B": 42}), true);
      });

      test("Same symbols, first less than second", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.gt,
        );
        expect(expression.evaluate({"A": 42, "B": 43}), false);
      });

      test("Same symbols, first equal to second", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.gt,
        );
        expect(expression.evaluate({"A": 42, "B": 42}), false);
      });
    });

    // ------------------------------------------------------------
    // Less than comparison
    // ------------------------------------------------------------
    group("Less than comparison", () {
      test("First number literal less than second", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(41),
          NumberLiteralExpression(42),
          ComparisonOperator.lt,
        );
        expect(expression.evaluate({}), true);
      });

      test("First number literal greater than second", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(43),
          NumberLiteralExpression(42),
          ComparisonOperator.lt,
        );
        expect(expression.evaluate({}), false);
      });

      test("First number literal equal to second", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(42),
          ComparisonOperator.lt,
        );
        expect(expression.evaluate({}), false);
      });

      test("Symbol less than literal", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.lt,
        );
        expect(expression.evaluate({"A": 41}), true);
      });

      test("Symbol greater than literal", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.lt,
        );
        expect(expression.evaluate({"A": 43}), false);
      });

      test("Symbol equal to literal", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.lt,
        );
        expect(expression.evaluate({"A": 42}), false);
      });

      test("Symbol < symbol", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.lt,
        );
        expect(expression.evaluate({"A": 41, "B": 42}), true);
      });

      test("Symbol > symbol", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.lt,
        );
        expect(expression.evaluate({"A": 43, "B": 42}), false);
      });

      test("Symbol == symbol", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.lt,
        );
        expect(expression.evaluate({"A": 42, "B": 42}), false);
      });
    });

    // ------------------------------------------------------------
    // Greater or equal comparison
    // ------------------------------------------------------------
    group("Greater or equal comparison", () {
      test("First literal greater", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(43),
          NumberLiteralExpression(42),
          ComparisonOperator.gte,
        );
        expect(expression.evaluate({}), true);
      });

      test("First literal equal", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(42),
          ComparisonOperator.gte,
        );
        expect(expression.evaluate({}), true);
      });

      test("First literal smaller", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(41),
          NumberLiteralExpression(42),
          ComparisonOperator.gte,
        );
        expect(expression.evaluate({}), false);
      });

      test("Symbol >= literal (greater)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.gte,
        );
        expect(expression.evaluate({"A": 43}), true);
      });

      test("Symbol >= literal (equal)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.gte,
        );
        expect(expression.evaluate({"A": 42}), true);
      });

      test("Symbol >= literal (less)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.gte,
        );
        expect(expression.evaluate({"A": 41}), false);
      });

      test("Symbol >= symbol (greater)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.gte,
        );
        expect(expression.evaluate({"A": 43, "B": 42}), true);
      });

      test("Symbol >= symbol (equal)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.gte,
        );
        expect(expression.evaluate({"A": 42, "B": 42}), true);
      });

      test("Symbol >= symbol (less)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.gte,
        );
        expect(expression.evaluate({"A": 41, "B": 42}), false);
      });
    });

    // ------------------------------------------------------------
    // Less or equal comparison
    // ------------------------------------------------------------
    group("Less or equal comparison", () {
      test("First literal less", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(41),
          NumberLiteralExpression(42),
          ComparisonOperator.lte,
        );
        expect(expression.evaluate({}), true);
      });

      test("First literal equal", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(42),
          ComparisonOperator.lte,
        );
        expect(expression.evaluate({}), true);
      });

      test("First literal greater", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(43),
          NumberLiteralExpression(42),
          ComparisonOperator.lte,
        );
        expect(expression.evaluate({}), false);
      });

      test("Symbol <= literal (less)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.lte,
        );
        expect(expression.evaluate({"A": 41}), true);
      });

      test("Symbol <= literal (equal)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.lte,
        );
        expect(expression.evaluate({"A": 42}), true);
      });

      test("Symbol <= literal (greater)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.lte,
        );
        expect(expression.evaluate({"A": 43}), false);
      });

      test("Symbol <= symbol (less)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.lte,
        );
        expect(expression.evaluate({"A": 41, "B": 42}), true);
      });

      test("Symbol <= symbol (equal)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.lte,
        );
        expect(expression.evaluate({"A": 42, "B": 42}), true);
      });

      test("Symbol <= symbol (greater)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.lte,
        );
        expect(expression.evaluate({"A": 43, "B": 42}), false);
      });
    });

    // ------------------------------------------------------------
    // Not equal comparison
    // ------------------------------------------------------------
    group("Not equal comparison", () {
      test("Different number literals", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(41),
          NumberLiteralExpression(42),
          ComparisonOperator.neq,
        );
        expect(expression.evaluate({}), true);
      });

      test("Equal number literals", () {
        final expression = ComparisonExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(42),
          ComparisonOperator.neq,
        );
        expect(expression.evaluate({}), false);
      });

      test("Symbol != literal (different)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.neq,
        );
        expect(expression.evaluate({"A": 41}), true);
      });

      test("Symbol != literal (equal)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          NumberLiteralExpression(42),
          ComparisonOperator.neq,
        );
        expect(expression.evaluate({"A": 42}), false);
      });

      test("Symbol != symbol (different)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.neq,
        );
        expect(expression.evaluate({"A": 41, "B": 42}), true);
      });

      test("Symbol != symbol (equal)", () {
        final expression = ComparisonExpression(
          IdentifierExpression("A"),
          IdentifierExpression("B"),
          ComparisonOperator.neq,
        );
        expect(expression.evaluate({"A": 42, "B": 42}), false);
      });
    });
  });

  group("Arithmetic expressions", () {
    group("Addition", () {
      test("Two positive numbers", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(43),
          ArithmeticOperator.add,
        );
        expect(expression.evaluate({}), 85);
      });

      test("Two negative numbers", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(-42),
          NumberLiteralExpression(-43),
          ArithmeticOperator.add,
        );
        expect(expression.evaluate({}), -85);
      });

      test("One positive number, one negative number", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(-43),
          ArithmeticOperator.add,
        );
        expect(expression.evaluate({}), -1);
      });

      test("One negative number, one positive number", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(-42),
          NumberLiteralExpression(43),
          ArithmeticOperator.add,
        );
        expect(expression.evaluate({}), 1);
      });

      test("One positive number, one zero", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(0),
          ArithmeticOperator.add,
        );
        expect(expression.evaluate({}), 42);
      });

      test("One negative number, one zero", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(-42),
          NumberLiteralExpression(0),
          ArithmeticOperator.add,
        );
        expect(expression.evaluate({}), -42);
      });
    });

    group("Subtraction", () {
      test("Two positive numbers", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(43),
          ArithmeticOperator.sub,
        );
        expect(expression.evaluate({}), -1);
      });

      test("Two negative numbers", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(-42),
          NumberLiteralExpression(-43),
          ArithmeticOperator.sub,
        );
        expect(expression.evaluate({}), 1);
      });

      test("One positive number, one negative number", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(-43),
          ArithmeticOperator.sub,
        );
        expect(expression.evaluate({}), 85);
      });

      test("One negative number, one positive number", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(-42),
          NumberLiteralExpression(43),
          ArithmeticOperator.sub,
        );
        expect(expression.evaluate({}), -85);
      });

      test("One positive number, one zero", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(0),
          ArithmeticOperator.sub,
        );
        expect(expression.evaluate({}), 42);
      });

      test("One negative number, one zero", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(-42),
          NumberLiteralExpression(0),
          ArithmeticOperator.sub,
        );
        expect(expression.evaluate({}), -42);
      });
    });

    group("Multiplication", () {
      test("Two positive numbers", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(2),
          NumberLiteralExpression(3),
          ArithmeticOperator.mul,
        );
        expect(expression.evaluate({}), 6);
      });

      test("Two negative numbers", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(-2),
          NumberLiteralExpression(-3),
          ArithmeticOperator.mul,
        );
        expect(expression.evaluate({}), 6);
      });

      test("One positive number, one negative number", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(2),
          NumberLiteralExpression(-3),
          ArithmeticOperator.mul,
        );
        expect(expression.evaluate({}), -6);
      });

      test("One zero", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(0),
          NumberLiteralExpression(3),
          ArithmeticOperator.mul,
        );
        expect(expression.evaluate({}), 0);
      });
    });

    group("Division", () {
      test("Two positive numbers", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(42),
          ArithmeticOperator.div,
        );
        expect(expression.evaluate({}), 1);
      });

      test("Two negative numbers", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(-42),
          NumberLiteralExpression(-42),
          ArithmeticOperator.div,
        );
        expect(expression.evaluate({}), 1);
      });

      test("One positive number, one negative number", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(3),
          NumberLiteralExpression(-2),
          ArithmeticOperator.div,
        );
        expect(expression.evaluate({}), -1.5);
      });

      test("One negative number, one positive number", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(-42),
          NumberLiteralExpression(6),
          ArithmeticOperator.div,
        );
        expect(expression.evaluate({}), -7);
      });

      test("Division by zero", () {
        final expression = ArithmeticExpression(
          NumberLiteralExpression(42),
          NumberLiteralExpression(0),
          ArithmeticOperator.div,
        );
        expect(
          () => expression.evaluate({}),
          throwsA(isA<DivisionByZeroError>()),
        );
      });
    });
  });
}
