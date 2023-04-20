import '../../utils/equality.dart';
import '../../utils/functional/may_fail.dart';
import '../data_repository.dart';
import 'comment.dart';

class Post extends Equality {
  final int id;
  final String title;
  final String body;

  Future<May<List<Comment>>> get comments => DataRepository.i.getComments(this);

  const Post({
    required this.id,
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [id, title, body];
}
