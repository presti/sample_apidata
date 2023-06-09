import 'dart:convert' as convert;

import 'functional/may_fail.dart';

typedef Json = Map<String, dynamic>;

class JsonUtils {
  static const JsonUtils i = JsonUtils._();

  const JsonUtils._();

  Json from(Map map) {
    return Map.castFrom<dynamic, dynamic, String, dynamic>(map);
  }

  May<T> fromJson<T, J>(J json, T Function(J) fromJson) {
    T t;
    try {
      t = fromJson(json);
    } catch (e) {
      return Fail(JsonInvalidFailure(e, json));
    }
    return Success(t);
  }

  May<J> decode<J>(String text) {
    J json;
    try {
      json = convert.json.decode(text) as J;
    } catch (e) {
      return Fail(JsonDecodingFailure(e, text));
    }
    return Success(json);
  }

  May<List<Json>> castToJsonList(List<dynamic> list) {
    List<Json> jsonList;
    try {
      jsonList = list.cast<Json>();
    } catch (e) {
      return Fail(JsonInvalidFailure(e, list));
    }
    return Success(jsonList);
  }
}

class JsonInvalidFailure<J> extends Failure {
  final Object error;
  final J json;

  @override
  Object? get data => '$error : $json';

  const JsonInvalidFailure(this.error, this.json);

  @override
  List<Object?> get props => [...super.props, error, json];
}

class JsonDecodingFailure extends Failure {
  final Object error;
  final String src;

  @override
  Object? get data => '$error : $src';

  const JsonDecodingFailure(this.error, this.src);

  @override
  List<Object?> get props => [...super.props, error, src];
}
