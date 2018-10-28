import 'dart:async';

import '../../todo_exception.dart';
import '../../todo_item.dart';
import '../../todo_list.dart';

/// A decorator that disallows the use of swearwords in TodoItem text
class NoSwearingTodoListDecorator implements TodoList {
  List<String> _swearWords;

  /// Keep a reference to the wrapped/decorated [TodoList]
  TodoList _todoList;

  /// We need this [Stream] so that we can add errors to the [onAdd] stream
  /// Basically we put our streamcontroller between the user and the wrapped [TodoList]
  StreamController<TodoItem> _addStream = StreamController<TodoItem>.broadcast();
  Stream<TodoItem> get onAdd => _addStream.stream;

  NoSwearingTodoListDecorator(this._todoList, [String swearWords]) {
    // make sure to include the events from the wrapped/decorated [TodoList]
    _todoList.onAdd.handleError(_addStream.addError).listen(_addStream.add);

    if (swearWords == null || swearWords.isEmpty) {
      // use default
      _swearWords = ['stupid'];
    } else {
      // parse by splitting words & lowercase
      _swearWords = swearWords.toLowerCase().split(' ').where((w) => w.isNotEmpty).toList(growable: false);
    }
  }

  void createItem(String text) {
    var lowercase = text.toLowerCase();
    if (_swearWords.any((sw) => lowercase.contains(sw))) {
      _addStream.addError(TodoException("You may not use swear words!"), StackTrace.current);
      return;
    }

    _todoList.createItem(text);
  }

  // the rest remains unchanged / we just delegate the implementation to the wrapped TodoList
  void removeItem(int id) => _todoList.removeItem(id);
  void toggleCompleted(int id) => _todoList.toggleCompleted(id);

  Stream<TodoItem> get onRemove => _todoList.onRemove;
  Stream<TodoItem> get onUpdate => _todoList.onUpdate;
}
