import 'package:flutter/material.dart';

import '../../../data/data_repository.dart';
import '../../../data/model/user.dart';
import '../../../feature/posts/comments_bottom_sheet.dart';
import '../../../feature/posts/posts_widget.dart';
import '../../../utils/functional/may_fail.dart';
import '../../../utils/rx/future_data.dart';
import 'post_data.dart';

class PostsPage extends StatefulWidget {
  final User user;

  const PostsPage(this.user, {super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late final FutureData<List<PostData>> posts;

  @override
  void initState() {
    super.initState();

    posts = FutureData(
      () => DataRepository.i.getPosts(widget.user).onSuccess(
            (posts) async => Success(posts.map(PostData.new).toList()),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PostsWidget<PostData>(
      onPostCommentPressed: (context, post) {
        CommentsBottomSheet.i.showComments(context, post.comments.builder);
      },
      postBuilder: posts.builder,
      getBody: (post) => post.body,
      getTitle: (post) => post.title,
    );
  }
}
