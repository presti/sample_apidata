import 'package:flutter/material.dart';

import '../../../data/data_repository.dart';
import '../../data/model/album.dart';
import '../../res/strings.dart';
import '../../ui/data_page.dart';
import 'album_widget.dart';

class AlbumPage extends StatelessWidget {
  final Album album;

  const AlbumPage(this.album, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.s.albumsPage.title(album.id)),
      ),
      body: DataPage(
        loader: () => DataRepository.i.getPhotos(album),
        dataBuilder: AlbumWidget.new,
      ),
    );
  }
}
