import 'package:flutter/material.dart';

import '../../../data/data_repository.dart';
import '../../../data/model/user.dart';
import '../../ui/data_page.dart';
import 'albums_widget.dart';

class AlbumsPage extends StatelessWidget {
  final User user;

  const AlbumsPage(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return DataPage(
      loader: () => DataRepository.i.getAlbums(user),
      dataBuilder: AlbumsWidget.new,
    );
  }
}
