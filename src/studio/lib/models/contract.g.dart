// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContractVersion _$ContractVersionFromJson(Map<String, dynamic> json) =>
    _ContractVersion(
      id: json['id'] as String,
      contractId: json['contractId'] as String,
      schemaJson: json['schemaJson'] as String,
      changeLog: json['changeLog'] as String,
      status: json['status'] as String,
      confirmedBy:
          (json['confirmedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ContractVersionToJson(_ContractVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contractId': instance.contractId,
      'schemaJson': instance.schemaJson,
      'changeLog': instance.changeLog,
      'status': instance.status,
      'confirmedBy': instance.confirmedBy,
    };

_Contract _$ContractFromJson(Map<String, dynamic> json) => _Contract(
  id: json['id'] as String,
  eventId: json['eventId'] as String,
  subscriberDomain: json['subscriberDomain'] as String,
  mapping: json['mapping'] == null ? const {} : _mapFromJson(json['mapping']),
  status: json['status'] as String? ?? 'active',
  versions:
      (json['versions'] as List<dynamic>?)
          ?.map((e) => ContractVersion.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ContractToJson(_Contract instance) => <String, dynamic>{
  'id': instance.id,
  'eventId': instance.eventId,
  'subscriberDomain': instance.subscriberDomain,
  'mapping': instance.mapping,
  'status': instance.status,
  'versions': instance.versions,
};
