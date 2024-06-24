import 'package:flutter_cos_challenge/app/core/resources_startup/resources_startup.dart';
import 'package:flutter_cos_challenge/app/features/auction/data_sources/auction_local_data_source.dart';
import 'package:flutter_cos_challenge/app/features/auction/data_sources/auction_remote_data_source.dart';
import 'package:flutter_cos_challenge/app/features/auction/repositories/auction_repository.dart';
import 'package:get_it/get_it.dart';

class AuctionResourcesStartup extends ResourcesStartup {
  @override
  Future<void> init(GetIt sl) async {
    sl.registerSingleton<AuctionLocalDataSource>(
        AuctionLocalDataSourceImpl(sl.get()));
    sl.registerSingleton<AuctionRemoteDataSource>(
        AuctionRemoteDataSourceImpl(sl.get()));
    sl.registerSingleton<AuctionRepository>(AuctionRepositoryImpl(
        remoteDataSource: sl.get(), localDataSource: sl.get()));
  }
}
