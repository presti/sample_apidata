import '../../utils/equality.dart';
import '../../utils/functional/may_fail.dart';
import '../../utils/json_utils.dart';
import '../model/todo.dart';

class TodoDto extends Equality {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const TodoDto._({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  static May<TodoDto> fromJson(Json json) {
    return JsonUtils.i.fromJson(
      json,
      (json) {
        return TodoDto._(
          userId: json['userId'],
          id: json['id'],
          title: json['title'],
          completed: json['completed'],
        );
      },
    );
  }

  Todo toModel() {
    return Todo(id, title, completed);
  }

  @override
  List<Object?> get props => [userId, id, title, completed];
}
