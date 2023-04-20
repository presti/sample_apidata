import 'package:flutter/material.dart';

import '../../data/model/comment.dart';
import '../../res/strings.dart';
import '../../utils/functional/may_fail.dart';
import 'comment_widget.dart';

class CommentsBottomSheet {
  static const CommentsBottomSheet i = CommentsBottomSheet._();

  const CommentsBottomSheet._();

  Future<void> showComments(
    BuildContext context,
    Widget Function(Widget Function(May<List<Comment>>? mayComments) onData)
        builder,
  ) async {
    const borderRadius = 16.0;

    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: builder(
            (mayComments) {
              if (mayComments == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return mayComments.on(
                  onSuccess: (comments) {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: borderRadius - 4,
                      ),
                      itemCount: comments.length,
                      separatorBuilder: (context, index) =>
                          Divider(thickness: 2, height: 24),
                      itemBuilder: (context, index) =>
                          CommentWidget(comments[index]),
                    );
                  },
                  onFailure: (f) => Center(child: Text(context.s.error)),
                );
              }
            },
          ),
        );
      },
    );
  }
}
