import 'package:flutter/widgets.dart';

import '../rx/data.dart';

class ImageBuilder extends StatefulWidget {
  final String url;
  final Widget Function() onLoading;
  final Widget Function() onError;
  final Widget Function(NetworkImage image) onLoaded;

  const ImageBuilder(
    this.url, {
    Key? key,
    required this.onLoading,
    required this.onError,
    required this.onLoaded,
  }) : super(key: key);

  @override
  State<ImageBuilder> createState() => _ImageBuilderState();
}

class _ImageBuilderState extends State<ImageBuilder> {
  late final NetworkImage image;
  final Data<bool?> mayLoaded = Data(null);

  @override
  void initState() {
    super.initState();
    image = NetworkImage(widget.url);
    image.resolve(ImageConfiguration()).addListener(
          ImageStreamListener(
            (image, synchronousCall) {
              mayLoaded.value = true;
            },
            onError: (exception, stackTrace) {
              mayLoaded.value = false;
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return mayLoaded.builder((loaded) {
      if (loaded == null) {
        return widget.onLoading();
      } else if (loaded) {
        return widget.onLoaded(image);
      } else {
        return widget.onError();
      }
    });
  }
}
