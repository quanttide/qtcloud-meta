import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/workflow.dart';
import '../sources/data_source.dart';

part 'workflow_state.dart';

class WorkflowCubit extends Cubit<WorkflowState> {
  final DataLoader<List<Workflow>> _loader;

  WorkflowCubit({
    DataSource? source,
    required String workflowsPath,
  }) : _loader = DataLoader<List<Workflow>>(
          source ?? BundleSource(),
          workflowsPath,
          _parseWorkflowList,
        ),
        super(const WorkflowState());

  static List<Workflow> _parseWorkflowList(dynamic json) {
    return (json as List<dynamic>)
        .map((e) => Workflow.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> loadWorkflows() async {
    emit(state.copyWith(status: WorkflowStatusState.loading));
    final result = await _loader.load();
    switch (result) {
      case DataSuccess<List<Workflow>>():
        emit(state.copyWith(
          status: WorkflowStatusState.loaded,
          workflows: result.data,
        ));
      case DataError<List<Workflow>>():
        emit(state.copyWith(
          status: WorkflowStatusState.error,
          errorMessage: result.message,
        ));
    }
  }

  void toggleWorkflow(String id) {
    final updated = state.workflows.map((w) {
      if (w.id == id) {
        return w.copyWith(status: w.status == 'enabled' ? 'disabled' : 'enabled');
      }
      return w;
    }).toList();
    emit(state.copyWith(workflows: updated));
  }

  void setTab(String tab) {
    emit(state.copyWith(activeTab: tab));
  }
}
