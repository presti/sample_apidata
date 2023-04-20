import 'package:flutter/widgets.dart';

import '../functional/may_fail.dart';
import 'data.dart';

class FutureData<T> {
  final Data<bool> _isLoadingData = Data(false);
  final Future<May<T>> Function() _loader;
  May<T>? _mayValue;
  bool _wasLoadCalled = false;

  FutureData(this._loader);

  DataBuilder builder(Widget Function(May<T>? value) f) {
    _wasLoadCalled ? null : load();
    return _isLoadingData.builder((isLoading) => f(_mayValue));
  }

  /// You would normally not want to await this.
  Future<void> load() async {
    _wasLoadCalled = true;
    _isLoadingData.value = true;
    _mayValue = await _loader();
    _isLoadingData.value = false;
  }
}
