// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SchemaField _$SchemaFieldFromJson(Map<String, dynamic> json) => _SchemaField(
  name: json['name'] as String,
  type: json['type'] as String,
  required: json['required'] as bool? ?? false,
);

Map<String, dynamic> _$SchemaFieldToJson(_SchemaField instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'required': instance.required,
    };

_EventSchema _$EventSchemaFromJson(Map<String, dynamic> json) => _EventSchema(
  fields:
      (json['fields'] as List<dynamic>?)
          ?.map((e) => SchemaField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$EventSchemaToJson(_EventSchema instance) =>
    <String, dynamic>{'fields': instance.fields};

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
  id: json['id'] as String,
  type: json['type'] as String,
  source: json['source'] as String,
  description: json['description'] as String,
  direction: json['direction'] as String,
  status: json['status'] as String? ?? 'active',
  version: json['version'] as String? ?? 'v1.0',
  subscriberCount: (json['subscriber_count'] as num?)?.toInt() ?? 0,
  schema: json['schema'] == null
      ? null
      : EventSchema.fromJson(json['schema'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'source': instance.source,
  'description': instance.description,
  'direction': instance.direction,
  'status': instance.status,
  'version': instance.version,
  'subscriber_count': instance.subscriberCount,
  'schema': instance.schema,
};
