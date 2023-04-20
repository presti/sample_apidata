import 'package:flutter/material.dart';

import '../../../utils/rx/future_data.dart';
import '../../res/strings.dart';

class FutureDataWidget<T> extends StatelessWidget {
  final FutureData<List<T>> futureData;
  final Widget Function(List<T> data) dataBuilder;
  final Key? errorKey;

  const FutureDataWidget(
    this.futureData, {
    super.key,
    required this.dataBuilder,
    this.errorKey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: futureData.builder(
        (mayData) {
          if (mayData == null) {
            return const CircularProgressIndicator();
          } else {
            return mayData.on(
              onSuccess: (data) => dataBuilder(data),
              onFailure: (f) => Text(
                context.s.error,
                key: errorKey,
              ),
            );
          }
        },
      ),
    );
  }
}
