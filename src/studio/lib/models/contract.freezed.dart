// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contract.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContractVersion {

 String get id; String get contractId; String get schemaJson; String get changeLog; String get status; List<String> get confirmedBy;
/// Create a copy of ContractVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContractVersionCopyWith<ContractVersion> get copyWith => _$ContractVersionCopyWithImpl<ContractVersion>(this as ContractVersion, _$identity);

  /// Serializes this ContractVersion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContractVersion&&(identical(other.id, id) || other.id == id)&&(identical(other.contractId, contractId) || other.contractId == contractId)&&(identical(other.schemaJson, schemaJson) || other.schemaJson == schemaJson)&&(identical(other.changeLog, changeLog) || other.changeLog == changeLog)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.confirmedBy, confirmedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,contractId,schemaJson,changeLog,status,const DeepCollectionEquality().hash(confirmedBy));

@override
String toString() {
  return 'ContractVersion(id: $id, contractId: $contractId, schemaJson: $schemaJson, changeLog: $changeLog, status: $status, confirmedBy: $confirmedBy)';
}


}

/// @nodoc
abstract mixin class $ContractVersionCopyWith<$Res>  {
  factory $ContractVersionCopyWith(ContractVersion value, $Res Function(ContractVersion) _then) = _$ContractVersionCopyWithImpl;
@useResult
$Res call({
 String id, String contractId, String schemaJson, String changeLog, String status, List<String> confirmedBy
});




}
/// @nodoc
class _$ContractVersionCopyWithImpl<$Res>
    implements $ContractVersionCopyWith<$Res> {
  _$ContractVersionCopyWithImpl(this._self, this._then);

  final ContractVersion _self;
  final $Res Function(ContractVersion) _then;

/// Create a copy of ContractVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? contractId = null,Object? schemaJson = null,Object? changeLog = null,Object? status = null,Object? confirmedBy = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contractId: null == contractId ? _self.contractId : contractId // ignore: cast_nullable_to_non_nullable
as String,schemaJson: null == schemaJson ? _self.schemaJson : schemaJson // ignore: cast_nullable_to_non_nullable
as String,changeLog: null == changeLog ? _self.changeLog : changeLog // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,confirmedBy: null == confirmedBy ? _self.confirmedBy : confirmedBy // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ContractVersion].
extension ContractVersionPatterns on ContractVersion {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContractVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContractVersion() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContractVersion value)  $default,){
final _that = this;
switch (_that) {
case _ContractVersion():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContractVersion value)?  $default,){
final _that = this;
switch (_that) {
case _ContractVersion() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String contractId,  String schemaJson,  String changeLog,  String status,  List<String> confirmedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContractVersion() when $default != null:
return $default(_that.id,_that.contractId,_that.schemaJson,_that.changeLog,_that.status,_that.confirmedBy);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String contractId,  String schemaJson,  String changeLog,  String status,  List<String> confirmedBy)  $default,) {final _that = this;
switch (_that) {
case _ContractVersion():
return $default(_that.id,_that.contractId,_that.schemaJson,_that.changeLog,_that.status,_that.confirmedBy);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String contractId,  String schemaJson,  String changeLog,  String status,  List<String> confirmedBy)?  $default,) {final _that = this;
switch (_that) {
case _ContractVersion() when $default != null:
return $default(_that.id,_that.contractId,_that.schemaJson,_that.changeLog,_that.status,_that.confirmedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContractVersion implements ContractVersion {
  const _ContractVersion({required this.id, required this.contractId, required this.schemaJson, required this.changeLog, required this.status, final  List<String> confirmedBy = const []}): _confirmedBy = confirmedBy;
  factory _ContractVersion.fromJson(Map<String, dynamic> json) => _$ContractVersionFromJson(json);

@override final  String id;
@override final  String contractId;
@override final  String schemaJson;
@override final  String changeLog;
@override final  String status;
 final  List<String> _confirmedBy;
@override@JsonKey() List<String> get confirmedBy {
  if (_confirmedBy is EqualUnmodifiableListView) return _confirmedBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_confirmedBy);
}


/// Create a copy of ContractVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContractVersionCopyWith<_ContractVersion> get copyWith => __$ContractVersionCopyWithImpl<_ContractVersion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContractVersionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContractVersion&&(identical(other.id, id) || other.id == id)&&(identical(other.contractId, contractId) || other.contractId == contractId)&&(identical(other.schemaJson, schemaJson) || other.schemaJson == schemaJson)&&(identical(other.changeLog, changeLog) || other.changeLog == changeLog)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._confirmedBy, _confirmedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,contractId,schemaJson,changeLog,status,const DeepCollectionEquality().hash(_confirmedBy));

@override
String toString() {
  return 'ContractVersion(id: $id, contractId: $contractId, schemaJson: $schemaJson, changeLog: $changeLog, status: $status, confirmedBy: $confirmedBy)';
}


}

/// @nodoc
abstract mixin class _$ContractVersionCopyWith<$Res> implements $ContractVersionCopyWith<$Res> {
  factory _$ContractVersionCopyWith(_ContractVersion value, $Res Function(_ContractVersion) _then) = __$ContractVersionCopyWithImpl;
@override @useResult
$Res call({
 String id, String contractId, String schemaJson, String changeLog, String status, List<String> confirmedBy
});




}
/// @nodoc
class __$ContractVersionCopyWithImpl<$Res>
    implements _$ContractVersionCopyWith<$Res> {
  __$ContractVersionCopyWithImpl(this._self, this._then);

  final _ContractVersion _self;
  final $Res Function(_ContractVersion) _then;

/// Create a copy of ContractVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? contractId = null,Object? schemaJson = null,Object? changeLog = null,Object? status = null,Object? confirmedBy = null,}) {
  return _then(_ContractVersion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contractId: null == contractId ? _self.contractId : contractId // ignore: cast_nullable_to_non_nullable
as String,schemaJson: null == schemaJson ? _self.schemaJson : schemaJson // ignore: cast_nullable_to_non_nullable
as String,changeLog: null == changeLog ? _self.changeLog : changeLog // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,confirmedBy: null == confirmedBy ? _self._confirmedBy : confirmedBy // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$Contract {

 String get id; String get eventId; String get subscriberDomain;@JsonKey(fromJson: _mapFromJson) Map<String, dynamic> get mapping; String get status; List<ContractVersion> get versions;
/// Create a copy of Contract
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContractCopyWith<Contract> get copyWith => _$ContractCopyWithImpl<Contract>(this as Contract, _$identity);

  /// Serializes this Contract to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Contract&&(identical(other.id, id) || other.id == id)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.subscriberDomain, subscriberDomain) || other.subscriberDomain == subscriberDomain)&&const DeepCollectionEquality().equals(other.mapping, mapping)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.versions, versions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,eventId,subscriberDomain,const DeepCollectionEquality().hash(mapping),status,const DeepCollectionEquality().hash(versions));

@override
String toString() {
  return 'Contract(id: $id, eventId: $eventId, subscriberDomain: $subscriberDomain, mapping: $mapping, status: $status, versions: $versions)';
}


}

/// @nodoc
abstract mixin class $ContractCopyWith<$Res>  {
  factory $ContractCopyWith(Contract value, $Res Function(Contract) _then) = _$ContractCopyWithImpl;
@useResult
$Res call({
 String id, String eventId, String subscriberDomain,@JsonKey(fromJson: _mapFromJson) Map<String, dynamic> mapping, String status, List<ContractVersion> versions
});




}
/// @nodoc
class _$ContractCopyWithImpl<$Res>
    implements $ContractCopyWith<$Res> {
  _$ContractCopyWithImpl(this._self, this._then);

  final Contract _self;
  final $Res Function(Contract) _then;

/// Create a copy of Contract
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? eventId = null,Object? subscriberDomain = null,Object? mapping = null,Object? status = null,Object? versions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,subscriberDomain: null == subscriberDomain ? _self.subscriberDomain : subscriberDomain // ignore: cast_nullable_to_non_nullable
as String,mapping: null == mapping ? _self.mapping : mapping // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,versions: null == versions ? _self.versions : versions // ignore: cast_nullable_to_non_nullable
as List<ContractVersion>,
  ));
}

}


/// Adds pattern-matching-related methods to [Contract].
extension ContractPatterns on Contract {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Contract value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Contract() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Contract value)  $default,){
final _that = this;
switch (_that) {
case _Contract():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Contract value)?  $default,){
final _that = this;
switch (_that) {
case _Contract() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String eventId,  String subscriberDomain, @JsonKey(fromJson: _mapFromJson)  Map<String, dynamic> mapping,  String status,  List<ContractVersion> versions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Contract() when $default != null:
return $default(_that.id,_that.eventId,_that.subscriberDomain,_that.mapping,_that.status,_that.versions);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String eventId,  String subscriberDomain, @JsonKey(fromJson: _mapFromJson)  Map<String, dynamic> mapping,  String status,  List<ContractVersion> versions)  $default,) {final _that = this;
switch (_that) {
case _Contract():
return $default(_that.id,_that.eventId,_that.subscriberDomain,_that.mapping,_that.status,_that.versions);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String eventId,  String subscriberDomain, @JsonKey(fromJson: _mapFromJson)  Map<String, dynamic> mapping,  String status,  List<ContractVersion> versions)?  $default,) {final _that = this;
switch (_that) {
case _Contract() when $default != null:
return $default(_that.id,_that.eventId,_that.subscriberDomain,_that.mapping,_that.status,_that.versions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Contract implements Contract {
  const _Contract({required this.id, required this.eventId, required this.subscriberDomain, @JsonKey(fromJson: _mapFromJson) final  Map<String, dynamic> mapping = const {}, this.status = 'active', final  List<ContractVersion> versions = const []}): _mapping = mapping,_versions = versions;
  factory _Contract.fromJson(Map<String, dynamic> json) => _$ContractFromJson(json);

@override final  String id;
@override final  String eventId;
@override final  String subscriberDomain;
 final  Map<String, dynamic> _mapping;
@override@JsonKey(fromJson: _mapFromJson) Map<String, dynamic> get mapping {
  if (_mapping is EqualUnmodifiableMapView) return _mapping;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_mapping);
}

@override@JsonKey() final  String status;
 final  List<ContractVersion> _versions;
@override@JsonKey() List<ContractVersion> get versions {
  if (_versions is EqualUnmodifiableListView) return _versions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_versions);
}


/// Create a copy of Contract
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContractCopyWith<_Contract> get copyWith => __$ContractCopyWithImpl<_Contract>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContractToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Contract&&(identical(other.id, id) || other.id == id)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.subscriberDomain, subscriberDomain) || other.subscriberDomain == subscriberDomain)&&const DeepCollectionEquality().equals(other._mapping, _mapping)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._versions, _versions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,eventId,subscriberDomain,const DeepCollectionEquality().hash(_mapping),status,const DeepCollectionEquality().hash(_versions));

@override
String toString() {
  return 'Contract(id: $id, eventId: $eventId, subscriberDomain: $subscriberDomain, mapping: $mapping, status: $status, versions: $versions)';
}


}

/// @nodoc
abstract mixin class _$ContractCopyWith<$Res> implements $ContractCopyWith<$Res> {
  factory _$ContractCopyWith(_Contract value, $Res Function(_Contract) _then) = __$ContractCopyWithImpl;
@override @useResult
$Res call({
 String id, String eventId, String subscriberDomain,@JsonKey(fromJson: _mapFromJson) Map<String, dynamic> mapping, String status, List<ContractVersion> versions
});




}
/// @nodoc
class __$ContractCopyWithImpl<$Res>
    implements _$ContractCopyWith<$Res> {
  __$ContractCopyWithImpl(this._self, this._then);

  final _Contract _self;
  final $Res Function(_Contract) _then;

/// Create a copy of Contract
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? eventId = null,Object? subscriberDomain = null,Object? mapping = null,Object? status = null,Object? versions = null,}) {
  return _then(_Contract(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,subscriberDomain: null == subscriberDomain ? _self.subscriberDomain : subscriberDomain // ignore: cast_nullable_to_non_nullable
as String,mapping: null == mapping ? _self._mapping : mapping // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,versions: null == versions ? _self._versions : versions // ignore: cast_nullable_to_non_nullable
as List<ContractVersion>,
  ));
}


}

// dart format on
