/// The [Exception] used for all [TodoList] operations
class TodoException implements Exception {
  // once a message is set, we don't want it to change, hence [final]
  final String message;

  // constructor to force a message value
  TodoException(this.message);
}
