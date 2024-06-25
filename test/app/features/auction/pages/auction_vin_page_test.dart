import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cos_challenge/app/core/clients/cos_challenge_client.dart';
import 'package:flutter_cos_challenge/app/core/widgets/alert_widget.dart';
import 'package:flutter_cos_challenge/app/features/auction/errors/auction_failures.dart';
import 'package:flutter_cos_challenge/app/features/auction/pages/auction_vin_page.dart';
import 'package:flutter_cos_challenge/app/features/auction/repositories/auction_repository.dart';
import 'package:flutter_cos_challenge/app/features/authentication/models/user.dart';
import 'package:flutter_cos_challenge/app/features/authentication/pages/cubits/user/user_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockUserCubit extends Mock implements UserCubit {}

class MockAuctionRepository extends Mock implements AuctionRepository {}

void main() {
  late UserCubit userCubit;
  late MockAuctionRepository mockAuctionRepository;

  setUp(() {
    userCubit = MockUserCubit();
    mockAuctionRepository = MockAuctionRepository();

    when(() => userCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => userCubit.state).thenReturn(
      const UserLoggedIn(
        User(password: 'password', email: 'email', token: 'token'),
      ),
    );

    GetIt.instance.registerSingleton<AuctionRepository>(mockAuctionRepository);
  });

  Widget buildWidget() {
    return MaterialApp(
      builder: (context, child) => BlocProvider.value(
        value: userCubit,
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => const AuctionVINPage(),
            )
          ],
        ),
      ),
    );
  }

  testWidgets(
    'should be able to fill VIN and see errors when they happen',
    (tester) async {
      await tester.pumpWidget(buildWidget());

      // Check if the sign out button is present
      expect(find.byIcon(Icons.logout), findsOneWidget);

      // Check if the submit button is present
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);

      // Check if the VIN field is present
      expect(find.byType(TextFormField), findsOneWidget);

      // Tap the submit button and check if the validation is working
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Check if the error message is present
      expect(find.text('Please enter a VIN'), findsOneWidget);

      // Fill the VIN with a wrong value and check if the validation is working
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'AAA456789012345');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      expect(find.text('VIN must be ${CosChallenge.vinLength} characters long'),
          findsOneWidget);

      // Fill the VIN with a correct value
      await tester.enterText(find.byType(TextFormField), 'AAA45678901234567');
      await tester.pumpAndSettle();

      // Mock an error
      when(() => mockAuctionRepository.getAuctionDataFromVIN(any(),
              authToken: any(named: 'authToken')))
          .thenAnswer((_) async => Left(GetAuctionDataFromVINFailure('error')));
      when(() => mockAuctionRepository.getAuctionDataFromCache(any()))
          .thenAnswer((_) async => Left(GetAuctionDataFromCacheFailure()));

      // Check if the validation is working
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a VIN'), findsNothing);
      expect(
        find.text('VIN must be ${CosChallenge.vinLength} characters long'),
        findsNothing,
      );

      // Check if the Auction error message is present
      expect(
        find.byWidgetPredicate(
            (widget) => widget is AlertWidget && widget.message == 'error'),
        findsOneWidget,
      );
    },
  );
}
