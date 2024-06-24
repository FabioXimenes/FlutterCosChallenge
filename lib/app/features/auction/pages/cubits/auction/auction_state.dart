part of 'auction_cubit.dart';

sealed class AuctionState extends Equatable {
  const AuctionState();

  @override
  List<Object> get props => [];
}

final class AuctionInitial extends AuctionState {}

final class AuctionLoading extends AuctionState {}

final class AuctionLoaded extends AuctionState {
  final List<Vehicle> vehicles;
  final bool isFromCache;

  const AuctionLoaded(this.vehicles, {this.isFromCache = false});

  @override
  List<Object> get props => [vehicles];
}

final class AuctionError extends AuctionState {
  final Failure failure;

  const AuctionError(this.failure);

  @override
  List<Object> get props => [failure];
}
