import '../utils/functional/may_fail.dart';
import 'http_provider.dart';
import 'model/album.dart';
import 'model/comment.dart';
import 'model/photo.dart';
import 'model/post.dart';
import 'model/todo.dart';
import 'model/user.dart';

class DataRepository {
  static final DataRepository i = DataRepository._();

  DataRepository._();

  final Map<int, Future<May<List<Album>>>> _albums = {};
  final Map<int, Future<May<List<Photo>>>> _photos = {};
  final Map<int, Future<May<List<Post>>>> _posts = {};
  final Map<int, Future<May<List<Comment>>>> _comments = {};
  final Map<int, Future<May<List<Todo>>>> _todos = {};

  HttpProvider get _provider => HttpProvider.i;

  Future<May<List<User>>> getUsers() async {
    return _provider
        .getUsers()
        .onSuccess((dtos) async => dtos.mapMay((dto) => dto.toModel()));
  }

  Future<May<List<Album>>> getAlbums(User user) async {
    return _get(
        _albums, user.id, _provider.getAlbums(user.id), (dto) => dto.toModel());
  }

  Future<May<List<Photo>>> getPhotos(Album album) async {
    return _get(_photos, album.id, _provider.getPhotos(album.id),
        (dto) => dto.toModel());
  }

  Future<May<List<Post>>> getPosts(User user) async {
    return _get(
        _posts, user.id, _provider.getPosts(user.id), (dto) => dto.toModel());
  }

  Future<May<List<Comment>>> getComments(Post post) async {
    return _get(_comments, post.id, _provider.getComments(post.id),
        (dto) => dto.toModel());
  }

  Future<May<List<Todo>>> getTodos(User user) async {
    return _get(
        _todos, user.id, _provider.getTodos(user.id), (dto) => dto.toModel());
  }

  Future<May<List<M>>> _get<D, M>(
    Map<int, Future<May<List<M>>>> map,
    int mapKey,
    Future<May<List<D>>> mayDtos,
    M Function(D) toModel,
  ) async {
    return map[mapKey] ??=
        mayDtos.onSuccess((dtos) async => Success(dtos.map(toModel).toList()));
  }
}
