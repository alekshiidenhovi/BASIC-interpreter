import 'package:basic_interpreter/lexer.dart';
import 'package:basic_interpreter/tokens.dart';
import 'package:test/test.dart';

void main() {
  group("Literals", () {
    test('Positive number literals', () {
      var lexer = Lexer('10 4.2');
      expect(lexer.tokenize(), [
        Token(Category.numberLiteral, '10'),
        Token(Category.numberLiteral, '4.2'),
      ]);
    });

    test("Zero number literal", () {
      var lexer = Lexer('0');
      expect(lexer.tokenize(), [Token(Category.numberLiteral, '0')]);
    });

    test('Negative number literals', () {
      var lexer = Lexer('-10 -4.2');
      expect(lexer.tokenize(), [
        Token(Category.numberLiteral, '-10'),
        Token(Category.numberLiteral, '-4.2'),
      ]);
    });

    test('String literals: "Hello, BASIC!"', () {
      var lexer = Lexer('"Hello, BASIC!"');
      expect(lexer.tokenize(), [
        Token(Category.stringLiteral, 'Hello, BASIC!'),
      ]);
    });

    test('String literals: "Hello", "BASIC"', () {
      var lexer = Lexer('"Hello", "BASIC"');
      expect(lexer.tokenize(), [
        Token(Category.stringLiteral, 'Hello'),
        Token(Category.comma, ','),
        Token(Category.stringLiteral, 'BASIC'),
      ]);
    });

    test("Semicolon separator", () {
      var lexer = Lexer("PRINT 1; 2");
      expect(lexer.tokenize(), [
        Token(Category.print, 'PRINT'),
        Token(Category.numberLiteral, '1'),
        Token(Category.semicolon, ';'),
        Token(Category.numberLiteral, '2'),
      ]);
    });
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

  group("Arithmetic operators", () {
    test("Addition", () {
      var lexer = Lexer('10 + 20');
      expect(lexer.tokenize(), [
        Token(Category.numberLiteral, '10'),
        Token(Category.plus, '+'),
        Token(Category.numberLiteral, '20'),
      ]);
    });

    test("Subtraction", () {
      var lexer = Lexer('10 - 20');
      expect(lexer.tokenize(), [
        Token(Category.numberLiteral, '10'),
        Token(Category.minus, '-'),
        Token(Category.numberLiteral, '20'),
      ]);
    });

    test("Multiplication", () {
      var lexer = Lexer('10 * 20');
      expect(lexer.tokenize(), [
        Token(Category.numberLiteral, '10'),
        Token(Category.times, '*'),
        Token(Category.numberLiteral, '20'),
      ]);
    });

    test("Division", () {
      var lexer = Lexer('10 / 20');
      expect(lexer.tokenize(), [
        Token(Category.numberLiteral, '10'),
        Token(Category.divide, '/'),
        Token(Category.numberLiteral, '20'),
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

  test("For statement", () {
    var lexer = Lexer("""10 FOR I = 1 TO 10 STEP 2
20 PRINT I
30 NEXT I
40 END""");
    expect(lexer.tokenize(), [
      Token(Category.numberLiteral, '10'),
      Token(Category.forToken, 'FOR'),
      Token(Category.identifier, 'I'),
      Token(Category.equals, '='),
      Token(Category.numberLiteral, '1'),
      Token(Category.toToken, 'TO'),
      Token(Category.numberLiteral, '10'),
      Token(Category.stepToken, 'STEP'),
      Token(Category.numberLiteral, '2'),
      Token(Category.endOfLine, '\n'), // 10 FOR i = 1 TO 10 STEP 2
      Token(Category.numberLiteral, '20'),
      Token(Category.print, 'PRINT'),
      Token(Category.identifier, 'I'),
      Token(Category.endOfLine, '\n'), // 20 PRINT I
      Token(Category.numberLiteral, '30'),
      Token(Category.nextToken, 'NEXT'),
      Token(Category.identifier, 'I'),
      Token(Category.endOfLine, '\n'), // 30 NEXT I
      Token(Category.numberLiteral, '40'),
      Token(Category.endToken, 'END'), // 40 END
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
