import 'package:flutter_cos_challenge/app/features/authentication/pages/sign_in_page.dart';
import 'package:go_router/go_router.dart';

class AuthenticationRoutes {
  static const signIn = 'sign-in';

  static final routes = [
    GoRoute(
      name: signIn,
      path: '/sign-in',
      builder: (context, state) => const SignInPage(),
    ),
  ];
}
