import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_cos_challenge/app/core/errors/exceptions.dart';
import 'package:flutter_cos_challenge/app/features/auction/data_sources/auction_local_data_source.dart';
import 'package:flutter_cos_challenge/app/features/auction/data_sources/auction_remote_data_source.dart';
import 'package:flutter_cos_challenge/app/features/auction/errors/auction_failures.dart';
import 'package:flutter_cos_challenge/app/features/auction/models/vehicle.dart';
import 'package:flutter_cos_challenge/app/features/auction/repositories/auction_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuctionLocalDataSource extends Mock
    implements AuctionLocalDataSource {}

class MockAuctionRemoteDataSource extends Mock
    implements AuctionRemoteDataSource {}

void main() {
  late MockAuctionLocalDataSource mockLocalDataSource;
  late MockAuctionRemoteDataSource mockRemoteDataSource;
  late AuctionRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockAuctionLocalDataSource();
    mockRemoteDataSource = MockAuctionRemoteDataSource();
    repository = AuctionRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

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

    void setUpSuccessfulRemoteDataSourceCall() {
      when(() => mockRemoteDataSource.getAuctionDataFromVIN(
            tVin,
            authToken: tAuthToken,
          )).thenAnswer((_) async => [vehicle, vehicle]);
    }

    test(
      'should call AuctionRmeoteDataSource.getAuctionDataFromVIN with the '
      'passed VIN and auth token',
      () {
        // arrange
        setUpSuccessfulRemoteDataSourceCall();

        // act
        repository.getAuctionDataFromVIN(tVin, authToken: tAuthToken);

        // assert
        verify(
          () => mockRemoteDataSource.getAuctionDataFromVIN(
            tVin,
            authToken: tAuthToken,
          ),
        );
      },
    );

    test(
      'should return a list of vehicles when the call to remote data source is '
      'successful',
      () async {
        // arrange
        setUpSuccessfulRemoteDataSourceCall();

        // act
        final result =
            await repository.getAuctionDataFromVIN(tVin, authToken: tAuthToken);

        // assert
        expect(result, isA<Right>());

        final vehicles = result.getOrElse(() => []);
        expect(vehicles, [vehicle, vehicle]);

        verifyZeroInteractions(mockLocalDataSource);
      },
    );

    test(
      'should call LocalDataSource.cacheAuctionDataFromVIN when the call to '
      'remote data source is successful and only one vehicle is returned',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getAuctionDataFromVIN(
              tVin,
              authToken: tAuthToken,
            )).thenAnswer((_) async => [vehicle]);

        // act
        await repository.getAuctionDataFromVIN(tVin, authToken: tAuthToken);

        // assert
        verify(
          () => mockLocalDataSource.cacheAuctionDataFromVIN(tVin, vehicle),
        ).called(1);
      },
    );

    test(
      'should return a GetAuctionDataFromVINTimeoutFailure when the call to '
      'remote data source times out',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getAuctionDataFromVIN(
              tVin,
              authToken: tAuthToken,
            )).thenThrow(TimeoutException(''));

        // act
        final result =
            await repository.getAuctionDataFromVIN(tVin, authToken: tAuthToken);

        // assert
        expect(result, Left(GetAuctionDataFromVINTimeoutFailure()));
      },
    );

    test(
      'should return a GetAuctionDataFromVINFailure when the call to remote '
      'data source fails with a ServerException',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getAuctionDataFromVIN(
              tVin,
              authToken: tAuthToken,
            )).thenThrow(const ServerException(''));

        // act
        final result =
            await repository.getAuctionDataFromVIN(tVin, authToken: tAuthToken);

        // assert
        expect(result, Left(GetAuctionDataFromVINFailure('')));
      },
    );

    test(
      'should return a AuctionDataFromVINUnknownFailure when the call to remote '
      'data source fails with an unknown exception',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getAuctionDataFromVIN(
              tVin,
              authToken: tAuthToken,
            )).thenThrow(Exception());

        // act
        final result =
            await repository.getAuctionDataFromVIN(tVin, authToken: tAuthToken);

        // assert
        expect(result, Left(AuctionDataFromVINUnknownFailure()));
      },
    );
  });

  group('getAuctionDataFromCache', () {
    const tVin = '1HGBH41JXMN109186';
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

    test(
      'should call LocalDataSource.getAuctionDataFromVIN with the passed VIN',
      () async {
        // arrange
        when(() => mockLocalDataSource.getAuctionDataFromVIN(tVin))
            .thenAnswer((_) async => vehicle);

        // act
        await repository.getAuctionDataFromCache(tVin);

        // assert
        verify(() => mockLocalDataSource.getAuctionDataFromVIN(tVin));
      },
    );

    test(
      'should return a NoCachedAuctionDataFailure when the call to local data '
      'source returns null',
      () async {
        // arrange
        when(() => mockLocalDataSource.getAuctionDataFromVIN(tVin))
            .thenAnswer((_) async => null);

        // act
        final result = await repository.getAuctionDataFromCache(tVin);

        // assert
        expect(result, Left(NoCachedAuctionDataFailure()));
      },
    );

    test(
      'should return a Vehicle when the call to local data source is successful',
      () async {
        // arrange
        when(() => mockLocalDataSource.getAuctionDataFromVIN(tVin))
            .thenAnswer((_) async => vehicle);

        // act
        final result = await repository.getAuctionDataFromCache(tVin);

        // assert
        expect(result, Right(vehicle));
      },
    );

    test(
      'should return a GetAuctionDataFromCacheFailure when the call to local '
      'data source fails',
      () async {
        // arrange
        when(() => mockLocalDataSource.getAuctionDataFromVIN(tVin))
            .thenThrow(Exception());

        // act
        final result = await repository.getAuctionDataFromCache(tVin);

        // assert
        expect(result, Left(GetAuctionDataFromCacheFailure()));
      },
    );
  });
}
