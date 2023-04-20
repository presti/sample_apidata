import '../../utils/equality.dart';
import '../../utils/functional/may_fail.dart';
import '../../utils/json_utils.dart';
import '../model/post.dart';

class PostDto extends Equality {
  final int userId;
  final int id;
  final String title;
  final String body;

  const PostDto._({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  static May<PostDto> fromJson(Json json) {
    return JsonUtils.i.fromJson(
      json,
      (json) {
        return PostDto._(
          userId: json['userId'],
          id: json['id'],
          title: json['title'],
          body: json['body'],
        );
      },
    );
  }

  Post toModel() {
    return Post(id: id, title: title, body: body);
  }

  @override
  List<Object?> get props => [userId, id, title, body];
}
