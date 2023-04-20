import 'package:flutter/material.dart';

import '../../data/model/photo.dart';
import '../../utils/routing.dart';
import '../../utils/ui/image_builder.dart';

class AlbumWidget extends StatelessWidget {
  final List<Photo> photos;

  const AlbumWidget(this.photos, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) => buildPhoto(context, photos[index]),
      itemCount: photos.length,
    );
  }

  Widget buildPhoto(BuildContext context, Photo photo) {
    return InkWell(
      onTap: () => Routing.i.pushPhotos(context, photos, photos.indexOf(photo)),
      child: ImageBuilder(
        photo.thumbnailUrl,
        onLoading: () => _buildOnLoadingPhoto(photo),
        onError: () => _buildOnLoadingPhoto(photo),
        onLoaded: (image) {
          return Ink.image(
            image: image,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildOnLoadingPhoto(Photo photo) {
    return Center(
      child: Text(
        photo.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
