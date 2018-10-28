import 'dart:async';

import 'package:TODO_app/src/todo_item.dart';

/// The "interface" that is used by UI controllers to deal with items
///
/// The idea is that you have methods to create, toggle completed and remove items.
/// The [TodoList] can now decide how to go about that operation.
///
/// If we take for example [createItem].
/// - we can validate [text]
/// - we can enforce a maximum number of items limit
/// - we can (re-)format the text
/// - we can split one text into multiple items
abstract class TodoList {
  // note that we only need to know the text!
  // id, datetime and completed are handled by the TodoList
  // - if we wanted to allow the user to create both "done" and "pending" items,
  //   then we need to change the interface (I simply decided that we don't need it)
  void createItem(String text);

  // again we only pass the minimal data that we need (id)
  void toggleCompleted(int id);
  void removeItem(int id);

  // These are the streams, they are basically events that you can listen to.
  // The [TodoList] itself can add new events to this stream and all subscribed (.listen)
  // event handlers will run.
  // This does not really differ from the events that you get from the UI, like onClick)
  Stream<TodoItem> get onAdd;
  Stream<TodoItem> get onUpdate;
  Stream<TodoItem> get onRemove;
}
