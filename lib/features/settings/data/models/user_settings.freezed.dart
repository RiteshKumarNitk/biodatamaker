// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) {
  return _UserSettings.fromJson(json);
}

/// @nodoc
mixin _$UserSettings {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get themeMode => throw _privateConstructorUsedError;
  @HiveField(2)
  String get language => throw _privateConstructorUsedError;
  @HiveField(3)
  String get pdfQuality => throw _privateConstructorUsedError;
  @HiveField(4)
  String get pdfPageSize => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get autoSave => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get cloudBackupEnabled => throw _privateConstructorUsedError;
  @HiveField(7)
  String get lastBackupId => throw _privateConstructorUsedError;
  @HiveField(8)
  int get totalBiodatasCreated => throw _privateConstructorUsedError;
  @HiveField(9)
  String get subscriptionTier => throw _privateConstructorUsedError;
  @HiveField(10)
  DateTime? get subscriptionExpiresAt => throw _privateConstructorUsedError;
  @HiveField(11)
  bool get isWatermarkRemoved => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) then) =
      _$UserSettingsCopyWithImpl<$Res, UserSettings>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String themeMode,
      @HiveField(2) String language,
      @HiveField(3) String pdfQuality,
      @HiveField(4) String pdfPageSize,
      @HiveField(5) bool autoSave,
      @HiveField(6) bool cloudBackupEnabled,
      @HiveField(7) String lastBackupId,
      @HiveField(8) int totalBiodatasCreated,
      @HiveField(9) String subscriptionTier,
      @HiveField(10) DateTime? subscriptionExpiresAt,
      @HiveField(11) bool isWatermarkRemoved});
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res, $Val extends UserSettings>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? themeMode = null,
    Object? language = null,
    Object? pdfQuality = null,
    Object? pdfPageSize = null,
    Object? autoSave = null,
    Object? cloudBackupEnabled = null,
    Object? lastBackupId = null,
    Object? totalBiodatasCreated = null,
    Object? subscriptionTier = null,
    Object? subscriptionExpiresAt = freezed,
    Object? isWatermarkRemoved = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      pdfQuality: null == pdfQuality
          ? _value.pdfQuality
          : pdfQuality // ignore: cast_nullable_to_non_nullable
              as String,
      pdfPageSize: null == pdfPageSize
          ? _value.pdfPageSize
          : pdfPageSize // ignore: cast_nullable_to_non_nullable
              as String,
      autoSave: null == autoSave
          ? _value.autoSave
          : autoSave // ignore: cast_nullable_to_non_nullable
              as bool,
      cloudBackupEnabled: null == cloudBackupEnabled
          ? _value.cloudBackupEnabled
          : cloudBackupEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastBackupId: null == lastBackupId
          ? _value.lastBackupId
          : lastBackupId // ignore: cast_nullable_to_non_nullable
              as String,
      totalBiodatasCreated: null == totalBiodatasCreated
          ? _value.totalBiodatasCreated
          : totalBiodatasCreated // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptionTier: null == subscriptionTier
          ? _value.subscriptionTier
          : subscriptionTier // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionExpiresAt: freezed == subscriptionExpiresAt
          ? _value.subscriptionExpiresAt
          : subscriptionExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isWatermarkRemoved: null == isWatermarkRemoved
          ? _value.isWatermarkRemoved
          : isWatermarkRemoved // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSettingsImplCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$UserSettingsImplCopyWith(
          _$UserSettingsImpl value, $Res Function(_$UserSettingsImpl) then) =
      __$$UserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String themeMode,
      @HiveField(2) String language,
      @HiveField(3) String pdfQuality,
      @HiveField(4) String pdfPageSize,
      @HiveField(5) bool autoSave,
      @HiveField(6) bool cloudBackupEnabled,
      @HiveField(7) String lastBackupId,
      @HiveField(8) int totalBiodatasCreated,
      @HiveField(9) String subscriptionTier,
      @HiveField(10) DateTime? subscriptionExpiresAt,
      @HiveField(11) bool isWatermarkRemoved});
}

/// @nodoc
class __$$UserSettingsImplCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res, _$UserSettingsImpl>
    implements _$$UserSettingsImplCopyWith<$Res> {
  __$$UserSettingsImplCopyWithImpl(
      _$UserSettingsImpl _value, $Res Function(_$UserSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? themeMode = null,
    Object? language = null,
    Object? pdfQuality = null,
    Object? pdfPageSize = null,
    Object? autoSave = null,
    Object? cloudBackupEnabled = null,
    Object? lastBackupId = null,
    Object? totalBiodatasCreated = null,
    Object? subscriptionTier = null,
    Object? subscriptionExpiresAt = freezed,
    Object? isWatermarkRemoved = null,
  }) {
    return _then(_$UserSettingsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      pdfQuality: null == pdfQuality
          ? _value.pdfQuality
          : pdfQuality // ignore: cast_nullable_to_non_nullable
              as String,
      pdfPageSize: null == pdfPageSize
          ? _value.pdfPageSize
          : pdfPageSize // ignore: cast_nullable_to_non_nullable
              as String,
      autoSave: null == autoSave
          ? _value.autoSave
          : autoSave // ignore: cast_nullable_to_non_nullable
              as bool,
      cloudBackupEnabled: null == cloudBackupEnabled
          ? _value.cloudBackupEnabled
          : cloudBackupEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastBackupId: null == lastBackupId
          ? _value.lastBackupId
          : lastBackupId // ignore: cast_nullable_to_non_nullable
              as String,
      totalBiodatasCreated: null == totalBiodatasCreated
          ? _value.totalBiodatasCreated
          : totalBiodatasCreated // ignore: cast_nullable_to_non_nullable
              as int,
      subscriptionTier: null == subscriptionTier
          ? _value.subscriptionTier
          : subscriptionTier // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionExpiresAt: freezed == subscriptionExpiresAt
          ? _value.subscriptionExpiresAt
          : subscriptionExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isWatermarkRemoved: null == isWatermarkRemoved
          ? _value.isWatermarkRemoved
          : isWatermarkRemoved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSettingsImpl implements _UserSettings {
  const _$UserSettingsImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) this.themeMode = 'system',
      @HiveField(2) this.language = 'en',
      @HiveField(3) this.pdfQuality = 'high',
      @HiveField(4) this.pdfPageSize = 'A4',
      @HiveField(5) this.autoSave = true,
      @HiveField(6) this.cloudBackupEnabled = false,
      @HiveField(7) this.lastBackupId = '',
      @HiveField(8) this.totalBiodatasCreated = 0,
      @HiveField(9) this.subscriptionTier = 'free',
      @HiveField(10) this.subscriptionExpiresAt,
      @HiveField(11) this.isWatermarkRemoved = false});

  factory _$UserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @JsonKey()
  @HiveField(1)
  final String themeMode;
  @override
  @JsonKey()
  @HiveField(2)
  final String language;
  @override
  @JsonKey()
  @HiveField(3)
  final String pdfQuality;
  @override
  @JsonKey()
  @HiveField(4)
  final String pdfPageSize;
  @override
  @JsonKey()
  @HiveField(5)
  final bool autoSave;
  @override
  @JsonKey()
  @HiveField(6)
  final bool cloudBackupEnabled;
  @override
  @JsonKey()
  @HiveField(7)
  final String lastBackupId;
  @override
  @JsonKey()
  @HiveField(8)
  final int totalBiodatasCreated;
  @override
  @JsonKey()
  @HiveField(9)
  final String subscriptionTier;
  @override
  @HiveField(10)
  final DateTime? subscriptionExpiresAt;
  @override
  @JsonKey()
  @HiveField(11)
  final bool isWatermarkRemoved;

  @override
  String toString() {
    return 'UserSettings(id: $id, themeMode: $themeMode, language: $language, pdfQuality: $pdfQuality, pdfPageSize: $pdfPageSize, autoSave: $autoSave, cloudBackupEnabled: $cloudBackupEnabled, lastBackupId: $lastBackupId, totalBiodatasCreated: $totalBiodatasCreated, subscriptionTier: $subscriptionTier, subscriptionExpiresAt: $subscriptionExpiresAt, isWatermarkRemoved: $isWatermarkRemoved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.pdfQuality, pdfQuality) ||
                other.pdfQuality == pdfQuality) &&
            (identical(other.pdfPageSize, pdfPageSize) ||
                other.pdfPageSize == pdfPageSize) &&
            (identical(other.autoSave, autoSave) ||
                other.autoSave == autoSave) &&
            (identical(other.cloudBackupEnabled, cloudBackupEnabled) ||
                other.cloudBackupEnabled == cloudBackupEnabled) &&
            (identical(other.lastBackupId, lastBackupId) ||
                other.lastBackupId == lastBackupId) &&
            (identical(other.totalBiodatasCreated, totalBiodatasCreated) ||
                other.totalBiodatasCreated == totalBiodatasCreated) &&
            (identical(other.subscriptionTier, subscriptionTier) ||
                other.subscriptionTier == subscriptionTier) &&
            (identical(other.subscriptionExpiresAt, subscriptionExpiresAt) ||
                other.subscriptionExpiresAt == subscriptionExpiresAt) &&
            (identical(other.isWatermarkRemoved, isWatermarkRemoved) ||
                other.isWatermarkRemoved == isWatermarkRemoved));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      themeMode,
      language,
      pdfQuality,
      pdfPageSize,
      autoSave,
      cloudBackupEnabled,
      lastBackupId,
      totalBiodatasCreated,
      subscriptionTier,
      subscriptionExpiresAt,
      isWatermarkRemoved);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      __$$UserSettingsImplCopyWithImpl<_$UserSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsImplToJson(
      this,
    );
  }
}

abstract class _UserSettings implements UserSettings {
  const factory _UserSettings(
      {@HiveField(0) required final String id,
      @HiveField(1) final String themeMode,
      @HiveField(2) final String language,
      @HiveField(3) final String pdfQuality,
      @HiveField(4) final String pdfPageSize,
      @HiveField(5) final bool autoSave,
      @HiveField(6) final bool cloudBackupEnabled,
      @HiveField(7) final String lastBackupId,
      @HiveField(8) final int totalBiodatasCreated,
      @HiveField(9) final String subscriptionTier,
      @HiveField(10) final DateTime? subscriptionExpiresAt,
      @HiveField(11) final bool isWatermarkRemoved}) = _$UserSettingsImpl;

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$UserSettingsImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get themeMode;
  @override
  @HiveField(2)
  String get language;
  @override
  @HiveField(3)
  String get pdfQuality;
  @override
  @HiveField(4)
  String get pdfPageSize;
  @override
  @HiveField(5)
  bool get autoSave;
  @override
  @HiveField(6)
  bool get cloudBackupEnabled;
  @override
  @HiveField(7)
  String get lastBackupId;
  @override
  @HiveField(8)
  int get totalBiodatasCreated;
  @override
  @HiveField(9)
  String get subscriptionTier;
  @override
  @HiveField(10)
  DateTime? get subscriptionExpiresAt;
  @override
  @HiveField(11)
  bool get isWatermarkRemoved;
  @override
  @JsonKey(ignore: true)
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
