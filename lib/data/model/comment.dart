import '../../utils/equality.dart';

class Comment extends Equality {
  final String name;
  final String email;
  final String body;

  const Comment({
    required this.name,
    required this.email,
    required this.body,
  });

  @override
  List<Object?> get props => [name, email, body];
}
