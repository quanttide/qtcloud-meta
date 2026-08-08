import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/workflow.dart';
import '../blocs/workflow_cubit.dart';
import '../views/workflow_chain.dart';
import '../constants.dart';

class WorkflowScreen extends StatefulWidget {
  const WorkflowScreen({super.key});

  @override
  State<WorkflowScreen> createState() => _WorkflowScreenState();
}

class _WorkflowScreenState extends State<WorkflowScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<WorkflowCubit>().loadWorkflows();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('流程编排')),
      body: BlocBuilder<WorkflowCubit, WorkflowState>(
        builder: (context, state) {
          switch (state.status) {
            case WorkflowStatusState.initial:
            case WorkflowStatusState.loading:
              return const Center(child: CircularProgressIndicator());
            case WorkflowStatusState.error:
              return Center(child: Text('加载失败: ${state.errorMessage}'));
            case WorkflowStatusState.loaded:
              return Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: '预置'),
                      Tab(text: '自定义'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _PresetTab(workflows: state.workflows),
                        const _CustomTab(),
                      ],
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}

class _PresetTab extends StatelessWidget {
  final List<Workflow> workflows;

  const _PresetTab({required this.workflows});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final w in workflows)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          w.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Switch(
                        value: w.status == 'enabled',
                        onChanged: (_) {
                          context.read<WorkflowCubit>().toggleWorkflow(w.id);
                        },
                      ),
                      Text(
                        workflowStatusLabel(w.status),
                        style: TextStyle(
                          color: workflowStatusColor(w.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final step in w.steps)
                    WorkflowChain(
                      step: step,
                      isEnabled: w.status == 'enabled',
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _CustomTab extends StatelessWidget {
  const _CustomTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text('暂无自定义流程'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('创建新流程'),
          ),
        ],
      ),
    );
  }
}
