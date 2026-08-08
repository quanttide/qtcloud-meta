import 'package:flutter_test/flutter_test.dart';
import 'package:qtcloud_studio/blocs/event_catalog_cubit.dart';
import 'package:qtcloud_studio/sources/data_source.dart';

class _MockSource extends DataSource {
  final String data;
  _MockSource(this.data);

  @override
  Future<String> load(String path) async => data;
}

void main() {
  group('EventCatalogCubit', () {
    test('initial state is initial', () {
      final source = _MockSource('[]');
      final cubit = EventCatalogCubit(
        source: source,
        eventsPath: 'test.json',
      );
      expect(cubit.state.status, EventCatalogStatus.initial);
      cubit.close();
    });

    test('loadEvents emits loaded on success', () async {
      final source = _MockSource('[{"id":"e1","type":"t","source":"s","description":"d","direction":"publish"}]');
      final cubit = EventCatalogCubit(
        source: source,
        eventsPath: 'test.json',
      );
      await cubit.loadEvents();
      expect(cubit.state.status, EventCatalogStatus.loaded);
      expect(cubit.state.events.length, 1);
      expect(cubit.state.events.first.id, 'e1');
      cubit.close();
    });

    test('loadEvents emits error on failure', () async {
      final source = _MockSource('invalid');
      final cubit = EventCatalogCubit(
        source: source,
        eventsPath: 'test.json',
      );
      await cubit.loadEvents();
      expect(cubit.state.status, EventCatalogStatus.error);
      cubit.close();
    });

    test('search filters events', () async {
      final source = _MockSource('[{"id":"e1","type":"deal.closed","source":"s","description":"d","direction":"publish"},{"id":"e2","type":"deal.created","source":"s","description":"d","direction":"publish"}]');
      final cubit = EventCatalogCubit(
        source: source,
        eventsPath: 'test.json',
      );
      await cubit.loadEvents();
      cubit.search('closed');
      expect(cubit.state.filteredEvents.length, 1);
      expect(cubit.state.filteredEvents.first.id, 'e1');
      cubit.close();
    });

    test('filterByDirection filters events', () async {
      final source = _MockSource('[{"id":"e1","type":"t","source":"s","description":"d","direction":"publish"},{"id":"e2","type":"t","source":"s","description":"d","direction":"subscribe"}]');
      final cubit = EventCatalogCubit(
        source: source,
        eventsPath: 'test.json',
      );
      await cubit.loadEvents();
      cubit.filterByDirection('subscribe');
      expect(cubit.state.filteredEvents.length, 1);
      expect(cubit.state.filteredEvents.first.direction, 'subscribe');
      cubit.close();
    });
  });
}
