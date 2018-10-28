/// A simple object that contains the information for a todotask
///
/// Note that this class does not have any special behavior
/// (except for the constructor - that makes using the class
/// incorrectly very hard, because you have to provide values)
class TodoItem {
  int id;
  DateTime createdAt;
  String text;
  bool completed;

  /// The constructor uses "named parameters" for optional arguments
  ///
  /// The syntax to create an instance with completed set to true is
  /// ```var item = TodoItem(0, 'item', completed: true)```
  TodoItem(this.id, this.text, {DateTime createdAt, this.completed = false}) {
    this.createdAt = createdAt ?? DateTime.now();
  }
}
