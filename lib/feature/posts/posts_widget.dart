import 'package:flutter/material.dart';

import '../../res/strings.dart';
import '../../utils/functional/may_fail.dart';
import '../../utils/ui/orientation_list_view.dart';

typedef MayPostsCallback<T> = Widget Function(May<List<T>>? mayPosts);

class PostsWidget<T> extends StatelessWidget {
  final void Function(BuildContext context, T post) onPostCommentPressed;
  final Widget Function(MayPostsCallback<T> onData) postBuilder;
  final String Function(T post) getBody;
  final String Function(T post) getTitle;

  const PostsWidget({
    super.key,
    required this.onPostCommentPressed,
    required this.postBuilder,
    required this.getBody,
    required this.getTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: postBuilder(
        (mayPosts) {
          if (mayPosts == null) {
            return const CircularProgressIndicator();
          } else {
            return mayPosts.on(
              onSuccess: (posts) => _buildPosts(posts),
              onFailure: (f) => Text(context.s.error),
            );
          }
        },
      ),
    );
  }

  Widget _buildPosts(List<T> posts) {
    return OrientationListView(posts, builder: _buildPost);
  }

  Widget _buildPost(BuildContext context, T post) {
    return Builder(
      builder: (context) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  getTitle(post),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    getBody(post),
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  child: Center(child: Text(context.s.postsPage.comments)),
                  onPressed: () => onPostCommentPressed(context, post),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
