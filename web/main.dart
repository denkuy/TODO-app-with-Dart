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
  for (var i=0; i<todoList.length; i++) {
    DateTime now = new DateTime.now();
    DivElement div = Element.div();
    ButtonElement buttonRemove = ButtonElement();
    ButtonElement taskButton = ButtonElement();

    buttonRemove.className = 'add-button';
    buttonRemove.text = 'X';
    buttonRemove.id = i.toString();
    buttonRemove.onClick.listen(removeTask);

    taskButton.className = 'task-button';
    taskButton.text = todoList[i]+'\n'+now.toString();
    taskButton.onClick.listen(toggleState);

    div.children.add(taskButton);
    div.children.add(buttonRemove);
    todoUI.children.add(div);
  };
}

// Toggle state between done and pending
void toggleState(Event event) {
  Element button = (event.currentTarget as Element);

  if(button.style.textDecoration == 'line-through')
    button.style.textDecoration = 'none';
  else
    button.style.textDecoration = 'line-through';
}

// Remove element from the list
void removeTask(MouseEvent event) {
  event.stopPropagation();
  Element div = (event.currentTarget as Element).parent;
  Element button = (event.currentTarget as Element);
  int index = int.parse(button.id.split('-')[0]);
  todoList.removeAt(index);
  div.remove();
}
