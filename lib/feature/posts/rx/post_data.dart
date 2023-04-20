import '../../../data/data_repository.dart';
import '../../../data/model/comment.dart';
import '../../../data/model/post.dart';
import '../../../utils/equality.dart';
import '../../../utils/rx/future_data.dart';

class PostData extends Equality {
  final FutureData<List<Comment>> comments;

  String get title => _post.title;

  String get body => _post.body;

  final Post _post;

  PostData(this._post)
      : comments = FutureData(() => DataRepository.i.getComments(_post));

  @override
  List<Object?> get props => [comments, _post];
}
