import 'package:flutter_cos_challenge/app/features/auction/models/vehicle.dart';
import 'package:flutter_cos_challenge/app/features/auction/pages/auction_details_page.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class VehicleTest extends Vehicle {
  const VehicleTest({
    required String make,
    required String model,
    required double? price,
    required String externalId,
    required String? containerName,
    required int? similarity,
    required DateTime? valuatedAt,
    required String? feedback,
    required bool? positiveCustomerFeedback,
    required String? auctionUuid,
  }) : super(
          make: make,
          model: model,
          price: price,
          externalId: externalId,
          containerName: containerName,
          similarity: similarity,
          valuatedAt: valuatedAt,
          feedback: feedback,
          positiveCustomerFeedback: positiveCustomerFeedback,
          auctionUuid: auctionUuid,
        );

  VehicleTest copyWith({
    String? make,
    String? model,
    double? price,
    String? externalId,
    String? containerName,
    int? similarity,
    DateTime? valuatedAt,
    String? feedback,
    bool? positiveCustomerFeedback,
    String? auctionUuid,
  }) {
    return VehicleTest(
      make: make ?? this.make,
      model: model ?? this.model,
      price: price ?? this.price,
      externalId: externalId ?? this.externalId,
      containerName: containerName ?? this.containerName,
      similarity: similarity ?? this.similarity,
      valuatedAt: valuatedAt ?? this.valuatedAt,
      feedback: feedback ?? this.feedback,
      positiveCustomerFeedback:
          positiveCustomerFeedback ?? this.positiveCustomerFeedback,
      auctionUuid: auctionUuid ?? this.auctionUuid,
    );
  }
}

void main() {
  final vehicle = VehicleTest(
    make: 'Ford',
    model: 'Focus',
    price: 1000,
    externalId: '1',
    containerName: null,
    similarity: null,
    valuatedAt: DateTime(2024, 1, 1, 12),
    feedback: 'feedback',
    positiveCustomerFeedback: true,
    auctionUuid: 'auctionUuid',
  );

  testGoldens(
    'AuctionDetailsPage',
    (tester) async {
      await loadAppFonts();
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(
          devices: [Device.phone, Device.iphone11],
        )
        ..addScenario(
            widget: AuctionDetailsPage(vehicle: vehicle),
            name: 'Success and positive feedback')
        ..addScenario(
            widget: AuctionDetailsPage(
                vehicle: vehicle.copyWith(positiveCustomerFeedback: false)),
            name: 'Success and negative feedback')
        ..addScenario(
            widget: AuctionDetailsPage(
              vehicle: vehicle.copyWith(feedback: null),
              isFromCache: true,
            ),
            name: 'Error with but has cached data')
        ..addScenario(
          widget: const AuctionDetailsPage(
              vehicle: VehicleTest(
                  make: 'Ford',
                  model: 'Focus',
                  price: null,
                  externalId: 'externalId',
                  containerName: 'containerName',
                  similarity: 1,
                  valuatedAt: null,
                  feedback: null,
                  positiveCustomerFeedback: null,
                  auctionUuid: null)),
          name: 'Success from vehicle selection',
        );

      await tester.pumpDeviceBuilder(builder);

      await screenMatchesGolden(
        tester,
        'auction_details_page_success_positive_feedback',
      );
    },
  );
}
