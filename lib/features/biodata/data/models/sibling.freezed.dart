// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sibling.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Sibling _$SiblingFromJson(Map<String, dynamic> json) {
  return _Sibling.fromJson(json);
}

/// @nodoc
mixin _$Sibling {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get relationship => throw _privateConstructorUsedError;
  @HiveField(2)
  String get name => throw _privateConstructorUsedError;
  @HiveField(3)
  String get occupation => throw _privateConstructorUsedError;
  @HiveField(4)
  String get maritalStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SiblingCopyWith<Sibling> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SiblingCopyWith<$Res> {
  factory $SiblingCopyWith(Sibling value, $Res Function(Sibling) then) =
      _$SiblingCopyWithImpl<$Res, Sibling>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String relationship,
      @HiveField(2) String name,
      @HiveField(3) String occupation,
      @HiveField(4) String maritalStatus});
}

/// @nodoc
class _$SiblingCopyWithImpl<$Res, $Val extends Sibling>
    implements $SiblingCopyWith<$Res> {
  _$SiblingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationship = null,
    Object? name = null,
    Object? occupation = null,
    Object? maritalStatus = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      relationship: null == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      occupation: null == occupation
          ? _value.occupation
          : occupation // ignore: cast_nullable_to_non_nullable
              as String,
      maritalStatus: null == maritalStatus
          ? _value.maritalStatus
          : maritalStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SiblingImplCopyWith<$Res> implements $SiblingCopyWith<$Res> {
  factory _$$SiblingImplCopyWith(
          _$SiblingImpl value, $Res Function(_$SiblingImpl) then) =
      __$$SiblingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String relationship,
      @HiveField(2) String name,
      @HiveField(3) String occupation,
      @HiveField(4) String maritalStatus});
}

/// @nodoc
class __$$SiblingImplCopyWithImpl<$Res>
    extends _$SiblingCopyWithImpl<$Res, _$SiblingImpl>
    implements _$$SiblingImplCopyWith<$Res> {
  __$$SiblingImplCopyWithImpl(
      _$SiblingImpl _value, $Res Function(_$SiblingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? relationship = null,
    Object? name = null,
    Object? occupation = null,
    Object? maritalStatus = null,
  }) {
    return _then(_$SiblingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      relationship: null == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      occupation: null == occupation
          ? _value.occupation
          : occupation // ignore: cast_nullable_to_non_nullable
              as String,
      maritalStatus: null == maritalStatus
          ? _value.maritalStatus
          : maritalStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SiblingImpl implements _Sibling {
  const _$SiblingImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) this.relationship = 'Brother',
      @HiveField(2) this.name = '',
      @HiveField(3) this.occupation = '',
      @HiveField(4) this.maritalStatus = ''});

  factory _$SiblingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SiblingImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @JsonKey()
  @HiveField(1)
  final String relationship;
  @override
  @JsonKey()
  @HiveField(2)
  final String name;
  @override
  @JsonKey()
  @HiveField(3)
  final String occupation;
  @override
  @JsonKey()
  @HiveField(4)
  final String maritalStatus;

  @override
  String toString() {
    return 'Sibling(id: $id, relationship: $relationship, name: $name, occupation: $occupation, maritalStatus: $maritalStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SiblingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.occupation, occupation) ||
                other.occupation == occupation) &&
            (identical(other.maritalStatus, maritalStatus) ||
                other.maritalStatus == maritalStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, relationship, name, occupation, maritalStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SiblingImplCopyWith<_$SiblingImpl> get copyWith =>
      __$$SiblingImplCopyWithImpl<_$SiblingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SiblingImplToJson(
      this,
    );
  }
}

abstract class _Sibling implements Sibling {
  const factory _Sibling(
      {@HiveField(0) required final String id,
      @HiveField(1) final String relationship,
      @HiveField(2) final String name,
      @HiveField(3) final String occupation,
      @HiveField(4) final String maritalStatus}) = _$SiblingImpl;

  factory _Sibling.fromJson(Map<String, dynamic> json) = _$SiblingImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get relationship;
  @override
  @HiveField(2)
  String get name;
  @override
  @HiveField(3)
  String get occupation;
  @override
  @HiveField(4)
  String get maritalStatus;
  @override
  @JsonKey(ignore: true)
  _$$SiblingImplCopyWith<_$SiblingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
