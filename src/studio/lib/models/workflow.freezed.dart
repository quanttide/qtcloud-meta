// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowStep {

 String get sourceEvent; String get sourceDomain; String get targetDomain; String get targetAction;
/// Create a copy of WorkflowStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowStepCopyWith<WorkflowStep> get copyWith => _$WorkflowStepCopyWithImpl<WorkflowStep>(this as WorkflowStep, _$identity);

  /// Serializes this WorkflowStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowStep&&(identical(other.sourceEvent, sourceEvent) || other.sourceEvent == sourceEvent)&&(identical(other.sourceDomain, sourceDomain) || other.sourceDomain == sourceDomain)&&(identical(other.targetDomain, targetDomain) || other.targetDomain == targetDomain)&&(identical(other.targetAction, targetAction) || other.targetAction == targetAction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceEvent,sourceDomain,targetDomain,targetAction);

@override
String toString() {
  return 'WorkflowStep(sourceEvent: $sourceEvent, sourceDomain: $sourceDomain, targetDomain: $targetDomain, targetAction: $targetAction)';
}


}

/// @nodoc
abstract mixin class $WorkflowStepCopyWith<$Res>  {
  factory $WorkflowStepCopyWith(WorkflowStep value, $Res Function(WorkflowStep) _then) = _$WorkflowStepCopyWithImpl;
@useResult
$Res call({
 String sourceEvent, String sourceDomain, String targetDomain, String targetAction
});




}
/// @nodoc
class _$WorkflowStepCopyWithImpl<$Res>
    implements $WorkflowStepCopyWith<$Res> {
  _$WorkflowStepCopyWithImpl(this._self, this._then);

  final WorkflowStep _self;
  final $Res Function(WorkflowStep) _then;

/// Create a copy of WorkflowStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceEvent = null,Object? sourceDomain = null,Object? targetDomain = null,Object? targetAction = null,}) {
  return _then(_self.copyWith(
sourceEvent: null == sourceEvent ? _self.sourceEvent : sourceEvent // ignore: cast_nullable_to_non_nullable
as String,sourceDomain: null == sourceDomain ? _self.sourceDomain : sourceDomain // ignore: cast_nullable_to_non_nullable
as String,targetDomain: null == targetDomain ? _self.targetDomain : targetDomain // ignore: cast_nullable_to_non_nullable
as String,targetAction: null == targetAction ? _self.targetAction : targetAction // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkflowStep].
extension WorkflowStepPatterns on WorkflowStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowStep value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowStep value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceEvent,  String sourceDomain,  String targetDomain,  String targetAction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowStep() when $default != null:
return $default(_that.sourceEvent,_that.sourceDomain,_that.targetDomain,_that.targetAction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceEvent,  String sourceDomain,  String targetDomain,  String targetAction)  $default,) {final _that = this;
switch (_that) {
case _WorkflowStep():
return $default(_that.sourceEvent,_that.sourceDomain,_that.targetDomain,_that.targetAction);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceEvent,  String sourceDomain,  String targetDomain,  String targetAction)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowStep() when $default != null:
return $default(_that.sourceEvent,_that.sourceDomain,_that.targetDomain,_that.targetAction);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkflowStep implements WorkflowStep {
  const _WorkflowStep({required this.sourceEvent, required this.sourceDomain, required this.targetDomain, required this.targetAction});
  factory _WorkflowStep.fromJson(Map<String, dynamic> json) => _$WorkflowStepFromJson(json);

@override final  String sourceEvent;
@override final  String sourceDomain;
@override final  String targetDomain;
@override final  String targetAction;

/// Create a copy of WorkflowStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowStepCopyWith<_WorkflowStep> get copyWith => __$WorkflowStepCopyWithImpl<_WorkflowStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkflowStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowStep&&(identical(other.sourceEvent, sourceEvent) || other.sourceEvent == sourceEvent)&&(identical(other.sourceDomain, sourceDomain) || other.sourceDomain == sourceDomain)&&(identical(other.targetDomain, targetDomain) || other.targetDomain == targetDomain)&&(identical(other.targetAction, targetAction) || other.targetAction == targetAction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceEvent,sourceDomain,targetDomain,targetAction);

@override
String toString() {
  return 'WorkflowStep(sourceEvent: $sourceEvent, sourceDomain: $sourceDomain, targetDomain: $targetDomain, targetAction: $targetAction)';
}


}

/// @nodoc
abstract mixin class _$WorkflowStepCopyWith<$Res> implements $WorkflowStepCopyWith<$Res> {
  factory _$WorkflowStepCopyWith(_WorkflowStep value, $Res Function(_WorkflowStep) _then) = __$WorkflowStepCopyWithImpl;
@override @useResult
$Res call({
 String sourceEvent, String sourceDomain, String targetDomain, String targetAction
});




}
/// @nodoc
class __$WorkflowStepCopyWithImpl<$Res>
    implements _$WorkflowStepCopyWith<$Res> {
  __$WorkflowStepCopyWithImpl(this._self, this._then);

  final _WorkflowStep _self;
  final $Res Function(_WorkflowStep) _then;

/// Create a copy of WorkflowStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceEvent = null,Object? sourceDomain = null,Object? targetDomain = null,Object? targetAction = null,}) {
  return _then(_WorkflowStep(
sourceEvent: null == sourceEvent ? _self.sourceEvent : sourceEvent // ignore: cast_nullable_to_non_nullable
as String,sourceDomain: null == sourceDomain ? _self.sourceDomain : sourceDomain // ignore: cast_nullable_to_non_nullable
as String,targetDomain: null == targetDomain ? _self.targetDomain : targetDomain // ignore: cast_nullable_to_non_nullable
as String,targetAction: null == targetAction ? _self.targetAction : targetAction // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Workflow {

 String get id; String get name; String get type; String get status; List<WorkflowStep> get steps;
/// Create a copy of Workflow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowCopyWith<Workflow> get copyWith => _$WorkflowCopyWithImpl<Workflow>(this as Workflow, _$identity);

  /// Serializes this Workflow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Workflow&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.steps, steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,status,const DeepCollectionEquality().hash(steps));

@override
String toString() {
  return 'Workflow(id: $id, name: $name, type: $type, status: $status, steps: $steps)';
}


}

/// @nodoc
abstract mixin class $WorkflowCopyWith<$Res>  {
  factory $WorkflowCopyWith(Workflow value, $Res Function(Workflow) _then) = _$WorkflowCopyWithImpl;
@useResult
$Res call({
 String id, String name, String type, String status, List<WorkflowStep> steps
});




}
/// @nodoc
class _$WorkflowCopyWithImpl<$Res>
    implements $WorkflowCopyWith<$Res> {
  _$WorkflowCopyWithImpl(this._self, this._then);

  final Workflow _self;
  final $Res Function(Workflow) _then;

/// Create a copy of Workflow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? status = null,Object? steps = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<WorkflowStep>,
  ));
}

}


/// Adds pattern-matching-related methods to [Workflow].
extension WorkflowPatterns on Workflow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Workflow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Workflow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Workflow value)  $default,){
final _that = this;
switch (_that) {
case _Workflow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Workflow value)?  $default,){
final _that = this;
switch (_that) {
case _Workflow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String type,  String status,  List<WorkflowStep> steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Workflow() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.status,_that.steps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String type,  String status,  List<WorkflowStep> steps)  $default,) {final _that = this;
switch (_that) {
case _Workflow():
return $default(_that.id,_that.name,_that.type,_that.status,_that.steps);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String type,  String status,  List<WorkflowStep> steps)?  $default,) {final _that = this;
switch (_that) {
case _Workflow() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.status,_that.steps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Workflow implements Workflow {
  const _Workflow({required this.id, required this.name, required this.type, this.status = 'disabled', final  List<WorkflowStep> steps = const []}): _steps = steps;
  factory _Workflow.fromJson(Map<String, dynamic> json) => _$WorkflowFromJson(json);

@override final  String id;
@override final  String name;
@override final  String type;
@override@JsonKey() final  String status;
 final  List<WorkflowStep> _steps;
@override@JsonKey() List<WorkflowStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


/// Create a copy of Workflow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowCopyWith<_Workflow> get copyWith => __$WorkflowCopyWithImpl<_Workflow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkflowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Workflow&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._steps, _steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,status,const DeepCollectionEquality().hash(_steps));

@override
String toString() {
  return 'Workflow(id: $id, name: $name, type: $type, status: $status, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$WorkflowCopyWith<$Res> implements $WorkflowCopyWith<$Res> {
  factory _$WorkflowCopyWith(_Workflow value, $Res Function(_Workflow) _then) = __$WorkflowCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String type, String status, List<WorkflowStep> steps
});




}
/// @nodoc
class __$WorkflowCopyWithImpl<$Res>
    implements _$WorkflowCopyWith<$Res> {
  __$WorkflowCopyWithImpl(this._self, this._then);

  final _Workflow _self;
  final $Res Function(_Workflow) _then;

/// Create a copy of Workflow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? status = null,Object? steps = null,}) {
  return _then(_Workflow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<WorkflowStep>,
  ));
}


}

// dart format on
