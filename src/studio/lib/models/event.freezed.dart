// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SchemaField {

 String get name; String get type; bool get required;
/// Create a copy of SchemaField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchemaFieldCopyWith<SchemaField> get copyWith => _$SchemaFieldCopyWithImpl<SchemaField>(this as SchemaField, _$identity);

  /// Serializes this SchemaField to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchemaField&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.required, required) || other.required == required));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,required);

@override
String toString() {
  return 'SchemaField(name: $name, type: $type, required: $required)';
}


}

/// @nodoc
abstract mixin class $SchemaFieldCopyWith<$Res>  {
  factory $SchemaFieldCopyWith(SchemaField value, $Res Function(SchemaField) _then) = _$SchemaFieldCopyWithImpl;
@useResult
$Res call({
 String name, String type, bool required
});




}
/// @nodoc
class _$SchemaFieldCopyWithImpl<$Res>
    implements $SchemaFieldCopyWith<$Res> {
  _$SchemaFieldCopyWithImpl(this._self, this._then);

  final SchemaField _self;
  final $Res Function(SchemaField) _then;

/// Create a copy of SchemaField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? required = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SchemaField].
extension SchemaFieldPatterns on SchemaField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchemaField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchemaField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchemaField value)  $default,){
final _that = this;
switch (_that) {
case _SchemaField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchemaField value)?  $default,){
final _that = this;
switch (_that) {
case _SchemaField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String type,  bool required)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchemaField() when $default != null:
return $default(_that.name,_that.type,_that.required);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String type,  bool required)  $default,) {final _that = this;
switch (_that) {
case _SchemaField():
return $default(_that.name,_that.type,_that.required);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String type,  bool required)?  $default,) {final _that = this;
switch (_that) {
case _SchemaField() when $default != null:
return $default(_that.name,_that.type,_that.required);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchemaField implements SchemaField {
  const _SchemaField({required this.name, required this.type, this.required = false});
  factory _SchemaField.fromJson(Map<String, dynamic> json) => _$SchemaFieldFromJson(json);

@override final  String name;
@override final  String type;
@override@JsonKey() final  bool required;

/// Create a copy of SchemaField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchemaFieldCopyWith<_SchemaField> get copyWith => __$SchemaFieldCopyWithImpl<_SchemaField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchemaFieldToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchemaField&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.required, required) || other.required == required));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,required);

@override
String toString() {
  return 'SchemaField(name: $name, type: $type, required: $required)';
}


}

/// @nodoc
abstract mixin class _$SchemaFieldCopyWith<$Res> implements $SchemaFieldCopyWith<$Res> {
  factory _$SchemaFieldCopyWith(_SchemaField value, $Res Function(_SchemaField) _then) = __$SchemaFieldCopyWithImpl;
@override @useResult
$Res call({
 String name, String type, bool required
});




}
/// @nodoc
class __$SchemaFieldCopyWithImpl<$Res>
    implements _$SchemaFieldCopyWith<$Res> {
  __$SchemaFieldCopyWithImpl(this._self, this._then);

  final _SchemaField _self;
  final $Res Function(_SchemaField) _then;

/// Create a copy of SchemaField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? required = null,}) {
  return _then(_SchemaField(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EventSchema {

 List<SchemaField> get fields;
/// Create a copy of EventSchema
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventSchemaCopyWith<EventSchema> get copyWith => _$EventSchemaCopyWithImpl<EventSchema>(this as EventSchema, _$identity);

  /// Serializes this EventSchema to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventSchema&&const DeepCollectionEquality().equals(other.fields, fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(fields));

@override
String toString() {
  return 'EventSchema(fields: $fields)';
}


}

/// @nodoc
abstract mixin class $EventSchemaCopyWith<$Res>  {
  factory $EventSchemaCopyWith(EventSchema value, $Res Function(EventSchema) _then) = _$EventSchemaCopyWithImpl;
@useResult
$Res call({
 List<SchemaField> fields
});




}
/// @nodoc
class _$EventSchemaCopyWithImpl<$Res>
    implements $EventSchemaCopyWith<$Res> {
  _$EventSchemaCopyWithImpl(this._self, this._then);

  final EventSchema _self;
  final $Res Function(EventSchema) _then;

/// Create a copy of EventSchema
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fields = null,}) {
  return _then(_self.copyWith(
fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<SchemaField>,
  ));
}

}


/// Adds pattern-matching-related methods to [EventSchema].
extension EventSchemaPatterns on EventSchema {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventSchema value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventSchema() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventSchema value)  $default,){
final _that = this;
switch (_that) {
case _EventSchema():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventSchema value)?  $default,){
final _that = this;
switch (_that) {
case _EventSchema() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SchemaField> fields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventSchema() when $default != null:
return $default(_that.fields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SchemaField> fields)  $default,) {final _that = this;
switch (_that) {
case _EventSchema():
return $default(_that.fields);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SchemaField> fields)?  $default,) {final _that = this;
switch (_that) {
case _EventSchema() when $default != null:
return $default(_that.fields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventSchema implements EventSchema {
  const _EventSchema({final  List<SchemaField> fields = const []}): _fields = fields;
  factory _EventSchema.fromJson(Map<String, dynamic> json) => _$EventSchemaFromJson(json);

 final  List<SchemaField> _fields;
@override@JsonKey() List<SchemaField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}


/// Create a copy of EventSchema
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventSchemaCopyWith<_EventSchema> get copyWith => __$EventSchemaCopyWithImpl<_EventSchema>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventSchemaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventSchema&&const DeepCollectionEquality().equals(other._fields, _fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_fields));

@override
String toString() {
  return 'EventSchema(fields: $fields)';
}


}

/// @nodoc
abstract mixin class _$EventSchemaCopyWith<$Res> implements $EventSchemaCopyWith<$Res> {
  factory _$EventSchemaCopyWith(_EventSchema value, $Res Function(_EventSchema) _then) = __$EventSchemaCopyWithImpl;
@override @useResult
$Res call({
 List<SchemaField> fields
});




}
/// @nodoc
class __$EventSchemaCopyWithImpl<$Res>
    implements _$EventSchemaCopyWith<$Res> {
  __$EventSchemaCopyWithImpl(this._self, this._then);

  final _EventSchema _self;
  final $Res Function(_EventSchema) _then;

/// Create a copy of EventSchema
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fields = null,}) {
  return _then(_EventSchema(
fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<SchemaField>,
  ));
}


}


/// @nodoc
mixin _$Event {

 String get id; String get type; String get source; String get description; String get direction; String get status; String get version;@JsonKey(name: 'subscriber_count') int get subscriberCount; EventSchema? get schema;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.source, source) || other.source == source)&&(identical(other.description, description) || other.description == description)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.version, version) || other.version == version)&&(identical(other.subscriberCount, subscriberCount) || other.subscriberCount == subscriberCount)&&(identical(other.schema, schema) || other.schema == schema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,source,description,direction,status,version,subscriberCount,schema);

@override
String toString() {
  return 'Event(id: $id, type: $type, source: $source, description: $description, direction: $direction, status: $status, version: $version, subscriberCount: $subscriberCount, schema: $schema)';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 String id, String type, String source, String description, String direction, String status, String version,@JsonKey(name: 'subscriber_count') int subscriberCount, EventSchema? schema
});


$EventSchemaCopyWith<$Res>? get schema;

}
/// @nodoc
class _$EventCopyWithImpl<$Res>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? source = null,Object? description = null,Object? direction = null,Object? status = null,Object? version = null,Object? subscriberCount = null,Object? schema = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,subscriberCount: null == subscriberCount ? _self.subscriberCount : subscriberCount // ignore: cast_nullable_to_non_nullable
as int,schema: freezed == schema ? _self.schema : schema // ignore: cast_nullable_to_non_nullable
as EventSchema?,
  ));
}
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventSchemaCopyWith<$Res>? get schema {
    if (_self.schema == null) {
    return null;
  }

  return $EventSchemaCopyWith<$Res>(_self.schema!, (value) {
    return _then(_self.copyWith(schema: value));
  });
}
}


/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Event value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Event value)  $default,){
final _that = this;
switch (_that) {
case _Event():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Event value)?  $default,){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String source,  String description,  String direction,  String status,  String version, @JsonKey(name: 'subscriber_count')  int subscriberCount,  EventSchema? schema)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.type,_that.source,_that.description,_that.direction,_that.status,_that.version,_that.subscriberCount,_that.schema);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String source,  String description,  String direction,  String status,  String version, @JsonKey(name: 'subscriber_count')  int subscriberCount,  EventSchema? schema)  $default,) {final _that = this;
switch (_that) {
case _Event():
return $default(_that.id,_that.type,_that.source,_that.description,_that.direction,_that.status,_that.version,_that.subscriberCount,_that.schema);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String source,  String description,  String direction,  String status,  String version, @JsonKey(name: 'subscriber_count')  int subscriberCount,  EventSchema? schema)?  $default,) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.type,_that.source,_that.description,_that.direction,_that.status,_that.version,_that.subscriberCount,_that.schema);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Event implements Event {
  const _Event({required this.id, required this.type, required this.source, required this.description, required this.direction, this.status = 'active', this.version = 'v1.0', @JsonKey(name: 'subscriber_count') this.subscriberCount = 0, this.schema});
  factory _Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

@override final  String id;
@override final  String type;
@override final  String source;
@override final  String description;
@override final  String direction;
@override@JsonKey() final  String status;
@override@JsonKey() final  String version;
@override@JsonKey(name: 'subscriber_count') final  int subscriberCount;
@override final  EventSchema? schema;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCopyWith<_Event> get copyWith => __$EventCopyWithImpl<_Event>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Event&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.source, source) || other.source == source)&&(identical(other.description, description) || other.description == description)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.version, version) || other.version == version)&&(identical(other.subscriberCount, subscriberCount) || other.subscriberCount == subscriberCount)&&(identical(other.schema, schema) || other.schema == schema));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,source,description,direction,status,version,subscriberCount,schema);

@override
String toString() {
  return 'Event(id: $id, type: $type, source: $source, description: $description, direction: $direction, status: $status, version: $version, subscriberCount: $subscriberCount, schema: $schema)';
}


}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) = __$EventCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String source, String description, String direction, String status, String version,@JsonKey(name: 'subscriber_count') int subscriberCount, EventSchema? schema
});


@override $EventSchemaCopyWith<$Res>? get schema;

}
/// @nodoc
class __$EventCopyWithImpl<$Res>
    implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(this._self, this._then);

  final _Event _self;
  final $Res Function(_Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? source = null,Object? description = null,Object? direction = null,Object? status = null,Object? version = null,Object? subscriberCount = null,Object? schema = freezed,}) {
  return _then(_Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,subscriberCount: null == subscriberCount ? _self.subscriberCount : subscriberCount // ignore: cast_nullable_to_non_nullable
as int,schema: freezed == schema ? _self.schema : schema // ignore: cast_nullable_to_non_nullable
as EventSchema?,
  ));
}

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventSchemaCopyWith<$Res>? get schema {
    if (_self.schema == null) {
    return null;
  }

  return $EventSchemaCopyWith<$Res>(_self.schema!, (value) {
    return _then(_self.copyWith(schema: value));
  });
}
}

// dart format on
