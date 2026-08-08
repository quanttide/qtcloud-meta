import 'package:flutter_test/flutter_test.dart';
import 'package:qtcloud_studio/models/contract.dart';

void main() {
  group('ContractVersion', () {
    test('fromJson parses all fields', () {
      final version = ContractVersion.fromJson({
        'id': 'ver_001',
        'contractId': 'ctr_001',
        'schemaJson': '{}',
        'changeLog': '初始版本',
        'status': 'active',
        'confirmedBy': ['qtcloud.biz'],
      });
      expect(version.id, 'ver_001');
      expect(version.contractId, 'ctr_001');
      expect(version.changeLog, '初始版本');
      expect(version.status, 'active');
      expect(version.confirmedBy, ['qtcloud.biz']);
    });

    test('fromJson defaults confirmedBy to empty', () {
      final version = ContractVersion.fromJson({
        'id': 'ver_002',
        'contractId': 'ctr_002',
        'schemaJson': '{}',
        'changeLog': 'v2',
        'status': 'pending',
      });
      expect(version.confirmedBy, []);
    });
  });

  group('Contract', () {
    test('fromJson parses all fields', () {
      final contract = Contract.fromJson({
        'id': 'ctr_001',
        'eventId': 'evt_001',
        'subscriberDomain': 'qtcloud.biz',
        'mapping': {},
        'status': 'active',
        'versions': [
          {
            'id': 'ver_001',
            'contractId': 'ctr_001',
            'schemaJson': '{}',
            'changeLog': '初始版本',
            'status': 'active',
          },
        ],
      });
      expect(contract.id, 'ctr_001');
      expect(contract.eventId, 'evt_001');
      expect(contract.subscriberDomain, 'qtcloud.biz');
      expect(contract.versions.length, 1);
    });

    test('copyWith overrides specified fields', () {
      final contract = Contract(
        id: 'ctr_001',
        eventId: 'evt_001',
        subscriberDomain: 'qtcloud.biz',
      );
      final copy = contract.copyWith(status: 'change_pending');
      expect(copy.status, 'change_pending');
      expect(copy.id, 'ctr_001');
    });
  });
}
