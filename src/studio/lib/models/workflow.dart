import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow.freezed.dart';
part 'workflow.g.dart';

@freezed
sealed class WorkflowStep with _$WorkflowStep {
  const factory WorkflowStep({
    required String sourceEvent,
    required String sourceDomain,
    required String targetDomain,
    required String targetAction,
  }) = _WorkflowStep;

  factory WorkflowStep.fromJson(Map<String, dynamic> json) =>
      _$WorkflowStepFromJson(json);
}

@freezed
sealed class Workflow with _$Workflow {
  const factory Workflow({
    required String id,
    required String name,
    required String type,
    @Default('disabled') String status,
    @Default([]) List<WorkflowStep> steps,
  }) = _Workflow;

  factory Workflow.fromJson(Map<String, dynamic> json) =>
      _$WorkflowFromJson(json);
}
