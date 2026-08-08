import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/event_catalog_cubit.dart';
import 'blocs/contract_cubit.dart';
import 'blocs/workflow_cubit.dart';
import 'router.dart';
import 'theme.dart';

void main() {
  runApp(const QtCloudStudioApp());
}

class QtCloudStudioApp extends StatelessWidget {
  const QtCloudStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => EventCatalogCubit(eventsPath: 'assets/events.json'),
        ),
        BlocProvider(
          create: (_) => ContractCubit(contractsPath: 'assets/contracts.json'),
        ),
        BlocProvider(
          create: (_) => WorkflowCubit(workflowsPath: 'assets/workflows.json'),
        ),
      ],
      child: MaterialApp.router(
        title: '量潮云',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.create(),
      ),
    );
  }
}
