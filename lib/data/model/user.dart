import '../../utils/equality.dart';
import '../../utils/functional/may_fail.dart';
import '../data_repository.dart';
import 'address.dart';
import 'album.dart';
import 'post.dart';
import 'todo.dart';

class User extends Equality {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final Address address;
  final Company company;

  Future<May<List<Album>>> get albums => DataRepository.i.getAlbums(this);

  Future<May<List<Post>>> get posts => DataRepository.i.getPosts(this);

  Future<May<List<Todo>>> get todos => DataRepository.i.getTodos(this);

  const User(
    this.id,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.website,
    this.address,
    this.company,
  );

  @override
  List<Object?> get props =>
      [id, name, username, email, phone, website, address, company];
}

class Company extends Equality {
  final String name;
  final String catchPhrase;
  final String bs;

  const Company(
    this.name,
    this.catchPhrase,
    this.bs,
  );

  @override
  List<Object?> get props => [name, catchPhrase, bs];
}
