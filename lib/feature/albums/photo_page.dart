import 'package:flutter/material.dart';

import '../../data/model/photo.dart';
import '../../res/colours.dart';
import '../../res/strings.dart';
import '../../utils/rx/data.dart';
import '../../utils/ui/image_builder.dart';

class PhotoPage extends StatefulWidget {
  final List<Photo> photos;
  final int index;

  const PhotoPage(this.photos, this.index, {super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  late final Data<int> currentIndex;
  late final PageController controller;

  @override
  void initState() {
    super.initState();
    currentIndex = Data(widget.index);
    controller = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.i.photoBackground,
      appBar: AppBar(
        title: currentIndex.builder((index) {
          return Text(context.s.albumsPage.photo(widget.photos[index].id));
        }),
      ),
      body: PageView.builder(
        allowImplicitScrolling: true,
        controller: controller,
        itemBuilder: (context, index) {
          return ImageBuilder(
            widget.photos[index].url,
            onLoading: () => buildOnLoading(index),
            onError: () => Icon(
              Icons.warning,
              size: 64,
              color: Colours.i.imageError,
            ),
            onLoaded: (image) => Ink.image(image: image),
          );
        },
        onPageChanged: (index) => currentIndex.value = index,
        itemCount: widget.photos.length,
      ),
    );
  }

  Widget buildOnLoading(int index) {
    return Stack(
      children: [
        Center(
          child: ImageBuilder(
            widget.photos[index].thumbnailUrl,
            onLoading: () => const SizedBox(),
            onError: () => const SizedBox(),
            onLoaded: (image) => Image(
              image: image,
            ),
          ),
        ),
        Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }
}
