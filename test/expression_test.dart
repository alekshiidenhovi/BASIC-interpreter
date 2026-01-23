import "package:basic_interpreter/expressions.dart";
import "package:basic_interpreter/operators.dart";
import "package:basic_interpreter/context.dart";
import "package:test/test.dart";

sealed class TestVal {}

class StringVal extends TestVal {
  final String value;
  StringVal(this.value);
}

sealed class NumVal extends TestVal {}

class IntVal extends NumVal {
  final int value;
  IntVal(this.value);
}

class FloatVal extends NumVal {
  final double value;
  FloatVal(this.value);
}

class IdentifierVal extends NumVal {
  final String value;
  IdentifierVal(this.value);
}

Expression<num> _toNumExp(NumVal val) {
  return switch (val) {
    IntVal(value: var v) => IntegerLiteralExpression(v),
    FloatVal(value: var v) => FloatingPointLiteralExpression(v),
    IdentifierVal(value: var v) => IdentifierExpression(v),
  };
}

abstract class BaseTestCase<T> {
  final T expected;
  final Context context;
  final String description;

  BaseTestCase(this.expected, this.description, this.context);

  Expression<T> buildExpression();
}

class IntegerLiteralCase extends BaseTestCase<int> {
  final IntVal val;
  IntegerLiteralCase(
    this.val,
    super.expected,
    super.description,
    super.context,
  );

  @override
  Expression<int> buildExpression() => IntegerLiteralExpression(val.value);
}

class FloatLiteralCase extends BaseTestCase<double> {
  final FloatVal val;
  FloatLiteralCase(this.val, super.expected, super.description, super.context);

  @override
  Expression<double> buildExpression() =>
      FloatingPointLiteralExpression(val.value);
}

class IdentifierCase extends BaseTestCase<num> {
  final IdentifierVal val;
  IdentifierCase(this.val, super.expected, super.description, super.context);

  @override
  Expression<num> buildExpression() => IdentifierExpression(val.value);
}

class StringLiteralCase extends BaseTestCase<String> {
  final StringVal val;
  StringLiteralCase(this.val, super.expected, super.description, super.context);

  @override
  Expression<String> buildExpression() => StringLiteralExpression(val.value);
}

class ArithmeticCase extends BaseTestCase<num> {
  final NumVal left;
  final NumVal right;
  final ArithmeticOperator op;
  ArithmeticCase(
    this.left,
    this.right,
    this.op,
    super.expected,
    super.description,
    super.context,
  );

  @override
  Expression<num> buildExpression() =>
      ArithmeticExpression(_toNumExp(left), _toNumExp(right), op);
}

class ComparisonCase extends BaseTestCase<bool> {
  final NumVal left;
  final NumVal right;
  final ComparisonOperator op;
  ComparisonCase(
    this.left,
    this.right,
    this.op,
    super.expected,
    super.description,
    super.context,
  );

  @override
  Expression<bool> buildExpression() =>
      ComparisonExpression(_toNumExp(left), _toNumExp(right), op);
}

void runSuite<T>(List<BaseTestCase<T>> cases) {
  for (var tc in cases) {
    test(tc.description, () {
      final expression = tc.buildExpression();
      expect(expression.evaluate(tc.context), tc.expected);
    });
  }
}

void main() {
  group("Integer Literal Expressions", () {
    runSuite<int>([
      IntegerLiteralCase(IntVal(42), 42, "Positive integer", Context()),
      IntegerLiteralCase(IntVal(0), 0, "Zero", Context()),
      IntegerLiteralCase(IntVal(-42), -42, "Negative integer", Context()),
    ]);
  });

  group("Floating Point Literal Expressions", () {
    runSuite<double>([
      FloatLiteralCase(
        FloatVal(42.0),
        42.0,
        "Positive floating point",
        Context(),
      ),
      FloatLiteralCase(FloatVal(0.0), 0.0, "Zero", Context()),
      FloatLiteralCase(
        FloatVal(-42.0),
        -42.0,
        "Negative floating point",
        Context(),
      ),
    ]);
  });

  group("Identifier Expressions", () {
    runSuite<num>([
      IdentifierCase(
        IdentifierVal("A"),
        42,
        "Positive integer",
        Context.withVariables({"A": 42}),
      ),
      IdentifierCase(
        IdentifierVal("A"),
        0,
        "Zero",
        Context.withVariables({"A": 0}),
      ),
      IdentifierCase(
        IdentifierVal("A"),
        -42,
        "Negative Integer",
        Context.withVariables({"A": -42}),
      ),
    ]);
  });

  group("String Literal Expressions", () {
    runSuite<String>([
      StringLiteralCase(
        StringVal("Hello, BASIC!"),
        "Hello, BASIC!",
        "Hello BASIC test",
        Context(),
      ),
    ]);
  });

  group("Comparison Expressions", () {
    group("Equality comparison (==)", () {
      group("Integers only", () {
        runSuite<bool>([
          ComparisonCase(
            IntVal(42),
            IntVal(42),
            ComparisonOperator.eq,
            true,
            "42 == 42",
            Context(),
          ),
          ComparisonCase(
            IntVal(42),
            IntVal(43),
            ComparisonOperator.eq,
            false,
            "42 == 43",
            Context(),
          ),
          ComparisonCase(
            IntVal(43),
            IntVal(42),
            ComparisonOperator.eq,
            false,
            "43 == 42",
            Context(),
          ),
        ]);
      });

      group("Floats only", () {
        runSuite<bool>([
          ComparisonCase(
            FloatVal(42.0),
            FloatVal(42.0),
            ComparisonOperator.eq,
            true,
            "42.0 == 42.0",
            Context(),
          ),
          ComparisonCase(
            FloatVal(42.0),
            FloatVal(43.0),
            ComparisonOperator.eq,
            false,
            "42.0 == 43.0",
            Context(),
          ),
          ComparisonCase(
            FloatVal(43.0),
            FloatVal(42.0),
            ComparisonOperator.eq,
            false,
            "43.0 == 42.0",
            Context(),
          ),
        ]);
      });

      group("Identifiers only", () {
        runSuite<bool>([
          ComparisonCase(
            IdentifierVal("A"),
            IdentifierVal("A"),
            ComparisonOperator.eq,
            true,
            "A == A",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ComparisonOperator.eq,
            false,
            "A == B",
            Context.withVariables({"A": 42, "B": 43}),
          ),
          ComparisonCase(
            IdentifierVal("B"),
            IdentifierVal("A"),
            ComparisonOperator.eq,
            false,
            "B == A",
            Context.withVariables({"A": 42, "B": 43}),
          ),
        ]);
      });

      group("Mixed types", () {
        runSuite<bool>([
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(43),
            ComparisonOperator.eq,
            false,
            "A == 43",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(42),
            ComparisonOperator.eq,
            true,
            "A == 42",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(41),
            ComparisonOperator.eq,
            false,
            "A == 41",
            Context.withVariables({"A": 42}),
          ),

          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(43.0),
            ComparisonOperator.eq,
            false,
            "A == 43.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(42.0),
            ComparisonOperator.eq,
            true,
            "A == 42.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(41.0),
            ComparisonOperator.eq,
            false,
            "A == 41.0",
            Context.withVariables({"A": 42}),
          ),

          ComparisonCase(
            IntVal(43),
            FloatVal(42.0),
            ComparisonOperator.eq,
            false,
            "43 == 42.0",
            Context(),
          ),
          ComparisonCase(
            IntVal(42),
            FloatVal(42.0),
            ComparisonOperator.eq,
            true,
            "42 == 42.0",
            Context(),
          ),
          ComparisonCase(
            IntVal(41),
            FloatVal(42.0),
            ComparisonOperator.eq,
            false,
            "41 == 42.0",
            Context(),
          ),
        ]);
      });
    });
    group("Inequality comparison (!=)", () {
      group("Integers only", () {
        runSuite<bool>([
          ComparisonCase(
            IntVal(42),
            IntVal(42),
            ComparisonOperator.neq,
            false,
            "42 != 42",
            Context(),
          ),
          ComparisonCase(
            IntVal(42),
            IntVal(43),
            ComparisonOperator.neq,
            true,
            "42 != 43",
            Context(),
          ),
          ComparisonCase(
            IntVal(43),
            IntVal(42),
            ComparisonOperator.neq,
            true,
            "43 != 42",
            Context(),
          ),
        ]);
      });

      group("Floats only", () {
        runSuite<bool>([
          ComparisonCase(
            FloatVal(42.0),
            FloatVal(42.0),
            ComparisonOperator.neq,
            false,
            "42.0 != 42.0",
            Context(),
          ),
          ComparisonCase(
            FloatVal(42.0),
            FloatVal(43.0),
            ComparisonOperator.neq,
            true,
            "42.0 != 43.0",
            Context(),
          ),
          ComparisonCase(
            FloatVal(43.0),
            FloatVal(42.0),
            ComparisonOperator.neq,
            true,
            "43.0 != 42.0",
            Context(),
          ),
        ]);
      });

      group("Identifiers only", () {
        runSuite<bool>([
          ComparisonCase(
            IdentifierVal("A"),
            IdentifierVal("A"),
            ComparisonOperator.neq,
            false,
            "A != A",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ComparisonOperator.neq,
            true,
            "A != B",
            Context.withVariables({"A": 42, "B": 43}),
          ),
          ComparisonCase(
            IdentifierVal("B"),
            IdentifierVal("A"),
            ComparisonOperator.neq,
            true,
            "B != A",
            Context.withVariables({"A": 42, "B": 43}),
          ),
        ]);
      });

      group("Mixed types", () {
        runSuite<bool>([
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(43),
            ComparisonOperator.neq,
            true,
            "A != 43",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(42),
            ComparisonOperator.neq,
            false,
            "A != 42",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(41),
            ComparisonOperator.neq,
            true,
            "A != 41",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(43.0),
            ComparisonOperator.neq,
            true,
            "A != 43.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(42.0),
            ComparisonOperator.neq,
            false,
            "A != 42.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(41.0),
            ComparisonOperator.neq,
            true,
            "A != 41.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IntVal(43),
            FloatVal(42.0),
            ComparisonOperator.neq,
            true,
            "43 != 42.0",
            Context(),
          ),
          ComparisonCase(
            IntVal(42),
            FloatVal(42.0),
            ComparisonOperator.neq,
            false,
            "42 != 42.0",
            Context(),
          ),
          ComparisonCase(
            IntVal(41),
            FloatVal(42.0),
            ComparisonOperator.neq,
            true,
            "41 != 42.0",
            Context(),
          ),
        ]);
      });
    });

    group("Less than comparison (<)", () {
      group("Integers only", () {
        runSuite<bool>([
          ComparisonCase(
            IntVal(42),
            IntVal(42),
            ComparisonOperator.lt,
            false,
            "42 < 42",
            Context(),
          ),
          ComparisonCase(
            IntVal(42),
            IntVal(43),
            ComparisonOperator.lt,
            true,
            "42 < 43",
            Context(),
          ),
          ComparisonCase(
            IntVal(43),
            IntVal(42),
            ComparisonOperator.lt,
            false,
            "43 < 42",
            Context(),
          ),
        ]);
      });

      group("Floats only", () {
        runSuite<bool>([
          ComparisonCase(
            FloatVal(42.0),
            FloatVal(42.0),
            ComparisonOperator.lt,
            false,
            "42.0 < 42.0",
            Context(),
          ),
          ComparisonCase(
            FloatVal(42.0),
            FloatVal(43.0),
            ComparisonOperator.lt,
            true,
            "42.0 < 43.0",
            Context(),
          ),
          ComparisonCase(
            FloatVal(43.0),
            FloatVal(42.0),
            ComparisonOperator.lt,
            false,
            "43.0 < 42.0",
            Context(),
          ),
        ]);
      });

      group("Identifiers only", () {
        runSuite<bool>([
          ComparisonCase(
            IdentifierVal("A"),
            IdentifierVal("A"),
            ComparisonOperator.lt,
            false,
            "A < A",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ComparisonOperator.lt,
            true,
            "A < B",
            Context.withVariables({"A": 42, "B": 43}),
          ),
          ComparisonCase(
            IdentifierVal("B"),
            IdentifierVal("A"),
            ComparisonOperator.lt,
            false,
            "B < A",
            Context.withVariables({"A": 42, "B": 43}),
          ),
        ]);
      });

      group("Mixed types", () {
        runSuite<bool>([
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(43),
            ComparisonOperator.lt,
            true,
            "A < 43",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(42),
            ComparisonOperator.lt,
            false,
            "A < 42",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(41),
            ComparisonOperator.lt,
            false,
            "A < 41",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(43.0),
            ComparisonOperator.lt,
            true,
            "A < 43.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(42.0),
            ComparisonOperator.lt,
            false,
            "A < 42.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(41.0),
            ComparisonOperator.lt,
            false,
            "A < 41.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IntVal(43),
            FloatVal(42.0),
            ComparisonOperator.lt,
            false,
            "43 < 42.0",
            Context(),
          ),
          ComparisonCase(
            IntVal(42),
            FloatVal(42.0),
            ComparisonOperator.lt,
            false,
            "42 < 42.0",
            Context(),
          ),
          ComparisonCase(
            IntVal(41),
            FloatVal(42.0),
            ComparisonOperator.lt,
            true,
            "41 < 42.0",
            Context(),
          ),
        ]);
      });
    });

    group("Less than or equal comparison (<=)", () {
      group("Integers only", () {
        runSuite<bool>([
          ComparisonCase(
            IntVal(42),
            IntVal(42),
            ComparisonOperator.lte,
            true,
            "42 <= 42",
            Context(),
          ),
          ComparisonCase(
            IntVal(42),
            IntVal(43),
            ComparisonOperator.lte,
            true,
            "42 <= 43",
            Context(),
          ),
          ComparisonCase(
            IntVal(43),
            IntVal(42),
            ComparisonOperator.lte,
            false,
            "43 <= 42",
            Context(),
          ),
        ]);
      });

      group("Floats only", () {
        runSuite<bool>([
          ComparisonCase(
            FloatVal(42.0),
            FloatVal(42.0),
            ComparisonOperator.lte,
            true,
            "42.0 <= 42.0",
            Context(),
          ),
          ComparisonCase(
            FloatVal(42.0),
            FloatVal(43.0),
            ComparisonOperator.lte,
            true,
            "42.0 <= 43.0",
            Context(),
          ),
          ComparisonCase(
            FloatVal(43.0),
            FloatVal(42.0),
            ComparisonOperator.lte,
            false,
            "43.0 <= 42.0",
            Context(),
          ),
        ]);
      });

      group("Identifiers only", () {
        runSuite<bool>([
          ComparisonCase(
            IdentifierVal("A"),
            IdentifierVal("A"),
            ComparisonOperator.lte,
            true,
            "A <= A",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ComparisonOperator.lte,
            true,
            "A <= B",
            Context.withVariables({"A": 42, "B": 43}),
          ),
          ComparisonCase(
            IdentifierVal("B"),
            IdentifierVal("A"),
            ComparisonOperator.lte,
            false,
            "B <= A",
            Context.withVariables({"A": 42, "B": 43}),
          ),
        ]);
      });

      group("Mixed types", () {
        runSuite<bool>([
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(43),
            ComparisonOperator.lte,
            true,
            "A <= 43",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(42),
            ComparisonOperator.lte,
            true,
            "A <= 42",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(41),
            ComparisonOperator.lte,
            false,
            "A <= 41",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(43.0),
            ComparisonOperator.lte,
            true,
            "A <= 43.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(42.0),
            ComparisonOperator.lte,
            true,
            "A <= 42.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(41.0),
            ComparisonOperator.lte,
            false,
            "A <= 41.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IntVal(43),
            FloatVal(42.0),
            ComparisonOperator.lte,
            false,
            "43 <= 42.0",
            Context(),
          ),
          ComparisonCase(
            IntVal(42),
            FloatVal(42.0),
            ComparisonOperator.lte,
            true,
            "42 <= 42.0",
            Context(),
          ),
          ComparisonCase(
            IntVal(41),
            FloatVal(42.0),
            ComparisonOperator.lte,
            true,
            "41 <= 42.0",
            Context(),
          ),
        ]);
      });
    });

    group("Greater than comparison (>)", () {
      group("Integers only", () {
        runSuite<bool>([
          ComparisonCase(
            IntVal(42),
            IntVal(42),
            ComparisonOperator.gt,
            false,
            "42 > 42",
            Context(),
          ),
          ComparisonCase(
            IntVal(42),
            IntVal(43),
            ComparisonOperator.gt,
            false,
            "42 > 43",
            Context(),
          ),
          ComparisonCase(
            IntVal(43),
            IntVal(42),
            ComparisonOperator.gt,
            true,
            "43 > 42",
            Context(),
          ),
        ]);
      });

      group("Floats only", () {
        runSuite<bool>([
          ComparisonCase(
            FloatVal(42.0),
            FloatVal(42.0),
            ComparisonOperator.gt,
            false,
            "42.0 > 42.0",
            Context(),
          ),
          ComparisonCase(
            FloatVal(42.0),
            FloatVal(43.0),
            ComparisonOperator.gt,
            false,
            "42.0 > 43.0",
            Context(),
          ),
          ComparisonCase(
            FloatVal(43.0),
            FloatVal(42.0),
            ComparisonOperator.gt,
            true,
            "43.0 > 42.0",
            Context(),
          ),
        ]);
      });

      group("Identifiers only", () {
        runSuite<bool>([
          ComparisonCase(
            IdentifierVal("A"),
            IdentifierVal("A"),
            ComparisonOperator.gt,
            false,
            "A > A",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ComparisonOperator.gt,
            false,
            "A > B",
            Context.withVariables({"A": 42, "B": 43}),
          ),
          ComparisonCase(
            IdentifierVal("B"),
            IdentifierVal("A"),
            ComparisonOperator.gt,
            true,
            "B > A",
            Context.withVariables({"A": 42, "B": 43}),
          ),
        ]);
      });

      group("Mixed types", () {
        runSuite<bool>([
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(43),
            ComparisonOperator.gt,
            false,
            "A > 43",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(42),
            ComparisonOperator.gt,
            false,
            "A > 42",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(41),
            ComparisonOperator.gt,
            true,
            "A > 41",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(43.0),
            ComparisonOperator.gt,
            false,
            "A > 43.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(42.0),
            ComparisonOperator.gt,
            false,
            "A > 42.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(41.0),
            ComparisonOperator.gt,
            true,
            "A > 41.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IntVal(43),
            FloatVal(42.0),
            ComparisonOperator.gt,
            true,
            "43 > 42.0",
            Context(),
          ),
          ComparisonCase(
            IntVal(42),
            FloatVal(42.0),
            ComparisonOperator.gt,
            false,
            "42 > 42.0",
            Context(),
          ),
          ComparisonCase(
            IntVal(41),
            FloatVal(42.0),
            ComparisonOperator.gt,
            false,
            "41 > 42.0",
            Context(),
          ),
        ]);
      });
    });

    group("Greater than or equal comparison (gte)", () {
      group("Integers only", () {
        runSuite<bool>([
          ComparisonCase(
            IntVal(42),
            IntVal(42),
            ComparisonOperator.gte,
            true,
            "42 >= 42",
            Context(),
          ),
          ComparisonCase(
            IntVal(42),
            IntVal(43),
            ComparisonOperator.gte,
            false,
            "42 >= 43",
            Context(),
          ),
          ComparisonCase(
            IntVal(43),
            IntVal(42),
            ComparisonOperator.gte,
            true,
            "43 >= 42",
            Context(),
          ),
        ]);
      });

      group("Floats only", () {
        runSuite<bool>([
          ComparisonCase(
            FloatVal(42.0),
            FloatVal(42.0),
            ComparisonOperator.gte,
            true,
            "42.0 >= 42.0",
            Context(),
          ),
          ComparisonCase(
            FloatVal(42.0),
            FloatVal(43.0),
            ComparisonOperator.gte,
            false,
            "42.0 >= 43.0",
            Context(),
          ),
          ComparisonCase(
            FloatVal(43.0),
            FloatVal(42.0),
            ComparisonOperator.gte,
            true,
            "43.0 >= 42.0",
            Context(),
          ),
        ]);
      });

      group("Identifiers only", () {
        runSuite<bool>([
          ComparisonCase(
            IdentifierVal("A"),
            IdentifierVal("A"),
            ComparisonOperator.gte,
            true,
            "A >= A",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ComparisonOperator.gte,
            false,
            "A >= B",
            Context.withVariables({"A": 42, "B": 43}),
          ),
          ComparisonCase(
            IdentifierVal("B"),
            IdentifierVal("A"),
            ComparisonOperator.gte,
            true,
            "B >= A",
            Context.withVariables({"A": 42, "B": 43}),
          ),
        ]);
      });

      group("Mixed types", () {
        runSuite<bool>([
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(43),
            ComparisonOperator.gte,
            false,
            "A >= 43",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(42),
            ComparisonOperator.gte,
            true,
            "A >= 42",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            IntVal(41),
            ComparisonOperator.gte,
            true,
            "A >= 41",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(43.0),
            ComparisonOperator.gte,
            false,
            "A >= 43.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(42.0),
            ComparisonOperator.gte,
            true,
            "A >= 42.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IdentifierVal("A"),
            FloatVal(41.0),
            ComparisonOperator.gte,
            true,
            "A >= 41.0",
            Context.withVariables({"A": 42}),
          ),
          ComparisonCase(
            IntVal(43),
            FloatVal(42.0),
            ComparisonOperator.gte,
            true,
            "43 >= 42.0",
            Context(),
          ),
          ComparisonCase(
            IntVal(42),
            FloatVal(42.0),
            ComparisonOperator.gte,
            true,
            "42 >= 42.0",
            Context(),
          ),
          ComparisonCase(
            IntVal(41),
            FloatVal(42.0),
            ComparisonOperator.gte,
            false,
            "41 >= 42.0",
            Context(),
          ),
        ]);
      });
    });
  });

  group("Arithmetic Expressions", () {
    group("Addition", () {
      group("Integers only", () {
        runSuite<num>([
          ArithmeticCase(
            IntVal(2),
            IntVal(3),
            ArithmeticOperator.add,
            5,
            "2 + 3",
            Context(),
          ),
          ArithmeticCase(
            IntVal(-2),
            IntVal(3),
            ArithmeticOperator.add,
            1,
            "-2 + 3",
            Context(),
          ),
          ArithmeticCase(
            IntVal(0),
            IntVal(2),
            ArithmeticOperator.add,
            2,
            "0 + 2",
            Context(),
          ),
          ArithmeticCase(
            IntVal(2),
            IntVal(0),
            ArithmeticOperator.add,
            2,
            "2 + 0",
            Context(),
          ),
        ]);
      });

      group("Floats only", () {
        runSuite<num>([
          ArithmeticCase(
            FloatVal(2.5),
            FloatVal(3.0),
            ArithmeticOperator.add,
            5.5,
            "2.5 + 3.0",
            Context(),
          ),
          ArithmeticCase(
            FloatVal(-2.5),
            FloatVal(3.0),
            ArithmeticOperator.add,
            0.5,
            "-2.5 + 3.0",
            Context(),
          ),
          ArithmeticCase(
            FloatVal(0.0),
            FloatVal(2.5),
            ArithmeticOperator.add,
            2.5,
            "0.0 + 2.5",
            Context(),
          ),
          ArithmeticCase(
            FloatVal(2.5),
            FloatVal(0.0),
            ArithmeticOperator.add,
            2.5,
            "2.5 + 0.0",
            Context(),
          ),
        ]);
      });

      group("Identifiers only", () {
        runSuite<num>([
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.add,
            5,
            "A + B",
            Context.withVariables({"A": 2, "B": 3}),
          ),
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.add,
            1,
            "A + B",
            Context.withVariables({"A": -2, "B": 3}),
          ),
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.add,
            2,
            "A + B",
            Context.withVariables({"A": 0, "B": 2}),
          ),
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.add,
            2,
            "A + B",
            Context.withVariables({"A": 2, "B": 0}),
          ),
        ]);

        group("Mixed types", () {
          runSuite<num>([
            ArithmeticCase(
              IdentifierVal("A"),
              IntVal(4),
              ArithmeticOperator.add,
              6,
              "A + 4",
              Context.withVariables({"A": 2}),
            ),
            ArithmeticCase(
              FloatVal(4.0),
              IdentifierVal("A"),
              ArithmeticOperator.add,
              6,
              "4.0 + A",
              Context.withVariables({"A": 2}),
            ),
          ]);
        });
      });
    });

    group("Subtraction", () {
      group("Integers only", () {
        runSuite<num>([
          ArithmeticCase(
            IntVal(5),
            IntVal(3),
            ArithmeticOperator.sub,
            2,
            "5 - 3",
            Context(),
          ),
          ArithmeticCase(
            IntVal(2),
            IntVal(3),
            ArithmeticOperator.sub,
            -1,
            "2 - 3",
            Context(),
          ),
          ArithmeticCase(
            IntVal(0),
            IntVal(2),
            ArithmeticOperator.sub,
            -2,
            "0 - 2",
            Context(),
          ),
          ArithmeticCase(
            IntVal(2),
            IntVal(0),
            ArithmeticOperator.sub,
            2,
            "2 - 0",
            Context(),
          ),
        ]);
      });

      group("Floats only", () {
        runSuite<num>([
          ArithmeticCase(
            FloatVal(5.5),
            FloatVal(3.0),
            ArithmeticOperator.sub,
            2.5,
            "5.5 - 3.0",
            Context(),
          ),
          ArithmeticCase(
            FloatVal(2.5),
            FloatVal(3.0),
            ArithmeticOperator.sub,
            -0.5,
            "2.5 - 3.0",
            Context(),
          ),
          ArithmeticCase(
            FloatVal(0.0),
            FloatVal(2.5),
            ArithmeticOperator.sub,
            -2.5,
            "0.0 - 2.5",
            Context(),
          ),
          ArithmeticCase(
            FloatVal(2.5),
            FloatVal(0.0),
            ArithmeticOperator.sub,
            2.5,
            "2.5 - 0.0",
            Context(),
          ),
        ]);
      });

      group("Identifiers only", () {
        runSuite<num>([
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.sub,
            2,
            "A - B",
            Context.withVariables({"A": 5, "B": 3}),
          ),
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.sub,
            -1,
            "A - B",
            Context.withVariables({"A": 2, "B": 3}),
          ),
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.sub,
            -2,
            "A - B",
            Context.withVariables({"A": 0, "B": 2}),
          ),
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.sub,
            2,
            "A - B",
            Context.withVariables({"A": 2, "B": 0}),
          ),
        ]);
      });

      group("Mixed types", () {
        runSuite<num>([
          ArithmeticCase(
            IdentifierVal("A"),
            IntVal(4),
            ArithmeticOperator.sub,
            6,
            "A - 4",
            Context.withVariables({"A": 10}),
          ),
          ArithmeticCase(
            FloatVal(10.0),
            IdentifierVal("A"),
            ArithmeticOperator.sub,
            8,
            "10.0 - A",
            Context.withVariables({"A": 2}),
          ),
        ]);
      });
    });

    group("Multiplication", () {
      group("Integers only", () {
        runSuite<num>([
          ArithmeticCase(
            IntVal(2),
            IntVal(3),
            ArithmeticOperator.mul,
            6,
            "2 * 3",
            Context(),
          ),
          ArithmeticCase(
            IntVal(-2),
            IntVal(3),
            ArithmeticOperator.mul,
            -6,
            "-2 * 3",
            Context(),
          ),
          ArithmeticCase(
            IntVal(0),
            IntVal(2),
            ArithmeticOperator.mul,
            0,
            "0 * 2",
            Context(),
          ),
          ArithmeticCase(
            IntVal(2),
            IntVal(0),
            ArithmeticOperator.mul,
            0,
            "2 * 0",
            Context(),
          ),
        ]);
      });

      group("Floats only", () {
        runSuite<num>([
          ArithmeticCase(
            FloatVal(2.5),
            FloatVal(2.0),
            ArithmeticOperator.mul,
            5.0,
            "2.5 * 2.0",
            Context(),
          ),
          ArithmeticCase(
            FloatVal(-2.5),
            FloatVal(3.0),
            ArithmeticOperator.mul,
            -7.5,
            "-2.5 * 3.0",
            Context(),
          ),
          ArithmeticCase(
            FloatVal(0.0),
            FloatVal(2.5),
            ArithmeticOperator.mul,
            0.0,
            "0.0 * 2.5",
            Context(),
          ),
          ArithmeticCase(
            FloatVal(2.5),
            FloatVal(0.0),
            ArithmeticOperator.mul,
            0.0,
            "2.5 * 0.0",
            Context(),
          ),
        ]);
      });

      group("Identifiers only", () {
        runSuite<num>([
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.mul,
            6,
            "A * B",
            Context.withVariables({"A": 2, "B": 3}),
          ),
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.mul,
            -6,
            "A * B",
            Context.withVariables({"A": -2, "B": 3}),
          ),
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.mul,
            0,
            "A * B",
            Context.withVariables({"A": 0, "B": 2}),
          ),
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.mul,
            0,
            "A * B",
            Context.withVariables({"A": 2, "B": 0}),
          ),
        ]);
      });

      group("Mixed types", () {
        runSuite<num>([
          ArithmeticCase(
            IdentifierVal("A"),
            IntVal(4),
            ArithmeticOperator.mul,
            8,
            "A * 4",
            Context.withVariables({"A": 2}),
          ),
          ArithmeticCase(
            FloatVal(4.0),
            IdentifierVal("A"),
            ArithmeticOperator.mul,
            8.0,
            "4.0 * A",
            Context.withVariables({"A": 2}),
          ),
        ]);
      });
    });

    group("Division", () {
      group("Integers only", () {
        runSuite<num>([
          ArithmeticCase(
            IntVal(6),
            IntVal(3),
            ArithmeticOperator.div,
            2,
            "6 / 3",
            Context(),
          ),
          ArithmeticCase(
            IntVal(-6),
            IntVal(3),
            ArithmeticOperator.div,
            -2,
            "-6 / 3",
            Context(),
          ),
          ArithmeticCase(
            IntVal(0),
            IntVal(2),
            ArithmeticOperator.div,
            0,
            "0 / 2",
            Context(),
          ),
          ArithmeticCase(
            IntVal(2),
            IntVal(1),
            ArithmeticOperator.div,
            2,
            "2 / 1",
            Context(),
          ),
        ]);
      });

      group("Floats only", () {
        runSuite<num>([
          ArithmeticCase(
            FloatVal(5.0),
            FloatVal(2.0),
            ArithmeticOperator.div,
            2.5,
            "5.0 / 2.0",
            Context(),
          ),
          ArithmeticCase(
            FloatVal(-7.5),
            FloatVal(3.0),
            ArithmeticOperator.div,
            -2.5,
            "-7.5 / 3.0",
            Context(),
          ),
          ArithmeticCase(
            FloatVal(0.0),
            FloatVal(2.5),
            ArithmeticOperator.div,
            0.0,
            "0.0 / 2.5",
            Context(),
          ),
          ArithmeticCase(
            FloatVal(2.5),
            FloatVal(1.0),
            ArithmeticOperator.div,
            2.5,
            "2.5 / 1.0",
            Context(),
          ),
        ]);
      });

      group("Identifiers only", () {
        runSuite<num>([
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.div,
            2,
            "A / B",
            Context.withVariables({"A": 6, "B": 3}),
          ),
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.div,
            -2,
            "A / B",
            Context.withVariables({"A": -6, "B": 3}),
          ),
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.div,
            0,
            "A / B",
            Context.withVariables({"A": 0, "B": 2}),
          ),
          ArithmeticCase(
            IdentifierVal("A"),
            IdentifierVal("B"),
            ArithmeticOperator.div,
            2,
            "A / B",
            Context.withVariables({"A": 2, "B": 1}),
          ),
        ]);
      });

      group("Mixed types", () {
        runSuite<num>([
          ArithmeticCase(
            IdentifierVal("A"),
            IntVal(4),
            ArithmeticOperator.div,
            2,
            "A / 4",
            Context.withVariables({"A": 8}),
          ),
          ArithmeticCase(
            FloatVal(10.0),
            IdentifierVal("A"),
            ArithmeticOperator.div,
            5.0,
            "10.0 / A",
            Context.withVariables({"A": 2}),
          ),
        ]);
      });
    });
  });
}
