import 'package:flutter_cos_challenge/app/features/splash/pages/splash_page.dart';
import 'package:go_router/go_router.dart';

class SplashRoutes {
  static const splash = 'splash';

  static final routes = [
    GoRoute(
      name: splash,
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
  ];
}
