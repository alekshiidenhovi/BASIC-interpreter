import 'dart:js_interop';
import 'package:basic_interpreter/lexer.dart';
import 'package:basic_interpreter/parser.dart';
import 'package:basic_interpreter/basic_interpreter.dart';
import 'package:basic_interpreter/errors.dart';

@JS('window')
external JSObject get window;

extension type WindowExtension(JSObject _) implements JSObject {
  external set interpretProgram(JSFunction f);
  external set interpretReplLine(JSFunction f);
  external set resetReplContext(JSFunction f);
}

void main() {
  final replInterpreter = Interpreter();

  final windowObj = window as WindowExtension;

  windowObj.interpretProgram =
      ((JSString code, JSString outputMode) {
            try {
              final lexer = Lexer(code.toDart);
              final tokens = lexer.tokenize();

              if (outputMode.toDart == "lexer") {
                return {
                  "ok": true,
                  "output": tokens.map((t) => t.toString().toJS).toList().toJS,
                }.jsify();
              }

              final parser = Parser(tokens);
              final programLines = parser.parse();

              if (outputMode.toDart == "parser") {
                return {
                  "ok": true,
                  "output": programLines
                      .map((p) => p.toString().toJS)
                      .toList()
                      .toJS,
                }.jsify();
              }

              final interpreter = Interpreter();
              final List<String> result = interpreter.interpret(programLines);

              return {
                "ok": true,
                "output": result.map((s) => s.toJS).toList().toJS,
              }.jsify();
            } on BASICInterpreterError catch (e) {
              return {
                "ok": false,
                "error": "${e.interpreterStepErrorName}: $e".toJS,
              }.jsify();
            } catch (e) {
              return {"ok": false, "error": "Unknown error: $e".toJS}.jsify();
            }
          }).toJS
          as JSFunction;

  windowObj.interpretReplLine =
      ((JSString code) {
            try {
              final lexer = Lexer(code.toDart);
              final tokens = lexer.tokenize();

              final parser = Parser(tokens);
              final programLines = parser.parse();

              final interpreter = Interpreter();
              final List<String> result = interpreter.interpret(programLines);

              return {
                "ok": true,
                "output": result.map((s) => s.toJS).toList().toJS,
              }.jsify();
            } on BASICInterpreterError catch (e) {
              return {
                "ok": false,
                "error": "${e.interpreterStepErrorName}: $e".toJS,
              }.jsify();
            } catch (e) {
              return {"ok": false, "error": "Unknown error: $e".toJS}.jsify();
            }
          }).toJS
          as JSFunction;

  windowObj.resetReplContext =
      (() {
            replInterpreter.resetContext();
          }).toJS
          as JSFunction;
}
