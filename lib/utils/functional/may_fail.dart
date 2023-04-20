import 'package:meta/meta.dart';

import '../equality.dart';
import '../logger.dart';

const Success<void, Failure> successVoid = Success(null);

typedef May<V> = MayFail<V, Failure>;

abstract class MayFail<V, F extends Failure> {
  static MayFail<V, F> of<V, F extends Failure>(
    V Function() mayThrow,
    F Function(Object error, StackTrace) failure,
  ) {
    try {
      return Success(mayThrow());
    } catch (e, s) {
      return Fail(failure(e, s));
    }
  }

  T on<T>({
    required T Function(V) onSuccess,
    required T Function(F) onFailure,
  });

  MayFail<V2, F> onSuccess<V2>(MayFail<V2, F> Function(V) onSuccess);

  Future<MayFail<V2, F>> onSuccessFuture<V2>(
    Future<MayFail<V2, F>> Function(V) onSuccess,
  );

  MayFail<V, F2> onFailure<F2 extends Failure>(
    MayFail<V, F2> Function(F) onFailure,
  );

  Future<MayFail<V, F2>> onFailureFuture<F2 extends Failure>(
    Future<MayFail<V, F2>> Function(F) onFailure,
  );

  MayFail<V2, F2> cast<V2, F2 extends Failure>();

  V force() {
    return Logger.i.tryError(() {
      return on(
        onSuccess: (v) => v,
        onFailure: (f) => throw f,
      );
    });
  }
}

@immutable
class Success<V, F extends Failure> with MayFail<V, F> {
  final V _value;

  const Success(this._value);

  @override
  T on<T>({
    required T Function(V) onSuccess,
    required T Function(Never) onFailure,
  }) =>
      onSuccess(_value);

  @override
  MayFail<V2, F> onSuccess<V2>(MayFail<V2, F> Function(V) onSuccess) {
    return onSuccess(_value);
  }

  @override
  Future<MayFail<V2, F>> onSuccessFuture<V2>(
    Future<MayFail<V2, F>> Function(V) onSuccess,
  ) {
    return onSuccess(_value);
  }

  @override
  MayFail<V, F2> onFailure<F2 extends Failure>(
    MayFail<V, F2> Function(F) onFailure,
  ) {
    return Success(_value);
  }

  @override
  Future<MayFail<V, F2>> onFailureFuture<F2 extends Failure>(
    Future<MayFail<V, F2>> Function(F) onFailure,
  ) async {
    return Success(_value);
  }

  @override
  MayFail<V2, F2> cast<V2, F2 extends Failure>() {
    assert(this is MayFail<V2, F2>);
    return Success(_value as V2);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<V, F> && _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => 'Success($_value)';
}

@immutable
class Fail<V, F extends Failure> with MayFail<V, F> {
  final F _failure;

  static Fail<V, Failure> of<V>(Object? o) => Fail(Failure(o));

  Fail(this._failure) {
    Logger.i.log('Fail<$V,$F>:$_failure\n${StackTrace.current}');
  }

  Fail._create(this._failure);

  @override
  T on<T>({
    required T Function(Never) onSuccess,
    required T Function(F) onFailure,
  }) =>
      onFailure(_failure);

  @override
  MayFail<V2, F> onSuccess<V2>(MayFail<V2, F> Function(V) onSuccess) {
    return Fail._create(_failure);
  }

  @override
  Future<MayFail<V2, F>> onSuccessFuture<V2>(
    Future<MayFail<V2, F>> Function(V) onSuccess,
  ) async {
    return Fail._create(_failure);
  }

  @override
  MayFail<V, F2> onFailure<F2 extends Failure>(
    MayFail<V, F2> Function(F) onFailure,
  ) {
    return onFailure(_failure);
  }

  @override
  Future<MayFail<V, F2>> onFailureFuture<F2 extends Failure>(
    Future<MayFail<V, F2>> Function(F) onFailure,
  ) async {
    return onFailure(_failure);
  }

  @override
  MayFail<V2, F2> cast<V2, F2 extends Failure>() {
    assert(this is MayFail<V2, F2>);
    return Fail._create(_failure as F2);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Fail<V, F> && _failure == other._failure;

  @override
  int get hashCode => _failure.hashCode;

  @override
  String toString() => 'Fail($_failure)';
}

class Failure extends Equality {
  final Object? data;

  const Failure([this.data]);

  Fail<V, F> wrap<V, F extends Failure>() {
    return Fail._create(this as F);
  }

  @override
  String toString() {
    //ignore: no_runtimeType_toString
    return '$runtimeType-${data ?? ''}';
  }

  @override
  List<Object?> get props => [data];
}

extension OnSuccessWithFuture<V, F extends Failure> on Future<MayFail<V, F>> {
  Future<T> on<T>({
    required Future<T> Function(V) onSuccess,
    required Future<T> Function(F) onFailure,
  }) async {
    final may = await this;
    return may.on(onSuccess: onSuccess, onFailure: onFailure);
  }

  Future<MayFail<V2, F>> onSuccess<V2>(
    Future<MayFail<V2, F>> Function(V) onSuccess,
  ) async {
    final may = await this;
    return may.onSuccessFuture(onSuccess);
  }

  Future<MayFail<V, F2>> onFailure<F2 extends Failure>(
    Future<MayFail<V, F2>> Function(F) onFailure,
  ) async {
    final may = await this;
    return may.onFailureFuture(onFailure);
  }

  Future<MayFail<V2, F2>> cast<V2, F2 extends Failure>() async {
    final may = await this;
    return may.cast();
  }
}

extension ListMay<T> on List<T> {
  /// If one fails, a [Fail] is returned.
  MayFail<List<V>, F> mapMay<V, F extends Failure>(
    MayFail<V, F> Function(T) f,
  ) {
    final list = <V>[];
    Fail<List<V>, F>? fail;
    for (final e in this) {
      f(e).on(
        onSuccess: list.add,
        onFailure: (f) => fail = f.wrap(),
      );
      if (fail != null) {
        break;
      }
    }
    return fail ?? Success(list);
  }

  List<V> mapAndExcludeFailures<V, F extends Failure>(
    MayFail<V, F> Function(T) f,
  ) {
    final list = <V>[];
    for (final e in this) {
      f(e).on(
        onSuccess: list.add,
        onFailure: (f) {},
      );
    }
    return list;
  }
}
