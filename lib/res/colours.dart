import 'package:flutter/material.dart';

class Colours {
  static const Colours i = Colours._();

  const Colours._();

  Color get primary => const Color.fromARGB(255, 0, 145, 133);

  Color get checked => const Color.fromARGB(77, 0, 255, 0);

  Color get missing => const Color.fromARGB(77, 255, 0, 0);

  Color get album => const Color(0x6077E1FA);

  Color get album2 => const Color(0xDDFFCA28);

  Color get userCardShadow => Colors.yellow;

  Color get photoBackground => Colors.black;

  Color get imageError => Colors.red;
}
