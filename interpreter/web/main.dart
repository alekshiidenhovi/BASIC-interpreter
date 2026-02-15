import 'dart:js_interop';
import 'package:basic_interpreter/lexer.dart';
import 'package:basic_interpreter/parser.dart';
import 'package:basic_interpreter/basic_interpreter.dart';
import 'package:basic_interpreter/errors.dart';

@JS('window')
external JSObject get window;

extension type WindowExtension(JSObject _) implements JSObject {
  external set interpretBASIC(JSFunction f);
}

void main() {
  final windowObj = window as WindowExtension;

  windowObj.interpretBASIC =
      ((JSString code, JSString outputMode) {
            try {
              final lexer = Lexer(code.toDart);
              final tokens = lexer.tokenize();

              if (outputMode.toDart == "lexer") {
                return tokens.map((t) => t.toString().toJS).toList().toJS;
              }

              final parser = Parser(tokens);
              final programLines = parser.parse();

              if (outputMode.toDart == "parser") {
                return programLines.map((p) => p.toString().toJS).toList().toJS;
              }

              final interpreter = Interpreter();
              final List<String> result = interpreter.interpret(programLines);

              return result.map((s) => s.toJS).toList().toJS;
            } on BASICInterpreterError catch (e) {
              return ["${e.interpreterStepErrorName}: $e".toJS].toJS;
            } catch (e) {
              return ["Unknown error: $e".toJS].toJS;
            }
          }).toJS
          as JSFunction;
}
