import 'package:basic_interpreter/expressions.dart';
import 'package:basic_interpreter/parser.dart';
import 'package:basic_interpreter/statements.dart';
import 'package:basic_interpreter/tokens.dart';
import 'package:test/test.dart';

void main() {
  test("Parse LET statement", () {
    final tokens = [
      Token(Category.numberLiteral, "10"),
      Token(Category.let, "LET"),
      Token(Category.identifier, "A"),
      Token(Category.equals, "="),
      Token(Category.numberLiteral, "5"),
    ];

    final parser = Parser(tokens);
    final program = parser.parse();

    expect(program[10], isA<LetStatement>());
  });
}
