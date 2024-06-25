import 'dart:convert';

import 'package:flutter_cos_challenge/app/core/clients/api_client.dart';
import 'package:flutter_cos_challenge/app/core/clients/cos_challenge_client.dart';
import 'package:flutter_cos_challenge/app/core/errors/exceptions.dart';
import 'package:flutter_cos_challenge/app/features/auction/data_sources/auction_remote_data_source.dart';
import 'package:flutter_cos_challenge/app/features/auction/models/vehicle.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockAPIClient extends Mock implements APIClient {}

void main() {
  late MockAPIClient mockAPIClient;
  late AuctionRemoteDataSourceImpl auctionRemoteDataSourceImpl;

  setUp(() {
    mockAPIClient = MockAPIClient();
    auctionRemoteDataSourceImpl = AuctionRemoteDataSourceImpl(mockAPIClient);
  });

  group('getAuctionDataFromVIN', () {
    const tVin = '1HGBH41JXMN109186';
    const tAuthToken = 'authToken';
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

    void setUpSuccessfulAPIClientCall() {
      when(() => mockAPIClient.get(
                host: any(named: 'host'),
                endpoint: any(named: 'endpoint'),
                headers: any(named: 'headers'),
              ))
          .thenAnswer(
              (_) async => Response(jsonEncode(tVehicle.toJson()), 200));
    }

    test(
      'should call APIClient.get with the correct data',
      () async {
        // arrange
        setUpSuccessfulAPIClientCall();

        // act
        await auctionRemoteDataSourceImpl.getAuctionDataFromVIN(
          tVin,
          authToken: tAuthToken,
        );

        // assert
        verify(() => mockAPIClient.get(
              host: 'api.cos.com',
              endpoint: '/vehicles/$tVin',
              headers: {CosChallenge.user: tAuthToken},
            )).called(1);
      },
    );

    test(
      'should return a List<Vehicle> with a single item when the status '
      'code is 200',
      () async {
        // arrange
        setUpSuccessfulAPIClientCall();

        // act
        final result = await auctionRemoteDataSourceImpl.getAuctionDataFromVIN(
          tVin,
          authToken: tAuthToken,
        );

        // assert
        expect(result, [tVehicle]);
      },
    );

    test(
      'should return a List<Vehicle> with multiple items when the status '
      'code is 300',
      () async {
        // arrange
        when(() => mockAPIClient.get(
              host: any(named: 'host'),
              endpoint: any(named: 'endpoint'),
              headers: any(named: 'headers'),
            )).thenAnswer(
          (_) async => Response(
            jsonEncode([
              tVehicle.toJson(),
              tVehicle.toJson(),
              tVehicle.toJson(),
            ]),
            300,
          ),
        );

        // act
        final result = await auctionRemoteDataSourceImpl.getAuctionDataFromVIN(
          tVin,
          authToken: tAuthToken,
        );

        // assert
        expect(result, [tVehicle, tVehicle, tVehicle]);
      },
    );

    test(
      'should throw a ServerException when the status code is 400',
      () async {
        // arrange
        when(() => mockAPIClient.get(
              host: any(named: 'host'),
              endpoint: any(named: 'endpoint'),
              headers: any(named: 'headers'),
            )).thenAnswer(
          (_) async => Response(
            jsonEncode({'message': 'error message'}),
            400,
          ),
        );

        // act
        final call = auctionRemoteDataSourceImpl.getAuctionDataFromVIN(
          tVin,
          authToken: tAuthToken,
        );

        // assert
        expect(call, throwsA(const ServerException('error message')));
      },
    );

    test(
      'should throw a ServerException when the status code is not 200, 300, '
      'or 400',
      () async {
        // arrange
        when(() => mockAPIClient.get(
              host: any(named: 'host'),
              endpoint: any(named: 'endpoint'),
              headers: any(named: 'headers'),
            )).thenAnswer(
          (_) async => Response('error message', 500),
        );

        // act
        final call = auctionRemoteDataSourceImpl.getAuctionDataFromVIN(
          tVin,
          authToken: tAuthToken,
        );

        // assert
        expect(
            call,
            throwsA(
                const ServerException('Failed to get auction data from VIN.')));
      },
    );
  });
}
