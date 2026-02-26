/// A stack data structure.
class Stack<T> {
  /// Internal storage for the stack.
  final _list = <T>[];

  /// Pushes an element onto the stack.
  void push(T value) => _list.add(value);

  /// Pops an element off the stack.
  T pop() => _list.removeLast();

  /// Returns the element at the top of the stack without removing it.
  T get peek => _list.last;

  /// Returns true if the stack is empty.
  bool get isEmpty => _list.isEmpty;

  /// Returns true if the stack is not empty.
  bool get isNotEmpty => _list.isNotEmpty;

  /// Returns the number of elements in the stack.
  int get length => _list.length;

  /// Returns elements in the stack in reverse order.
  Iterable<T> get topToBottom => _list.reversed;

  @override
  String toString() => _list.toString();
}

/// A single flat scope frame mapping identifiers to values.
class Scope<T> {
  final Map<String, T> _bindings = {};

  /// Declares [identifier] with [value] in this scope.
  void declare(String identifier, T value) {
    _bindings[identifier] = value;
  }

  /// Returns the value bound to [identifier], or null if not present.
  T? lookup(String identifier) => _bindings[identifier];
}
