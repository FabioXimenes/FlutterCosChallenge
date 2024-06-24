import 'package:flutter_cos_challenge/app/features/auction/pages/auction_details_page.dart';
import 'package:flutter_cos_challenge/app/features/auction/pages/auction_vin_page.dart';
import 'package:flutter_cos_challenge/app/features/auction/pages/vehicle_selection_page.dart';
import 'package:go_router/go_router.dart';

class AuctionRoutes {
  static const String initial = 'auction-initial-vin';
  static const String vehicleSelection = 'auction-vehicle-selection';
  static const String details = 'auction-details';

  static final routes = [
    GoRoute(
      name: initial,
      path: '/auction',
      builder: (context, state) => const AuctionVINPage(),
    ),
    GoRoute(
      name: vehicleSelection,
      path: '/auction/vehicle-selection',
      builder: (context, state) => const VehicleSelectionPage(),
    ),
    GoRoute(
      name: details,
      path: '/auction/details',
      builder: (context, state) => const AuctionDetailsPage(),
    ),
  ];
}
