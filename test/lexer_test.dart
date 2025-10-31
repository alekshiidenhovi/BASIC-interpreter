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
      Token(Category.comma, ','),
      Token(Category.stringLiteral, 'BASIC'),
    ]);
  });

  test('Keywords and identifiers: LET PRINT A', () {
    var lexer = Lexer('LET PRINT A');
    expect(lexer.tokenize(), [
      Token(Category.let, 'LET'),
      Token(Category.print, 'PRINT'),
      Token(Category.identifier, 'A'),
    ]);
  });

  test('Comma, equals, and new line: , = \n', () {
    var lexer = Lexer(', = \n');
    expect(lexer.tokenize(), [
      Token(Category.comma, ','),
      Token(Category.equals, '='),
      Token(Category.endOfLine, '\n'),
    ]);
  });

  test('Full program', () {
    var lexer = Lexer('''10 LET A = 5
20 PRINT A, "Hello, BASIC!"''');
    expect(lexer.tokenize(), [
      Token(Category.numberLiteral, '10'),
      Token(Category.let, 'LET'),
      Token(Category.identifier, 'A'),
      Token(Category.equals, '='),
      Token(Category.numberLiteral, '5'),
      Token(Category.endOfLine, '\n'),
      Token(Category.numberLiteral, '20'),
      Token(Category.print, 'PRINT'),
      Token(Category.identifier, 'A'),
      Token(Category.comma, ','),
      Token(Category.stringLiteral, 'Hello, BASIC!'),
    ]);
  });
}
