import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
sealed class SchemaField with _$SchemaField {
  const factory SchemaField({
    required String name,
    required String type,
    @Default(false) bool required,
  }) = _SchemaField;

  factory SchemaField.fromJson(Map<String, dynamic> json) =>
      _$SchemaFieldFromJson(json);
}

@freezed
sealed class EventSchema with _$EventSchema {
  const factory EventSchema({
    @Default([]) List<SchemaField> fields,
  }) = _EventSchema;

  factory EventSchema.fromJson(Map<String, dynamic> json) =>
      _$EventSchemaFromJson(json);
}

@freezed
sealed class Event with _$Event {
  const factory Event({
    required String id,
    required String type,
    required String source,
    required String description,
    required String direction,
    @Default('active') String status,
    @Default('v1.0') String version,
    @JsonKey(name: 'subscriber_count') @Default(0) int subscriberCount,
    EventSchema? schema,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
