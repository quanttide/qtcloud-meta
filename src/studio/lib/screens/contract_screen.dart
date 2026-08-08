import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/contract_cubit.dart';
import '../blocs/event_catalog_cubit.dart';
import '../models/contract.dart';
import '../models/event.dart';
import '../constants.dart';

class ContractScreen extends StatefulWidget {
  final String eventId;

  const ContractScreen({super.key, required this.eventId});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ContractCubit>().loadContracts().then((_) {
      if (!mounted) return;
      context.read<ContractCubit>().selectContract(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('契约管理')),
      body: BlocBuilder<ContractCubit, ContractState>(
        builder: (context, state) {
          switch (state.status) {
            case ContractStatus.initial:
            case ContractStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ContractStatus.error:
              return Center(child: Text('加载失败: ${state.errorMessage}'));
            case ContractStatus.loaded:
              final event = _findEvent(context);
              final contracts = state.selectedContracts;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (event != null) _EventHeader(event: event),
                  if (contracts.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('该事件暂无订阅契约'),
                      ),
                    )
                  else
                    for (final contract in contracts)
                      _ContractSection(contract: contract),
                ],
              );
          }
        },
      ),
    );
  }

  Event? _findEvent(BuildContext context) {
    final eventState = context.read<EventCatalogCubit>().state;
    for (final e in eventState.events) {
      if (e.id == widget.eventId) return e;
    }
    return null;
  }
}

class _EventHeader extends StatelessWidget {
  final Event event;

  const _EventHeader({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.type,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('来源域: ${domainLabel(event.source)}',
                style: theme.textTheme.bodySmall),
            Text('版本: ${event.version}',
                style: theme.textTheme.bodySmall),
            Text('方向: ${eventDirectionLabel(event.direction)}',
                style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(event.description, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _ContractSection extends StatelessWidget {
  final Contract contract;

  const _ContractSection({required this.contract});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Schema', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('订阅域: ${domainLabel(contract.subscriberDomain)}'),
                Text('状态: ${contractStatusLabel(contract.status)}'),
                const SizedBox(height: 12),
                Text('字段列表', style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                if (contract.versions.isNotEmpty)
                  ..._parseFields(contract.versions.last.schemaJson).map(
                    (f) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Text('• ${f.name} ',
                              style: theme.textTheme.bodySmall),
                          Text('(${f.type})',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey)),
                          if (f.required)
                            const Text(' *', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  )
                else
                  const Text('无字段信息'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('订阅方', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Chip(label: Text(domainLabel(contract.subscriberDomain))),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('订阅此事件'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('版本变更', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                ...contract.versions.map((v) => ListTile(
                      dense: true,
                      leading: Icon(
                        v.status == 'active'
                            ? Icons.check_circle
                            : v.status == 'pending'
                                ? Icons.pending
                                : Icons.cancel,
                        color: contractStatusColor(v.status),
                      ),
                      title: Text(v.changeLog),
                      subtitle:
                          Text('v${v.id} · ${contractStatusLabel(v.status)}'),
                    )),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('提交流变更'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<SchemaField> _parseFields(String schemaJson) {
    try {
      final json = jsonDecode(schemaJson) as Map<String, dynamic>;
      final fields = json['fields'] as List<dynamic>;
      return fields
          .map((f) => SchemaField(
                name: f['name'].toString(),
                type: f['type'].toString(),
                required: f['required'] == true,
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
