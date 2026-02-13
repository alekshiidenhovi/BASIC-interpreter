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
                return tokens.map((t) => t.toString()).toList();
              }

              final parser = Parser(tokens);
              final programLines = parser.parse();
              if (outputMode.toDart == "parser") {
                return programLines.values
                    .map((p) => p.toString().toJS)
                    .toList();
              }

              final interpreter = Interpreter(programLines);
              final result = interpreter.interpret();

              return result.map((s) => s.toJS).toList().toJS;
            } on BASICInterpreterError catch (e) {
              return [
                "${e.interpreterStepErrorName}: ${e.toString()}".toJS,
              ].toList().toJS;
            } catch (e) {
              return ["Unknown error: $e".toJS].toList().toJS;
            }
          }).toJS
          as JSFunction;
}
