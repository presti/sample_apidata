import '../../utils/equality.dart';
import '../../utils/functional/may_fail.dart';
import '../../utils/json_utils.dart';
import '../model/album.dart';

class AlbumDto extends Equality {
  final int userId;
  final int id;
  final String title;

  const AlbumDto._({
    required this.userId,
    required this.id,
    required this.title,
  });

  static May<AlbumDto> fromJson(Json json) {
    return JsonUtils.i.fromJson(
      json,
      (json) {
        return AlbumDto._(
          userId: json['userId'],
          id: json['id'],
          title: json['title'],
        );
      },
    );
  }

  Album toModel() {
    return Album(id: id, title: title);
  }

  @override
  List<Object?> get props => [userId, id, title];
}
