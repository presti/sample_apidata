import '../../utils/equality.dart';
import '../../utils/functional/may_fail.dart';
import '../../utils/json_utils.dart';
import '../model/photo.dart';

class PhotoDto extends Equality {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const PhotoDto._({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  static May<PhotoDto> fromJson(Json json) {
    return JsonUtils.i.fromJson(
      json,
      (json) {
        return PhotoDto._(
          albumId: json['albumId'],
          id: json['id'],
          title: json['title'],
          url: json['url'],
          thumbnailUrl: json['thumbnailUrl'],
        );
      },
    );
  }

  Photo toModel() {
    return Photo(id: id, title: title, url: url, thumbnailUrl: thumbnailUrl);
  }

  @override
  List<Object?> get props => [albumId, id, title, url, thumbnailUrl];
}
