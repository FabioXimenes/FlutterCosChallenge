import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cos_challenge/app/features/auction/navigation/auction_routes.dart';
import 'package:flutter_cos_challenge/app/features/authentication/navigation/authentication_routes.dart';
import 'package:flutter_cos_challenge/app/features/authentication/pages/cubits/user/user_cubit.dart';
import 'package:flutter_cos_challenge/app/features/splash/navigation/splash_routes.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ...SplashRoutes.routes,
    ...AuthenticationRoutes.routes,
    ...AuctionRoutes.routes,
  ],
  debugLogDiagnostics: true,
);

class CosChallengeApp extends StatelessWidget {
  const CosChallengeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return BlocProvider(
          create: (_) => UserCubit(GetIt.instance.get()),
          child: child,
        );
      },
      routerConfig: _router,
    );
  }
}
