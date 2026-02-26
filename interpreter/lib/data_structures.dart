/// A stack data structure.
class Stack<E> {
  /// Internal storage for the stack.
  final _list = <E>[];

  /// Pushes an element onto the stack.
  void push(E value) => _list.add(value);

  /// Pops an element off the stack.
  E pop() => _list.removeLast();

  /// Returns the element at the top of the stack without removing it.
  E get peek => _list.last;

  /// Returns true if the stack is empty.
  bool get isEmpty => _list.isEmpty;

  /// Returns true if the stack is not empty.
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  String toString() => _list.toString();
}
