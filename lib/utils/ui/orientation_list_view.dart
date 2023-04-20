import 'package:flutter/widgets.dart';

class OrientationListView<T> extends StatelessWidget {
  final List<T> list;
  final Widget Function(BuildContext context, T data) builder;

  const OrientationListView(
    this.list, {
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return ListView.builder(
            itemBuilder: (context, index) => builder(context, list[index]),
            itemCount: list.length,
          );
        } else {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: builder(context, list[index * 2])),
                  if (list.length > index + 1)
                    Expanded(child: builder(context, list[index * 2 + 1])),
                ],
              );
            },
            itemCount: list.length ~/ 2 + list.length % 2,
          );
        }
      },
    );
  }
}
