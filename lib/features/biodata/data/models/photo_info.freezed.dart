// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PhotoInfo _$PhotoInfoFromJson(Map<String, dynamic> json) {
  return _PhotoInfo.fromJson(json);
}

/// @nodoc
mixin _$PhotoInfo {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get path => throw _privateConstructorUsedError;
  @HiveField(2)
  int get order => throw _privateConstructorUsedError;
  @HiveField(3)
  bool get isProfilePhoto => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PhotoInfoCopyWith<PhotoInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoInfoCopyWith<$Res> {
  factory $PhotoInfoCopyWith(PhotoInfo value, $Res Function(PhotoInfo) then) =
      _$PhotoInfoCopyWithImpl<$Res, PhotoInfo>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String path,
      @HiveField(2) int order,
      @HiveField(3) bool isProfilePhoto});
}

/// @nodoc
class _$PhotoInfoCopyWithImpl<$Res, $Val extends PhotoInfo>
    implements $PhotoInfoCopyWith<$Res> {
  _$PhotoInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? order = null,
    Object? isProfilePhoto = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      isProfilePhoto: null == isProfilePhoto
          ? _value.isProfilePhoto
          : isProfilePhoto // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PhotoInfoImplCopyWith<$Res>
    implements $PhotoInfoCopyWith<$Res> {
  factory _$$PhotoInfoImplCopyWith(
          _$PhotoInfoImpl value, $Res Function(_$PhotoInfoImpl) then) =
      __$$PhotoInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String path,
      @HiveField(2) int order,
      @HiveField(3) bool isProfilePhoto});
}

/// @nodoc
class __$$PhotoInfoImplCopyWithImpl<$Res>
    extends _$PhotoInfoCopyWithImpl<$Res, _$PhotoInfoImpl>
    implements _$$PhotoInfoImplCopyWith<$Res> {
  __$$PhotoInfoImplCopyWithImpl(
      _$PhotoInfoImpl _value, $Res Function(_$PhotoInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? path = null,
    Object? order = null,
    Object? isProfilePhoto = null,
  }) {
    return _then(_$PhotoInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      isProfilePhoto: null == isProfilePhoto
          ? _value.isProfilePhoto
          : isProfilePhoto // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhotoInfoImpl implements _PhotoInfo {
  const _$PhotoInfoImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.path,
      @HiveField(2) this.order = 0,
      @HiveField(3) this.isProfilePhoto = false});

  factory _$PhotoInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoInfoImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String path;
  @override
  @JsonKey()
  @HiveField(2)
  final int order;
  @override
  @JsonKey()
  @HiveField(3)
  final bool isProfilePhoto;

  @override
  String toString() {
    return 'PhotoInfo(id: $id, path: $path, order: $order, isProfilePhoto: $isProfilePhoto)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.isProfilePhoto, isProfilePhoto) ||
                other.isProfilePhoto == isProfilePhoto));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, path, order, isProfilePhoto);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoInfoImplCopyWith<_$PhotoInfoImpl> get copyWith =>
      __$$PhotoInfoImplCopyWithImpl<_$PhotoInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoInfoImplToJson(
      this,
    );
  }
}

abstract class _PhotoInfo implements PhotoInfo {
  const factory _PhotoInfo(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String path,
      @HiveField(2) final int order,
      @HiveField(3) final bool isProfilePhoto}) = _$PhotoInfoImpl;

  factory _PhotoInfo.fromJson(Map<String, dynamic> json) =
      _$PhotoInfoImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get path;
  @override
  @HiveField(2)
  int get order;
  @override
  @HiveField(3)
  bool get isProfilePhoto;
  @override
  @JsonKey(ignore: true)
  _$$PhotoInfoImplCopyWith<_$PhotoInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
