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
  todoList.add(todoInput.value);
  updateUI();
  todoInput.value = '';
}

// Update UI responsible to display all tasks
void updateUI() {
  todoUI.children.clear();
  todoList.forEach((todo) {
    DivElement div = Element.div();
    Element span = Element.span();
    span.text = todo;
    div.children.add(span);
    todoUI.children.add(div);
  });
}