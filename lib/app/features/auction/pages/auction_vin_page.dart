import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cos_challenge/app/core/clients/cos_challenge_client.dart';
import 'package:flutter_cos_challenge/app/core/widgets/alert_widget.dart';
import 'package:flutter_cos_challenge/app/core/widgets/primary_button_widget.dart';
import 'package:flutter_cos_challenge/app/features/auction/navigation/auction_routes.dart';
import 'package:flutter_cos_challenge/app/features/auction/pages/cubits/auction/auction_cubit.dart';
import 'package:flutter_cos_challenge/app/features/auction/repositories/auction_repository.dart';
import 'package:flutter_cos_challenge/app/features/authentication/navigation/authentication_routes.dart';
import 'package:flutter_cos_challenge/app/features/authentication/pages/cubits/user/user_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class AuctionVINPage extends StatefulWidget {
  const AuctionVINPage({super.key});

  @override
  State<AuctionVINPage> createState() => _AuctionVINPageState();
}

class _AuctionVINPageState extends State<AuctionVINPage> {
  late final TextEditingController vinController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    vinController = TextEditingController();
  }

  @override
  void dispose() {
    vinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuctionCubit(GetIt.instance<AuctionRepository>()),
      child: BlocConsumer<AuctionCubit, AuctionState>(
        listener: (context, state) {
          if (state is AuctionLoaded) {
            if (state.vehicles.length == 1) {
              context.pushNamed(
                AuctionRoutes.details,
                extra: (state.vehicles.first, state.isFromCache),
              );
            } else {
              context.pushNamed(
                AuctionRoutes.vehicleSelection,
                extra: state.vehicles,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<UserCubit>().logout();
                  context.goNamed(AuthenticationRoutes.signIn);
                },
              ),
            ]),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Search VIN',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Type the Vehicle Identification Number (VIN) to get the auction details.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: formKey,
                        child: TextFormField(
                          controller: vinController,
                          decoration: const InputDecoration(
                            labelText: 'VIN',
                          ),
                          maxLength: CosChallenge.vinLength,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a VIN';
                            }
                            if (value.length != CosChallenge.vinLength) {
                              return 'VIN must be ${CosChallenge.vinLength} characters long';
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.characters,
                        ),
                      ),
                      if (state is AuctionError) ...[
                        const SizedBox(height: 16),
                        AlertWidget(
                          message: state.failure.message,
                          icon: Icons.error,
                          backgroundColor: Colors.red[100],
                          iconColor: Colors.red,
                          textColor: Colors.red,
                        ),
                      ],
                      const SizedBox(height: 16),
                      PrimaryButtonWidget(
                        text: 'Submit',
                        isLoading: state is AuctionLoading,
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            final userCubit = context.read<UserCubit>();

                            final currentUserState = userCubit.state;
                            if (currentUserState is! UserLoggedIn) {
                              context.goNamed(AuthenticationRoutes.signIn);
                              return;
                            }

                            await context
                                .read<AuctionCubit>()
                                .getAuctionDataFromVIN(
                                  vinController.text,
                                  authToken: currentUserState.user.token!,
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
