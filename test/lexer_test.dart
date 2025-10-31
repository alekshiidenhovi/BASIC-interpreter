import 'package:basic_interpreter/lexer.dart';
import 'package:basic_interpreter/tokens.dart';
import 'package:test/test.dart';

void main() {
  test('Number literals: 10 4.2', () {
    var lexer = Lexer('10 4.2');
    expect(lexer.tokenize(), [
      Token(Category.numberLiteral, '10'),
      Token(Category.numberLiteral, '4.2'),
    ]);
  });

  test('String literals: "Hello, BASIC!"', () {
    var lexer = Lexer('"Hello, BASIC!"');
    expect(lexer.tokenize(), [Token(Category.stringLiteral, 'Hello, BASIC!')]);
  });

  test('String literals: "Hello", "BASIC"', () {
    var lexer = Lexer('"Hello", "BASIC"');
    expect(lexer.tokenize(), [
      Token(Category.stringLiteral, 'Hello'),
      Token(Category.stringLiteral, 'BASIC'),
    ]);
  });
}
