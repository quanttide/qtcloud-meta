import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtcloud_studio/models/workflow.dart';
import 'package:qtcloud_studio/views/workflow_chain.dart';

void main() {
  group('WorkflowChain', () {
    testWidgets('displays step domains and actions', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: WorkflowChain(
            step: WorkflowStep(
              sourceEvent: 'com.qtcloud.sales.deal.closed',
              sourceDomain: 'qtcloud.sales',
              targetDomain: 'qtcloud.biz',
              targetAction: '创建合同',
            ),
            isEnabled: true,
          ),
        ),
      ));

      expect(find.text('销售云'), findsOneWidget);
      expect(find.text('商务云'), findsOneWidget);
      expect(find.text('创建合同'), findsOneWidget);
    });
  });
}
