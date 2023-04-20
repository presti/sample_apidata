import 'package:sample_apidata/external/http_service.dart';
import 'package:sample_apidata/external/map_service.dart';
import 'package:sample_apidata/external/service_locator.dart';

import 'stub_http_service.dart';

class TestServiceLocator implements ServiceLocator {
  @override
  HttpService httpService = StubHttpService();

  @override
  MapService mapService = MapService.i;
}
