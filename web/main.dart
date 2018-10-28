import 'dart:html';

import 'package:TODO_app/todo.dart';

void main() {
  var todoInput = querySelector('#todo') as TextInputElement;
  var pendingList = querySelector('#pending-task-list') as DivElement;
  var doneList = querySelector('#finished-task-list') as DivElement;
  var addButton = querySelector('#add') as ButtonElement;

  TodoList list = SimpleTodoList();

  // ADVANCED - Decorator usage, uncomment to disallow the word "stupid" in TodoItems
  //list = NoSwearingTodoListDecorator(list);

  // create the UI controller given the TodoList and UI Elements
  SplitUi(list, todoInput, addButton, doneList, pendingList);

  // alternative UI (not moving items, instead striking item's text)
  //UnifiedUi(list, todoInput, addButton, doneList);
}
