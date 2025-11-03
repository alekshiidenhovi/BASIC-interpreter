import 'package:basic_interpreter/basic_interpreter.dart';
import 'package:test/test.dart';

void main() {
  late Interpreter interpreter;

  setUp(() {
    interpreter = Interpreter();
  });

  group("Printing", () {
    test('10 PRINT "HELLO, WORLD!"', () {
      expect(interpreter.interpret('10 PRINT "HELLO, WORLD!"'), [
        "HELLO, WORLD!",
      ]);
    });

    test('Two print statements', () {
      expect(
        interpreter.interpret(
          '10 PRINT "HELLO, WORLD!"\n20 PRINT "HELLO, BASIC!"',
        ),
        ["HELLO, WORLD!", "HELLO, BASIC!"],
      );
    });

    test('10 PRINT "HELLO, WORLD!", "HELLO, BASIC!"', () {
      expect(
        interpreter.interpret('10 PRINT "HELLO, WORLD!", "HELLO, BASIC!"'),
        ["HELLO, WORLD!\tHELLO, BASIC!"],
      );
    });
  });

  group("Variables", () {
    test('10 LET A = 5\n20 PRINT A', () {
      expect(interpreter.interpret('10 LET A = 5\n20 PRINT A'), ["5"]);
    });

    test('10 LET A = 5.2\n20 PRINT A', () {
      expect(interpreter.interpret('10 LET A = 5.2\n20 PRINT A'), ["5.2"]);
    });

    test('10 LET A = 42\n20 PRINT "A IS", A', () {
      expect(interpreter.interpret('10 LET A = 42\n20 PRINT "A IS", A'), [
        "A IS\t42",
      ]);
    });
  });

  group("Goto statements", () {
    test("Goto statement skipping a line", () {
      expect(
        interpreter.interpret('10 GOTO 30\n20 PRINT "SKIP"\n30 PRINT "END"'),
        ["END"],
      );
    });
  });
}
