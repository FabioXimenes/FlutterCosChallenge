import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cos_challenge/app/core/clients/cos_challenge_client.dart';
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
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 64, left: 16, right: 16),
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
                        Card(
                          color: Colors.red[100]?.withOpacity(0.7),
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    state.failure.message,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.red,
                                          height: 1.15,
                                        ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                            if (currentUserState is! UserLoaded) {
                              context.goNamed(AuthenticationRoutes.signIn);
                              return;
                            }

                            await context
                                .read<AuctionCubit>()
                                .getAuctionDataFromVIN(vinController.text,
                                    authToken: currentUserState.user.token!);
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
