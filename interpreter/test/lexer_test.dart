import 'package:basic_interpreter/lexer.dart';
import 'package:basic_interpreter/tokens.dart';
import 'package:test/test.dart';

void main() {
  group("Literals", () {
    test('Positive number literals', () {
      var lexer = Lexer('10 4.2');
      expect(lexer.tokenize(), [
        IntegerLiteralToken(10),
        FloatingPointLiteralToken(4.2),
      ]);
    });

    test("Zero number literal", () {
      var lexer = Lexer('0');
      expect(lexer.tokenize(), [IntegerLiteralToken(0)]);
    });

    test('Negative number literals', () {
      var lexer = Lexer('-4.2 -10');
      expect(lexer.tokenize(), [
        FloatingPointLiteralToken(-4.2),
        IntegerLiteralToken(-10),
      ]);
    });

    test('String literals: "Hello, BASIC!"', () {
      var lexer = Lexer('"Hello, BASIC!"');
      expect(lexer.tokenize(), [StringLiteralToken('Hello, BASIC!')]);
    });

    test('String literals: "Hello", "BASIC"', () {
      var lexer = Lexer('"Hello", "BASIC"');
      expect(lexer.tokenize(), [
        StringLiteralToken('Hello'),
        CommaToken(),
        StringLiteralToken('BASIC'),
      ]);
    });

    test("Semicolon separator", () {
      var lexer = Lexer("PRINT 1; 2");
      expect(lexer.tokenize(), [
        PrintKeywordToken(),
        IntegerLiteralToken(1),
        SemicolonToken(),
        IntegerLiteralToken(2),
      ]);
    });
  });

  group("Keywords and identifiers", () {
    test("Identifier with a single letter", () {
      var lexer = Lexer('LET PRINT A');
      expect(lexer.tokenize(), [
        LetKeywordToken(),
        PrintKeywordToken(),
        IdentifierToken('A'),
      ]);
    });

    test("Identifier with multiple letters", () {
      var lexer = Lexer('LET PRINT ABC');
      expect(lexer.tokenize(), [
        LetKeywordToken(),
        PrintKeywordToken(),
        IdentifierToken('ABC'),
      ]);
    });

    test("Identifier with numbers", () {
      var lexer = Lexer('LET PRINT A1');
      expect(lexer.tokenize(), [
        LetKeywordToken(),
        PrintKeywordToken(),
        IdentifierToken('A1'),
      ]);
    });

    test("Uppercase keywords", () {
      var lexer = Lexer('LET PRINT IF THEN END');
      expect(lexer.tokenize(), [
        LetKeywordToken(),
        PrintKeywordToken(),
        IfKeywordToken(),
        ThenKeywordToken(),
        EndKeywordToken(),
      ]);
    });

    test("Lowercase keywords", () {
      var lexer = Lexer('let print if then end');
      expect(lexer.tokenize(), [
        LetKeywordToken(),
        PrintKeywordToken(),
        IfKeywordToken(),
        ThenKeywordToken(),
        EndKeywordToken(),
      ]);
    });
  });

  group("Arithmetic operators", () {
    test("All operators", () {
      var lexer = Lexer('10 + 20.5 - A * 40 / -50.5');
      expect(lexer.tokenize(), [
        IntegerLiteralToken(10),
        PlusToken(),
        FloatingPointLiteralToken(20.5),
        MinusToken(),
        IdentifierToken('A'),
        TimesToken(),
        IntegerLiteralToken(40),
        DivideToken(),
        FloatingPointLiteralToken(-50.5),
      ]);
    });
  });

  test('Comma, equals, and new line: , = \n', () {
    var lexer = Lexer(', = \n');
    expect(lexer.tokenize(), [CommaToken(), EqualsToken(), EndOfLineToken()]);
  });

  test('Double minus token: --', () {
    var lexer = Lexer('--');
    expect(lexer.tokenize(), [DoubleMinusToken()]);
  });

  test("Expressions with parentheses", () {
    var lexer = Lexer('LET A = (10 + 20) * 30 / (40 - 50)');
    expect(lexer.tokenize(), [
      LetKeywordToken(),
      IdentifierToken('A'),
      EqualsToken(),
      OpenParenToken(),
      IntegerLiteralToken(10),
      PlusToken(),
      IntegerLiteralToken(20),
      CloseParenToken(),
      TimesToken(),
      IntegerLiteralToken(30),
      DivideToken(),
      OpenParenToken(),
      IntegerLiteralToken(40),
      MinusToken(),
      IntegerLiteralToken(50),
      CloseParenToken(),
    ]);
  });

  test('Full program', () {
    var lexer = Lexer('''10 LET A = 5
20 PRINT A, "Hello, BASIC!"''');
    expect(lexer.tokenize(), [
      IntegerLiteralToken(10),
      LetKeywordToken(),
      IdentifierToken('A'),
      EqualsToken(),
      IntegerLiteralToken(5),
      EndOfLineToken(),
      IntegerLiteralToken(20),
      PrintKeywordToken(),
      IdentifierToken('A'),
      CommaToken(),
      StringLiteralToken('Hello, BASIC!'),
    ]);
  });

  test("For statement", () {
    var lexer = Lexer("""10 FOR I = 1 TO 10 STEP 2
20 PRINT I
30 NEXT I
40 END""");
    expect(lexer.tokenize(), [
      IntegerLiteralToken(10),
      ForKeywordToken(),
      IdentifierToken('I'),
      EqualsToken(),
      IntegerLiteralToken(1),
      ToKeywordToken(),
      IntegerLiteralToken(10),
      StepKeywordToken(),
      IntegerLiteralToken(2),
      EndOfLineToken(), // 10 FOR i = 1 TO 10 STEP 2
      IntegerLiteralToken(20),
      PrintKeywordToken(),
      IdentifierToken('I'),
      EndOfLineToken(), // 20 PRINT I
      IntegerLiteralToken(30),
      NextKeywordToken(),
      IdentifierToken('I'),
      EndOfLineToken(), // 30 NEXT I
      IntegerLiteralToken(40),
      EndKeywordToken(), // 40 END
    ]);
  });

  group("If statement", () {
    test("equal comparison operator", () {
      var lexer = Lexer('20 IF A = 5 THEN 40');
      expect(lexer.tokenize(), [
        IntegerLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken('A'),
        EqualsToken(),
        IntegerLiteralToken(5),
        ThenKeywordToken(),
        IntegerLiteralToken(40),
      ]);
    });
  });

  group("Comments", () {
    test("REM statement 1", () {
      var lexer = Lexer('10 REM This is a comment');
      expect(lexer.tokenize(), [
        IntegerLiteralToken(10),
        RemKeywordToken(),
        IdentifierToken('This'),
        IdentifierToken('is'),
        IdentifierToken('a'),
        IdentifierToken('comment'),
      ]);
    });

    test("REM statement 2", () {
      var lexer = Lexer('10 REM THERE ARE NUMBERS 123.456');
      expect(lexer.tokenize(), [
        IntegerLiteralToken(10),
        RemKeywordToken(),
        IdentifierToken('THERE'),
        IdentifierToken('ARE'),
        IdentifierToken('NUMBERS'),
        FloatingPointLiteralToken(123.456),
      ]);
    });
  });
}
