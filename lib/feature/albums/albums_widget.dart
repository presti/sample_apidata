import 'package:flutter/material.dart';

import '../../data/model/album.dart';
import '../../res/colours.dart';
import '../../utils/routing.dart';

class AlbumsWidget extends StatelessWidget {
  final List<Album> albums;

  const AlbumsWidget(this.albums, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) => _buildAlbum(context, albums[index]),
      itemCount: albums.length,
    );
  }

  Widget _buildAlbum(BuildContext context, Album album) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colours.i.album2, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colours.i.album,
      splashColor: Colours.i.album2,
      onPressed: () => Routing.i.pushAlbums(context, album),
      child: Text(
        album.title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
