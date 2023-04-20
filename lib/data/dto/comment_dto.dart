import '../../utils/equality.dart';
import '../../utils/functional/may_fail.dart';
import '../../utils/json_utils.dart';
import '../model/comment.dart';

class CommentDto extends Equality {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  const CommentDto._({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  static May<CommentDto> fromJson(Json json) {
    return JsonUtils.i.fromJson(
      json,
      (json) {
        return CommentDto._(
          postId: json['postId'],
          id: json['id'],
          name: json['name'],
          email: json['email'],
          body: json['body'],
        );
      },
    );
  }

  Comment toModel() {
    return Comment(name: name, email: email, body: body);
  }

  @override
  List<Object?> get props => [postId, id, name, email, body];
}
