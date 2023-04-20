import 'package:sample_apidata/external/http_service.dart';
import 'package:sample_apidata/utils/functional/may_fail.dart';

/// For simplicity for this sample, there is no possibility to
/// stub something different than a 200 request, such as a
/// different status code or a timeout.
class HttpServiceStubs {
  HttpServiceStubs._();

  String usersResponse = '';
}

class StubHttpService implements HttpService {
  final HttpServiceStubs stubs = HttpServiceStubs._();

  @override
  Future<MayFail<HttpResponse, HttpErrorFailure>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    const usersUrl = 'https://jsonplaceholder.typicode.com/users';
    if (url == usersUrl) {
      return Success(
        HttpResponse(
          statusCode: 200,
          body: stubs.usersResponse,
        ),
      );
    } else {
      throw UnimplementedError();
    }
  }
}
