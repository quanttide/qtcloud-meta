import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qtcloud_studio/models/event.dart';
import 'package:qtcloud_studio/views/event_card.dart';

void main() {
  group('EventCard', () {
    testWidgets('displays event type and source', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: EventCard(
            event: Event(
              id: 'evt_001',
              type: 'com.qtcloud.sales.deal.closed',
              source: 'qtcloud.sales',
              description: '商机成交时触发',
              direction: 'publish',
            ),
          ),
        ),
      ));

      expect(find.text('com.qtcloud.sales.deal.closed'), findsOneWidget);
      expect(find.text('销售云'), findsOneWidget);
    });

    testWidgets('shows deprecated style when deprecated', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: EventCard(
            event: Event(
              id: 'evt_001',
              type: 'com.qtcloud.sales.deal.closed',
              source: 'qtcloud.sales',
              description: 'desc',
              direction: 'publish',
              status: 'deprecated',
            ),
          ),
        ),
      ));

      expect(find.text('com.qtcloud.sales.deal.closed'), findsOneWidget);
    });

    testWidgets('triggers onTap callback', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: EventCard(
            event: Event(
              id: 'evt_001',
              type: 'test.event',
              source: 'test',
              description: 'desc',
              direction: 'publish',
            ),
            onTap: () => tapped = true,
          ),
        ),
      ));

      await tester.tap(find.text('test.event'));
      expect(tapped, true);
    });
  });
}
