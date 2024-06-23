import 'dart:convert';

import 'package:flutter_cos_challenge/app/core/clients/local_storage_client.dart';
import 'package:flutter_cos_challenge/app/features/auction/models/vehicle.dart';

abstract class AuctionLocalDataSource {
  Future<Vehicle?> getAuctionDataFromVIN(String vin);
  Future<void> cacheAuctionDataFromVIN(String vin, Vehicle vehicle);
}

class AuctionLocalDataSourceImpl implements AuctionLocalDataSource {
  final LocalStorageClient _localStorageClient;

  AuctionLocalDataSourceImpl(this._localStorageClient);

  @override
  Future<Vehicle?> getAuctionDataFromVIN(String vin) async {
    final vehicleString = await _localStorageClient.get(vin);

    if (vehicleString == null) return null;

    return Vehicle.fromJson(jsonDecode(vehicleString));
  }

  @override
  Future<void> cacheAuctionDataFromVIN(String vin, Vehicle vehicle) {
    return _localStorageClient.set(vin, jsonEncode(vehicle.toJson()));
  }
}
