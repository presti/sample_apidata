import 'package:flutter/material.dart';
import 'package:sample_apidata/res/images.dart';
import 'package:sample_apidata/res/strings.dart';

import '../../data/model/todo.dart';
import '../../res/colours.dart';
import '../../utils/rx/data.dart';
import '../../utils/ui/orientation_list_view.dart';

class TodosWidget extends StatefulWidget {
  final List<Todo> todos;

  const TodosWidget(this.todos, {super.key});

  @override
  State<TodosWidget> createState() => _TodosWidgetState();
}

class _TodosWidgetState extends State<TodosWidget> {
  late final Data<List<Todo>> todos;
  bool? sort = false;
  bool? filter = false;

  @override
  void initState() {
    super.initState();

    todos = Data(widget.todos);
  }

  @override
  Widget build(BuildContext context) {
    return todos.builder((todos) {
      return Column(
        children: [
          _buildActions(),
          Expanded(
            child: OrientationListView(todos, builder: _buildTodo),
          ),
        ],
      );
    });
  }

  Row _buildActions() {
    Widget buildButton({
      required IconData iconData,
      required String text,
      required VoidCallback onPressed,
    }) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: ElevatedButton(
              onPressed: onPressed,
              child: Row(
                children: [
                  Icon(iconData),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final s = context.s.todos;
    final filter = this.filter;
    final sort = this.sort;
    return Row(
      children: [
        buildButton(
          iconData: Images.i.sort,
          text: sort == null
              ? s.sortCompletedFirst
              : sort
                  ? s.sortUncompletedFirst
                  : s.sort,
          onPressed: () {
            this.filter = false;
            if (sort == null) {
              this.sort = false;
              todos.value = widget.todos.toList();
            } else {
              todos.value = widget.todos.toList()
                ..sort(
                  (a, b) {
                    final int compare;
                    if (sort) {
                      compare = 1;
                    } else {
                      compare = -1;
                    }
                    final todo0 = a.completed ? 0 : compare;
                    final todo1 = b.completed ? 0 : compare;
                    return todo0 - todo1;
                  },
                );
              this.sort = sort ? null : true;
            }
          },
        ),
        buildButton(
          iconData: Images.i.filter,
          text: filter == null
              ? s.filterCompleted
              : filter
                  ? s.filterUncompleted
                  : s.filter,
          onPressed: () {
            this.sort = false;
            if (filter == null) {
              this.filter = false;
              todos.value = widget.todos.toList();
            } else {
              todos.value = widget.todos
                  .where((todo) => todo.completed == filter)
                  .toList();
              this.filter = filter ? null : true;
            }
          },
        ),
      ],
    );
  }

  Widget _buildTodo(BuildContext context, Todo todo) {
    return Card(
      key: ValueKey(todo.id),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white54, width: 4),
        borderRadius: BorderRadius.circular(16),
      ),
      color: todo.completed ? Colours.i.checked : Colours.i.missing,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            SizedBox(width: 12),
            Checkbox(
              value: todo.completed,
              onChanged: null,
            ),
          ],
        ),
      ),
    );
  }
}
