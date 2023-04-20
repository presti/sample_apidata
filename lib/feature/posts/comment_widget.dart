import 'package:flutter/widgets.dart';

import '../../data/model/comment.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget(this.comment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          comment.name,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          comment.email,
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: Text(
            comment.body,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
