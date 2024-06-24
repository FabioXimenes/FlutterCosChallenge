import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cos_challenge/app/features/auction/navigation/auction_routes.dart';
import 'package:flutter_cos_challenge/app/features/authentication/navigation/authentication_routes.dart';
import 'package:flutter_cos_challenge/app/features/authentication/pages/cubits/user/user_cubit.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Adding a delay just to simulate a loading splash screen. Usually you
    // don't need this and the splash screen will have a custom animation
    // with specific duration.
    Future.delayed(
      const Duration(seconds: 2),
      () => context.read<UserCubit>().getUser(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          context.goNamed(AuctionRoutes.initial);
        }

        if (state is UserError || state is UserInitial) {
          context.goNamed(AuthenticationRoutes.signIn);
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
