part of 'event_catalog_cubit.dart';

enum EventCatalogStatus { initial, loading, loaded, error }

class EventCatalogState extends Equatable {
  final EventCatalogStatus status;
  final List<Event> events;
  final List<Event> filteredEvents;
  final String? errorMessage;
  final String searchQuery;
  final String? directionFilter;
  final String? statusFilter;

  const EventCatalogState({
    this.status = EventCatalogStatus.initial,
    this.events = const [],
    this.filteredEvents = const [],
    this.errorMessage,
    this.searchQuery = '',
    this.directionFilter,
    this.statusFilter,
  });

  EventCatalogState copyWith({
    EventCatalogStatus? status,
    List<Event>? events,
    List<Event>? filteredEvents,
    String? errorMessage,
    String? searchQuery,
    String? directionFilter,
    String? statusFilter,
  }) {
    return EventCatalogState(
      status: status ?? this.status,
      events: events ?? this.events,
      filteredEvents: filteredEvents ?? this.filteredEvents,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      directionFilter: directionFilter,
      statusFilter: statusFilter,
    );
  }

  @override
  List<Object?> get props => [
        status,
        events,
        filteredEvents,
        errorMessage,
        searchQuery,
        directionFilter,
        statusFilter,
      ];
}
