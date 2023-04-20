import 'package:flutter/material.dart';

import '/res/strings.dart';
import '/res/themes.dart';
import 'feature/users/users_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: context.s.appTitle,
      theme: context.t.app,
      darkTheme: context.t.dark,
      home: const UsersPage(),
    );
  }
}
