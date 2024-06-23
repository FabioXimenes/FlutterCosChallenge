import 'package:flutter_cos_challenge/app/core/errors/failures.dart';

class GetUserFailure extends Failure {
  @override
  String get message => 'Failed to get user from local storage.';
}
