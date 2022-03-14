class FBStack<E> {
  final List<E> _stack;
  final int capacity;
  int _top;

  FBStack(this.capacity)
      : _top = -1,
        _stack = List<E>(capacity);

  bool get isEmpty => _top == -1;

  bool get isFull => _top == capacity - 1;

  int get size => _top + 1;

  bool push(E e) {
    if (isFull) {
      return false;
    } else {
      _stack[++_top] = e;
      return true;
    }
  }

  E pop() {
    if (isEmpty) return null;
    return _stack[_top--];
  }

  E get top {
    if (isEmpty) return null;
    return _stack[_top];
  }
}

// class StackOverFlowException implements Exception {
//   const StackOverFlowException();
//
//   String toString() => 'StackOverFlowException';
// }

// class StackEmptyException implements Exception {
//   const StackEmptyException();
//
//   String toString() => 'StackEmptyException';
// }
