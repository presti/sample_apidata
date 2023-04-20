import '../../utils/equality.dart';
import '../../utils/functional/may_fail.dart';
import '../data_repository.dart';
import 'photo.dart';

class Album extends Equality {
  final int id;
  final String title;

  Future<May<List<Photo>>> get photos => DataRepository.i.getPhotos(this);

  const Album({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}
