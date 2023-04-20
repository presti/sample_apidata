import 'package:flutter/material.dart';

import '../../../data/data_repository.dart';
import '../../res/keys.dart';
import '../../res/strings.dart';
import '../../ui/data_page.dart';
import 'users_widget.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final keys = Keys.i.users;
    return Scaffold(
      key: keys.page,
      appBar: AppBar(
        title: Text(
          key: keys.txTitle,
          context.s.users.title,
        ),
      ),
      body: DataPage(
        loader: DataRepository.i.getUsers,
        dataBuilder: UsersWidget.new,
        errorKey: keys.txError,
      ),
    );
  }
}
