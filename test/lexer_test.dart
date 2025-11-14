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

  group("Keywords and identifiers", () {
    test("Identifier with a single letter", () {
      var lexer = Lexer('LET PRINT A');
      expect(lexer.tokenize(), [
        Token(Category.let, 'LET'),
        Token(Category.print, 'PRINT'),
        Token(Category.identifier, 'A'),
      ]);
    });

    test("Identifier with multiple letters", () {
      var lexer = Lexer('LET PRINT ABC');
      expect(lexer.tokenize(), [
        Token(Category.let, 'LET'),
        Token(Category.print, 'PRINT'),
        Token(Category.identifier, 'ABC'),
      ]);
    });

    test("Identifier with numbers", () {
      var lexer = Lexer('LET PRINT A1');
      expect(lexer.tokenize(), [
        Token(Category.let, 'LET'),
        Token(Category.print, 'PRINT'),
        Token(Category.identifier, 'A1'),
      ]);
    });

    test("Uppercase keywords", () {
      var lexer = Lexer('LET PRINT GOTO IF THEN END');
      expect(lexer.tokenize(), [
        Token(Category.let, 'LET'),
        Token(Category.print, 'PRINT'),
        Token(Category.goto, 'GOTO'),
        Token(Category.ifToken, 'IF'),
        Token(Category.then, 'THEN'),
        Token(Category.endToken, 'END'),
      ]);
    });

    test("Lowercase keywords", () {
      var lexer = Lexer('let print goto if then end');
      expect(lexer.tokenize(), [
        Token(Category.let, 'LET'),
        Token(Category.print, 'PRINT'),
        Token(Category.goto, 'GOTO'),
        Token(Category.ifToken, 'IF'),
        Token(Category.then, 'THEN'),
        Token(Category.endToken, 'END'),
      ]);
    });
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

  test('Goto statement: 10 GOTO 20', () {
    var lexer = Lexer('10 GOTO 20');
    expect(lexer.tokenize(), [
      Token(Category.numberLiteral, '10'),
      Token(Category.goto, 'GOTO'),
      Token(Category.numberLiteral, '20'),
    ]);
  });

  group("If statement", () {
    test("equal comparison operator", () {
      var lexer = Lexer('20 IF A = 5 THEN 40');
      expect(lexer.tokenize(), [
        Token(Category.numberLiteral, '20'),
        Token(Category.ifToken, 'IF'),
        Token(Category.identifier, 'A'),
        Token(Category.equals, '='),
        Token(Category.numberLiteral, '5'),
        Token(Category.then, 'THEN'),
        Token(Category.numberLiteral, '40'),
      ]);
    });

    test("greater than comparison operator", () {
      var lexer = Lexer('20 IF A > 5 THEN 40');
      expect(lexer.tokenize(), [
        Token(Category.numberLiteral, '20'),
        Token(Category.ifToken, 'IF'),
        Token(Category.identifier, 'A'),
        Token(Category.greaterThan, '>'),
        Token(Category.numberLiteral, '5'),
        Token(Category.then, 'THEN'),
        Token(Category.numberLiteral, '40'),
      ]);
    });

    test("less than comparison operator", () {
      var lexer = Lexer('20 IF A < 5 THEN 40');
      expect(lexer.tokenize(), [
        Token(Category.numberLiteral, '20'),
        Token(Category.ifToken, 'IF'),
        Token(Category.identifier, 'A'),
        Token(Category.lessThan, '<'),
        Token(Category.numberLiteral, '5'),
        Token(Category.then, 'THEN'),
        Token(Category.numberLiteral, '40'),
      ]);
    });

    test("greater than or equal comparison operator", () {
      var lexer = Lexer('20 IF A >= 5 THEN 40');
      expect(lexer.tokenize(), [
        Token(Category.numberLiteral, '20'),
        Token(Category.ifToken, 'IF'),
        Token(Category.identifier, 'A'),
        Token(Category.greaterThanOrEqual, '>='),
        Token(Category.numberLiteral, '5'),
        Token(Category.then, 'THEN'),
        Token(Category.numberLiteral, '40'),
      ]);
    });

    test("less than or equal comparison operator", () {
      var lexer = Lexer('20 IF A <= 5 THEN 40');
      expect(lexer.tokenize(), [
        Token(Category.numberLiteral, '20'),
        Token(Category.ifToken, 'IF'),
        Token(Category.identifier, 'A'),
        Token(Category.lessThanOrEqual, '<='),
        Token(Category.numberLiteral, '5'),
        Token(Category.then, 'THEN'),
        Token(Category.numberLiteral, '40'),
      ]);
    });

    test("not equal comparison operator", () {
      var lexer = Lexer('20 IF A <> 5 THEN 40');
      expect(lexer.tokenize(), [
        Token(Category.numberLiteral, '20'),
        Token(Category.ifToken, 'IF'),
        Token(Category.identifier, 'A'),
        Token(Category.notEqual, '<>'),
        Token(Category.numberLiteral, '5'),
        Token(Category.then, 'THEN'),
        Token(Category.numberLiteral, '40'),
      ]);
    });
  });
}
