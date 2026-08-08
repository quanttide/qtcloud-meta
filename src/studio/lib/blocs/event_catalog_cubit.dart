import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/event.dart';
import '../sources/data_source.dart';

part 'event_catalog_state.dart';

class EventCatalogCubit extends Cubit<EventCatalogState> {
  final DataLoader<List<Event>> _loader;

  EventCatalogCubit({
    DataSource? source,
    required String eventsPath,
  }) : _loader = DataLoader<List<Event>>(
          source ?? BundleSource(),
          eventsPath,
          _parseEventList,
        ),
        super(const EventCatalogState());

  static List<Event> _parseEventList(dynamic json) {
    return (json as List<dynamic>)
        .map((e) => Event.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> loadEvents() async {
    emit(state.copyWith(status: EventCatalogStatus.loading));
    final result = await _loader.load();
    switch (result) {
      case DataSuccess<List<Event>>():
        emit(state.copyWith(
          status: EventCatalogStatus.loaded,
          events: result.data,
          filteredEvents: result.data,
        ));
      case DataError<List<Event>>():
        emit(state.copyWith(
          status: EventCatalogStatus.error,
          errorMessage: result.message,
        ));
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(filteredEvents: state.events, searchQuery: ''));
      return;
    }
    final filtered = state.events.where((event) {
      return event.type.toLowerCase().contains(query.toLowerCase()) ||
          event.source.toLowerCase().contains(query.toLowerCase()) ||
          event.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
    emit(state.copyWith(
      filteredEvents: filtered,
      searchQuery: query,
    ));
  }

  void filterByDirection(String? direction) {
    emit(state.copyWith(directionFilter: direction));
    _applyFilters();
  }

  void filterByStatus(String? status) {
    emit(state.copyWith(statusFilter: status));
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = List<Event>.from(state.events);
    if (state.directionFilter != null && state.directionFilter!.isNotEmpty) {
      filtered = filtered.where((e) => e.direction == state.directionFilter).toList();
    }
    if (state.statusFilter != null && state.statusFilter!.isNotEmpty) {
      filtered = filtered.where((e) => e.status == state.statusFilter).toList();
    }
    if (state.searchQuery.isNotEmpty) {
      filtered = filtered.where((event) {
        return event.type.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
            event.source.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
            event.description.toLowerCase().contains(state.searchQuery.toLowerCase());
      }).toList();
    }
    emit(state.copyWith(filteredEvents: filtered));
  }
}
