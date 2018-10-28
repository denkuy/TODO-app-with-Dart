import 'dart:async';

import '../todo_item.dart';
import '../todo_list.dart';

/// A basic [TodoList] implementation.
///
/// We're not doing anything special in here execpt of
/// checking for empty items text. No errors will be emitted.
class SimpleTodoList implements TodoList {
  /// keep a counter that is incremented everytime we create a new item
  int _idCounter = 0;

  /// we keep a list of items, because we only get the id as a reference in [toggleCompleted] and [removeItem]
  List<TodoItem> _items = [];

  /// This would allow outside (the UI controller) classes to see what the current list of items is
  /// This could be used to initialize the UI - for example when this class actually persisted [TodoItem]s
  // Iterable<TodoItem> get items => _items;

  void createItem(String text) {
    var item = TodoItem(_idCounter++, text);

    _items.add(item);

    // Notify listeners that we "accepted" the new item
    // We could also do `_addStream.addError(...)` here to notify about rejection
    // (We could also silently reject the item by not doing either action)
    _addStream.add(item);
  }

  void toggleCompleted(int id) {
    // firstWhere finds the first item that matches the `item.id == id`
    // i have provided a "orElse:", because otherwise this would not return null
    // and instead throw an exception. I prefer the `if(itemToToggle == null)` check
    // over catching exceptions with try-catch
    var itemToToggle = _items.firstWhere((item) => item.id == id, orElse: () => null);

    // actually this should never happen. This can only happen when the UI class gets
    // desynchronized with the state of the [TodoList]
    if (itemToToggle == null) return;

    itemToToggle.completed = !itemToToggle.completed;

    // Again we could add some rules here that allow/disallow
    // the changing of the completed state
    _updateStream.add(itemToToggle);
  }

  void removeItem(int id) {
    var itemToRemove = _items.firstWhere((item) => item.id == id, orElse: () => null);
    if (itemToRemove == null) return;

    _items.remove(itemToRemove);
    _removeStream.add(itemToRemove);
  }

  // see: https://www.dartlang.org/tutorials/language/streams
  StreamController<TodoItem> _addStream = StreamController.broadcast<TodoItem>();
  Stream<TodoItem> get onAdd => _addStream.stream;

  StreamController<TodoItem> _removeStream = StreamController.broadcast<TodoItem>();
  Stream<TodoItem> get onRemove => _removeStream.stream;

  StreamController<TodoItem> _updateStream = StreamController.broadcast<TodoItem>();
  Stream<TodoItem> get onUpdate => _updateStream.stream;
}
