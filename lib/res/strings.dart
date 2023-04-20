import 'package:flutter/widgets.dart';

extension BuildContextSrings on BuildContext {
  // The context is not needed, but it is used for a seamless
  // transition to internationalization.
  Strings get s => Strings.i;
}

class Strings {
  static const Strings i = Strings._();

  const Strings._();

  PostsPageStrings get postsPage => PostsPageStrings.i;

  UsersStrings get users => UsersStrings.i;

  UserStrings get user => UserStrings.i;

  TodosStrings get todos => TodosStrings.i;

  AlbumsPageStrings get albumsPage => AlbumsPageStrings.i;

  String get appTitle => 'Api Data Sample';

  String get posts => 'Posts';

  String get albums => 'Albums';

  String get error => 'Something wrong happened';

  String get empty => 'Nothing to show';
}

class UsersStrings {
  static const UsersStrings i = UsersStrings._();

  const UsersStrings._();

  String get title => 'Users';

  String get address => 'Address';

  String get showOnMap => 'Show on map';
}

class UserStrings {
  static const UserStrings i = UserStrings._();

  const UserStrings._();

  String title(int userId) => 'User: $userId';
}

class TodosStrings {
  static const TodosStrings i = TodosStrings._();

  const TodosStrings._();

  String get title => 'Todos';

  String get sort => 'Sort';

  String get sortCompletedFirst => 'Completed first';

  String get sortUncompletedFirst => 'Uncompleted first';

  String get filter => 'Filter';

  String get filterUncompleted => 'Uncompleted';

  String get filterCompleted => 'Completed';
}

class PostsPageStrings {
  static const PostsPageStrings i = PostsPageStrings._();

  const PostsPageStrings._();

  String get comments => 'Comments';
}

class AlbumsPageStrings {
  static const AlbumsPageStrings i = AlbumsPageStrings._();

  const AlbumsPageStrings._();

  String title(int albumId) => 'Album: $albumId';

  String photo(int photoId) => 'Photo: $photoId';
}
