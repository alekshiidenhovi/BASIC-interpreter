import "context.dart";
import "errors.dart";
import "dart:math";

/// Built-in function that computes the square root of a number.
double builtinSqr(Context context) {
  final x = context.lookupVariable<num>("X").toDouble();
  if (x < 0) {
    throw NegativeSquareRootError(context.getStatementCount(), x);
  }
  return sqrt(x);
}
