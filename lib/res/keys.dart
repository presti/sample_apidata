import 'package:flutter/widgets.dart';

class Keys {
  const Keys._();

  static const Keys i = Keys._();

  UsersKeys get users => UsersKeys._i;
}

mixin ComponentKeys {
  String get _type;

  Key _of(String id) {
    return ValueKey('$_type.$id');
  }
}

class UsersKeys with ComponentKeys {
  const UsersKeys._();

  static const UsersKeys _i = UsersKeys._();

  @override
  String get _type => 'UsersKeys';

  Key get page => _of('page');

  Key get txTitle => _of('txTitle');

  Key get txError => _of('txError');

  Key get lsCards => _of('lsCards');

  Key wdCard(int userId) => _of('wdCard$userId');
}
