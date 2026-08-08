import 'package:flutter_test/flutter_test.dart';
import 'package:qtcloud_studio/sources/data_source.dart';

class _MockSource extends DataSource {
  final String data;
  _MockSource(this.data);

  @override
  Future<String> load(String path) async => data;
}

void main() {
  group('DataLoader', () {
    test('load returns DataSuccess on valid JSON map', () async {
      final source = _MockSource('{"id": "l1", "title": "T"}');
      final loader = DataLoader<Map<String, dynamic>>(
        source,
        'test.json',
        (json) => json as Map<String, dynamic>,
      );
      final result = await loader.load();
      expect(result, isA<DataSuccess<Map<String, dynamic>>>());
      final success = result as DataSuccess<Map<String, dynamic>>;
      expect(success.data['id'], 'l1');
    });

    test('load returns DataSuccess on valid JSON list', () async {
      final source = _MockSource('[{"id": "l1"}, {"id": "l2"}]');
      final loader = DataLoader<List<Map<String, dynamic>>>(
        source,
        'test.json',
        (json) => (json as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList(),
      );
      final result = await loader.load();
      expect(result, isA<DataSuccess<List<Map<String, dynamic>>>>());
      final success = result as DataSuccess<List<Map<String, dynamic>>>;
      expect(success.data.length, 2);
    });

    test('load returns DataError on invalid JSON', () async {
      final source = _MockSource('invalid json');
      final loader = DataLoader<Map<String, dynamic>>(
        source,
        'test.json',
        (json) => json as Map<String, dynamic>,
      );
      final result = await loader.load();
      expect(result, isA<DataError<Map<String, dynamic>>>());
    });
  });
}
