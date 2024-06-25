import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cos_challenge/app/core/errors/failures.dart';
import 'package:flutter_cos_challenge/app/features/auction/models/vehicle.dart';
import 'package:flutter_cos_challenge/app/features/auction/repositories/auction_repository.dart';

part 'auction_state.dart';

class AuctionCubit extends Cubit<AuctionState> {
  final AuctionRepository _auctionRepository;

  AuctionCubit(this._auctionRepository) : super(AuctionInitial());

  Future<void> getAuctionDataFromVIN(String vin,
      {required String authToken}) async {
    emit(AuctionLoading());

    final auctionEither = await _auctionRepository.getAuctionDataFromVIN(
      vin,
      authToken: authToken,
    );

    auctionEither.fold(
      (failure) async {
        final cachedVehicleEither =
            await _auctionRepository.getAuctionDataFromCache(vin);

        cachedVehicleEither.fold(
          (_) => emit(AuctionError(failure)),
          (vehicle) => emit(AuctionLoaded([vehicle], isFromCache: true)),
        );
      },
      (vehicles) => emit(AuctionLoaded(vehicles)),
    );
  }
}
