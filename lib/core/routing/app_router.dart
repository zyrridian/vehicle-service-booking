import 'package:flutter/material.dart';
import '../../presentation/auth/pages/login_page.dart';

/// Centralized application routing. 
/// Consider using `go_router` or `auto_route` for more complex navigation graphs.
class AppRouter {
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
