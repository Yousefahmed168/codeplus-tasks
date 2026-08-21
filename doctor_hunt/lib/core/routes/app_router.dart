import 'package:go_router/go_router.dart';

import 'app_routes.dart';

/// Central router.
///
/// The [GoRouter] instance is defined in [appRoutes].
/// Navigation is done via [context.go], [context.push], etc. using
/// the path constants from [AppRoutes], e.g.:
/// ```dart
/// context.go(AppRoutes.login);
/// context.push(AppRoutes.register);
/// ```
class AppRouter {
  AppRouter._();

  static final GoRouter router = appRouter;
}
