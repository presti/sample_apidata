import 'package:flutter_bloc/flutter_bloc.dart' as bl;

import '../../../data/data_repository.dart';
import '../../../data/model/post.dart';
import '../../../data/model/user.dart';
import 'posts_state.dart';

class PostsCubit extends bl.Cubit<PostsState> {
  final User user;

  PostsCubit(this.user) : super(PostsLoadingState()) {
    _getPosts();
  }

  Future<void> _getPosts() async {
    final mayPosts = await DataRepository.i.getPosts(user);
    emit(
      mayPosts.on(
        onSuccess: (posts) => PostsSuccessState(posts),
        onFailure: (f) => PostsFailedState(),
      ),
    );
  }

  Future<void> openComments(Post post) async {
    final state = this.state;
    if (state is PostsSuccessState) {
      final commentsLoadingState = PostCommentsLoadingState(post);
      final commentsState = PostCommentsSheetOpenedState(commentsLoadingState);

      emit(PostsSuccessState(state.posts, commentsState));
      final mayComments = await post.comments;

      final currentState = this.state;
      bool isStillInSameCommentsState = currentState is PostsSuccessState &&
          currentState.commentsSheetState == commentsState;

      if (isStillInSameCommentsState) {
        emit(
          PostsSuccessState(
            currentState.posts,
            PostCommentsSheetOpenedState(PostCommentsLoadedState(mayComments)),
          ),
        );
      }
    }
  }

  void closeComments() {
    final state = this.state;
    if (state is PostsSuccessState) {
      emit(PostsSuccessState(state.posts));
    }
  }
}
