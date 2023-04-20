import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/comment.dart';
import '../../../data/model/post.dart';
import '../../../data/model/user.dart';
import '../../../feature/posts/comments_bottom_sheet.dart';
import '../../../feature/posts/posts_widget.dart';
import '../../../utils/functional/may_fail.dart';
import 'posts_cubit.dart';
import 'posts_state.dart';

class PostsPage extends StatelessWidget {
  final User user;

  const PostsPage(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsCubit(user),
      child: PostsWidget<Post>(
        onPostCommentPressed: (context, post) {
          context.read<PostsCubit>().openComments(post);
        },
        postBuilder: postBuilder,
        getBody: (post) => post.body,
        getTitle: (post) => post.title,
      ),
    );
  }

  Widget postBuilder(Widget Function(May<List<Post>>? mayPosts) onData) {
    return BlocConsumer<PostsCubit, PostsState>(
      listenWhen: (previous, current) {
        return current.hasDialogOpenedFrom(previous);
      },
      listener: (context, state) async {
        final openedCommentsState = state.getCommentsOpened();
        if (openedCommentsState != null) {
          await CommentsBottomSheet.i.showComments(
            context,
            (onData) {
              final bloc = context.read<PostsCubit>();
              return commentsBuilder(bloc, onData);
            },
          );
          if (context.mounted) {
            context.read<PostsCubit>().closeComments();
          }
        }
      },
      builder: (context, state) {
        return state.on(
          onLoading: () => onData(null),
          onFailed: () => onData(Fail.of(null)),
          onSuccess: (state) => onData(Success(state.posts)),
        );
      },
    );
  }

  Widget commentsBuilder(
    PostsCubit bloc,
    Widget Function(May<List<Comment>>? mayComments) onData,
  ) {
    return BlocBuilder<PostsCubit, PostsState>(
      bloc: bloc,
      buildWhen: (previous, current) {
        // builder will throw is buildWhen is changed.
        final state = current;
        return state is PostsSuccessState &&
            state.commentsSheetState is PostCommentsSheetOpenedState;
      },
      builder: (context, state) {
        if (state is PostsSuccessState) {
          final commentsSheetState = state.commentsSheetState;
          if (commentsSheetState is PostCommentsSheetOpenedState) {
            return commentsSheetState.commentsState.on(
              onLoading: () => onData(null),
              onLoaded: (commentsLoadedState) {
                return commentsLoadedState.mayComments.on(
                  onSuccess: (comments) => onData(Success(comments)),
                  onFailure: (f) => onData(f.wrap()),
                );
              },
            );
          }
        }
        throw 'Should not happen given buildWhen';
      },
    );
  }
}
