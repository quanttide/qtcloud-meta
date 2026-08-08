// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowStep _$WorkflowStepFromJson(Map<String, dynamic> json) =>
    _WorkflowStep(
      sourceEvent: json['sourceEvent'] as String,
      sourceDomain: json['sourceDomain'] as String,
      targetDomain: json['targetDomain'] as String,
      targetAction: json['targetAction'] as String,
    );

Map<String, dynamic> _$WorkflowStepToJson(_WorkflowStep instance) =>
    <String, dynamic>{
      'sourceEvent': instance.sourceEvent,
      'sourceDomain': instance.sourceDomain,
      'targetDomain': instance.targetDomain,
      'targetAction': instance.targetAction,
    };

_Workflow _$WorkflowFromJson(Map<String, dynamic> json) => _Workflow(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  status: json['status'] as String? ?? 'disabled',
  steps:
      (json['steps'] as List<dynamic>?)
          ?.map((e) => WorkflowStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$WorkflowToJson(_Workflow instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'status': instance.status,
  'steps': instance.steps,
};
