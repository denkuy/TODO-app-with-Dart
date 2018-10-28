import 'dart:async';
import 'dart:html';

import '../todo_exception.dart';
import '../todo_item.dart';
import '../todo_list.dart';

class UnifiedUi {
  TodoList _todoList;

  TextInputElement _todoInput;
  ButtonElement _addButton;
  DivElement _todoListElement;

  Map<int, DivElement> _itemElements = {};

  UnifiedUi(this._todoList, this._todoInput, this._addButton, this._todoListElement) {
    interceptErrors("add", _todoList.onAdd).listen(itemAddedHandler);
    interceptErrors("remove", _todoList.onRemove).listen(itemRemovedHandler);
    interceptErrors("update", _todoList.onUpdate).listen(itemUpdatedHandler);

    _addButton.onClick.listen(uiAddEvent);
  }

  Stream<TodoItem> interceptErrors(String actionName, Stream<TodoItem> stream) {
    // see https://api.dartlang.org/stable/2.0.0/dart-async/Stream/handleError.html
    return stream.handleError((e) => window.alert("Can not $actionName\n\n${e.message}"),
        test: (e) => e is TodoException);
  }

  void uiAddEvent(Event e) {
    var text = _todoInput.value;

    if (text.isEmpty) return;

    _todoList.createItem(text);
  }

  void itemAddedHandler(TodoItem item) {
    var buttonRemove = ButtonElement()
      ..className = 'add-button'
      ..text = "X"
      ..onClick.listen((e) => _todoList.removeItem(item.id));

    var taskButton = ButtonElement()
      ..className = 'task-button'
      ..text = "${item.text}\n${item.createdAt}"
      ..onClick.listen((e) => _todoList.toggleCompleted(item.id));

    var itemElement = DivElement()..children.add(taskButton)..children.add(buttonRemove);
    if(item.completed) itemElement.classes.add("item-completed");

    _todoListElement.children.add(itemElement);

    _itemElements[item.id] = itemElement;

    _todoInput.value = '';
  }

  void itemRemovedHandler(TodoItem item) {
    var element = _itemElements.remove(item.id);

    if (element == null) return;
    element.remove();
  }

  void itemUpdatedHandler(TodoItem item) {
    var element = _itemElements[item.id];
    if (element == null) return;

    if (item.completed) {
      element.classes.add("item-completed");
    } else {
      element.classes.remove("item-completed");
    }
  }
}
