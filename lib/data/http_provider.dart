import '../external/http_service.dart';
import '../external/service_locator.dart';
import '../utils/functional/may_fail.dart';
import '../utils/json_utils.dart';
import 'dto/album_dto.dart';
import 'dto/comment_dto.dart';
import 'dto/photo_dto.dart';
import 'dto/post_dto.dart';
import 'dto/todo_dto.dart';
import 'dto/user_dto.dart';

class HttpProvider {
  static const HttpProvider i = HttpProvider._();

  HttpService get _httpService => sl().httpService;

  const HttpProvider._();

  static const _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const _usersUrl = '$_baseUrl/users';

  String _albumsUrl(int userId) => '$_baseUrl/albums?userId=$userId';

  String _photosUrl(int albumId) => '$_baseUrl/photos?albumId=$albumId';

  String _postsUrl(int userId) => '$_baseUrl/posts?userId=$userId';

  String _commentsUrl(int postId) => '$_baseUrl/comments?postId=$postId';

  String _todosUrl(int userId) => '$_baseUrl/todos?userId=$userId';

  Future<May<List<UserDto>>> getUsers() async {
    return _getDtos(_usersUrl, UserDto.fromJson);
  }

  Future<May<List<AlbumDto>>> getAlbums(int userId) async {
    return _getDtos(_albumsUrl(userId), AlbumDto.fromJson);
  }

  Future<May<List<PhotoDto>>> getPhotos(int albumId) async {
    return _getDtos(_photosUrl(albumId), PhotoDto.fromJson);
  }

  Future<May<List<PostDto>>> getPosts(int userId) async {
    return _getDtos(_postsUrl(userId), PostDto.fromJson);
  }

  Future<May<List<CommentDto>>> getComments(int postId) async {
    return _getDtos(_commentsUrl(postId), CommentDto.fromJson);
  }

  Future<May<List<TodoDto>>> getTodos(int userId) async {
    return _getDtos(_todosUrl(userId), TodoDto.fromJson);
  }

  Future<May<List<T>>> _getDtos<T>(
      String url, May<T> Function(Json json) fromJson) async {
    return _getAndDecodeList(
      url: url,
      fromJson: (jsonList) => jsonList.mapMay(fromJson),
    );
  }

  Future<May<T>> _getAndDecodeList<T>({
    required String url,
    required May<T> Function(List<Json> jsonList) fromJson,
  }) {
    return _getAndDecodeJson(
      url: url,
      fromJson: (List<dynamic> list) =>
          JsonUtils.i.castToJsonList(list).onSuccess(fromJson),
    );
  }

  Future<May<T>> _getAndDecodeJson<T, J>({
    required String url,
    required May<T> Function(J json) fromJson,
  }) {
    return _get(url: url)
        .cast<HttpResponse, Failure>()
        .onSuccess((res) async => JsonUtils.i.decode<J>(res.body))
        .onSuccess((json) async => fromJson(json));
  }

  Future<May<HttpResponse>> _get({required String url}) {
    return _call(() => _httpService.get(url));
  }

  Future<May<HttpResponse>> _call(
      Future<MayFail<HttpResponse, HttpErrorFailure>> Function() call) async {
    return call()
        .cast<HttpResponse, Failure>()
        .onSuccess<HttpResponse>((response) async {
      int statusCode = response.statusCode;
      if (statusCode >= 100 && statusCode < 300) {
        return Success(HttpResponse(
          statusCode: statusCode,
          body: response.body,
        ));
      } else {
        return Fail(HttpNotSuccessfulFailure(statusCode: statusCode));
      }
    });
  }
}

class HttpNotSuccessfulFailure extends Failure {
  final int statusCode;

  const HttpNotSuccessfulFailure({required this.statusCode});

  @override
  List<Object?> get props => [...super.props, statusCode];
}
