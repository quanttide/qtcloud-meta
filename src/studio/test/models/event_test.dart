import 'package:flutter_test/flutter_test.dart';
import 'package:qtcloud_studio/models/event.dart';

void main() {
  group('SchemaField', () {
    test('fromJson parses all fields', () {
      final field = SchemaField.fromJson({
        'name': 'deal_id',
        'type': 'string',
        'required': true,
      });
      expect(field.name, 'deal_id');
      expect(field.type, 'string');
      expect(field.required, true);
    });

    test('fromJson defaults required to false', () {
      final field = SchemaField.fromJson({
        'name': 'amount',
        'type': 'number',
      });
      expect(field.name, 'amount');
      expect(field.required, false);
    });

    test('copyWith overrides specified fields', () {
      final field = SchemaField(
        name: 'deal_id',
        type: 'string',
        required: true,
      );
      final copy = field.copyWith(name: 'amount');
      expect(copy.name, 'amount');
      expect(copy.type, 'string');
      expect(copy.required, true);
    });
  });

  group('Event', () {
    test('fromJson parses all fields', () {
      final event = Event.fromJson({
        'id': 'evt_001',
        'type': 'com.qtcloud.sales.deal.closed',
        'source': 'qtcloud.sales',
        'description': '商机成交时触发',
        'direction': 'publish',
        'status': 'active',
        'version': 'v2.1',
        'subscriber_count': 3,
      });
      expect(event.id, 'evt_001');
      expect(event.type, 'com.qtcloud.sales.deal.closed');
      expect(event.source, 'qtcloud.sales');
      expect(event.status, 'active');
      expect(event.version, 'v2.1');
      expect(event.subscriberCount, 3);
    });

    test('fromJson uses default values', () {
      final event = Event.fromJson({
        'id': 'evt_002',
        'type': 'com.qtcloud.sales.deal.created',
        'source': 'qtcloud.sales',
        'description': '新商机产生',
        'direction': 'publish',
      });
      expect(event.status, 'active');
      expect(event.version, 'v1.0');
      expect(event.subscriberCount, 0);
    });

    test('copyWith overrides specified fields', () {
      final event = Event(
        id: 'evt_001',
        type: 'com.qtcloud.sales.deal.closed',
        source: 'qtcloud.sales',
        description: 'desc',
        direction: 'publish',
      );
      final copy = event.copyWith(status: 'deprecated');
      expect(copy.status, 'deprecated');
      expect(copy.id, 'evt_001');
    });
  });
}
