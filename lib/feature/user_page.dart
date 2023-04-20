import 'package:flutter/material.dart';

import '../data/model/user.dart';
import '../res/images.dart';
import '../res/strings.dart';
import '../utils/rx/data.dart';
import 'albums/albums_page.dart';
import 'posts/rx/posts_page.dart';
import 'todos/todos_page.dart';

enum _Category {
  album,
  post,
  todo;

  IconData get iconData {
    const images = Images.i;
    switch (this) {
      case _Category.album:
        return images.album;
      case _Category.post:
        return images.post;
      case _Category.todo:
        return images.todo;
    }
  }

  String title(BuildContext context) {
    final strings = context.s;
    switch (this) {
      case _Category.album:
        return strings.albums;
      case _Category.post:
        return strings.posts;
      case _Category.todo:
        return strings.todos.title;
    }
  }
}

class UserPage extends StatefulWidget {
  final User user;

  const UserPage(this.user, {super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final Data<int> selectedIndex = Data(0);

  final Data<Widget?> _albumsPage = Data(null);
  final Data<Widget?> _todosPage = Data(null);
  final Data<Widget?> _postsPage = Data(null);

  @override
  void initState() {
    super.initState();
    _albumsPage.value ??= AlbumsPage(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.s.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.title(widget.user.id)),
      ),
      bottomNavigationBar: selectedIndex.builder(
        (index) => NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                _albumsPage.value ??= AlbumsPage(widget.user);
                break;
              case 1:
                _postsPage.value ??= PostsPage(widget.user);
                break;
              case 2:
                _todosPage.value ??= TodosPage(widget.user);
                break;
            }
            selectedIndex.value = index;
          },
          destinations: [
            for (final category in _Category.values)
              NavigationDestination(
                icon: Icon(category.iconData),
                label: category.title(context),
              )
          ],
        ),
      ),
      body: selectedIndex.builder(
        (index) => Stack(
          children: [
            buildPage(_albumsPage, 0),
            buildPage(_postsPage, 1),
            buildPage(_todosPage, 2),
          ],
        ),
      ),
    );
  }

  Visibility buildPage(Data<Widget?> widgetData, int index) {
    final showPage = selectedIndex.value == index;
    return Visibility.maintain(
      visible: showPage,
      child: IgnorePointer(
        ignoring: !showPage,
        child: widgetData.builder((w) => w ?? Container()),
      ),
    );
  }
}
