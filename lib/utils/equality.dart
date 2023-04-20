import 'package:equatable/equatable.dart' as eq;

abstract class Equality extends eq.Equatable {
  const Equality();

  @override
  bool? get stringify => true;
}
