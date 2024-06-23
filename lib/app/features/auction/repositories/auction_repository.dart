import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_cos_challenge/app/core/errors/exceptions.dart';
import 'package:flutter_cos_challenge/app/core/errors/failures.dart';
import 'package:flutter_cos_challenge/app/features/auction/data_sources/auction_local_data_source.dart';
import 'package:flutter_cos_challenge/app/features/auction/data_sources/auction_remote_data_source.dart';
import 'package:flutter_cos_challenge/app/features/auction/errors/auction_failures.dart';
import 'package:flutter_cos_challenge/app/features/auction/models/vehicle.dart';

abstract class AuctionRepository {
  Future<Either<Failure, List<Vehicle>>> getAuctionDataFromVIN(
    String vin, {
    required String authToken,
  });
}

class AuctionRepositoryImpl implements AuctionRepository {
  final AuctionRemoteDataSource _remoteDataSource;
  final AuctionLocalDataSource _localDataSource;

  AuctionRepositoryImpl(
      {required AuctionRemoteDataSource remoteDataSource,
      required AuctionLocalDataSource localDataSource})
      : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<Vehicle>>> getAuctionDataFromVIN(String vin,
      {required String authToken}) async {
    try {
      final vehicles = await _remoteDataSource.getAuctionDataFromVIN(
        vin,
        authToken: authToken,
      );

      // We will cache the auction data for the vehicle if there is only one
      // vehicle returned from the API. This means we found an exact match for
      // the VIN.
      if (vehicles.length == 1) {
        try {
          await _localDataSource.cacheAuctionDataFromVIN(vin, vehicles.first);
        } catch (_) {
          // We don't want to fail the operation if the cache fails.
        }
      }

      return Right(vehicles);
    } on TimeoutException {
      return Left(GetAuctionDataFromVINTimeoutFailure());
    } on ServerException catch (e) {
      return Left(GetAuctionDataFromVINFailure(e.message));
    } catch (e) {
      return Left(AuctionDataFromVINUnknownFailure());
    }
  }
}
