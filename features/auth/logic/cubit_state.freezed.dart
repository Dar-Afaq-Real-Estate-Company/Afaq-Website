// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cubit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LoginState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(ApiErrorModel apiErrorModel) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(ApiErrorModel apiErrorModel)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(ApiErrorModel apiErrorModel)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(Success<T> value) success,
    required TResult Function(Error<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(Success<T> value)? success,
    TResult? Function(Error<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(Loading<T> value)? loading,
    TResult Function(Success<T> value)? success,
    TResult Function(Error<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginStateCopyWith<T, $Res> {
  factory $LoginStateCopyWith(
          LoginState<T> value, $Res Function(LoginState<T>) then) =
      _$LoginStateCopyWithImpl<T, $Res, LoginState<T>>;
}

/// @nodoc
class _$LoginStateCopyWithImpl<T, $Res, $Val extends LoginState<T>>
    implements $LoginStateCopyWith<T, $Res> {
  _$LoginStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<T, $Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl<T> value, $Res Function(_$InitialImpl<T>) then) =
      __$$InitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<T, $Res>
    extends _$LoginStateCopyWithImpl<T, $Res, _$InitialImpl<T>>
    implements _$$InitialImplCopyWith<T, $Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl<T> _value, $Res Function(_$InitialImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl<T> implements _Initial<T> {
  const _$InitialImpl();

  @override
  String toString() {
    return 'LoginState<$T>.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(ApiErrorModel apiErrorModel) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(ApiErrorModel apiErrorModel)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(ApiErrorModel apiErrorModel)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(Success<T> value) success,
    required TResult Function(Error<T> value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(Success<T> value)? success,
    TResult? Function(Error<T> value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(Loading<T> value)? loading,
    TResult Function(Success<T> value)? success,
    TResult Function(Error<T> value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial<T> implements LoginState<T> {
  const factory _Initial() = _$InitialImpl<T>;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<T, $Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl<T> value, $Res Function(_$LoadingImpl<T>) then) =
      __$$LoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<T, $Res>
    extends _$LoginStateCopyWithImpl<T, $Res, _$LoadingImpl<T>>
    implements _$$LoadingImplCopyWith<T, $Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl<T> _value, $Res Function(_$LoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl<T> implements Loading<T> {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'LoginState<$T>.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(ApiErrorModel apiErrorModel) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(ApiErrorModel apiErrorModel)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(ApiErrorModel apiErrorModel)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(Success<T> value) success,
    required TResult Function(Error<T> value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(Success<T> value)? success,
    TResult? Function(Error<T> value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(Loading<T> value)? loading,
    TResult Function(Success<T> value)? success,
    TResult Function(Error<T> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading<T> implements LoginState<T> {
  const factory Loading() = _$LoadingImpl<T>;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<T, $Res> {
  factory _$$SuccessImplCopyWith(
          _$SuccessImpl<T> value, $Res Function(_$SuccessImpl<T>) then) =
      __$$SuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<T, $Res>
    extends _$LoginStateCopyWithImpl<T, $Res, _$SuccessImpl<T>>
    implements _$$SuccessImplCopyWith<T, $Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl<T> _value, $Res Function(_$SuccessImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$SuccessImpl<T>(
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$SuccessImpl<T> implements Success<T> {
  const _$SuccessImpl(this.data);

  @override
  final T data;

  @override
  String toString() {
    return 'LoginState<$T>.success(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessImplCopyWith<T, _$SuccessImpl<T>> get copyWith =>
      __$$SuccessImplCopyWithImpl<T, _$SuccessImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(ApiErrorModel apiErrorModel) error,
  }) {
    return success(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(ApiErrorModel apiErrorModel)? error,
  }) {
    return success?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(ApiErrorModel apiErrorModel)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(Success<T> value) success,
    required TResult Function(Error<T> value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(Success<T> value)? success,
    TResult? Function(Error<T> value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(Loading<T> value)? loading,
    TResult Function(Success<T> value)? success,
    TResult Function(Error<T> value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class Success<T> implements LoginState<T> {
  const factory Success(final T data) = _$SuccessImpl<T>;

  T get data;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuccessImplCopyWith<T, _$SuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<T, $Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl<T> value, $Res Function(_$ErrorImpl<T>) then) =
      __$$ErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({ApiErrorModel apiErrorModel});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<T, $Res>
    extends _$LoginStateCopyWithImpl<T, $Res, _$ErrorImpl<T>>
    implements _$$ErrorImplCopyWith<T, $Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl<T> _value, $Res Function(_$ErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiErrorModel = null,
  }) {
    return _then(_$ErrorImpl<T>(
      null == apiErrorModel
          ? _value.apiErrorModel
          : apiErrorModel // ignore: cast_nullable_to_non_nullable
              as ApiErrorModel,
    ));
  }
}

/// @nodoc

class _$ErrorImpl<T> implements Error<T> {
  const _$ErrorImpl(this.apiErrorModel);

  @override
  final ApiErrorModel apiErrorModel;

  @override
  String toString() {
    return 'LoginState<$T>.error(apiErrorModel: $apiErrorModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl<T> &&
            (identical(other.apiErrorModel, apiErrorModel) ||
                other.apiErrorModel == apiErrorModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, apiErrorModel);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<T, _$ErrorImpl<T>> get copyWith =>
      __$$ErrorImplCopyWithImpl<T, _$ErrorImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(ApiErrorModel apiErrorModel) error,
  }) {
    return error(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(ApiErrorModel apiErrorModel)? error,
  }) {
    return error?.call(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(ApiErrorModel apiErrorModel)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(apiErrorModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial<T> value) initial,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(Success<T> value) success,
    required TResult Function(Error<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial<T> value)? initial,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(Success<T> value)? success,
    TResult? Function(Error<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial<T> value)? initial,
    TResult Function(Loading<T> value)? loading,
    TResult Function(Success<T> value)? success,
    TResult Function(Error<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error<T> implements LoginState<T> {
  const factory Error(final ApiErrorModel apiErrorModel) = _$ErrorImpl<T>;

  ApiErrorModel get apiErrorModel;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<T, _$ErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RegisterState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() registerInitial,
    required TResult Function() registerLoading,
    required TResult Function(T data) registerSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) registerError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? registerInitial,
    TResult? Function()? registerLoading,
    TResult? Function(T data)? registerSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? registerError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? registerInitial,
    TResult Function()? registerLoading,
    TResult Function(T data)? registerSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? registerError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterInitial<T> value) registerInitial,
    required TResult Function(RegisterLoading<T> value) registerLoading,
    required TResult Function(RegisterSuccess<T> value) registerSuccess,
    required TResult Function(RegisterError<T> value) registerError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterInitial<T> value)? registerInitial,
    TResult? Function(RegisterLoading<T> value)? registerLoading,
    TResult? Function(RegisterSuccess<T> value)? registerSuccess,
    TResult? Function(RegisterError<T> value)? registerError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterInitial<T> value)? registerInitial,
    TResult Function(RegisterLoading<T> value)? registerLoading,
    TResult Function(RegisterSuccess<T> value)? registerSuccess,
    TResult Function(RegisterError<T> value)? registerError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterStateCopyWith<T, $Res> {
  factory $RegisterStateCopyWith(
          RegisterState<T> value, $Res Function(RegisterState<T>) then) =
      _$RegisterStateCopyWithImpl<T, $Res, RegisterState<T>>;
}

/// @nodoc
class _$RegisterStateCopyWithImpl<T, $Res, $Val extends RegisterState<T>>
    implements $RegisterStateCopyWith<T, $Res> {
  _$RegisterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$RegisterInitialImplCopyWith<T, $Res> {
  factory _$$RegisterInitialImplCopyWith(_$RegisterInitialImpl<T> value,
          $Res Function(_$RegisterInitialImpl<T>) then) =
      __$$RegisterInitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$RegisterInitialImplCopyWithImpl<T, $Res>
    extends _$RegisterStateCopyWithImpl<T, $Res, _$RegisterInitialImpl<T>>
    implements _$$RegisterInitialImplCopyWith<T, $Res> {
  __$$RegisterInitialImplCopyWithImpl(_$RegisterInitialImpl<T> _value,
      $Res Function(_$RegisterInitialImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RegisterInitialImpl<T> implements RegisterInitial<T> {
  const _$RegisterInitialImpl();

  @override
  String toString() {
    return 'RegisterState<$T>.registerInitial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RegisterInitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() registerInitial,
    required TResult Function() registerLoading,
    required TResult Function(T data) registerSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) registerError,
  }) {
    return registerInitial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? registerInitial,
    TResult? Function()? registerLoading,
    TResult? Function(T data)? registerSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? registerError,
  }) {
    return registerInitial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? registerInitial,
    TResult Function()? registerLoading,
    TResult Function(T data)? registerSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? registerError,
    required TResult orElse(),
  }) {
    if (registerInitial != null) {
      return registerInitial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterInitial<T> value) registerInitial,
    required TResult Function(RegisterLoading<T> value) registerLoading,
    required TResult Function(RegisterSuccess<T> value) registerSuccess,
    required TResult Function(RegisterError<T> value) registerError,
  }) {
    return registerInitial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterInitial<T> value)? registerInitial,
    TResult? Function(RegisterLoading<T> value)? registerLoading,
    TResult? Function(RegisterSuccess<T> value)? registerSuccess,
    TResult? Function(RegisterError<T> value)? registerError,
  }) {
    return registerInitial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterInitial<T> value)? registerInitial,
    TResult Function(RegisterLoading<T> value)? registerLoading,
    TResult Function(RegisterSuccess<T> value)? registerSuccess,
    TResult Function(RegisterError<T> value)? registerError,
    required TResult orElse(),
  }) {
    if (registerInitial != null) {
      return registerInitial(this);
    }
    return orElse();
  }
}

abstract class RegisterInitial<T> implements RegisterState<T> {
  const factory RegisterInitial() = _$RegisterInitialImpl<T>;
}

/// @nodoc
abstract class _$$RegisterLoadingImplCopyWith<T, $Res> {
  factory _$$RegisterLoadingImplCopyWith(_$RegisterLoadingImpl<T> value,
          $Res Function(_$RegisterLoadingImpl<T>) then) =
      __$$RegisterLoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$RegisterLoadingImplCopyWithImpl<T, $Res>
    extends _$RegisterStateCopyWithImpl<T, $Res, _$RegisterLoadingImpl<T>>
    implements _$$RegisterLoadingImplCopyWith<T, $Res> {
  __$$RegisterLoadingImplCopyWithImpl(_$RegisterLoadingImpl<T> _value,
      $Res Function(_$RegisterLoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RegisterLoadingImpl<T> implements RegisterLoading<T> {
  const _$RegisterLoadingImpl();

  @override
  String toString() {
    return 'RegisterState<$T>.registerLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RegisterLoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() registerInitial,
    required TResult Function() registerLoading,
    required TResult Function(T data) registerSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) registerError,
  }) {
    return registerLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? registerInitial,
    TResult? Function()? registerLoading,
    TResult? Function(T data)? registerSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? registerError,
  }) {
    return registerLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? registerInitial,
    TResult Function()? registerLoading,
    TResult Function(T data)? registerSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? registerError,
    required TResult orElse(),
  }) {
    if (registerLoading != null) {
      return registerLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterInitial<T> value) registerInitial,
    required TResult Function(RegisterLoading<T> value) registerLoading,
    required TResult Function(RegisterSuccess<T> value) registerSuccess,
    required TResult Function(RegisterError<T> value) registerError,
  }) {
    return registerLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterInitial<T> value)? registerInitial,
    TResult? Function(RegisterLoading<T> value)? registerLoading,
    TResult? Function(RegisterSuccess<T> value)? registerSuccess,
    TResult? Function(RegisterError<T> value)? registerError,
  }) {
    return registerLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterInitial<T> value)? registerInitial,
    TResult Function(RegisterLoading<T> value)? registerLoading,
    TResult Function(RegisterSuccess<T> value)? registerSuccess,
    TResult Function(RegisterError<T> value)? registerError,
    required TResult orElse(),
  }) {
    if (registerLoading != null) {
      return registerLoading(this);
    }
    return orElse();
  }
}

abstract class RegisterLoading<T> implements RegisterState<T> {
  const factory RegisterLoading() = _$RegisterLoadingImpl<T>;
}

/// @nodoc
abstract class _$$RegisterSuccessImplCopyWith<T, $Res> {
  factory _$$RegisterSuccessImplCopyWith(_$RegisterSuccessImpl<T> value,
          $Res Function(_$RegisterSuccessImpl<T>) then) =
      __$$RegisterSuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$RegisterSuccessImplCopyWithImpl<T, $Res>
    extends _$RegisterStateCopyWithImpl<T, $Res, _$RegisterSuccessImpl<T>>
    implements _$$RegisterSuccessImplCopyWith<T, $Res> {
  __$$RegisterSuccessImplCopyWithImpl(_$RegisterSuccessImpl<T> _value,
      $Res Function(_$RegisterSuccessImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$RegisterSuccessImpl<T>(
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$RegisterSuccessImpl<T> implements RegisterSuccess<T> {
  const _$RegisterSuccessImpl(this.data);

  @override
  final T data;

  @override
  String toString() {
    return 'RegisterState<$T>.registerSuccess(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterSuccessImplCopyWith<T, _$RegisterSuccessImpl<T>> get copyWith =>
      __$$RegisterSuccessImplCopyWithImpl<T, _$RegisterSuccessImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() registerInitial,
    required TResult Function() registerLoading,
    required TResult Function(T data) registerSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) registerError,
  }) {
    return registerSuccess(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? registerInitial,
    TResult? Function()? registerLoading,
    TResult? Function(T data)? registerSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? registerError,
  }) {
    return registerSuccess?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? registerInitial,
    TResult Function()? registerLoading,
    TResult Function(T data)? registerSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? registerError,
    required TResult orElse(),
  }) {
    if (registerSuccess != null) {
      return registerSuccess(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterInitial<T> value) registerInitial,
    required TResult Function(RegisterLoading<T> value) registerLoading,
    required TResult Function(RegisterSuccess<T> value) registerSuccess,
    required TResult Function(RegisterError<T> value) registerError,
  }) {
    return registerSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterInitial<T> value)? registerInitial,
    TResult? Function(RegisterLoading<T> value)? registerLoading,
    TResult? Function(RegisterSuccess<T> value)? registerSuccess,
    TResult? Function(RegisterError<T> value)? registerError,
  }) {
    return registerSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterInitial<T> value)? registerInitial,
    TResult Function(RegisterLoading<T> value)? registerLoading,
    TResult Function(RegisterSuccess<T> value)? registerSuccess,
    TResult Function(RegisterError<T> value)? registerError,
    required TResult orElse(),
  }) {
    if (registerSuccess != null) {
      return registerSuccess(this);
    }
    return orElse();
  }
}

abstract class RegisterSuccess<T> implements RegisterState<T> {
  const factory RegisterSuccess(final T data) = _$RegisterSuccessImpl<T>;

  T get data;

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterSuccessImplCopyWith<T, _$RegisterSuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RegisterErrorImplCopyWith<T, $Res> {
  factory _$$RegisterErrorImplCopyWith(_$RegisterErrorImpl<T> value,
          $Res Function(_$RegisterErrorImpl<T>) then) =
      __$$RegisterErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({ApiErrorModel apiErrorModel});
}

/// @nodoc
class __$$RegisterErrorImplCopyWithImpl<T, $Res>
    extends _$RegisterStateCopyWithImpl<T, $Res, _$RegisterErrorImpl<T>>
    implements _$$RegisterErrorImplCopyWith<T, $Res> {
  __$$RegisterErrorImplCopyWithImpl(_$RegisterErrorImpl<T> _value,
      $Res Function(_$RegisterErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiErrorModel = null,
  }) {
    return _then(_$RegisterErrorImpl<T>(
      null == apiErrorModel
          ? _value.apiErrorModel
          : apiErrorModel // ignore: cast_nullable_to_non_nullable
              as ApiErrorModel,
    ));
  }
}

/// @nodoc

class _$RegisterErrorImpl<T> implements RegisterError<T> {
  const _$RegisterErrorImpl(this.apiErrorModel);

  @override
  final ApiErrorModel apiErrorModel;

  @override
  String toString() {
    return 'RegisterState<$T>.registerError(apiErrorModel: $apiErrorModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterErrorImpl<T> &&
            (identical(other.apiErrorModel, apiErrorModel) ||
                other.apiErrorModel == apiErrorModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, apiErrorModel);

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterErrorImplCopyWith<T, _$RegisterErrorImpl<T>> get copyWith =>
      __$$RegisterErrorImplCopyWithImpl<T, _$RegisterErrorImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() registerInitial,
    required TResult Function() registerLoading,
    required TResult Function(T data) registerSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) registerError,
  }) {
    return registerError(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? registerInitial,
    TResult? Function()? registerLoading,
    TResult? Function(T data)? registerSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? registerError,
  }) {
    return registerError?.call(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? registerInitial,
    TResult Function()? registerLoading,
    TResult Function(T data)? registerSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? registerError,
    required TResult orElse(),
  }) {
    if (registerError != null) {
      return registerError(apiErrorModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RegisterInitial<T> value) registerInitial,
    required TResult Function(RegisterLoading<T> value) registerLoading,
    required TResult Function(RegisterSuccess<T> value) registerSuccess,
    required TResult Function(RegisterError<T> value) registerError,
  }) {
    return registerError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RegisterInitial<T> value)? registerInitial,
    TResult? Function(RegisterLoading<T> value)? registerLoading,
    TResult? Function(RegisterSuccess<T> value)? registerSuccess,
    TResult? Function(RegisterError<T> value)? registerError,
  }) {
    return registerError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RegisterInitial<T> value)? registerInitial,
    TResult Function(RegisterLoading<T> value)? registerLoading,
    TResult Function(RegisterSuccess<T> value)? registerSuccess,
    TResult Function(RegisterError<T> value)? registerError,
    required TResult orElse(),
  }) {
    if (registerError != null) {
      return registerError(this);
    }
    return orElse();
  }
}

abstract class RegisterError<T> implements RegisterState<T> {
  const factory RegisterError(final ApiErrorModel apiErrorModel) =
      _$RegisterErrorImpl<T>;

  ApiErrorModel get apiErrorModel;

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterErrorImplCopyWith<T, _$RegisterErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ForgotPasswordState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() forgotPasswordInitial,
    required TResult Function() forgotPasswordLoading,
    required TResult Function(T data) forgotPasswordSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) forgotPasswordError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? forgotPasswordInitial,
    TResult? Function()? forgotPasswordLoading,
    TResult? Function(T data)? forgotPasswordSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? forgotPasswordError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? forgotPasswordInitial,
    TResult Function()? forgotPasswordLoading,
    TResult Function(T data)? forgotPasswordSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? forgotPasswordError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ForgotPasswordInitial<T> value)
        forgotPasswordInitial,
    required TResult Function(ForgotPasswordLoading<T> value)
        forgotPasswordLoading,
    required TResult Function(ForgotPasswordSuccess<T> value)
        forgotPasswordSuccess,
    required TResult Function(ForgotPasswordError<T> value) forgotPasswordError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ForgotPasswordInitial<T> value)? forgotPasswordInitial,
    TResult? Function(ForgotPasswordLoading<T> value)? forgotPasswordLoading,
    TResult? Function(ForgotPasswordSuccess<T> value)? forgotPasswordSuccess,
    TResult? Function(ForgotPasswordError<T> value)? forgotPasswordError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ForgotPasswordInitial<T> value)? forgotPasswordInitial,
    TResult Function(ForgotPasswordLoading<T> value)? forgotPasswordLoading,
    TResult Function(ForgotPasswordSuccess<T> value)? forgotPasswordSuccess,
    TResult Function(ForgotPasswordError<T> value)? forgotPasswordError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordStateCopyWith<T, $Res> {
  factory $ForgotPasswordStateCopyWith(ForgotPasswordState<T> value,
          $Res Function(ForgotPasswordState<T>) then) =
      _$ForgotPasswordStateCopyWithImpl<T, $Res, ForgotPasswordState<T>>;
}

/// @nodoc
class _$ForgotPasswordStateCopyWithImpl<T, $Res,
        $Val extends ForgotPasswordState<T>>
    implements $ForgotPasswordStateCopyWith<T, $Res> {
  _$ForgotPasswordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ForgotPasswordInitialImplCopyWith<T, $Res> {
  factory _$$ForgotPasswordInitialImplCopyWith(
          _$ForgotPasswordInitialImpl<T> value,
          $Res Function(_$ForgotPasswordInitialImpl<T>) then) =
      __$$ForgotPasswordInitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$ForgotPasswordInitialImplCopyWithImpl<T, $Res>
    extends _$ForgotPasswordStateCopyWithImpl<T, $Res,
        _$ForgotPasswordInitialImpl<T>>
    implements _$$ForgotPasswordInitialImplCopyWith<T, $Res> {
  __$$ForgotPasswordInitialImplCopyWithImpl(
      _$ForgotPasswordInitialImpl<T> _value,
      $Res Function(_$ForgotPasswordInitialImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ForgotPasswordInitialImpl<T> implements _ForgotPasswordInitial<T> {
  const _$ForgotPasswordInitialImpl();

  @override
  String toString() {
    return 'ForgotPasswordState<$T>.forgotPasswordInitial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordInitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() forgotPasswordInitial,
    required TResult Function() forgotPasswordLoading,
    required TResult Function(T data) forgotPasswordSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) forgotPasswordError,
  }) {
    return forgotPasswordInitial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? forgotPasswordInitial,
    TResult? Function()? forgotPasswordLoading,
    TResult? Function(T data)? forgotPasswordSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? forgotPasswordError,
  }) {
    return forgotPasswordInitial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? forgotPasswordInitial,
    TResult Function()? forgotPasswordLoading,
    TResult Function(T data)? forgotPasswordSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? forgotPasswordError,
    required TResult orElse(),
  }) {
    if (forgotPasswordInitial != null) {
      return forgotPasswordInitial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ForgotPasswordInitial<T> value)
        forgotPasswordInitial,
    required TResult Function(ForgotPasswordLoading<T> value)
        forgotPasswordLoading,
    required TResult Function(ForgotPasswordSuccess<T> value)
        forgotPasswordSuccess,
    required TResult Function(ForgotPasswordError<T> value) forgotPasswordError,
  }) {
    return forgotPasswordInitial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ForgotPasswordInitial<T> value)? forgotPasswordInitial,
    TResult? Function(ForgotPasswordLoading<T> value)? forgotPasswordLoading,
    TResult? Function(ForgotPasswordSuccess<T> value)? forgotPasswordSuccess,
    TResult? Function(ForgotPasswordError<T> value)? forgotPasswordError,
  }) {
    return forgotPasswordInitial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ForgotPasswordInitial<T> value)? forgotPasswordInitial,
    TResult Function(ForgotPasswordLoading<T> value)? forgotPasswordLoading,
    TResult Function(ForgotPasswordSuccess<T> value)? forgotPasswordSuccess,
    TResult Function(ForgotPasswordError<T> value)? forgotPasswordError,
    required TResult orElse(),
  }) {
    if (forgotPasswordInitial != null) {
      return forgotPasswordInitial(this);
    }
    return orElse();
  }
}

abstract class _ForgotPasswordInitial<T> implements ForgotPasswordState<T> {
  const factory _ForgotPasswordInitial() = _$ForgotPasswordInitialImpl<T>;
}

/// @nodoc
abstract class _$$ForgotPasswordLoadingImplCopyWith<T, $Res> {
  factory _$$ForgotPasswordLoadingImplCopyWith(
          _$ForgotPasswordLoadingImpl<T> value,
          $Res Function(_$ForgotPasswordLoadingImpl<T>) then) =
      __$$ForgotPasswordLoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$ForgotPasswordLoadingImplCopyWithImpl<T, $Res>
    extends _$ForgotPasswordStateCopyWithImpl<T, $Res,
        _$ForgotPasswordLoadingImpl<T>>
    implements _$$ForgotPasswordLoadingImplCopyWith<T, $Res> {
  __$$ForgotPasswordLoadingImplCopyWithImpl(
      _$ForgotPasswordLoadingImpl<T> _value,
      $Res Function(_$ForgotPasswordLoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ForgotPasswordLoadingImpl<T> implements ForgotPasswordLoading<T> {
  const _$ForgotPasswordLoadingImpl();

  @override
  String toString() {
    return 'ForgotPasswordState<$T>.forgotPasswordLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordLoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() forgotPasswordInitial,
    required TResult Function() forgotPasswordLoading,
    required TResult Function(T data) forgotPasswordSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) forgotPasswordError,
  }) {
    return forgotPasswordLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? forgotPasswordInitial,
    TResult? Function()? forgotPasswordLoading,
    TResult? Function(T data)? forgotPasswordSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? forgotPasswordError,
  }) {
    return forgotPasswordLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? forgotPasswordInitial,
    TResult Function()? forgotPasswordLoading,
    TResult Function(T data)? forgotPasswordSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? forgotPasswordError,
    required TResult orElse(),
  }) {
    if (forgotPasswordLoading != null) {
      return forgotPasswordLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ForgotPasswordInitial<T> value)
        forgotPasswordInitial,
    required TResult Function(ForgotPasswordLoading<T> value)
        forgotPasswordLoading,
    required TResult Function(ForgotPasswordSuccess<T> value)
        forgotPasswordSuccess,
    required TResult Function(ForgotPasswordError<T> value) forgotPasswordError,
  }) {
    return forgotPasswordLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ForgotPasswordInitial<T> value)? forgotPasswordInitial,
    TResult? Function(ForgotPasswordLoading<T> value)? forgotPasswordLoading,
    TResult? Function(ForgotPasswordSuccess<T> value)? forgotPasswordSuccess,
    TResult? Function(ForgotPasswordError<T> value)? forgotPasswordError,
  }) {
    return forgotPasswordLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ForgotPasswordInitial<T> value)? forgotPasswordInitial,
    TResult Function(ForgotPasswordLoading<T> value)? forgotPasswordLoading,
    TResult Function(ForgotPasswordSuccess<T> value)? forgotPasswordSuccess,
    TResult Function(ForgotPasswordError<T> value)? forgotPasswordError,
    required TResult orElse(),
  }) {
    if (forgotPasswordLoading != null) {
      return forgotPasswordLoading(this);
    }
    return orElse();
  }
}

abstract class ForgotPasswordLoading<T> implements ForgotPasswordState<T> {
  const factory ForgotPasswordLoading() = _$ForgotPasswordLoadingImpl<T>;
}

/// @nodoc
abstract class _$$ForgotPasswordSuccessImplCopyWith<T, $Res> {
  factory _$$ForgotPasswordSuccessImplCopyWith(
          _$ForgotPasswordSuccessImpl<T> value,
          $Res Function(_$ForgotPasswordSuccessImpl<T>) then) =
      __$$ForgotPasswordSuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$ForgotPasswordSuccessImplCopyWithImpl<T, $Res>
    extends _$ForgotPasswordStateCopyWithImpl<T, $Res,
        _$ForgotPasswordSuccessImpl<T>>
    implements _$$ForgotPasswordSuccessImplCopyWith<T, $Res> {
  __$$ForgotPasswordSuccessImplCopyWithImpl(
      _$ForgotPasswordSuccessImpl<T> _value,
      $Res Function(_$ForgotPasswordSuccessImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$ForgotPasswordSuccessImpl<T>(
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$ForgotPasswordSuccessImpl<T> implements ForgotPasswordSuccess<T> {
  const _$ForgotPasswordSuccessImpl(this.data);

  @override
  final T data;

  @override
  String toString() {
    return 'ForgotPasswordState<$T>.forgotPasswordSuccess(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordSuccessImplCopyWith<T, _$ForgotPasswordSuccessImpl<T>>
      get copyWith => __$$ForgotPasswordSuccessImplCopyWithImpl<T,
          _$ForgotPasswordSuccessImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() forgotPasswordInitial,
    required TResult Function() forgotPasswordLoading,
    required TResult Function(T data) forgotPasswordSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) forgotPasswordError,
  }) {
    return forgotPasswordSuccess(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? forgotPasswordInitial,
    TResult? Function()? forgotPasswordLoading,
    TResult? Function(T data)? forgotPasswordSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? forgotPasswordError,
  }) {
    return forgotPasswordSuccess?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? forgotPasswordInitial,
    TResult Function()? forgotPasswordLoading,
    TResult Function(T data)? forgotPasswordSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? forgotPasswordError,
    required TResult orElse(),
  }) {
    if (forgotPasswordSuccess != null) {
      return forgotPasswordSuccess(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ForgotPasswordInitial<T> value)
        forgotPasswordInitial,
    required TResult Function(ForgotPasswordLoading<T> value)
        forgotPasswordLoading,
    required TResult Function(ForgotPasswordSuccess<T> value)
        forgotPasswordSuccess,
    required TResult Function(ForgotPasswordError<T> value) forgotPasswordError,
  }) {
    return forgotPasswordSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ForgotPasswordInitial<T> value)? forgotPasswordInitial,
    TResult? Function(ForgotPasswordLoading<T> value)? forgotPasswordLoading,
    TResult? Function(ForgotPasswordSuccess<T> value)? forgotPasswordSuccess,
    TResult? Function(ForgotPasswordError<T> value)? forgotPasswordError,
  }) {
    return forgotPasswordSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ForgotPasswordInitial<T> value)? forgotPasswordInitial,
    TResult Function(ForgotPasswordLoading<T> value)? forgotPasswordLoading,
    TResult Function(ForgotPasswordSuccess<T> value)? forgotPasswordSuccess,
    TResult Function(ForgotPasswordError<T> value)? forgotPasswordError,
    required TResult orElse(),
  }) {
    if (forgotPasswordSuccess != null) {
      return forgotPasswordSuccess(this);
    }
    return orElse();
  }
}

abstract class ForgotPasswordSuccess<T> implements ForgotPasswordState<T> {
  const factory ForgotPasswordSuccess(final T data) =
      _$ForgotPasswordSuccessImpl<T>;

  T get data;

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgotPasswordSuccessImplCopyWith<T, _$ForgotPasswordSuccessImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ForgotPasswordErrorImplCopyWith<T, $Res> {
  factory _$$ForgotPasswordErrorImplCopyWith(_$ForgotPasswordErrorImpl<T> value,
          $Res Function(_$ForgotPasswordErrorImpl<T>) then) =
      __$$ForgotPasswordErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({ApiErrorModel apiErrorModel});
}

/// @nodoc
class __$$ForgotPasswordErrorImplCopyWithImpl<T, $Res>
    extends _$ForgotPasswordStateCopyWithImpl<T, $Res,
        _$ForgotPasswordErrorImpl<T>>
    implements _$$ForgotPasswordErrorImplCopyWith<T, $Res> {
  __$$ForgotPasswordErrorImplCopyWithImpl(_$ForgotPasswordErrorImpl<T> _value,
      $Res Function(_$ForgotPasswordErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiErrorModel = null,
  }) {
    return _then(_$ForgotPasswordErrorImpl<T>(
      null == apiErrorModel
          ? _value.apiErrorModel
          : apiErrorModel // ignore: cast_nullable_to_non_nullable
              as ApiErrorModel,
    ));
  }
}

/// @nodoc

class _$ForgotPasswordErrorImpl<T> implements ForgotPasswordError<T> {
  const _$ForgotPasswordErrorImpl(this.apiErrorModel);

  @override
  final ApiErrorModel apiErrorModel;

  @override
  String toString() {
    return 'ForgotPasswordState<$T>.forgotPasswordError(apiErrorModel: $apiErrorModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordErrorImpl<T> &&
            (identical(other.apiErrorModel, apiErrorModel) ||
                other.apiErrorModel == apiErrorModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, apiErrorModel);

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordErrorImplCopyWith<T, _$ForgotPasswordErrorImpl<T>>
      get copyWith => __$$ForgotPasswordErrorImplCopyWithImpl<T,
          _$ForgotPasswordErrorImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() forgotPasswordInitial,
    required TResult Function() forgotPasswordLoading,
    required TResult Function(T data) forgotPasswordSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) forgotPasswordError,
  }) {
    return forgotPasswordError(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? forgotPasswordInitial,
    TResult? Function()? forgotPasswordLoading,
    TResult? Function(T data)? forgotPasswordSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? forgotPasswordError,
  }) {
    return forgotPasswordError?.call(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? forgotPasswordInitial,
    TResult Function()? forgotPasswordLoading,
    TResult Function(T data)? forgotPasswordSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? forgotPasswordError,
    required TResult orElse(),
  }) {
    if (forgotPasswordError != null) {
      return forgotPasswordError(apiErrorModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ForgotPasswordInitial<T> value)
        forgotPasswordInitial,
    required TResult Function(ForgotPasswordLoading<T> value)
        forgotPasswordLoading,
    required TResult Function(ForgotPasswordSuccess<T> value)
        forgotPasswordSuccess,
    required TResult Function(ForgotPasswordError<T> value) forgotPasswordError,
  }) {
    return forgotPasswordError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ForgotPasswordInitial<T> value)? forgotPasswordInitial,
    TResult? Function(ForgotPasswordLoading<T> value)? forgotPasswordLoading,
    TResult? Function(ForgotPasswordSuccess<T> value)? forgotPasswordSuccess,
    TResult? Function(ForgotPasswordError<T> value)? forgotPasswordError,
  }) {
    return forgotPasswordError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ForgotPasswordInitial<T> value)? forgotPasswordInitial,
    TResult Function(ForgotPasswordLoading<T> value)? forgotPasswordLoading,
    TResult Function(ForgotPasswordSuccess<T> value)? forgotPasswordSuccess,
    TResult Function(ForgotPasswordError<T> value)? forgotPasswordError,
    required TResult orElse(),
  }) {
    if (forgotPasswordError != null) {
      return forgotPasswordError(this);
    }
    return orElse();
  }
}

abstract class ForgotPasswordError<T> implements ForgotPasswordState<T> {
  const factory ForgotPasswordError(final ApiErrorModel apiErrorModel) =
      _$ForgotPasswordErrorImpl<T>;

  ApiErrorModel get apiErrorModel;

  /// Create a copy of ForgotPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgotPasswordErrorImplCopyWith<T, _$ForgotPasswordErrorImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VerifyCodeState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verifyCodeInitial,
    required TResult Function() verifyCodeLoading,
    required TResult Function(T data) verifyCodeSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) verifyCodeError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verifyCodeInitial,
    TResult? Function()? verifyCodeLoading,
    TResult? Function(T data)? verifyCodeSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? verifyCodeError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verifyCodeInitial,
    TResult Function()? verifyCodeLoading,
    TResult Function(T data)? verifyCodeSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? verifyCodeError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VerifyCodeInitial<T> value) verifyCodeInitial,
    required TResult Function(VerifyCodeLoading<T> value) verifyCodeLoading,
    required TResult Function(VerifyCodeSuccess<T> value) verifyCodeSuccess,
    required TResult Function(VerifyCodeError<T> value) verifyCodeError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VerifyCodeInitial<T> value)? verifyCodeInitial,
    TResult? Function(VerifyCodeLoading<T> value)? verifyCodeLoading,
    TResult? Function(VerifyCodeSuccess<T> value)? verifyCodeSuccess,
    TResult? Function(VerifyCodeError<T> value)? verifyCodeError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VerifyCodeInitial<T> value)? verifyCodeInitial,
    TResult Function(VerifyCodeLoading<T> value)? verifyCodeLoading,
    TResult Function(VerifyCodeSuccess<T> value)? verifyCodeSuccess,
    TResult Function(VerifyCodeError<T> value)? verifyCodeError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyCodeStateCopyWith<T, $Res> {
  factory $VerifyCodeStateCopyWith(
          VerifyCodeState<T> value, $Res Function(VerifyCodeState<T>) then) =
      _$VerifyCodeStateCopyWithImpl<T, $Res, VerifyCodeState<T>>;
}

/// @nodoc
class _$VerifyCodeStateCopyWithImpl<T, $Res, $Val extends VerifyCodeState<T>>
    implements $VerifyCodeStateCopyWith<T, $Res> {
  _$VerifyCodeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyCodeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$VerifyCodeInitialImplCopyWith<T, $Res> {
  factory _$$VerifyCodeInitialImplCopyWith(_$VerifyCodeInitialImpl<T> value,
          $Res Function(_$VerifyCodeInitialImpl<T>) then) =
      __$$VerifyCodeInitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$VerifyCodeInitialImplCopyWithImpl<T, $Res>
    extends _$VerifyCodeStateCopyWithImpl<T, $Res, _$VerifyCodeInitialImpl<T>>
    implements _$$VerifyCodeInitialImplCopyWith<T, $Res> {
  __$$VerifyCodeInitialImplCopyWithImpl(_$VerifyCodeInitialImpl<T> _value,
      $Res Function(_$VerifyCodeInitialImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of VerifyCodeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$VerifyCodeInitialImpl<T> implements _VerifyCodeInitial<T> {
  const _$VerifyCodeInitialImpl();

  @override
  String toString() {
    return 'VerifyCodeState<$T>.verifyCodeInitial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyCodeInitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verifyCodeInitial,
    required TResult Function() verifyCodeLoading,
    required TResult Function(T data) verifyCodeSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) verifyCodeError,
  }) {
    return verifyCodeInitial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verifyCodeInitial,
    TResult? Function()? verifyCodeLoading,
    TResult? Function(T data)? verifyCodeSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? verifyCodeError,
  }) {
    return verifyCodeInitial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verifyCodeInitial,
    TResult Function()? verifyCodeLoading,
    TResult Function(T data)? verifyCodeSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? verifyCodeError,
    required TResult orElse(),
  }) {
    if (verifyCodeInitial != null) {
      return verifyCodeInitial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VerifyCodeInitial<T> value) verifyCodeInitial,
    required TResult Function(VerifyCodeLoading<T> value) verifyCodeLoading,
    required TResult Function(VerifyCodeSuccess<T> value) verifyCodeSuccess,
    required TResult Function(VerifyCodeError<T> value) verifyCodeError,
  }) {
    return verifyCodeInitial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VerifyCodeInitial<T> value)? verifyCodeInitial,
    TResult? Function(VerifyCodeLoading<T> value)? verifyCodeLoading,
    TResult? Function(VerifyCodeSuccess<T> value)? verifyCodeSuccess,
    TResult? Function(VerifyCodeError<T> value)? verifyCodeError,
  }) {
    return verifyCodeInitial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VerifyCodeInitial<T> value)? verifyCodeInitial,
    TResult Function(VerifyCodeLoading<T> value)? verifyCodeLoading,
    TResult Function(VerifyCodeSuccess<T> value)? verifyCodeSuccess,
    TResult Function(VerifyCodeError<T> value)? verifyCodeError,
    required TResult orElse(),
  }) {
    if (verifyCodeInitial != null) {
      return verifyCodeInitial(this);
    }
    return orElse();
  }
}

abstract class _VerifyCodeInitial<T> implements VerifyCodeState<T> {
  const factory _VerifyCodeInitial() = _$VerifyCodeInitialImpl<T>;
}

/// @nodoc
abstract class _$$VerifyCodeLoadingImplCopyWith<T, $Res> {
  factory _$$VerifyCodeLoadingImplCopyWith(_$VerifyCodeLoadingImpl<T> value,
          $Res Function(_$VerifyCodeLoadingImpl<T>) then) =
      __$$VerifyCodeLoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$VerifyCodeLoadingImplCopyWithImpl<T, $Res>
    extends _$VerifyCodeStateCopyWithImpl<T, $Res, _$VerifyCodeLoadingImpl<T>>
    implements _$$VerifyCodeLoadingImplCopyWith<T, $Res> {
  __$$VerifyCodeLoadingImplCopyWithImpl(_$VerifyCodeLoadingImpl<T> _value,
      $Res Function(_$VerifyCodeLoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of VerifyCodeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$VerifyCodeLoadingImpl<T> implements VerifyCodeLoading<T> {
  const _$VerifyCodeLoadingImpl();

  @override
  String toString() {
    return 'VerifyCodeState<$T>.verifyCodeLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyCodeLoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verifyCodeInitial,
    required TResult Function() verifyCodeLoading,
    required TResult Function(T data) verifyCodeSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) verifyCodeError,
  }) {
    return verifyCodeLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verifyCodeInitial,
    TResult? Function()? verifyCodeLoading,
    TResult? Function(T data)? verifyCodeSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? verifyCodeError,
  }) {
    return verifyCodeLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verifyCodeInitial,
    TResult Function()? verifyCodeLoading,
    TResult Function(T data)? verifyCodeSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? verifyCodeError,
    required TResult orElse(),
  }) {
    if (verifyCodeLoading != null) {
      return verifyCodeLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VerifyCodeInitial<T> value) verifyCodeInitial,
    required TResult Function(VerifyCodeLoading<T> value) verifyCodeLoading,
    required TResult Function(VerifyCodeSuccess<T> value) verifyCodeSuccess,
    required TResult Function(VerifyCodeError<T> value) verifyCodeError,
  }) {
    return verifyCodeLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VerifyCodeInitial<T> value)? verifyCodeInitial,
    TResult? Function(VerifyCodeLoading<T> value)? verifyCodeLoading,
    TResult? Function(VerifyCodeSuccess<T> value)? verifyCodeSuccess,
    TResult? Function(VerifyCodeError<T> value)? verifyCodeError,
  }) {
    return verifyCodeLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VerifyCodeInitial<T> value)? verifyCodeInitial,
    TResult Function(VerifyCodeLoading<T> value)? verifyCodeLoading,
    TResult Function(VerifyCodeSuccess<T> value)? verifyCodeSuccess,
    TResult Function(VerifyCodeError<T> value)? verifyCodeError,
    required TResult orElse(),
  }) {
    if (verifyCodeLoading != null) {
      return verifyCodeLoading(this);
    }
    return orElse();
  }
}

abstract class VerifyCodeLoading<T> implements VerifyCodeState<T> {
  const factory VerifyCodeLoading() = _$VerifyCodeLoadingImpl<T>;
}

/// @nodoc
abstract class _$$VerifyCodeSuccessImplCopyWith<T, $Res> {
  factory _$$VerifyCodeSuccessImplCopyWith(_$VerifyCodeSuccessImpl<T> value,
          $Res Function(_$VerifyCodeSuccessImpl<T>) then) =
      __$$VerifyCodeSuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$VerifyCodeSuccessImplCopyWithImpl<T, $Res>
    extends _$VerifyCodeStateCopyWithImpl<T, $Res, _$VerifyCodeSuccessImpl<T>>
    implements _$$VerifyCodeSuccessImplCopyWith<T, $Res> {
  __$$VerifyCodeSuccessImplCopyWithImpl(_$VerifyCodeSuccessImpl<T> _value,
      $Res Function(_$VerifyCodeSuccessImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of VerifyCodeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$VerifyCodeSuccessImpl<T>(
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$VerifyCodeSuccessImpl<T> implements VerifyCodeSuccess<T> {
  const _$VerifyCodeSuccessImpl(this.data);

  @override
  final T data;

  @override
  String toString() {
    return 'VerifyCodeState<$T>.verifyCodeSuccess(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyCodeSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of VerifyCodeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyCodeSuccessImplCopyWith<T, _$VerifyCodeSuccessImpl<T>>
      get copyWith =>
          __$$VerifyCodeSuccessImplCopyWithImpl<T, _$VerifyCodeSuccessImpl<T>>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verifyCodeInitial,
    required TResult Function() verifyCodeLoading,
    required TResult Function(T data) verifyCodeSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) verifyCodeError,
  }) {
    return verifyCodeSuccess(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verifyCodeInitial,
    TResult? Function()? verifyCodeLoading,
    TResult? Function(T data)? verifyCodeSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? verifyCodeError,
  }) {
    return verifyCodeSuccess?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verifyCodeInitial,
    TResult Function()? verifyCodeLoading,
    TResult Function(T data)? verifyCodeSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? verifyCodeError,
    required TResult orElse(),
  }) {
    if (verifyCodeSuccess != null) {
      return verifyCodeSuccess(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VerifyCodeInitial<T> value) verifyCodeInitial,
    required TResult Function(VerifyCodeLoading<T> value) verifyCodeLoading,
    required TResult Function(VerifyCodeSuccess<T> value) verifyCodeSuccess,
    required TResult Function(VerifyCodeError<T> value) verifyCodeError,
  }) {
    return verifyCodeSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VerifyCodeInitial<T> value)? verifyCodeInitial,
    TResult? Function(VerifyCodeLoading<T> value)? verifyCodeLoading,
    TResult? Function(VerifyCodeSuccess<T> value)? verifyCodeSuccess,
    TResult? Function(VerifyCodeError<T> value)? verifyCodeError,
  }) {
    return verifyCodeSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VerifyCodeInitial<T> value)? verifyCodeInitial,
    TResult Function(VerifyCodeLoading<T> value)? verifyCodeLoading,
    TResult Function(VerifyCodeSuccess<T> value)? verifyCodeSuccess,
    TResult Function(VerifyCodeError<T> value)? verifyCodeError,
    required TResult orElse(),
  }) {
    if (verifyCodeSuccess != null) {
      return verifyCodeSuccess(this);
    }
    return orElse();
  }
}

abstract class VerifyCodeSuccess<T> implements VerifyCodeState<T> {
  const factory VerifyCodeSuccess(final T data) = _$VerifyCodeSuccessImpl<T>;

  T get data;

  /// Create a copy of VerifyCodeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyCodeSuccessImplCopyWith<T, _$VerifyCodeSuccessImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VerifyCodeErrorImplCopyWith<T, $Res> {
  factory _$$VerifyCodeErrorImplCopyWith(_$VerifyCodeErrorImpl<T> value,
          $Res Function(_$VerifyCodeErrorImpl<T>) then) =
      __$$VerifyCodeErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({ApiErrorModel apiErrorModel});
}

/// @nodoc
class __$$VerifyCodeErrorImplCopyWithImpl<T, $Res>
    extends _$VerifyCodeStateCopyWithImpl<T, $Res, _$VerifyCodeErrorImpl<T>>
    implements _$$VerifyCodeErrorImplCopyWith<T, $Res> {
  __$$VerifyCodeErrorImplCopyWithImpl(_$VerifyCodeErrorImpl<T> _value,
      $Res Function(_$VerifyCodeErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of VerifyCodeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiErrorModel = null,
  }) {
    return _then(_$VerifyCodeErrorImpl<T>(
      null == apiErrorModel
          ? _value.apiErrorModel
          : apiErrorModel // ignore: cast_nullable_to_non_nullable
              as ApiErrorModel,
    ));
  }
}

/// @nodoc

class _$VerifyCodeErrorImpl<T> implements VerifyCodeError<T> {
  const _$VerifyCodeErrorImpl(this.apiErrorModel);

  @override
  final ApiErrorModel apiErrorModel;

  @override
  String toString() {
    return 'VerifyCodeState<$T>.verifyCodeError(apiErrorModel: $apiErrorModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyCodeErrorImpl<T> &&
            (identical(other.apiErrorModel, apiErrorModel) ||
                other.apiErrorModel == apiErrorModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, apiErrorModel);

  /// Create a copy of VerifyCodeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyCodeErrorImplCopyWith<T, _$VerifyCodeErrorImpl<T>> get copyWith =>
      __$$VerifyCodeErrorImplCopyWithImpl<T, _$VerifyCodeErrorImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verifyCodeInitial,
    required TResult Function() verifyCodeLoading,
    required TResult Function(T data) verifyCodeSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) verifyCodeError,
  }) {
    return verifyCodeError(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verifyCodeInitial,
    TResult? Function()? verifyCodeLoading,
    TResult? Function(T data)? verifyCodeSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? verifyCodeError,
  }) {
    return verifyCodeError?.call(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verifyCodeInitial,
    TResult Function()? verifyCodeLoading,
    TResult Function(T data)? verifyCodeSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? verifyCodeError,
    required TResult orElse(),
  }) {
    if (verifyCodeError != null) {
      return verifyCodeError(apiErrorModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VerifyCodeInitial<T> value) verifyCodeInitial,
    required TResult Function(VerifyCodeLoading<T> value) verifyCodeLoading,
    required TResult Function(VerifyCodeSuccess<T> value) verifyCodeSuccess,
    required TResult Function(VerifyCodeError<T> value) verifyCodeError,
  }) {
    return verifyCodeError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VerifyCodeInitial<T> value)? verifyCodeInitial,
    TResult? Function(VerifyCodeLoading<T> value)? verifyCodeLoading,
    TResult? Function(VerifyCodeSuccess<T> value)? verifyCodeSuccess,
    TResult? Function(VerifyCodeError<T> value)? verifyCodeError,
  }) {
    return verifyCodeError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VerifyCodeInitial<T> value)? verifyCodeInitial,
    TResult Function(VerifyCodeLoading<T> value)? verifyCodeLoading,
    TResult Function(VerifyCodeSuccess<T> value)? verifyCodeSuccess,
    TResult Function(VerifyCodeError<T> value)? verifyCodeError,
    required TResult orElse(),
  }) {
    if (verifyCodeError != null) {
      return verifyCodeError(this);
    }
    return orElse();
  }
}

abstract class VerifyCodeError<T> implements VerifyCodeState<T> {
  const factory VerifyCodeError(final ApiErrorModel apiErrorModel) =
      _$VerifyCodeErrorImpl<T>;

  ApiErrorModel get apiErrorModel;

  /// Create a copy of VerifyCodeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyCodeErrorImplCopyWith<T, _$VerifyCodeErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VerifyCodeRegisterState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verifyCodeRegisterInitial,
    required TResult Function() verifyCodeRegisterLoading,
    required TResult Function(T data) verifyCodeRegisterSuccess,
    required TResult Function(ApiErrorModel apiErrorModel)
        verifyCodeRegisterError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verifyCodeRegisterInitial,
    TResult? Function()? verifyCodeRegisterLoading,
    TResult? Function(T data)? verifyCodeRegisterSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? verifyCodeRegisterError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verifyCodeRegisterInitial,
    TResult Function()? verifyCodeRegisterLoading,
    TResult Function(T data)? verifyCodeRegisterSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? verifyCodeRegisterError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VerifyCodeRegisterInitial<T> value)
        verifyCodeRegisterInitial,
    required TResult Function(VerifyCodeRegisterLoading<T> value)
        verifyCodeRegisterLoading,
    required TResult Function(VerifyCodeRegisterSuccess<T> value)
        verifyCodeRegisterSuccess,
    required TResult Function(VerifyCodeRegisterError<T> value)
        verifyCodeRegisterError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VerifyCodeRegisterInitial<T> value)?
        verifyCodeRegisterInitial,
    TResult? Function(VerifyCodeRegisterLoading<T> value)?
        verifyCodeRegisterLoading,
    TResult? Function(VerifyCodeRegisterSuccess<T> value)?
        verifyCodeRegisterSuccess,
    TResult? Function(VerifyCodeRegisterError<T> value)?
        verifyCodeRegisterError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VerifyCodeRegisterInitial<T> value)?
        verifyCodeRegisterInitial,
    TResult Function(VerifyCodeRegisterLoading<T> value)?
        verifyCodeRegisterLoading,
    TResult Function(VerifyCodeRegisterSuccess<T> value)?
        verifyCodeRegisterSuccess,
    TResult Function(VerifyCodeRegisterError<T> value)? verifyCodeRegisterError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyCodeRegisterStateCopyWith<T, $Res> {
  factory $VerifyCodeRegisterStateCopyWith(VerifyCodeRegisterState<T> value,
          $Res Function(VerifyCodeRegisterState<T>) then) =
      _$VerifyCodeRegisterStateCopyWithImpl<T, $Res,
          VerifyCodeRegisterState<T>>;
}

/// @nodoc
class _$VerifyCodeRegisterStateCopyWithImpl<T, $Res,
        $Val extends VerifyCodeRegisterState<T>>
    implements $VerifyCodeRegisterStateCopyWith<T, $Res> {
  _$VerifyCodeRegisterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyCodeRegisterState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$VerifyCodeRegisterInitialImplCopyWith<T, $Res> {
  factory _$$VerifyCodeRegisterInitialImplCopyWith(
          _$VerifyCodeRegisterInitialImpl<T> value,
          $Res Function(_$VerifyCodeRegisterInitialImpl<T>) then) =
      __$$VerifyCodeRegisterInitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$VerifyCodeRegisterInitialImplCopyWithImpl<T, $Res>
    extends _$VerifyCodeRegisterStateCopyWithImpl<T, $Res,
        _$VerifyCodeRegisterInitialImpl<T>>
    implements _$$VerifyCodeRegisterInitialImplCopyWith<T, $Res> {
  __$$VerifyCodeRegisterInitialImplCopyWithImpl(
      _$VerifyCodeRegisterInitialImpl<T> _value,
      $Res Function(_$VerifyCodeRegisterInitialImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of VerifyCodeRegisterState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$VerifyCodeRegisterInitialImpl<T>
    implements _VerifyCodeRegisterInitial<T> {
  const _$VerifyCodeRegisterInitialImpl();

  @override
  String toString() {
    return 'VerifyCodeRegisterState<$T>.verifyCodeRegisterInitial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyCodeRegisterInitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verifyCodeRegisterInitial,
    required TResult Function() verifyCodeRegisterLoading,
    required TResult Function(T data) verifyCodeRegisterSuccess,
    required TResult Function(ApiErrorModel apiErrorModel)
        verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterInitial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verifyCodeRegisterInitial,
    TResult? Function()? verifyCodeRegisterLoading,
    TResult? Function(T data)? verifyCodeRegisterSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterInitial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verifyCodeRegisterInitial,
    TResult Function()? verifyCodeRegisterLoading,
    TResult Function(T data)? verifyCodeRegisterSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? verifyCodeRegisterError,
    required TResult orElse(),
  }) {
    if (verifyCodeRegisterInitial != null) {
      return verifyCodeRegisterInitial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VerifyCodeRegisterInitial<T> value)
        verifyCodeRegisterInitial,
    required TResult Function(VerifyCodeRegisterLoading<T> value)
        verifyCodeRegisterLoading,
    required TResult Function(VerifyCodeRegisterSuccess<T> value)
        verifyCodeRegisterSuccess,
    required TResult Function(VerifyCodeRegisterError<T> value)
        verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterInitial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VerifyCodeRegisterInitial<T> value)?
        verifyCodeRegisterInitial,
    TResult? Function(VerifyCodeRegisterLoading<T> value)?
        verifyCodeRegisterLoading,
    TResult? Function(VerifyCodeRegisterSuccess<T> value)?
        verifyCodeRegisterSuccess,
    TResult? Function(VerifyCodeRegisterError<T> value)?
        verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterInitial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VerifyCodeRegisterInitial<T> value)?
        verifyCodeRegisterInitial,
    TResult Function(VerifyCodeRegisterLoading<T> value)?
        verifyCodeRegisterLoading,
    TResult Function(VerifyCodeRegisterSuccess<T> value)?
        verifyCodeRegisterSuccess,
    TResult Function(VerifyCodeRegisterError<T> value)? verifyCodeRegisterError,
    required TResult orElse(),
  }) {
    if (verifyCodeRegisterInitial != null) {
      return verifyCodeRegisterInitial(this);
    }
    return orElse();
  }
}

abstract class _VerifyCodeRegisterInitial<T>
    implements VerifyCodeRegisterState<T> {
  const factory _VerifyCodeRegisterInitial() =
      _$VerifyCodeRegisterInitialImpl<T>;
}

/// @nodoc
abstract class _$$VerifyCodeRegisterLoadingImplCopyWith<T, $Res> {
  factory _$$VerifyCodeRegisterLoadingImplCopyWith(
          _$VerifyCodeRegisterLoadingImpl<T> value,
          $Res Function(_$VerifyCodeRegisterLoadingImpl<T>) then) =
      __$$VerifyCodeRegisterLoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$VerifyCodeRegisterLoadingImplCopyWithImpl<T, $Res>
    extends _$VerifyCodeRegisterStateCopyWithImpl<T, $Res,
        _$VerifyCodeRegisterLoadingImpl<T>>
    implements _$$VerifyCodeRegisterLoadingImplCopyWith<T, $Res> {
  __$$VerifyCodeRegisterLoadingImplCopyWithImpl(
      _$VerifyCodeRegisterLoadingImpl<T> _value,
      $Res Function(_$VerifyCodeRegisterLoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of VerifyCodeRegisterState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$VerifyCodeRegisterLoadingImpl<T>
    implements VerifyCodeRegisterLoading<T> {
  const _$VerifyCodeRegisterLoadingImpl();

  @override
  String toString() {
    return 'VerifyCodeRegisterState<$T>.verifyCodeRegisterLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyCodeRegisterLoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verifyCodeRegisterInitial,
    required TResult Function() verifyCodeRegisterLoading,
    required TResult Function(T data) verifyCodeRegisterSuccess,
    required TResult Function(ApiErrorModel apiErrorModel)
        verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verifyCodeRegisterInitial,
    TResult? Function()? verifyCodeRegisterLoading,
    TResult? Function(T data)? verifyCodeRegisterSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verifyCodeRegisterInitial,
    TResult Function()? verifyCodeRegisterLoading,
    TResult Function(T data)? verifyCodeRegisterSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? verifyCodeRegisterError,
    required TResult orElse(),
  }) {
    if (verifyCodeRegisterLoading != null) {
      return verifyCodeRegisterLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VerifyCodeRegisterInitial<T> value)
        verifyCodeRegisterInitial,
    required TResult Function(VerifyCodeRegisterLoading<T> value)
        verifyCodeRegisterLoading,
    required TResult Function(VerifyCodeRegisterSuccess<T> value)
        verifyCodeRegisterSuccess,
    required TResult Function(VerifyCodeRegisterError<T> value)
        verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VerifyCodeRegisterInitial<T> value)?
        verifyCodeRegisterInitial,
    TResult? Function(VerifyCodeRegisterLoading<T> value)?
        verifyCodeRegisterLoading,
    TResult? Function(VerifyCodeRegisterSuccess<T> value)?
        verifyCodeRegisterSuccess,
    TResult? Function(VerifyCodeRegisterError<T> value)?
        verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VerifyCodeRegisterInitial<T> value)?
        verifyCodeRegisterInitial,
    TResult Function(VerifyCodeRegisterLoading<T> value)?
        verifyCodeRegisterLoading,
    TResult Function(VerifyCodeRegisterSuccess<T> value)?
        verifyCodeRegisterSuccess,
    TResult Function(VerifyCodeRegisterError<T> value)? verifyCodeRegisterError,
    required TResult orElse(),
  }) {
    if (verifyCodeRegisterLoading != null) {
      return verifyCodeRegisterLoading(this);
    }
    return orElse();
  }
}

abstract class VerifyCodeRegisterLoading<T>
    implements VerifyCodeRegisterState<T> {
  const factory VerifyCodeRegisterLoading() =
      _$VerifyCodeRegisterLoadingImpl<T>;
}

/// @nodoc
abstract class _$$VerifyCodeRegisterSuccessImplCopyWith<T, $Res> {
  factory _$$VerifyCodeRegisterSuccessImplCopyWith(
          _$VerifyCodeRegisterSuccessImpl<T> value,
          $Res Function(_$VerifyCodeRegisterSuccessImpl<T>) then) =
      __$$VerifyCodeRegisterSuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$VerifyCodeRegisterSuccessImplCopyWithImpl<T, $Res>
    extends _$VerifyCodeRegisterStateCopyWithImpl<T, $Res,
        _$VerifyCodeRegisterSuccessImpl<T>>
    implements _$$VerifyCodeRegisterSuccessImplCopyWith<T, $Res> {
  __$$VerifyCodeRegisterSuccessImplCopyWithImpl(
      _$VerifyCodeRegisterSuccessImpl<T> _value,
      $Res Function(_$VerifyCodeRegisterSuccessImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of VerifyCodeRegisterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$VerifyCodeRegisterSuccessImpl<T>(
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$VerifyCodeRegisterSuccessImpl<T>
    implements VerifyCodeRegisterSuccess<T> {
  const _$VerifyCodeRegisterSuccessImpl(this.data);

  @override
  final T data;

  @override
  String toString() {
    return 'VerifyCodeRegisterState<$T>.verifyCodeRegisterSuccess(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyCodeRegisterSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of VerifyCodeRegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyCodeRegisterSuccessImplCopyWith<T,
          _$VerifyCodeRegisterSuccessImpl<T>>
      get copyWith => __$$VerifyCodeRegisterSuccessImplCopyWithImpl<T,
          _$VerifyCodeRegisterSuccessImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verifyCodeRegisterInitial,
    required TResult Function() verifyCodeRegisterLoading,
    required TResult Function(T data) verifyCodeRegisterSuccess,
    required TResult Function(ApiErrorModel apiErrorModel)
        verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterSuccess(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verifyCodeRegisterInitial,
    TResult? Function()? verifyCodeRegisterLoading,
    TResult? Function(T data)? verifyCodeRegisterSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterSuccess?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verifyCodeRegisterInitial,
    TResult Function()? verifyCodeRegisterLoading,
    TResult Function(T data)? verifyCodeRegisterSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? verifyCodeRegisterError,
    required TResult orElse(),
  }) {
    if (verifyCodeRegisterSuccess != null) {
      return verifyCodeRegisterSuccess(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VerifyCodeRegisterInitial<T> value)
        verifyCodeRegisterInitial,
    required TResult Function(VerifyCodeRegisterLoading<T> value)
        verifyCodeRegisterLoading,
    required TResult Function(VerifyCodeRegisterSuccess<T> value)
        verifyCodeRegisterSuccess,
    required TResult Function(VerifyCodeRegisterError<T> value)
        verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VerifyCodeRegisterInitial<T> value)?
        verifyCodeRegisterInitial,
    TResult? Function(VerifyCodeRegisterLoading<T> value)?
        verifyCodeRegisterLoading,
    TResult? Function(VerifyCodeRegisterSuccess<T> value)?
        verifyCodeRegisterSuccess,
    TResult? Function(VerifyCodeRegisterError<T> value)?
        verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VerifyCodeRegisterInitial<T> value)?
        verifyCodeRegisterInitial,
    TResult Function(VerifyCodeRegisterLoading<T> value)?
        verifyCodeRegisterLoading,
    TResult Function(VerifyCodeRegisterSuccess<T> value)?
        verifyCodeRegisterSuccess,
    TResult Function(VerifyCodeRegisterError<T> value)? verifyCodeRegisterError,
    required TResult orElse(),
  }) {
    if (verifyCodeRegisterSuccess != null) {
      return verifyCodeRegisterSuccess(this);
    }
    return orElse();
  }
}

abstract class VerifyCodeRegisterSuccess<T>
    implements VerifyCodeRegisterState<T> {
  const factory VerifyCodeRegisterSuccess(final T data) =
      _$VerifyCodeRegisterSuccessImpl<T>;

  T get data;

  /// Create a copy of VerifyCodeRegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyCodeRegisterSuccessImplCopyWith<T,
          _$VerifyCodeRegisterSuccessImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VerifyCodeRegisterErrorImplCopyWith<T, $Res> {
  factory _$$VerifyCodeRegisterErrorImplCopyWith(
          _$VerifyCodeRegisterErrorImpl<T> value,
          $Res Function(_$VerifyCodeRegisterErrorImpl<T>) then) =
      __$$VerifyCodeRegisterErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({ApiErrorModel apiErrorModel});
}

/// @nodoc
class __$$VerifyCodeRegisterErrorImplCopyWithImpl<T, $Res>
    extends _$VerifyCodeRegisterStateCopyWithImpl<T, $Res,
        _$VerifyCodeRegisterErrorImpl<T>>
    implements _$$VerifyCodeRegisterErrorImplCopyWith<T, $Res> {
  __$$VerifyCodeRegisterErrorImplCopyWithImpl(
      _$VerifyCodeRegisterErrorImpl<T> _value,
      $Res Function(_$VerifyCodeRegisterErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of VerifyCodeRegisterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiErrorModel = null,
  }) {
    return _then(_$VerifyCodeRegisterErrorImpl<T>(
      null == apiErrorModel
          ? _value.apiErrorModel
          : apiErrorModel // ignore: cast_nullable_to_non_nullable
              as ApiErrorModel,
    ));
  }
}

/// @nodoc

class _$VerifyCodeRegisterErrorImpl<T> implements VerifyCodeRegisterError<T> {
  const _$VerifyCodeRegisterErrorImpl(this.apiErrorModel);

  @override
  final ApiErrorModel apiErrorModel;

  @override
  String toString() {
    return 'VerifyCodeRegisterState<$T>.verifyCodeRegisterError(apiErrorModel: $apiErrorModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyCodeRegisterErrorImpl<T> &&
            (identical(other.apiErrorModel, apiErrorModel) ||
                other.apiErrorModel == apiErrorModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, apiErrorModel);

  /// Create a copy of VerifyCodeRegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyCodeRegisterErrorImplCopyWith<T, _$VerifyCodeRegisterErrorImpl<T>>
      get copyWith => __$$VerifyCodeRegisterErrorImplCopyWithImpl<T,
          _$VerifyCodeRegisterErrorImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() verifyCodeRegisterInitial,
    required TResult Function() verifyCodeRegisterLoading,
    required TResult Function(T data) verifyCodeRegisterSuccess,
    required TResult Function(ApiErrorModel apiErrorModel)
        verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterError(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? verifyCodeRegisterInitial,
    TResult? Function()? verifyCodeRegisterLoading,
    TResult? Function(T data)? verifyCodeRegisterSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterError?.call(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? verifyCodeRegisterInitial,
    TResult Function()? verifyCodeRegisterLoading,
    TResult Function(T data)? verifyCodeRegisterSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? verifyCodeRegisterError,
    required TResult orElse(),
  }) {
    if (verifyCodeRegisterError != null) {
      return verifyCodeRegisterError(apiErrorModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_VerifyCodeRegisterInitial<T> value)
        verifyCodeRegisterInitial,
    required TResult Function(VerifyCodeRegisterLoading<T> value)
        verifyCodeRegisterLoading,
    required TResult Function(VerifyCodeRegisterSuccess<T> value)
        verifyCodeRegisterSuccess,
    required TResult Function(VerifyCodeRegisterError<T> value)
        verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_VerifyCodeRegisterInitial<T> value)?
        verifyCodeRegisterInitial,
    TResult? Function(VerifyCodeRegisterLoading<T> value)?
        verifyCodeRegisterLoading,
    TResult? Function(VerifyCodeRegisterSuccess<T> value)?
        verifyCodeRegisterSuccess,
    TResult? Function(VerifyCodeRegisterError<T> value)?
        verifyCodeRegisterError,
  }) {
    return verifyCodeRegisterError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_VerifyCodeRegisterInitial<T> value)?
        verifyCodeRegisterInitial,
    TResult Function(VerifyCodeRegisterLoading<T> value)?
        verifyCodeRegisterLoading,
    TResult Function(VerifyCodeRegisterSuccess<T> value)?
        verifyCodeRegisterSuccess,
    TResult Function(VerifyCodeRegisterError<T> value)? verifyCodeRegisterError,
    required TResult orElse(),
  }) {
    if (verifyCodeRegisterError != null) {
      return verifyCodeRegisterError(this);
    }
    return orElse();
  }
}

abstract class VerifyCodeRegisterError<T>
    implements VerifyCodeRegisterState<T> {
  const factory VerifyCodeRegisterError(final ApiErrorModel apiErrorModel) =
      _$VerifyCodeRegisterErrorImpl<T>;

  ApiErrorModel get apiErrorModel;

  /// Create a copy of VerifyCodeRegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyCodeRegisterErrorImplCopyWith<T, _$VerifyCodeRegisterErrorImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserInfoState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() userInfoInitial,
    required TResult Function() userInfoLoading,
    required TResult Function(UserInfoResponse data) userInfoSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) userInfoError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? userInfoInitial,
    TResult? Function()? userInfoLoading,
    TResult? Function(UserInfoResponse data)? userInfoSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? userInfoError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? userInfoInitial,
    TResult Function()? userInfoLoading,
    TResult Function(UserInfoResponse data)? userInfoSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? userInfoError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserInfoInitial<T> value) userInfoInitial,
    required TResult Function(UserInfoLoading<T> value) userInfoLoading,
    required TResult Function(UserInfoSuccess<T> value) userInfoSuccess,
    required TResult Function(UserInfoError<T> value) userInfoError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserInfoInitial<T> value)? userInfoInitial,
    TResult? Function(UserInfoLoading<T> value)? userInfoLoading,
    TResult? Function(UserInfoSuccess<T> value)? userInfoSuccess,
    TResult? Function(UserInfoError<T> value)? userInfoError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserInfoInitial<T> value)? userInfoInitial,
    TResult Function(UserInfoLoading<T> value)? userInfoLoading,
    TResult Function(UserInfoSuccess<T> value)? userInfoSuccess,
    TResult Function(UserInfoError<T> value)? userInfoError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoStateCopyWith<T, $Res> {
  factory $UserInfoStateCopyWith(
          UserInfoState<T> value, $Res Function(UserInfoState<T>) then) =
      _$UserInfoStateCopyWithImpl<T, $Res, UserInfoState<T>>;
}

/// @nodoc
class _$UserInfoStateCopyWithImpl<T, $Res, $Val extends UserInfoState<T>>
    implements $UserInfoStateCopyWith<T, $Res> {
  _$UserInfoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserInfoState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UserInfoInitialImplCopyWith<T, $Res> {
  factory _$$UserInfoInitialImplCopyWith(_$UserInfoInitialImpl<T> value,
          $Res Function(_$UserInfoInitialImpl<T>) then) =
      __$$UserInfoInitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$UserInfoInitialImplCopyWithImpl<T, $Res>
    extends _$UserInfoStateCopyWithImpl<T, $Res, _$UserInfoInitialImpl<T>>
    implements _$$UserInfoInitialImplCopyWith<T, $Res> {
  __$$UserInfoInitialImplCopyWithImpl(_$UserInfoInitialImpl<T> _value,
      $Res Function(_$UserInfoInitialImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of UserInfoState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserInfoInitialImpl<T> implements UserInfoInitial<T> {
  const _$UserInfoInitialImpl();

  @override
  String toString() {
    return 'UserInfoState<$T>.userInfoInitial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserInfoInitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() userInfoInitial,
    required TResult Function() userInfoLoading,
    required TResult Function(UserInfoResponse data) userInfoSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) userInfoError,
  }) {
    return userInfoInitial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? userInfoInitial,
    TResult? Function()? userInfoLoading,
    TResult? Function(UserInfoResponse data)? userInfoSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? userInfoError,
  }) {
    return userInfoInitial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? userInfoInitial,
    TResult Function()? userInfoLoading,
    TResult Function(UserInfoResponse data)? userInfoSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? userInfoError,
    required TResult orElse(),
  }) {
    if (userInfoInitial != null) {
      return userInfoInitial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserInfoInitial<T> value) userInfoInitial,
    required TResult Function(UserInfoLoading<T> value) userInfoLoading,
    required TResult Function(UserInfoSuccess<T> value) userInfoSuccess,
    required TResult Function(UserInfoError<T> value) userInfoError,
  }) {
    return userInfoInitial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserInfoInitial<T> value)? userInfoInitial,
    TResult? Function(UserInfoLoading<T> value)? userInfoLoading,
    TResult? Function(UserInfoSuccess<T> value)? userInfoSuccess,
    TResult? Function(UserInfoError<T> value)? userInfoError,
  }) {
    return userInfoInitial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserInfoInitial<T> value)? userInfoInitial,
    TResult Function(UserInfoLoading<T> value)? userInfoLoading,
    TResult Function(UserInfoSuccess<T> value)? userInfoSuccess,
    TResult Function(UserInfoError<T> value)? userInfoError,
    required TResult orElse(),
  }) {
    if (userInfoInitial != null) {
      return userInfoInitial(this);
    }
    return orElse();
  }
}

abstract class UserInfoInitial<T> implements UserInfoState<T> {
  const factory UserInfoInitial() = _$UserInfoInitialImpl<T>;
}

/// @nodoc
abstract class _$$UserInfoLoadingImplCopyWith<T, $Res> {
  factory _$$UserInfoLoadingImplCopyWith(_$UserInfoLoadingImpl<T> value,
          $Res Function(_$UserInfoLoadingImpl<T>) then) =
      __$$UserInfoLoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$UserInfoLoadingImplCopyWithImpl<T, $Res>
    extends _$UserInfoStateCopyWithImpl<T, $Res, _$UserInfoLoadingImpl<T>>
    implements _$$UserInfoLoadingImplCopyWith<T, $Res> {
  __$$UserInfoLoadingImplCopyWithImpl(_$UserInfoLoadingImpl<T> _value,
      $Res Function(_$UserInfoLoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of UserInfoState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserInfoLoadingImpl<T> implements UserInfoLoading<T> {
  const _$UserInfoLoadingImpl();

  @override
  String toString() {
    return 'UserInfoState<$T>.userInfoLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserInfoLoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() userInfoInitial,
    required TResult Function() userInfoLoading,
    required TResult Function(UserInfoResponse data) userInfoSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) userInfoError,
  }) {
    return userInfoLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? userInfoInitial,
    TResult? Function()? userInfoLoading,
    TResult? Function(UserInfoResponse data)? userInfoSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? userInfoError,
  }) {
    return userInfoLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? userInfoInitial,
    TResult Function()? userInfoLoading,
    TResult Function(UserInfoResponse data)? userInfoSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? userInfoError,
    required TResult orElse(),
  }) {
    if (userInfoLoading != null) {
      return userInfoLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserInfoInitial<T> value) userInfoInitial,
    required TResult Function(UserInfoLoading<T> value) userInfoLoading,
    required TResult Function(UserInfoSuccess<T> value) userInfoSuccess,
    required TResult Function(UserInfoError<T> value) userInfoError,
  }) {
    return userInfoLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserInfoInitial<T> value)? userInfoInitial,
    TResult? Function(UserInfoLoading<T> value)? userInfoLoading,
    TResult? Function(UserInfoSuccess<T> value)? userInfoSuccess,
    TResult? Function(UserInfoError<T> value)? userInfoError,
  }) {
    return userInfoLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserInfoInitial<T> value)? userInfoInitial,
    TResult Function(UserInfoLoading<T> value)? userInfoLoading,
    TResult Function(UserInfoSuccess<T> value)? userInfoSuccess,
    TResult Function(UserInfoError<T> value)? userInfoError,
    required TResult orElse(),
  }) {
    if (userInfoLoading != null) {
      return userInfoLoading(this);
    }
    return orElse();
  }
}

abstract class UserInfoLoading<T> implements UserInfoState<T> {
  const factory UserInfoLoading() = _$UserInfoLoadingImpl<T>;
}

/// @nodoc
abstract class _$$UserInfoSuccessImplCopyWith<T, $Res> {
  factory _$$UserInfoSuccessImplCopyWith(_$UserInfoSuccessImpl<T> value,
          $Res Function(_$UserInfoSuccessImpl<T>) then) =
      __$$UserInfoSuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({UserInfoResponse data});
}

/// @nodoc
class __$$UserInfoSuccessImplCopyWithImpl<T, $Res>
    extends _$UserInfoStateCopyWithImpl<T, $Res, _$UserInfoSuccessImpl<T>>
    implements _$$UserInfoSuccessImplCopyWith<T, $Res> {
  __$$UserInfoSuccessImplCopyWithImpl(_$UserInfoSuccessImpl<T> _value,
      $Res Function(_$UserInfoSuccessImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of UserInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$UserInfoSuccessImpl<T>(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as UserInfoResponse,
    ));
  }
}

/// @nodoc

class _$UserInfoSuccessImpl<T> implements UserInfoSuccess<T> {
  const _$UserInfoSuccessImpl(this.data);

  @override
  final UserInfoResponse data;

  @override
  String toString() {
    return 'UserInfoState<$T>.userInfoSuccess(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoSuccessImpl<T> &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of UserInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoSuccessImplCopyWith<T, _$UserInfoSuccessImpl<T>> get copyWith =>
      __$$UserInfoSuccessImplCopyWithImpl<T, _$UserInfoSuccessImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() userInfoInitial,
    required TResult Function() userInfoLoading,
    required TResult Function(UserInfoResponse data) userInfoSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) userInfoError,
  }) {
    return userInfoSuccess(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? userInfoInitial,
    TResult? Function()? userInfoLoading,
    TResult? Function(UserInfoResponse data)? userInfoSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? userInfoError,
  }) {
    return userInfoSuccess?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? userInfoInitial,
    TResult Function()? userInfoLoading,
    TResult Function(UserInfoResponse data)? userInfoSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? userInfoError,
    required TResult orElse(),
  }) {
    if (userInfoSuccess != null) {
      return userInfoSuccess(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserInfoInitial<T> value) userInfoInitial,
    required TResult Function(UserInfoLoading<T> value) userInfoLoading,
    required TResult Function(UserInfoSuccess<T> value) userInfoSuccess,
    required TResult Function(UserInfoError<T> value) userInfoError,
  }) {
    return userInfoSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserInfoInitial<T> value)? userInfoInitial,
    TResult? Function(UserInfoLoading<T> value)? userInfoLoading,
    TResult? Function(UserInfoSuccess<T> value)? userInfoSuccess,
    TResult? Function(UserInfoError<T> value)? userInfoError,
  }) {
    return userInfoSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserInfoInitial<T> value)? userInfoInitial,
    TResult Function(UserInfoLoading<T> value)? userInfoLoading,
    TResult Function(UserInfoSuccess<T> value)? userInfoSuccess,
    TResult Function(UserInfoError<T> value)? userInfoError,
    required TResult orElse(),
  }) {
    if (userInfoSuccess != null) {
      return userInfoSuccess(this);
    }
    return orElse();
  }
}

abstract class UserInfoSuccess<T> implements UserInfoState<T> {
  const factory UserInfoSuccess(final UserInfoResponse data) =
      _$UserInfoSuccessImpl<T>;

  UserInfoResponse get data;

  /// Create a copy of UserInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserInfoSuccessImplCopyWith<T, _$UserInfoSuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserInfoErrorImplCopyWith<T, $Res> {
  factory _$$UserInfoErrorImplCopyWith(_$UserInfoErrorImpl<T> value,
          $Res Function(_$UserInfoErrorImpl<T>) then) =
      __$$UserInfoErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({ApiErrorModel apiErrorModel});
}

/// @nodoc
class __$$UserInfoErrorImplCopyWithImpl<T, $Res>
    extends _$UserInfoStateCopyWithImpl<T, $Res, _$UserInfoErrorImpl<T>>
    implements _$$UserInfoErrorImplCopyWith<T, $Res> {
  __$$UserInfoErrorImplCopyWithImpl(_$UserInfoErrorImpl<T> _value,
      $Res Function(_$UserInfoErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of UserInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiErrorModel = null,
  }) {
    return _then(_$UserInfoErrorImpl<T>(
      null == apiErrorModel
          ? _value.apiErrorModel
          : apiErrorModel // ignore: cast_nullable_to_non_nullable
              as ApiErrorModel,
    ));
  }
}

/// @nodoc

class _$UserInfoErrorImpl<T> implements UserInfoError<T> {
  const _$UserInfoErrorImpl(this.apiErrorModel);

  @override
  final ApiErrorModel apiErrorModel;

  @override
  String toString() {
    return 'UserInfoState<$T>.userInfoError(apiErrorModel: $apiErrorModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoErrorImpl<T> &&
            (identical(other.apiErrorModel, apiErrorModel) ||
                other.apiErrorModel == apiErrorModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, apiErrorModel);

  /// Create a copy of UserInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoErrorImplCopyWith<T, _$UserInfoErrorImpl<T>> get copyWith =>
      __$$UserInfoErrorImplCopyWithImpl<T, _$UserInfoErrorImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() userInfoInitial,
    required TResult Function() userInfoLoading,
    required TResult Function(UserInfoResponse data) userInfoSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) userInfoError,
  }) {
    return userInfoError(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? userInfoInitial,
    TResult? Function()? userInfoLoading,
    TResult? Function(UserInfoResponse data)? userInfoSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? userInfoError,
  }) {
    return userInfoError?.call(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? userInfoInitial,
    TResult Function()? userInfoLoading,
    TResult Function(UserInfoResponse data)? userInfoSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? userInfoError,
    required TResult orElse(),
  }) {
    if (userInfoError != null) {
      return userInfoError(apiErrorModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UserInfoInitial<T> value) userInfoInitial,
    required TResult Function(UserInfoLoading<T> value) userInfoLoading,
    required TResult Function(UserInfoSuccess<T> value) userInfoSuccess,
    required TResult Function(UserInfoError<T> value) userInfoError,
  }) {
    return userInfoError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UserInfoInitial<T> value)? userInfoInitial,
    TResult? Function(UserInfoLoading<T> value)? userInfoLoading,
    TResult? Function(UserInfoSuccess<T> value)? userInfoSuccess,
    TResult? Function(UserInfoError<T> value)? userInfoError,
  }) {
    return userInfoError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UserInfoInitial<T> value)? userInfoInitial,
    TResult Function(UserInfoLoading<T> value)? userInfoLoading,
    TResult Function(UserInfoSuccess<T> value)? userInfoSuccess,
    TResult Function(UserInfoError<T> value)? userInfoError,
    required TResult orElse(),
  }) {
    if (userInfoError != null) {
      return userInfoError(this);
    }
    return orElse();
  }
}

abstract class UserInfoError<T> implements UserInfoState<T> {
  const factory UserInfoError(final ApiErrorModel apiErrorModel) =
      _$UserInfoErrorImpl<T>;

  ApiErrorModel get apiErrorModel;

  /// Create a copy of UserInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserInfoErrorImplCopyWith<T, _$UserInfoErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateUserInfoState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() updateInitial,
    required TResult Function() updateLoading,
    required TResult Function(UpdateUserInfoResponse data) updateSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) updateInfoError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? updateInitial,
    TResult? Function()? updateLoading,
    TResult? Function(UpdateUserInfoResponse data)? updateSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? updateInfoError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? updateInitial,
    TResult Function()? updateLoading,
    TResult Function(UpdateUserInfoResponse data)? updateSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? updateInfoError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UpdateUserInfoInitial<T> value) updateInitial,
    required TResult Function(UpdateLoading<T> value) updateLoading,
    required TResult Function(UpdateSuccess<T> value) updateSuccess,
    required TResult Function(UpdateInfoError<T> value) updateInfoError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UpdateUserInfoInitial<T> value)? updateInitial,
    TResult? Function(UpdateLoading<T> value)? updateLoading,
    TResult? Function(UpdateSuccess<T> value)? updateSuccess,
    TResult? Function(UpdateInfoError<T> value)? updateInfoError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UpdateUserInfoInitial<T> value)? updateInitial,
    TResult Function(UpdateLoading<T> value)? updateLoading,
    TResult Function(UpdateSuccess<T> value)? updateSuccess,
    TResult Function(UpdateInfoError<T> value)? updateInfoError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateUserInfoStateCopyWith<T, $Res> {
  factory $UpdateUserInfoStateCopyWith(UpdateUserInfoState<T> value,
          $Res Function(UpdateUserInfoState<T>) then) =
      _$UpdateUserInfoStateCopyWithImpl<T, $Res, UpdateUserInfoState<T>>;
}

/// @nodoc
class _$UpdateUserInfoStateCopyWithImpl<T, $Res,
        $Val extends UpdateUserInfoState<T>>
    implements $UpdateUserInfoStateCopyWith<T, $Res> {
  _$UpdateUserInfoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateUserInfoState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UpdateUserInfoInitialImplCopyWith<T, $Res> {
  factory _$$UpdateUserInfoInitialImplCopyWith(
          _$UpdateUserInfoInitialImpl<T> value,
          $Res Function(_$UpdateUserInfoInitialImpl<T>) then) =
      __$$UpdateUserInfoInitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$UpdateUserInfoInitialImplCopyWithImpl<T, $Res>
    extends _$UpdateUserInfoStateCopyWithImpl<T, $Res,
        _$UpdateUserInfoInitialImpl<T>>
    implements _$$UpdateUserInfoInitialImplCopyWith<T, $Res> {
  __$$UpdateUserInfoInitialImplCopyWithImpl(
      _$UpdateUserInfoInitialImpl<T> _value,
      $Res Function(_$UpdateUserInfoInitialImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of UpdateUserInfoState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UpdateUserInfoInitialImpl<T> implements _UpdateUserInfoInitial<T> {
  const _$UpdateUserInfoInitialImpl();

  @override
  String toString() {
    return 'UpdateUserInfoState<$T>.updateInitial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserInfoInitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() updateInitial,
    required TResult Function() updateLoading,
    required TResult Function(UpdateUserInfoResponse data) updateSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) updateInfoError,
  }) {
    return updateInitial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? updateInitial,
    TResult? Function()? updateLoading,
    TResult? Function(UpdateUserInfoResponse data)? updateSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? updateInfoError,
  }) {
    return updateInitial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? updateInitial,
    TResult Function()? updateLoading,
    TResult Function(UpdateUserInfoResponse data)? updateSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? updateInfoError,
    required TResult orElse(),
  }) {
    if (updateInitial != null) {
      return updateInitial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UpdateUserInfoInitial<T> value) updateInitial,
    required TResult Function(UpdateLoading<T> value) updateLoading,
    required TResult Function(UpdateSuccess<T> value) updateSuccess,
    required TResult Function(UpdateInfoError<T> value) updateInfoError,
  }) {
    return updateInitial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UpdateUserInfoInitial<T> value)? updateInitial,
    TResult? Function(UpdateLoading<T> value)? updateLoading,
    TResult? Function(UpdateSuccess<T> value)? updateSuccess,
    TResult? Function(UpdateInfoError<T> value)? updateInfoError,
  }) {
    return updateInitial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UpdateUserInfoInitial<T> value)? updateInitial,
    TResult Function(UpdateLoading<T> value)? updateLoading,
    TResult Function(UpdateSuccess<T> value)? updateSuccess,
    TResult Function(UpdateInfoError<T> value)? updateInfoError,
    required TResult orElse(),
  }) {
    if (updateInitial != null) {
      return updateInitial(this);
    }
    return orElse();
  }
}

abstract class _UpdateUserInfoInitial<T> implements UpdateUserInfoState<T> {
  const factory _UpdateUserInfoInitial() = _$UpdateUserInfoInitialImpl<T>;
}

/// @nodoc
abstract class _$$UpdateLoadingImplCopyWith<T, $Res> {
  factory _$$UpdateLoadingImplCopyWith(_$UpdateLoadingImpl<T> value,
          $Res Function(_$UpdateLoadingImpl<T>) then) =
      __$$UpdateLoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$UpdateLoadingImplCopyWithImpl<T, $Res>
    extends _$UpdateUserInfoStateCopyWithImpl<T, $Res, _$UpdateLoadingImpl<T>>
    implements _$$UpdateLoadingImplCopyWith<T, $Res> {
  __$$UpdateLoadingImplCopyWithImpl(_$UpdateLoadingImpl<T> _value,
      $Res Function(_$UpdateLoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of UpdateUserInfoState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UpdateLoadingImpl<T> implements UpdateLoading<T> {
  const _$UpdateLoadingImpl();

  @override
  String toString() {
    return 'UpdateUserInfoState<$T>.updateLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UpdateLoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() updateInitial,
    required TResult Function() updateLoading,
    required TResult Function(UpdateUserInfoResponse data) updateSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) updateInfoError,
  }) {
    return updateLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? updateInitial,
    TResult? Function()? updateLoading,
    TResult? Function(UpdateUserInfoResponse data)? updateSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? updateInfoError,
  }) {
    return updateLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? updateInitial,
    TResult Function()? updateLoading,
    TResult Function(UpdateUserInfoResponse data)? updateSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? updateInfoError,
    required TResult orElse(),
  }) {
    if (updateLoading != null) {
      return updateLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UpdateUserInfoInitial<T> value) updateInitial,
    required TResult Function(UpdateLoading<T> value) updateLoading,
    required TResult Function(UpdateSuccess<T> value) updateSuccess,
    required TResult Function(UpdateInfoError<T> value) updateInfoError,
  }) {
    return updateLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UpdateUserInfoInitial<T> value)? updateInitial,
    TResult? Function(UpdateLoading<T> value)? updateLoading,
    TResult? Function(UpdateSuccess<T> value)? updateSuccess,
    TResult? Function(UpdateInfoError<T> value)? updateInfoError,
  }) {
    return updateLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UpdateUserInfoInitial<T> value)? updateInitial,
    TResult Function(UpdateLoading<T> value)? updateLoading,
    TResult Function(UpdateSuccess<T> value)? updateSuccess,
    TResult Function(UpdateInfoError<T> value)? updateInfoError,
    required TResult orElse(),
  }) {
    if (updateLoading != null) {
      return updateLoading(this);
    }
    return orElse();
  }
}

abstract class UpdateLoading<T> implements UpdateUserInfoState<T> {
  const factory UpdateLoading() = _$UpdateLoadingImpl<T>;
}

/// @nodoc
abstract class _$$UpdateSuccessImplCopyWith<T, $Res> {
  factory _$$UpdateSuccessImplCopyWith(_$UpdateSuccessImpl<T> value,
          $Res Function(_$UpdateSuccessImpl<T>) then) =
      __$$UpdateSuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({UpdateUserInfoResponse data});
}

/// @nodoc
class __$$UpdateSuccessImplCopyWithImpl<T, $Res>
    extends _$UpdateUserInfoStateCopyWithImpl<T, $Res, _$UpdateSuccessImpl<T>>
    implements _$$UpdateSuccessImplCopyWith<T, $Res> {
  __$$UpdateSuccessImplCopyWithImpl(_$UpdateSuccessImpl<T> _value,
      $Res Function(_$UpdateSuccessImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of UpdateUserInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$UpdateSuccessImpl<T>(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as UpdateUserInfoResponse,
    ));
  }
}

/// @nodoc

class _$UpdateSuccessImpl<T> implements UpdateSuccess<T> {
  const _$UpdateSuccessImpl(this.data);

  @override
  final UpdateUserInfoResponse data;

  @override
  String toString() {
    return 'UpdateUserInfoState<$T>.updateSuccess(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSuccessImpl<T> &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of UpdateUserInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateSuccessImplCopyWith<T, _$UpdateSuccessImpl<T>> get copyWith =>
      __$$UpdateSuccessImplCopyWithImpl<T, _$UpdateSuccessImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() updateInitial,
    required TResult Function() updateLoading,
    required TResult Function(UpdateUserInfoResponse data) updateSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) updateInfoError,
  }) {
    return updateSuccess(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? updateInitial,
    TResult? Function()? updateLoading,
    TResult? Function(UpdateUserInfoResponse data)? updateSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? updateInfoError,
  }) {
    return updateSuccess?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? updateInitial,
    TResult Function()? updateLoading,
    TResult Function(UpdateUserInfoResponse data)? updateSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? updateInfoError,
    required TResult orElse(),
  }) {
    if (updateSuccess != null) {
      return updateSuccess(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UpdateUserInfoInitial<T> value) updateInitial,
    required TResult Function(UpdateLoading<T> value) updateLoading,
    required TResult Function(UpdateSuccess<T> value) updateSuccess,
    required TResult Function(UpdateInfoError<T> value) updateInfoError,
  }) {
    return updateSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UpdateUserInfoInitial<T> value)? updateInitial,
    TResult? Function(UpdateLoading<T> value)? updateLoading,
    TResult? Function(UpdateSuccess<T> value)? updateSuccess,
    TResult? Function(UpdateInfoError<T> value)? updateInfoError,
  }) {
    return updateSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UpdateUserInfoInitial<T> value)? updateInitial,
    TResult Function(UpdateLoading<T> value)? updateLoading,
    TResult Function(UpdateSuccess<T> value)? updateSuccess,
    TResult Function(UpdateInfoError<T> value)? updateInfoError,
    required TResult orElse(),
  }) {
    if (updateSuccess != null) {
      return updateSuccess(this);
    }
    return orElse();
  }
}

abstract class UpdateSuccess<T> implements UpdateUserInfoState<T> {
  const factory UpdateSuccess(final UpdateUserInfoResponse data) =
      _$UpdateSuccessImpl<T>;

  UpdateUserInfoResponse get data;

  /// Create a copy of UpdateUserInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateSuccessImplCopyWith<T, _$UpdateSuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateInfoErrorImplCopyWith<T, $Res> {
  factory _$$UpdateInfoErrorImplCopyWith(_$UpdateInfoErrorImpl<T> value,
          $Res Function(_$UpdateInfoErrorImpl<T>) then) =
      __$$UpdateInfoErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({ApiErrorModel apiErrorModel});
}

/// @nodoc
class __$$UpdateInfoErrorImplCopyWithImpl<T, $Res>
    extends _$UpdateUserInfoStateCopyWithImpl<T, $Res, _$UpdateInfoErrorImpl<T>>
    implements _$$UpdateInfoErrorImplCopyWith<T, $Res> {
  __$$UpdateInfoErrorImplCopyWithImpl(_$UpdateInfoErrorImpl<T> _value,
      $Res Function(_$UpdateInfoErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of UpdateUserInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiErrorModel = null,
  }) {
    return _then(_$UpdateInfoErrorImpl<T>(
      null == apiErrorModel
          ? _value.apiErrorModel
          : apiErrorModel // ignore: cast_nullable_to_non_nullable
              as ApiErrorModel,
    ));
  }
}

/// @nodoc

class _$UpdateInfoErrorImpl<T> implements UpdateInfoError<T> {
  const _$UpdateInfoErrorImpl(this.apiErrorModel);

  @override
  final ApiErrorModel apiErrorModel;

  @override
  String toString() {
    return 'UpdateUserInfoState<$T>.updateInfoError(apiErrorModel: $apiErrorModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateInfoErrorImpl<T> &&
            (identical(other.apiErrorModel, apiErrorModel) ||
                other.apiErrorModel == apiErrorModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, apiErrorModel);

  /// Create a copy of UpdateUserInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateInfoErrorImplCopyWith<T, _$UpdateInfoErrorImpl<T>> get copyWith =>
      __$$UpdateInfoErrorImplCopyWithImpl<T, _$UpdateInfoErrorImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() updateInitial,
    required TResult Function() updateLoading,
    required TResult Function(UpdateUserInfoResponse data) updateSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) updateInfoError,
  }) {
    return updateInfoError(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? updateInitial,
    TResult? Function()? updateLoading,
    TResult? Function(UpdateUserInfoResponse data)? updateSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? updateInfoError,
  }) {
    return updateInfoError?.call(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? updateInitial,
    TResult Function()? updateLoading,
    TResult Function(UpdateUserInfoResponse data)? updateSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? updateInfoError,
    required TResult orElse(),
  }) {
    if (updateInfoError != null) {
      return updateInfoError(apiErrorModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_UpdateUserInfoInitial<T> value) updateInitial,
    required TResult Function(UpdateLoading<T> value) updateLoading,
    required TResult Function(UpdateSuccess<T> value) updateSuccess,
    required TResult Function(UpdateInfoError<T> value) updateInfoError,
  }) {
    return updateInfoError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_UpdateUserInfoInitial<T> value)? updateInitial,
    TResult? Function(UpdateLoading<T> value)? updateLoading,
    TResult? Function(UpdateSuccess<T> value)? updateSuccess,
    TResult? Function(UpdateInfoError<T> value)? updateInfoError,
  }) {
    return updateInfoError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_UpdateUserInfoInitial<T> value)? updateInitial,
    TResult Function(UpdateLoading<T> value)? updateLoading,
    TResult Function(UpdateSuccess<T> value)? updateSuccess,
    TResult Function(UpdateInfoError<T> value)? updateInfoError,
    required TResult orElse(),
  }) {
    if (updateInfoError != null) {
      return updateInfoError(this);
    }
    return orElse();
  }
}

abstract class UpdateInfoError<T> implements UpdateUserInfoState<T> {
  const factory UpdateInfoError(final ApiErrorModel apiErrorModel) =
      _$UpdateInfoErrorImpl<T>;

  ApiErrorModel get apiErrorModel;

  /// Create a copy of UpdateUserInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateInfoErrorImplCopyWith<T, _$UpdateInfoErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ResetPasswordState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() resetPasswordInitial,
    required TResult Function() resetPasswordLoading,
    required TResult Function(T data) resetPasswordSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) resetPasswordError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? resetPasswordInitial,
    TResult? Function()? resetPasswordLoading,
    TResult? Function(T data)? resetPasswordSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? resetPasswordError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? resetPasswordInitial,
    TResult Function()? resetPasswordLoading,
    TResult Function(T data)? resetPasswordSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? resetPasswordError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ResetPasswordInitial<T> value)
        resetPasswordInitial,
    required TResult Function(ResetPasswordLoading<T> value)
        resetPasswordLoading,
    required TResult Function(ResetPasswordSuccess<T> value)
        resetPasswordSuccess,
    required TResult Function(ResetPasswordError<T> value) resetPasswordError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ResetPasswordInitial<T> value)? resetPasswordInitial,
    TResult? Function(ResetPasswordLoading<T> value)? resetPasswordLoading,
    TResult? Function(ResetPasswordSuccess<T> value)? resetPasswordSuccess,
    TResult? Function(ResetPasswordError<T> value)? resetPasswordError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ResetPasswordInitial<T> value)? resetPasswordInitial,
    TResult Function(ResetPasswordLoading<T> value)? resetPasswordLoading,
    TResult Function(ResetPasswordSuccess<T> value)? resetPasswordSuccess,
    TResult Function(ResetPasswordError<T> value)? resetPasswordError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordStateCopyWith<T, $Res> {
  factory $ResetPasswordStateCopyWith(ResetPasswordState<T> value,
          $Res Function(ResetPasswordState<T>) then) =
      _$ResetPasswordStateCopyWithImpl<T, $Res, ResetPasswordState<T>>;
}

/// @nodoc
class _$ResetPasswordStateCopyWithImpl<T, $Res,
        $Val extends ResetPasswordState<T>>
    implements $ResetPasswordStateCopyWith<T, $Res> {
  _$ResetPasswordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ResetPasswordInitialImplCopyWith<T, $Res> {
  factory _$$ResetPasswordInitialImplCopyWith(
          _$ResetPasswordInitialImpl<T> value,
          $Res Function(_$ResetPasswordInitialImpl<T>) then) =
      __$$ResetPasswordInitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$ResetPasswordInitialImplCopyWithImpl<T, $Res>
    extends _$ResetPasswordStateCopyWithImpl<T, $Res,
        _$ResetPasswordInitialImpl<T>>
    implements _$$ResetPasswordInitialImplCopyWith<T, $Res> {
  __$$ResetPasswordInitialImplCopyWithImpl(_$ResetPasswordInitialImpl<T> _value,
      $Res Function(_$ResetPasswordInitialImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ResetPasswordInitialImpl<T> implements _ResetPasswordInitial<T> {
  const _$ResetPasswordInitialImpl();

  @override
  String toString() {
    return 'ResetPasswordState<$T>.resetPasswordInitial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordInitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() resetPasswordInitial,
    required TResult Function() resetPasswordLoading,
    required TResult Function(T data) resetPasswordSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) resetPasswordError,
  }) {
    return resetPasswordInitial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? resetPasswordInitial,
    TResult? Function()? resetPasswordLoading,
    TResult? Function(T data)? resetPasswordSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? resetPasswordError,
  }) {
    return resetPasswordInitial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? resetPasswordInitial,
    TResult Function()? resetPasswordLoading,
    TResult Function(T data)? resetPasswordSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? resetPasswordError,
    required TResult orElse(),
  }) {
    if (resetPasswordInitial != null) {
      return resetPasswordInitial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ResetPasswordInitial<T> value)
        resetPasswordInitial,
    required TResult Function(ResetPasswordLoading<T> value)
        resetPasswordLoading,
    required TResult Function(ResetPasswordSuccess<T> value)
        resetPasswordSuccess,
    required TResult Function(ResetPasswordError<T> value) resetPasswordError,
  }) {
    return resetPasswordInitial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ResetPasswordInitial<T> value)? resetPasswordInitial,
    TResult? Function(ResetPasswordLoading<T> value)? resetPasswordLoading,
    TResult? Function(ResetPasswordSuccess<T> value)? resetPasswordSuccess,
    TResult? Function(ResetPasswordError<T> value)? resetPasswordError,
  }) {
    return resetPasswordInitial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ResetPasswordInitial<T> value)? resetPasswordInitial,
    TResult Function(ResetPasswordLoading<T> value)? resetPasswordLoading,
    TResult Function(ResetPasswordSuccess<T> value)? resetPasswordSuccess,
    TResult Function(ResetPasswordError<T> value)? resetPasswordError,
    required TResult orElse(),
  }) {
    if (resetPasswordInitial != null) {
      return resetPasswordInitial(this);
    }
    return orElse();
  }
}

abstract class _ResetPasswordInitial<T> implements ResetPasswordState<T> {
  const factory _ResetPasswordInitial() = _$ResetPasswordInitialImpl<T>;
}

/// @nodoc
abstract class _$$ResetPasswordLoadingImplCopyWith<T, $Res> {
  factory _$$ResetPasswordLoadingImplCopyWith(
          _$ResetPasswordLoadingImpl<T> value,
          $Res Function(_$ResetPasswordLoadingImpl<T>) then) =
      __$$ResetPasswordLoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$ResetPasswordLoadingImplCopyWithImpl<T, $Res>
    extends _$ResetPasswordStateCopyWithImpl<T, $Res,
        _$ResetPasswordLoadingImpl<T>>
    implements _$$ResetPasswordLoadingImplCopyWith<T, $Res> {
  __$$ResetPasswordLoadingImplCopyWithImpl(_$ResetPasswordLoadingImpl<T> _value,
      $Res Function(_$ResetPasswordLoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ResetPasswordLoadingImpl<T> implements ResetPasswordLoading<T> {
  const _$ResetPasswordLoadingImpl();

  @override
  String toString() {
    return 'ResetPasswordState<$T>.resetPasswordLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordLoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() resetPasswordInitial,
    required TResult Function() resetPasswordLoading,
    required TResult Function(T data) resetPasswordSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) resetPasswordError,
  }) {
    return resetPasswordLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? resetPasswordInitial,
    TResult? Function()? resetPasswordLoading,
    TResult? Function(T data)? resetPasswordSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? resetPasswordError,
  }) {
    return resetPasswordLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? resetPasswordInitial,
    TResult Function()? resetPasswordLoading,
    TResult Function(T data)? resetPasswordSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? resetPasswordError,
    required TResult orElse(),
  }) {
    if (resetPasswordLoading != null) {
      return resetPasswordLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ResetPasswordInitial<T> value)
        resetPasswordInitial,
    required TResult Function(ResetPasswordLoading<T> value)
        resetPasswordLoading,
    required TResult Function(ResetPasswordSuccess<T> value)
        resetPasswordSuccess,
    required TResult Function(ResetPasswordError<T> value) resetPasswordError,
  }) {
    return resetPasswordLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ResetPasswordInitial<T> value)? resetPasswordInitial,
    TResult? Function(ResetPasswordLoading<T> value)? resetPasswordLoading,
    TResult? Function(ResetPasswordSuccess<T> value)? resetPasswordSuccess,
    TResult? Function(ResetPasswordError<T> value)? resetPasswordError,
  }) {
    return resetPasswordLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ResetPasswordInitial<T> value)? resetPasswordInitial,
    TResult Function(ResetPasswordLoading<T> value)? resetPasswordLoading,
    TResult Function(ResetPasswordSuccess<T> value)? resetPasswordSuccess,
    TResult Function(ResetPasswordError<T> value)? resetPasswordError,
    required TResult orElse(),
  }) {
    if (resetPasswordLoading != null) {
      return resetPasswordLoading(this);
    }
    return orElse();
  }
}

abstract class ResetPasswordLoading<T> implements ResetPasswordState<T> {
  const factory ResetPasswordLoading() = _$ResetPasswordLoadingImpl<T>;
}

/// @nodoc
abstract class _$$ResetPasswordSuccessImplCopyWith<T, $Res> {
  factory _$$ResetPasswordSuccessImplCopyWith(
          _$ResetPasswordSuccessImpl<T> value,
          $Res Function(_$ResetPasswordSuccessImpl<T>) then) =
      __$$ResetPasswordSuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$ResetPasswordSuccessImplCopyWithImpl<T, $Res>
    extends _$ResetPasswordStateCopyWithImpl<T, $Res,
        _$ResetPasswordSuccessImpl<T>>
    implements _$$ResetPasswordSuccessImplCopyWith<T, $Res> {
  __$$ResetPasswordSuccessImplCopyWithImpl(_$ResetPasswordSuccessImpl<T> _value,
      $Res Function(_$ResetPasswordSuccessImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$ResetPasswordSuccessImpl<T>(
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$ResetPasswordSuccessImpl<T> implements ResetPasswordSuccess<T> {
  const _$ResetPasswordSuccessImpl(this.data);

  @override
  final T data;

  @override
  String toString() {
    return 'ResetPasswordState<$T>.resetPasswordSuccess(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordSuccessImplCopyWith<T, _$ResetPasswordSuccessImpl<T>>
      get copyWith => __$$ResetPasswordSuccessImplCopyWithImpl<T,
          _$ResetPasswordSuccessImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() resetPasswordInitial,
    required TResult Function() resetPasswordLoading,
    required TResult Function(T data) resetPasswordSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) resetPasswordError,
  }) {
    return resetPasswordSuccess(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? resetPasswordInitial,
    TResult? Function()? resetPasswordLoading,
    TResult? Function(T data)? resetPasswordSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? resetPasswordError,
  }) {
    return resetPasswordSuccess?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? resetPasswordInitial,
    TResult Function()? resetPasswordLoading,
    TResult Function(T data)? resetPasswordSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? resetPasswordError,
    required TResult orElse(),
  }) {
    if (resetPasswordSuccess != null) {
      return resetPasswordSuccess(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ResetPasswordInitial<T> value)
        resetPasswordInitial,
    required TResult Function(ResetPasswordLoading<T> value)
        resetPasswordLoading,
    required TResult Function(ResetPasswordSuccess<T> value)
        resetPasswordSuccess,
    required TResult Function(ResetPasswordError<T> value) resetPasswordError,
  }) {
    return resetPasswordSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ResetPasswordInitial<T> value)? resetPasswordInitial,
    TResult? Function(ResetPasswordLoading<T> value)? resetPasswordLoading,
    TResult? Function(ResetPasswordSuccess<T> value)? resetPasswordSuccess,
    TResult? Function(ResetPasswordError<T> value)? resetPasswordError,
  }) {
    return resetPasswordSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ResetPasswordInitial<T> value)? resetPasswordInitial,
    TResult Function(ResetPasswordLoading<T> value)? resetPasswordLoading,
    TResult Function(ResetPasswordSuccess<T> value)? resetPasswordSuccess,
    TResult Function(ResetPasswordError<T> value)? resetPasswordError,
    required TResult orElse(),
  }) {
    if (resetPasswordSuccess != null) {
      return resetPasswordSuccess(this);
    }
    return orElse();
  }
}

abstract class ResetPasswordSuccess<T> implements ResetPasswordState<T> {
  const factory ResetPasswordSuccess(final T data) =
      _$ResetPasswordSuccessImpl<T>;

  T get data;

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResetPasswordSuccessImplCopyWith<T, _$ResetPasswordSuccessImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResetPasswordErrorImplCopyWith<T, $Res> {
  factory _$$ResetPasswordErrorImplCopyWith(_$ResetPasswordErrorImpl<T> value,
          $Res Function(_$ResetPasswordErrorImpl<T>) then) =
      __$$ResetPasswordErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({ApiErrorModel apiErrorModel});
}

/// @nodoc
class __$$ResetPasswordErrorImplCopyWithImpl<T, $Res>
    extends _$ResetPasswordStateCopyWithImpl<T, $Res,
        _$ResetPasswordErrorImpl<T>>
    implements _$$ResetPasswordErrorImplCopyWith<T, $Res> {
  __$$ResetPasswordErrorImplCopyWithImpl(_$ResetPasswordErrorImpl<T> _value,
      $Res Function(_$ResetPasswordErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiErrorModel = null,
  }) {
    return _then(_$ResetPasswordErrorImpl<T>(
      null == apiErrorModel
          ? _value.apiErrorModel
          : apiErrorModel // ignore: cast_nullable_to_non_nullable
              as ApiErrorModel,
    ));
  }
}

/// @nodoc

class _$ResetPasswordErrorImpl<T> implements ResetPasswordError<T> {
  const _$ResetPasswordErrorImpl(this.apiErrorModel);

  @override
  final ApiErrorModel apiErrorModel;

  @override
  String toString() {
    return 'ResetPasswordState<$T>.resetPasswordError(apiErrorModel: $apiErrorModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordErrorImpl<T> &&
            (identical(other.apiErrorModel, apiErrorModel) ||
                other.apiErrorModel == apiErrorModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, apiErrorModel);

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordErrorImplCopyWith<T, _$ResetPasswordErrorImpl<T>>
      get copyWith => __$$ResetPasswordErrorImplCopyWithImpl<T,
          _$ResetPasswordErrorImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() resetPasswordInitial,
    required TResult Function() resetPasswordLoading,
    required TResult Function(T data) resetPasswordSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) resetPasswordError,
  }) {
    return resetPasswordError(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? resetPasswordInitial,
    TResult? Function()? resetPasswordLoading,
    TResult? Function(T data)? resetPasswordSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? resetPasswordError,
  }) {
    return resetPasswordError?.call(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? resetPasswordInitial,
    TResult Function()? resetPasswordLoading,
    TResult Function(T data)? resetPasswordSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? resetPasswordError,
    required TResult orElse(),
  }) {
    if (resetPasswordError != null) {
      return resetPasswordError(apiErrorModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ResetPasswordInitial<T> value)
        resetPasswordInitial,
    required TResult Function(ResetPasswordLoading<T> value)
        resetPasswordLoading,
    required TResult Function(ResetPasswordSuccess<T> value)
        resetPasswordSuccess,
    required TResult Function(ResetPasswordError<T> value) resetPasswordError,
  }) {
    return resetPasswordError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ResetPasswordInitial<T> value)? resetPasswordInitial,
    TResult? Function(ResetPasswordLoading<T> value)? resetPasswordLoading,
    TResult? Function(ResetPasswordSuccess<T> value)? resetPasswordSuccess,
    TResult? Function(ResetPasswordError<T> value)? resetPasswordError,
  }) {
    return resetPasswordError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ResetPasswordInitial<T> value)? resetPasswordInitial,
    TResult Function(ResetPasswordLoading<T> value)? resetPasswordLoading,
    TResult Function(ResetPasswordSuccess<T> value)? resetPasswordSuccess,
    TResult Function(ResetPasswordError<T> value)? resetPasswordError,
    required TResult orElse(),
  }) {
    if (resetPasswordError != null) {
      return resetPasswordError(this);
    }
    return orElse();
  }
}

abstract class ResetPasswordError<T> implements ResetPasswordState<T> {
  const factory ResetPasswordError(final ApiErrorModel apiErrorModel) =
      _$ResetPasswordErrorImpl<T>;

  ApiErrorModel get apiErrorModel;

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResetPasswordErrorImplCopyWith<T, _$ResetPasswordErrorImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DeleteAccountState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() deleteAccountInitial,
    required TResult Function() deleteAccountLoading,
    required TResult Function(dynamic response) deleteAccountSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) deleteAccountError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? deleteAccountInitial,
    TResult? Function()? deleteAccountLoading,
    TResult? Function(dynamic response)? deleteAccountSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? deleteAccountError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? deleteAccountInitial,
    TResult Function()? deleteAccountLoading,
    TResult Function(dynamic response)? deleteAccountSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? deleteAccountError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DeleteAccountInitial value) deleteAccountInitial,
    required TResult Function(DeleteAccountLoading value) deleteAccountLoading,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DeleteAccountInitial value)? deleteAccountInitial,
    TResult? Function(DeleteAccountLoading value)? deleteAccountLoading,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DeleteAccountInitial value)? deleteAccountInitial,
    TResult Function(DeleteAccountLoading value)? deleteAccountLoading,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteAccountStateCopyWith<$Res> {
  factory $DeleteAccountStateCopyWith(
          DeleteAccountState value, $Res Function(DeleteAccountState) then) =
      _$DeleteAccountStateCopyWithImpl<$Res, DeleteAccountState>;
}

/// @nodoc
class _$DeleteAccountStateCopyWithImpl<$Res, $Val extends DeleteAccountState>
    implements $DeleteAccountStateCopyWith<$Res> {
  _$DeleteAccountStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DeleteAccountInitialImplCopyWith<$Res> {
  factory _$$DeleteAccountInitialImplCopyWith(_$DeleteAccountInitialImpl value,
          $Res Function(_$DeleteAccountInitialImpl) then) =
      __$$DeleteAccountInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeleteAccountInitialImplCopyWithImpl<$Res>
    extends _$DeleteAccountStateCopyWithImpl<$Res, _$DeleteAccountInitialImpl>
    implements _$$DeleteAccountInitialImplCopyWith<$Res> {
  __$$DeleteAccountInitialImplCopyWithImpl(_$DeleteAccountInitialImpl _value,
      $Res Function(_$DeleteAccountInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DeleteAccountInitialImpl implements _DeleteAccountInitial {
  const _$DeleteAccountInitialImpl();

  @override
  String toString() {
    return 'DeleteAccountState.deleteAccountInitial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteAccountInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() deleteAccountInitial,
    required TResult Function() deleteAccountLoading,
    required TResult Function(dynamic response) deleteAccountSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) deleteAccountError,
  }) {
    return deleteAccountInitial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? deleteAccountInitial,
    TResult? Function()? deleteAccountLoading,
    TResult? Function(dynamic response)? deleteAccountSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? deleteAccountError,
  }) {
    return deleteAccountInitial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? deleteAccountInitial,
    TResult Function()? deleteAccountLoading,
    TResult Function(dynamic response)? deleteAccountSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deleteAccountInitial != null) {
      return deleteAccountInitial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DeleteAccountInitial value) deleteAccountInitial,
    required TResult Function(DeleteAccountLoading value) deleteAccountLoading,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return deleteAccountInitial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DeleteAccountInitial value)? deleteAccountInitial,
    TResult? Function(DeleteAccountLoading value)? deleteAccountLoading,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return deleteAccountInitial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DeleteAccountInitial value)? deleteAccountInitial,
    TResult Function(DeleteAccountLoading value)? deleteAccountLoading,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deleteAccountInitial != null) {
      return deleteAccountInitial(this);
    }
    return orElse();
  }
}

abstract class _DeleteAccountInitial implements DeleteAccountState {
  const factory _DeleteAccountInitial() = _$DeleteAccountInitialImpl;
}

/// @nodoc
abstract class _$$DeleteAccountLoadingImplCopyWith<$Res> {
  factory _$$DeleteAccountLoadingImplCopyWith(_$DeleteAccountLoadingImpl value,
          $Res Function(_$DeleteAccountLoadingImpl) then) =
      __$$DeleteAccountLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeleteAccountLoadingImplCopyWithImpl<$Res>
    extends _$DeleteAccountStateCopyWithImpl<$Res, _$DeleteAccountLoadingImpl>
    implements _$$DeleteAccountLoadingImplCopyWith<$Res> {
  __$$DeleteAccountLoadingImplCopyWithImpl(_$DeleteAccountLoadingImpl _value,
      $Res Function(_$DeleteAccountLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DeleteAccountLoadingImpl implements DeleteAccountLoading {
  const _$DeleteAccountLoadingImpl();

  @override
  String toString() {
    return 'DeleteAccountState.deleteAccountLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteAccountLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() deleteAccountInitial,
    required TResult Function() deleteAccountLoading,
    required TResult Function(dynamic response) deleteAccountSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) deleteAccountError,
  }) {
    return deleteAccountLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? deleteAccountInitial,
    TResult? Function()? deleteAccountLoading,
    TResult? Function(dynamic response)? deleteAccountSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? deleteAccountError,
  }) {
    return deleteAccountLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? deleteAccountInitial,
    TResult Function()? deleteAccountLoading,
    TResult Function(dynamic response)? deleteAccountSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deleteAccountLoading != null) {
      return deleteAccountLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DeleteAccountInitial value) deleteAccountInitial,
    required TResult Function(DeleteAccountLoading value) deleteAccountLoading,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return deleteAccountLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DeleteAccountInitial value)? deleteAccountInitial,
    TResult? Function(DeleteAccountLoading value)? deleteAccountLoading,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return deleteAccountLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DeleteAccountInitial value)? deleteAccountInitial,
    TResult Function(DeleteAccountLoading value)? deleteAccountLoading,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deleteAccountLoading != null) {
      return deleteAccountLoading(this);
    }
    return orElse();
  }
}

abstract class DeleteAccountLoading implements DeleteAccountState {
  const factory DeleteAccountLoading() = _$DeleteAccountLoadingImpl;
}

/// @nodoc
abstract class _$$DeleteAccountSuccessImplCopyWith<$Res> {
  factory _$$DeleteAccountSuccessImplCopyWith(_$DeleteAccountSuccessImpl value,
          $Res Function(_$DeleteAccountSuccessImpl) then) =
      __$$DeleteAccountSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({dynamic response});
}

/// @nodoc
class __$$DeleteAccountSuccessImplCopyWithImpl<$Res>
    extends _$DeleteAccountStateCopyWithImpl<$Res, _$DeleteAccountSuccessImpl>
    implements _$$DeleteAccountSuccessImplCopyWith<$Res> {
  __$$DeleteAccountSuccessImplCopyWithImpl(_$DeleteAccountSuccessImpl _value,
      $Res Function(_$DeleteAccountSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? response = freezed,
  }) {
    return _then(_$DeleteAccountSuccessImpl(
      freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$DeleteAccountSuccessImpl implements DeleteAccountSuccess {
  const _$DeleteAccountSuccessImpl(this.response);

  @override
  final dynamic response;

  @override
  String toString() {
    return 'DeleteAccountState.deleteAccountSuccess(response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteAccountSuccessImpl &&
            const DeepCollectionEquality().equals(other.response, response));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(response));

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteAccountSuccessImplCopyWith<_$DeleteAccountSuccessImpl>
      get copyWith =>
          __$$DeleteAccountSuccessImplCopyWithImpl<_$DeleteAccountSuccessImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() deleteAccountInitial,
    required TResult Function() deleteAccountLoading,
    required TResult Function(dynamic response) deleteAccountSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) deleteAccountError,
  }) {
    return deleteAccountSuccess(response);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? deleteAccountInitial,
    TResult? Function()? deleteAccountLoading,
    TResult? Function(dynamic response)? deleteAccountSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? deleteAccountError,
  }) {
    return deleteAccountSuccess?.call(response);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? deleteAccountInitial,
    TResult Function()? deleteAccountLoading,
    TResult Function(dynamic response)? deleteAccountSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deleteAccountSuccess != null) {
      return deleteAccountSuccess(response);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DeleteAccountInitial value) deleteAccountInitial,
    required TResult Function(DeleteAccountLoading value) deleteAccountLoading,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return deleteAccountSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DeleteAccountInitial value)? deleteAccountInitial,
    TResult? Function(DeleteAccountLoading value)? deleteAccountLoading,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return deleteAccountSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DeleteAccountInitial value)? deleteAccountInitial,
    TResult Function(DeleteAccountLoading value)? deleteAccountLoading,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deleteAccountSuccess != null) {
      return deleteAccountSuccess(this);
    }
    return orElse();
  }
}

abstract class DeleteAccountSuccess implements DeleteAccountState {
  const factory DeleteAccountSuccess(final dynamic response) =
      _$DeleteAccountSuccessImpl;

  dynamic get response;

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteAccountSuccessImplCopyWith<_$DeleteAccountSuccessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteAccountErrorImplCopyWith<$Res> {
  factory _$$DeleteAccountErrorImplCopyWith(_$DeleteAccountErrorImpl value,
          $Res Function(_$DeleteAccountErrorImpl) then) =
      __$$DeleteAccountErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ApiErrorModel apiErrorModel});
}

/// @nodoc
class __$$DeleteAccountErrorImplCopyWithImpl<$Res>
    extends _$DeleteAccountStateCopyWithImpl<$Res, _$DeleteAccountErrorImpl>
    implements _$$DeleteAccountErrorImplCopyWith<$Res> {
  __$$DeleteAccountErrorImplCopyWithImpl(_$DeleteAccountErrorImpl _value,
      $Res Function(_$DeleteAccountErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiErrorModel = null,
  }) {
    return _then(_$DeleteAccountErrorImpl(
      null == apiErrorModel
          ? _value.apiErrorModel
          : apiErrorModel // ignore: cast_nullable_to_non_nullable
              as ApiErrorModel,
    ));
  }
}

/// @nodoc

class _$DeleteAccountErrorImpl implements DeleteAccountError {
  const _$DeleteAccountErrorImpl(this.apiErrorModel);

  @override
  final ApiErrorModel apiErrorModel;

  @override
  String toString() {
    return 'DeleteAccountState.deleteAccountError(apiErrorModel: $apiErrorModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteAccountErrorImpl &&
            (identical(other.apiErrorModel, apiErrorModel) ||
                other.apiErrorModel == apiErrorModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, apiErrorModel);

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteAccountErrorImplCopyWith<_$DeleteAccountErrorImpl> get copyWith =>
      __$$DeleteAccountErrorImplCopyWithImpl<_$DeleteAccountErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() deleteAccountInitial,
    required TResult Function() deleteAccountLoading,
    required TResult Function(dynamic response) deleteAccountSuccess,
    required TResult Function(ApiErrorModel apiErrorModel) deleteAccountError,
  }) {
    return deleteAccountError(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? deleteAccountInitial,
    TResult? Function()? deleteAccountLoading,
    TResult? Function(dynamic response)? deleteAccountSuccess,
    TResult? Function(ApiErrorModel apiErrorModel)? deleteAccountError,
  }) {
    return deleteAccountError?.call(apiErrorModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? deleteAccountInitial,
    TResult Function()? deleteAccountLoading,
    TResult Function(dynamic response)? deleteAccountSuccess,
    TResult Function(ApiErrorModel apiErrorModel)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deleteAccountError != null) {
      return deleteAccountError(apiErrorModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DeleteAccountInitial value) deleteAccountInitial,
    required TResult Function(DeleteAccountLoading value) deleteAccountLoading,
    required TResult Function(DeleteAccountSuccess value) deleteAccountSuccess,
    required TResult Function(DeleteAccountError value) deleteAccountError,
  }) {
    return deleteAccountError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DeleteAccountInitial value)? deleteAccountInitial,
    TResult? Function(DeleteAccountLoading value)? deleteAccountLoading,
    TResult? Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult? Function(DeleteAccountError value)? deleteAccountError,
  }) {
    return deleteAccountError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DeleteAccountInitial value)? deleteAccountInitial,
    TResult Function(DeleteAccountLoading value)? deleteAccountLoading,
    TResult Function(DeleteAccountSuccess value)? deleteAccountSuccess,
    TResult Function(DeleteAccountError value)? deleteAccountError,
    required TResult orElse(),
  }) {
    if (deleteAccountError != null) {
      return deleteAccountError(this);
    }
    return orElse();
  }
}

abstract class DeleteAccountError implements DeleteAccountState {
  const factory DeleteAccountError(final ApiErrorModel apiErrorModel) =
      _$DeleteAccountErrorImpl;

  ApiErrorModel get apiErrorModel;

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteAccountErrorImplCopyWith<_$DeleteAccountErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
