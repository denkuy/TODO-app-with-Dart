import 'dart:html';

InputElement todoInput;
DivElement todoUI;
DivElement todoDoneUI;
ButtonElement buttonAdd;
List<Todo> pendingTodoList = [];
List<Todo> doneTodoList = [];

void main() {
  todoInput = querySelector('#todo');
  todoUI = querySelector('#pending-task-list');
  todoDoneUI = querySelector('#finished-task-list');
  buttonAdd = querySelector('#add');
  buttonAdd.onClick.listen(addTodo);
}

// Add  a new task to the list
void addTodo(Event event) {
  if(todoInput.value == '')
    return;

  Todo todo = Todo(todoInput.value, DateTime.now(), "pending");
  todo.addTodo(todoUI);
  pendingTodoList.add(todo);
  todoInput.value = '';
}

class Todo {
  static int _id = 0;
  int id;
  String text;
  String state;
  DateTime date;

  Todo(String text, DateTime date, String state) : this.id = _id++ {
    this.text = text;
    this.date = date;
    this.state = state;
  }

  // Remove element from the list
  void removeTask(MouseEvent event) {
    event.stopPropagation();
    Element div = (event.currentTarget as Element).parent;
    Element button = (event.currentTarget as Element);
    int index = int.parse(button.id.split('-')[0]);
    pendingTodoList.removeWhere((todo) => todo.id == index);
    div.remove();
  }

  // Add  a new task to the list
  void addTodo(DivElement parentDiv) {
    DivElement div = Element.div();
    ButtonElement buttonRemove = ButtonElement();
    ButtonElement taskButton = ButtonElement();

    buttonRemove.className = 'add-button';
    buttonRemove.text = 'X';
    buttonRemove.id = id.toString();
    buttonRemove.onClick.listen(removeTask);

    taskButton.className = 'task-button';
    taskButton.text = text+'\n'+date.toString();
    taskButton.id = id.toString();

    if (state == "pending") {
      taskButton.onClick.listen(toggleToDoneState);
    }
    else {
      taskButton.style.textDecoration = 'line-through';
      taskButton.onClick.listen(toggleToPendingState);
    }

    div.children.add(taskButton);
    div.children.add(buttonRemove);
    parentDiv.children.add(div);
  }

  // Toggle state from pending to done
  void toggleToDoneState(Event event) {
    Element div = (event.currentTarget as Element).parent;
    Element button = (event.currentTarget as Element);
    int index = int.parse(button.id);

    Todo todo = pendingTodoList.firstWhere((todo) => todo.id == index);
    todo.state = "done";
    doneTodoList.add(todo);
    todo.addTodo(todoDoneUI);

    pendingTodoList.removeWhere((todo) => todo.id == index);
    div.remove();
  }

  // Toggle state from done to pending
  void toggleToPendingState(Event event) {
    Element div = (event.currentTarget as Element).parent;
    Element button = (event.currentTarget as Element);
    int index = int.parse(button.id);

    Todo todo = doneTodoList.firstWhere((todo) => todo.id == index);
    todo.state = "pending";
    pendingTodoList.add(todo);
    todo.addTodo(todoUI);

    doneTodoList.removeWhere((todo) => todo.id == index);
    div.remove();
  }
}