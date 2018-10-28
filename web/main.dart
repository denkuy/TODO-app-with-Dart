import 'dart:html';

InputElement todoInput;
DivElement todoUI;
DivElement todoDoneUI;
ButtonElement buttonAdd;
List<String> pendingTodoList = [];
List<String> doneTodoList = [];

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

  pendingTodoList.add(todoInput.value);
  updateUI();
  todoInput.value = '';
}

// Update UI responsible to display all tasks
void updateUI() {
  todoUI.children.clear();
  todoDoneUI.children.clear();

  for (var i=0; i<pendingTodoList.length; i++) {
    DateTime now = new DateTime.now();
    DivElement div = Element.div();
    ButtonElement buttonRemove = ButtonElement();
    ButtonElement taskButton = ButtonElement();

    buttonRemove.className = 'add-button';
    buttonRemove.text = 'X';
    buttonRemove.id = i.toString();
    buttonRemove.onClick.listen(removeTask);

    taskButton.className = 'task-button';
    taskButton.text = pendingTodoList[i]+'\n'+now.toString();
    taskButton.id = i.toString();
    taskButton.onClick.listen(toggleToDoneState);

    div.children.add(taskButton);
    div.children.add(buttonRemove);
    todoUI.children.add(div);
  };

  for (var i=0; i<doneTodoList.length; i++) {
    DateTime now = new DateTime.now();
    DivElement div = Element.div();
    ButtonElement buttonRemove = ButtonElement();
    ButtonElement taskButton = ButtonElement();

    buttonRemove.className = 'add-button';
    buttonRemove.text = 'X';
    buttonRemove.id = i.toString();
    buttonRemove.onClick.listen(removeTask);

    taskButton.className = 'finished-task-button';
    taskButton.text = doneTodoList[i]+'\n'+now.toString();
    taskButton.id = i.toString();
    taskButton.onClick.listen(toggleToPendingState);

    div.children.add(taskButton);
    div.children.add(buttonRemove);
    todoDoneUI.children.add(div);
  };
}

// Toggle state from pending to done
void toggleToDoneState(Event event) {
  Element button = (event.currentTarget as Element);
  int index = int.parse(button.id.split('-')[0]);
  pendingTodoList.removeAt(index);
  String text = button.text.split('\n')[0];
  doneTodoList.add(text);
  updateUI();
}

// Toggle state from done to pending
void toggleToPendingState(Event event) {
  Element button = (event.currentTarget as Element);
  int index = int.parse(button.id.split('-')[0]);
  doneTodoList.removeAt(index);
  String text = button.text.split('\n')[0];
  pendingTodoList.add(text);
  updateUI();
}

// Remove element from the list
void removeTask(MouseEvent event) {
  event.stopPropagation();
  Element div = (event.currentTarget as Element).parent;
  Element button = (event.currentTarget as Element);
  int index = int.parse(button.id.split('-')[0]);
  pendingTodoList.removeAt(index);
  div.remove();
}
