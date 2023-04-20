import '../../utils/equality.dart';

class Photo extends Equality {
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo({
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [id, title, url, thumbnailUrl];
}
