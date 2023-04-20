import 'package:flutter/material.dart';

import '../../../utils/rx/future_data.dart';
import '../utils/functional/may_fail.dart';
import 'data_widget.dart';

class DataPage<T> extends StatefulWidget {
  final Future<May<List<T>>> Function() loader;
  final Widget Function(List<T> data) dataBuilder;
  final Key? errorKey;

  const DataPage({
    super.key,
    required this.loader,
    required this.dataBuilder,
    this.errorKey,
  });

  @override
  State<DataPage> createState() => _DataPageState<T>();
}

class _DataPageState<T> extends State<DataPage<T>> {
  late final FutureData<List<T>> data;

  @override
  void initState() {
    super.initState();
    data = FutureData(widget.loader);
  }

  @override
  Widget build(BuildContext context) {
    return FutureDataWidget(
      data,
      dataBuilder: widget.dataBuilder,
      errorKey: widget.errorKey,
    );
  }
}
