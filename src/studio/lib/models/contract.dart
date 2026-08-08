import 'package:freezed_annotation/freezed_annotation.dart';

part 'contract.freezed.dart';
part 'contract.g.dart';

Map<String, dynamic> _mapFromJson(dynamic json) {
  if (json is Map<String, dynamic>) return json;
  if (json is Map) return json.cast<String, dynamic>();
  return {};
}

@freezed
sealed class ContractVersion with _$ContractVersion {
  const factory ContractVersion({
    required String id,
    required String contractId,
    required String schemaJson,
    required String changeLog,
    required String status,
    @Default([]) List<String> confirmedBy,
  }) = _ContractVersion;

  factory ContractVersion.fromJson(Map<String, dynamic> json) =>
      _$ContractVersionFromJson(json);
}

@freezed
sealed class Contract with _$Contract {
  const factory Contract({
    required String id,
    required String eventId,
    required String subscriberDomain,
    @JsonKey(fromJson: _mapFromJson) @Default({}) Map<String, dynamic> mapping,
    @Default('active') String status,
    @Default([]) List<ContractVersion> versions,
  }) = _Contract;

  factory Contract.fromJson(Map<String, dynamic> json) =>
      _$ContractFromJson(json);
}
