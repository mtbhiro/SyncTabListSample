import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_blueprint/ui/screens/root_page.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'root',
        path: '/',
        builder: (context, state) {
          return const RootPage();
        },
      ),
    ],
  );
});
