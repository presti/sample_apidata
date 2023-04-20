import 'package:flutter/material.dart';

import '../../../data/data_repository.dart';
import '../../../data/model/user.dart';
import '../../ui/data_page.dart';
import 'todos_widget.dart';

class TodosPage extends StatelessWidget {
  final User user;

  const TodosPage(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return DataPage(
      loader: () => DataRepository.i.getTodos(user),
      dataBuilder: TodosWidget.new,
    );
  }
}
