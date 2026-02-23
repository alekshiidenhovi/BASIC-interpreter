sealed class Operator {
  const Operator();
}

sealed class BinaryOperator implements Operator {
  const BinaryOperator();
}

/// Represents the possible unary operators used in calculations.
///
/// Available operators:
/// - `negate`: Negation
enum UnaryOperator implements Operator { negate }

/// Represents the possible arithmetic operators used in calculations.
///
/// Available operators:
/// - `add`: Addition
/// - `sub`: Subtraction
/// - `mul`: Multiplication
/// - `div`: Division
enum ArithmeticOperator implements BinaryOperator { add, sub, mul, div, exp }

/// Represents the possible comparison operators used in filtering or ordering data.
///
/// Available operators:
/// - `eq`: Equal to
/// - `neq`: Not equal to
/// - `gt`: Greater than
/// - `lt`: Less than
/// - `gte`: Greater than or equal to
/// - `lte`: Less than or equal to
enum ComparisonOperator implements BinaryOperator { eq, neq, gt, lt, gte, lte }
