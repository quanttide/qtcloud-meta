import 'package:flutter_test/flutter_test.dart';
import 'package:qtcloud_studio/blocs/workflow_cubit.dart';
import 'package:qtcloud_studio/sources/data_source.dart';

class _MockSource extends DataSource {
  final String data;
  _MockSource(this.data);

  @override
  Future<String> load(String path) async => data;
}

void main() {
  group('WorkflowCubit', () {
    test('toggleWorkflow toggles status', () async {
      final source = _MockSource('[{"id":"wf_001","name":"成交转化","type":"preset","status":"disabled","steps":[]}]');
      final cubit = WorkflowCubit(
        source: source,
        workflowsPath: 'test.json',
      );
      await cubit.loadWorkflows();
      expect(cubit.state.workflows.first.status, 'disabled');

      cubit.toggleWorkflow('wf_001');
      expect(cubit.state.workflows.first.status, 'enabled');

      cubit.toggleWorkflow('wf_001');
      expect(cubit.state.workflows.first.status, 'disabled');
      cubit.close();
    });

    test('setTab changes active tab', () {
      final source = _MockSource('[]');
      final cubit = WorkflowCubit(
        source: source,
        workflowsPath: 'test.json',
      );
      expect(cubit.state.activeTab, 'preset');
      cubit.setTab('custom');
      expect(cubit.state.activeTab, 'custom');
      cubit.close();
    });
  });
}
