import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/event_catalog_cubit.dart';
import '../views/event_card.dart';

class EventCatalogScreen extends StatefulWidget {
  const EventCatalogScreen({super.key});

  @override
  State<EventCatalogScreen> createState() => _EventCatalogScreenState();
}

class _EventCatalogScreenState extends State<EventCatalogScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EventCatalogCubit>().loadEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('事件目录')),
      body: BlocBuilder<EventCatalogCubit, EventCatalogState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: '搜索事件名称、来源域...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (query) {
                    context.read<EventCatalogCubit>().search(query);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _FilterDropdown(
                      label: '方向',
                      value: state.directionFilter,
                      items: const [null, 'publish', 'subscribe'],
                      itemLabels: const ['全部', '发布', '订阅'],
                      onChanged: (v) {
                        context.read<EventCatalogCubit>().filterByDirection(v);
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterDropdown(
                      label: '状态',
                      value: state.statusFilter,
                      items: const [null, 'active', 'deprecated'],
                      itemLabels: const ['全部', '活跃', '已弃用'],
                      onChanged: (v) {
                        context.read<EventCatalogCubit>().filterByStatus(v);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: _buildEventList(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEventList(EventCatalogState state) {
    switch (state.status) {
      case EventCatalogStatus.initial:
      case EventCatalogStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case EventCatalogStatus.error:
        return Center(child: Text('加载失败: ${state.errorMessage}'));
      case EventCatalogStatus.loaded:
        if (state.filteredEvents.isEmpty) {
          return const Center(child: Text('无匹配事件'));
        }
        return ListView.builder(
          itemCount: state.filteredEvents.length,
          itemBuilder: (context, index) {
            final event = state.filteredEvents[index];
            return EventCard(
              event: event,
              onTap: () => context.push('/contract/${event.id}'),
            );
          },
        );
    }
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String?> items;
  final List<String> itemLabels;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String?>(
      value: value,
      hint: Text(label),
      items: [
        for (int i = 0; i < items.length; i++)
          DropdownMenuItem(value: items[i], child: Text(itemLabels[i])),
      ],
      onChanged: onChanged,
    );
  }
}
