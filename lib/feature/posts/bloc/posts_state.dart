import '../../../data/model/comment.dart';
import '../../../data/model/post.dart';
import '../../../utils/equality.dart';
import '../../../utils/functional/may_fail.dart';

abstract class PostsState extends Equality {
  const PostsState();

  T on<T>({
    required T Function() onLoading,
    required T Function() onFailed,
    required T Function(PostsSuccessState state) onSuccess,
  }) {
    final myself = this;
    if (myself is PostsLoadingState) {
      return onLoading();
    } else if (myself is PostsFailedState) {
      return onFailed();
    } else if (myself is PostsSuccessState) {
      return onSuccess(myself);
    } else {
      throw TypeError();
    }
  }

  PostCommentsSheetOpenedState? getCommentsOpened() {
    final state = this;
    if (state is PostsSuccessState) {
      final commentsSheetState = state.commentsSheetState;
      return commentsSheetState is PostCommentsSheetOpenedState
          ? commentsSheetState
          : null;
    } else {
      return null;
    }
  }

  bool areCommentsOpened() {
    final state = this;
    return state is PostsSuccessState && state.commentsSheetState.isOpened;
  }

  bool hasDialogOpenedFrom(PostsState previous) {
    return areCommentsOpened() && !previous.areCommentsOpened();
  }

  @override
  List<Object?> get props => [];
}

class PostsLoadingState extends PostsState {
  const PostsLoadingState();
}

class PostsFailedState extends PostsState {
  const PostsFailedState();
}

class PostsSuccessState extends PostsState {
  final List<Post> posts;

  final PostCommentsSheetState commentsSheetState;

  const PostsSuccessState(
    this.posts, [
    this.commentsSheetState = const PostCommentsSheetNotOpenedState(),
  ]);

  @override
  List<Object?> get props => super.props + [posts, commentsSheetState];
}

abstract class PostCommentsSheetState extends Equality {
  const PostCommentsSheetState();

  bool get isOpened => this is PostCommentsSheetOpenedState;

  T on<T>({
    required T Function() onNotOpened,
    required T Function(PostCommentsSheetOpenedState state) onOpened,
  }) {
    final myself = this;
    if (myself is PostCommentsSheetNotOpenedState) {
      return onNotOpened();
    } else if (myself is PostCommentsSheetOpenedState) {
      return onOpened(myself);
    } else {
      throw TypeError();
    }
  }

  @override
  List<Object?> get props => [];
}

class PostCommentsSheetNotOpenedState extends PostCommentsSheetState {
  const PostCommentsSheetNotOpenedState();
}

class PostCommentsSheetOpenedState extends PostCommentsSheetState {
  final PostCommentsState commentsState;

  const PostCommentsSheetOpenedState(this.commentsState);

  @override
  List<Object?> get props => super.props + [commentsState];
}

abstract class PostCommentsState extends Equality {
  const PostCommentsState();

  T on<T>({
    required T Function() onLoading,
    required T Function(PostCommentsLoadedState state) onLoaded,
  }) {
    final myself = this;
    if (myself is PostCommentsLoadingState) {
      return onLoading();
    } else if (myself is PostCommentsLoadedState) {
      return onLoaded(myself);
    } else {
      throw TypeError();
    }
  }

  @override
  List<Object?> get props => [];
}

class PostCommentsLoadingState extends PostCommentsState {
  final Post post;

  const PostCommentsLoadingState(this.post);

  @override
  List<Object?> get props => super.props + [post];
}

class PostCommentsLoadedState extends PostCommentsState {
  final May<List<Comment>> mayComments;

  const PostCommentsLoadedState(this.mayComments);

  @override
  List<Object?> get props => super.props + [mayComments];
}
