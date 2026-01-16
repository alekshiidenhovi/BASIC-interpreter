import 'package:basic_interpreter/lexer.dart';
import 'package:basic_interpreter/tokens.dart';
import 'package:test/test.dart';

void main() {
  group("Literals", () {
    test('Positive number literals', () {
      var lexer = Lexer('10 4.2');
      expect(lexer.tokenize(), [
        NumberLiteralToken(10),
        NumberLiteralToken(4.2),
      ]);
    });

    test("Zero number literal", () {
      var lexer = Lexer('0');
      expect(lexer.tokenize(), [NumberLiteralToken(0)]);
    });

    test('Negative number literals', () {
      var lexer = Lexer('-10 -4.2');
      expect(lexer.tokenize(), [
        NumberLiteralToken(-10),
        NumberLiteralToken(-4.2),
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
        NumberLiteralToken(1),
        SemicolonToken(),
        NumberLiteralToken(2),
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
      var lexer = Lexer('LET PRINT GOTO IF THEN END');
      expect(lexer.tokenize(), [
        LetKeywordToken(),
        PrintKeywordToken(),
        GotoKeywordToken(),
        IfKeywordToken(),
        ThenKeywordToken(),
        EndKeywordToken(),
      ]);
    });

    test("Lowercase keywords", () {
      var lexer = Lexer('let print goto if then end');
      expect(lexer.tokenize(), [
        LetKeywordToken(),
        PrintKeywordToken(),
        GotoKeywordToken(),
        IfKeywordToken(),
        ThenKeywordToken(),
        EndKeywordToken(),
      ]);
    });
  });

  group("Arithmetic operators", () {
    test("Addition", () {
      var lexer = Lexer('10 + 20');
      expect(lexer.tokenize(), [
        NumberLiteralToken(10),
        PlusToken(),
        NumberLiteralToken(20),
      ]);
    });

    test("Subtraction", () {
      var lexer = Lexer('10 - 20');
      expect(lexer.tokenize(), [
        NumberLiteralToken(10),
        MinusToken(),
        NumberLiteralToken(20),
      ]);
    });

    test("Multiplication", () {
      var lexer = Lexer('10 * 20');
      expect(lexer.tokenize(), [
        NumberLiteralToken(10),
        TimesToken(),
        NumberLiteralToken(20),
      ]);
    });

    test("Division", () {
      var lexer = Lexer('10 / 20');
      expect(lexer.tokenize(), [
        NumberLiteralToken(10),
        DivideToken(),
        NumberLiteralToken(20),
      ]);
    });
  });

  test('Comma, equals, and new line: , = \n', () {
    var lexer = Lexer(', = \n');
    expect(lexer.tokenize(), [CommaToken(), EqualsToken(), EndOfLineToken()]);
  });

  test('Full program', () {
    var lexer = Lexer('''10 LET A = 5
20 PRINT A, "Hello, BASIC!"''');
    expect(lexer.tokenize(), [
      NumberLiteralToken(10),
      LetKeywordToken(),
      IdentifierToken('A'),
      EqualsToken(),
      NumberLiteralToken(5),
      EndOfLineToken(),
      NumberLiteralToken(20),
      PrintKeywordToken(),
      IdentifierToken('A'),
      CommaToken(),
      StringLiteralToken('Hello, BASIC!'),
    ]);
  });

  test('Goto statement: 10 GOTO 20', () {
    var lexer = Lexer('10 GOTO 20');
    expect(lexer.tokenize(), [
      NumberLiteralToken(10),
      GotoKeywordToken(),
      NumberLiteralToken(20),
    ]);
  });

  test("For statement", () {
    var lexer = Lexer("""10 FOR I = 1 TO 10 STEP 2
20 PRINT I
30 NEXT I
40 END""");
    expect(lexer.tokenize(), [
      NumberLiteralToken(10),
      ForKeywordToken(),
      IdentifierToken('I'),
      EqualsToken(),
      NumberLiteralToken(1),
      ToKeywordToken(),
      NumberLiteralToken(10),
      StepKeywordToken(),
      NumberLiteralToken(2),
      EndOfLineToken(), // 10 FOR i = 1 TO 10 STEP 2
      NumberLiteralToken(20),
      PrintKeywordToken(),
      IdentifierToken('I'),
      EndOfLineToken(), // 20 PRINT I
      NumberLiteralToken(30),
      NextKeywordToken(),
      IdentifierToken('I'),
      EndOfLineToken(), // 30 NEXT I
      NumberLiteralToken(40),
      EndKeywordToken(), // 40 END
    ]);
  });

  group("If statement", () {
    test("equal comparison operator", () {
      var lexer = Lexer('20 IF A = 5 THEN 40');
      expect(lexer.tokenize(), [
        NumberLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken('A'),
        EqualsToken(),
        NumberLiteralToken(5),
        ThenKeywordToken(),
        NumberLiteralToken(40),
      ]);
    });

    test("greater than comparison operator", () {
      var lexer = Lexer('20 IF A > 5 THEN 40');
      expect(lexer.tokenize(), [
        NumberLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken('A'),
        GreaterThanToken(),
        NumberLiteralToken(5),
        ThenKeywordToken(),
        NumberLiteralToken(40),
      ]);
    });

    test("less than comparison operator", () {
      var lexer = Lexer('20 IF A < 5 THEN 40');
      expect(lexer.tokenize(), [
        NumberLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken('A'),
        LessThanToken(),
        NumberLiteralToken(5),
        ThenKeywordToken(),
        NumberLiteralToken(40),
      ]);
    });

    test("greater than or equal comparison operator", () {
      var lexer = Lexer('20 IF A >= 5 THEN 40');
      expect(lexer.tokenize(), [
        NumberLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken('A'),
        GreaterThanOrEqualToken(),
        NumberLiteralToken(5),
        ThenKeywordToken(),
        NumberLiteralToken(40),
      ]);
    });

    test("less than or equal comparison operator", () {
      var lexer = Lexer('20 IF A <= 5 THEN 40');
      expect(lexer.tokenize(), [
        NumberLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken('A'),
        LessThanOrEqualToken(),
        NumberLiteralToken(5),
        ThenKeywordToken(),
        NumberLiteralToken(40),
      ]);
    });

    test("not equal comparison operator", () {
      var lexer = Lexer('20 IF A <> 5 THEN 40');
      expect(lexer.tokenize(), [
        NumberLiteralToken(20),
        IfKeywordToken(),
        IdentifierToken('A'),
        NotEqualToken(),
        NumberLiteralToken(5),
        ThenKeywordToken(),
        NumberLiteralToken(40),
      ]);
    });
  });
}
