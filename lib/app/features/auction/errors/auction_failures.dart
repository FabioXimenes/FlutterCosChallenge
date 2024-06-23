import 'package:flutter_cos_challenge/app/core/errors/failures.dart';

class GetAuctionDataFromVINFailure extends Failure {
  final String _message;

  GetAuctionDataFromVINFailure(this._message);

  @override
  String get message => _message;
}

class GetAuctionDataFromVINTimeoutFailure extends Failure {
  @override
  String get message => 'Failed to get auction data from VIN due to a timeout.';
}

class AuctionDataFromVINUnknownFailure extends Failure {
  @override
  String get message => 'Failed to get auction data from VIN.';
}
