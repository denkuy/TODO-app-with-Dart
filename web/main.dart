import 'dart:html';

InputElement todoInput;
DivElement todoUI;
ButtonElement buttonAdd;
List<String> todoList = [];

void main() {
  todoInput = querySelector('#todo');
  todoUI = querySelector('#task-list');
  buttonAdd = querySelector('#add');
  buttonAdd.onClick.listen(addTodo);
}

// Add  a new task to the list
void addTodo(Event event) {
  if(todoInput.value == '')
    return;

  todoList.add(todoInput.value);
  updateUI();
  todoInput.value = '';
}

// Update UI responsible to display all tasks
void updateUI() {
  todoUI.children.clear();
  todoList.forEach((todo) {
    DateTime now = new DateTime.now();
    DivElement div = Element.div();
    ButtonElement taskButton = ButtonElement();
    taskButton.className = 'task-button';
    taskButton.text = todo+'\n'+now.toString();
    taskButton.onClick.listen(toggleState);
    div.children.add(taskButton);
    todoUI.children.add(div);
  });
}

// Toggle state between done and pending
void toggleState(Event event) {
  Element button = (event.currentTarget as Element);

  if(button.style.textDecoration == 'line-through')
    button.style.textDecoration = 'none';
  else
    button.style.textDecoration = 'line-through';
}