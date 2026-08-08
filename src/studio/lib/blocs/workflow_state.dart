part of 'workflow_cubit.dart';

enum WorkflowStatusState { initial, loading, loaded, error }

class WorkflowState extends Equatable {
  final WorkflowStatusState status;
  final List<Workflow> workflows;
  final String? errorMessage;
  final String activeTab;

  const WorkflowState({
    this.status = WorkflowStatusState.initial,
    this.workflows = const [],
    this.errorMessage,
    this.activeTab = 'preset',
  });

  WorkflowState copyWith({
    WorkflowStatusState? status,
    List<Workflow>? workflows,
    String? errorMessage,
    String? activeTab,
  }) {
    return WorkflowState(
      status: status ?? this.status,
      workflows: workflows ?? this.workflows,
      errorMessage: errorMessage,
      activeTab: activeTab ?? this.activeTab,
    );
  }

  @override
  List<Object?> get props => [
        status,
        workflows,
        errorMessage,
        activeTab,
      ];
}
