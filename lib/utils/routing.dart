import 'package:flutter/material.dart';

import '../data/model/album.dart';
import '../data/model/photo.dart';
import '../data/model/user.dart';
import '../feature/albums/album_page.dart';
import '../feature/albums/photo_page.dart';
import '../feature/user_page.dart';

class Routing {
  static const Routing i = Routing._();

  const Routing._();

  Future<void> pushUser(BuildContext context, User user) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => UserPage(user),
      ),
    );
  }

  Future<void> pushAlbums(BuildContext context, Album album) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => AlbumPage(album),
      ),
    );
  }

  Future<void> pushPhotos(
    BuildContext context,
    List<Photo> photos,
    int index,
  ) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoPage(photos, index),
      ),
    );
  }
}
