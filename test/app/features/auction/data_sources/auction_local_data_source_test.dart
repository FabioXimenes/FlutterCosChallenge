import 'dart:convert';

import 'package:flutter_cos_challenge/app/core/clients/local_storage_client.dart';
import 'package:flutter_cos_challenge/app/features/auction/data_sources/auction_local_data_source.dart';
import 'package:flutter_cos_challenge/app/features/auction/models/vehicle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalStorageClient extends Mock implements LocalStorageClient {}

void main() {
  late MockLocalStorageClient mockLocalStorageClient;
  late AuctionLocalDataSourceImpl auctionLocalDataSourceImpl;

  setUp(() {
    mockLocalStorageClient = MockLocalStorageClient();
    auctionLocalDataSourceImpl =
        AuctionLocalDataSourceImpl(mockLocalStorageClient);
  });

  group('getAuctionDataFromVIN', () {
    const tVin = '1HGBH41JXMN109186';
    final tVehicle = Vehicle(
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

    void setUpSuccessfulLocalStorageCall() {
      when(() => mockLocalStorageClient.get(any()))
          .thenAnswer((_) async => jsonEncode(tVehicle.toJson()));
    }

    test('should call LocalStorageClient.get with the passed VIN', () {
      // arrange
      setUpSuccessfulLocalStorageCall();

      // act
      auctionLocalDataSourceImpl.getAuctionDataFromVIN(tVin);

      // assert
      verify(() => mockLocalStorageClient.get(tVin)).called(1);
    });

    test('should return a Vehicle when there is one in the cache', () async {
      // arrange
      setUpSuccessfulLocalStorageCall();

      // act
      final result =
          await auctionLocalDataSourceImpl.getAuctionDataFromVIN(tVin);

      // assert
      expect(result, tVehicle);
    });

    test('should return null when there is no Vehicle in the cache', () async {
      // arrange
      when(() => mockLocalStorageClient.get(any()))
          .thenAnswer((_) async => null);

      // act
      final result =
          await auctionLocalDataSourceImpl.getAuctionDataFromVIN(tVin);

      // assert
      expect(result, isNull);
    });
  });

  group('cacheAuctionDataFromVIN', () {
    const tVin = '1HGBH41JXMN109186';
    final tVehicle = Vehicle(
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

    test('should call LocalStorageClient.set with the passed VIN and Vehicle',
        () {
      // arrange
      when(() => mockLocalStorageClient.set(any(), any()))
          .thenAnswer((_) async {});

      // act
      auctionLocalDataSourceImpl.cacheAuctionDataFromVIN(tVin, tVehicle);

      // assert
      verify(() =>
              mockLocalStorageClient.set(tVin, jsonEncode(tVehicle.toJson())))
          .called(1);
    });
  });
}
