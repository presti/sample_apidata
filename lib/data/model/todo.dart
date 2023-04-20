import '../../utils/equality.dart';

class Todo extends Equality {
  final int id;
  final String title;
  final bool completed;

  const Todo(
    this.id,
    this.title,
    this.completed,
  );

  @override
  List<Object?> get props => [id, title, completed];
}
