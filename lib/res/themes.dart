import 'package:flutter/material.dart';

import '../res/colours.dart';

extension BuildContextTheme on BuildContext {
  // The context is not needed, but it is used for a seamless
  // potential transition.
  Themes get t => Themes._i;
}

class Themes {
  const Themes._();

  static const Themes _i = Themes._();

  ThemeData get app => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colours.i.primary,
      );

  ThemeData get dark => ThemeData(brightness: Brightness.dark);
}
