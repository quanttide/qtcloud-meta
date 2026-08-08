import 'package:flutter_test/flutter_test.dart';
import 'package:qtcloud_studio/models/workflow.dart';

void main() {
  group('WorkflowStep', () {
    test('fromJson parses all fields', () {
      final step = WorkflowStep.fromJson({
        'sourceEvent': 'com.qtcloud.sales.deal.closed',
        'sourceDomain': 'qtcloud.sales',
        'targetDomain': 'qtcloud.biz',
        'targetAction': '创建合同',
      });
      expect(step.sourceEvent, 'com.qtcloud.sales.deal.closed');
      expect(step.sourceDomain, 'qtcloud.sales');
      expect(step.targetDomain, 'qtcloud.biz');
      expect(step.targetAction, '创建合同');
    });
  });

  group('Workflow', () {
    test('fromJson parses all fields', () {
      final workflow = Workflow.fromJson({
        'id': 'wf_001',
        'name': '成交转化',
        'type': 'preset',
        'status': 'enabled',
        'steps': [
          {
            'sourceEvent': 'com.qtcloud.sales.deal.closed',
            'sourceDomain': 'qtcloud.sales',
            'targetDomain': 'qtcloud.biz',
            'targetAction': '创建合同',
          },
        ],
      });
      expect(workflow.id, 'wf_001');
      expect(workflow.name, '成交转化');
      expect(workflow.type, 'preset');
      expect(workflow.status, 'enabled');
      expect(workflow.steps.length, 1);
    });

    test('fromJson uses default values', () {
      final workflow = Workflow.fromJson({
        'id': 'wf_002',
        'name': '订单交付',
        'type': 'preset',
      });
      expect(workflow.status, 'disabled');
      expect(workflow.steps, []);
    });

    test('copyWith overrides specified fields', () {
      final workflow = Workflow(
        id: 'wf_001',
        name: '成交转化',
        type: 'preset',
        status: 'disabled',
      );
      final copy = workflow.copyWith(status: 'enabled');
      expect(copy.status, 'enabled');
      expect(copy.name, '成交转化');
    });
  });
}
