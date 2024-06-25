import 'package:dartz/dartz.dart';
import 'package:flutter_cos_challenge/app/features/auction/errors/auction_failures.dart';
import 'package:flutter_cos_challenge/app/features/auction/models/vehicle.dart';
import 'package:flutter_cos_challenge/app/features/auction/pages/cubit/auction_cubit.dart';
import 'package:flutter_cos_challenge/app/features/auction/repositories/auction_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuctionRepository extends Mock implements AuctionRepository {}

void main() {
  late MockAuctionRepository mockAuctionRepository;
  late AuctionCubit cubit;

  setUp(() {
    mockAuctionRepository = MockAuctionRepository();
    cubit = AuctionCubit(mockAuctionRepository);
  });

  test(
    'initial state should be AuctionInitial',
    () {
      expect(cubit.state, AuctionInitial());
    },
  );

  group('getAuctionDataFromVIN', () {
    const tVin = '1HGBH41JXMN109186';
    const tAuthToken = 'authToken';
    final vehicle = Vehicle(
      make: 'Ford',
      model: 'Focus',
      price: 1000,
      externalId: '1',
      containerName: 'containerName',
      similarity: 1,
      valuatedAt: DateTime.now(),
      feedback: 'feedback',
      positiveCustomerFeedback: true,
      auctionUuid: 'auctionUuid',
    );

    void setUpSuccessfulRepositoryCall() {
      when(() => mockAuctionRepository.getAuctionDataFromVIN(tVin,
          authToken: tAuthToken)).thenAnswer((_) async => Right([vehicle]));
    }

    test(
      'should call AuctionRepository.getAuctionDataFromVIN with the passed '
      'VIN and authToken',
      () {
        // arrange
        setUpSuccessfulRepositoryCall();

        // act
        cubit.getAuctionDataFromVIN(tVin, authToken: tAuthToken);

        // assert
        verify(
          () => mockAuctionRepository.getAuctionDataFromVIN(
            tVin,
            authToken: tAuthToken,
          ),
        );
      },
    );

    test(
      'should emit [AuctionLoading, AuctionLoaded] when the call to the '
      'repository is successful',
      () async {
        // arrange
        setUpSuccessfulRepositoryCall();

        // assert later
        expectLater(
          cubit.stream,
          emitsInOrder([
            AuctionLoading(),
            AuctionLoaded([vehicle])
          ]),
        );

        // act
        cubit.getAuctionDataFromVIN(tVin, authToken: tAuthToken);
        verifyNever(() => mockAuctionRepository.getAuctionDataFromCache(tVin));
      },
    );

    test(
      'should emit [AuctionLoading, AuctionError] when the call to the '
      'repository is unsuccessful and there is no cached data',
      () async {
        // arrange
        when(() => mockAuctionRepository.getAuctionDataFromVIN(tVin,
                authToken: tAuthToken))
            .thenAnswer(
                (_) async => Left(GetAuctionDataFromVINTimeoutFailure()));

        when(() => mockAuctionRepository.getAuctionDataFromCache(tVin))
            .thenAnswer((_) async => Left(GetAuctionDataFromCacheFailure()));

        // assert later
        expectLater(
          cubit.stream,
          emitsInOrder([
            AuctionLoading(),
            AuctionError(GetAuctionDataFromVINTimeoutFailure())
          ]),
        );

        // act
        cubit.getAuctionDataFromVIN(tVin, authToken: tAuthToken);
      },
    );

    test(
      'should emit [AuctionLoading, AuctionLoaded] when the call to the '
      'repository is unsuccessful but there is cached data',
      () async {
        // arrange
        when(() => mockAuctionRepository.getAuctionDataFromVIN(tVin,
                authToken: tAuthToken))
            .thenAnswer(
                (_) async => Left(GetAuctionDataFromVINTimeoutFailure()));

        when(() => mockAuctionRepository.getAuctionDataFromCache(tVin))
            .thenAnswer((_) async => Right(vehicle));

        // assert later
        expectLater(
          cubit.stream,
          emitsInOrder([
            AuctionLoading(),
            AuctionLoaded([vehicle], isFromCache: true)
          ]),
        );

        // act
        cubit.getAuctionDataFromVIN(tVin, authToken: tAuthToken);
      },
    );
  });
}
