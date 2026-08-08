import 'package:go_router/go_router.dart';
import 'screens/event_catalog_screen.dart';
import 'screens/contract_screen.dart';
import 'screens/workflow_screen.dart';

class RouteConfig {
  final String path;
  final String title;

  const RouteConfig({required this.path, required this.title});
}

const routeConfigs = <String, RouteConfig>{
  'events': RouteConfig(path: '/events', title: '事件目录'),
  'contract': RouteConfig(path: '/contract/:eventId', title: '契约管理'),
  'workflows': RouteConfig(path: '/workflows', title: '流程编排'),
};

class AppRouter {
  static GoRouter create() {
    return GoRouter(
      initialLocation: '/events',
      routes: [
        GoRoute(
          path: '/',
          redirect: (context, state) => '/events',
        ),
        GoRoute(
          path: '/events',
          name: 'events',
          builder: (context, state) => const EventCatalogScreen(),
        ),
        GoRoute(
          path: '/contract/:eventId',
          name: 'contract',
          builder: (context, state) {
            final eventId = state.pathParameters['eventId'] ?? '';
            return ContractScreen(eventId: eventId);
          },
        ),
        GoRoute(
          path: '/workflows',
          name: 'workflows',
          builder: (context, state) => const WorkflowScreen(),
        ),
      ],
    );
  }
}
