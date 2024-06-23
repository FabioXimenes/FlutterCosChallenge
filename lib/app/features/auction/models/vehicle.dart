import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';

@JsonSerializable()
class Vehicle extends Equatable {
  final String make;
  final String model;
  final String externalId;
  final String? containerName;
  final int? similarity;
  final DateTime? valuatedAt;
  final String? feedback;
  final bool? positiveCustomerFeedback;
  @JsonKey(name: '_fk_uuid_auction')
  final String auctionUuid;
  final double? price;

  const Vehicle({
    required this.make,
    required this.model,
    required this.externalId,
    required this.containerName,
    required this.similarity,
    required this.valuatedAt,
    required this.feedback,
    required this.positiveCustomerFeedback,
    required this.auctionUuid,
    required this.price,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleToJson(this);

  @override
  List<Object?> get props => [
        make,
        model,
        externalId,
        containerName,
        similarity,
        valuatedAt,
        feedback,
        positiveCustomerFeedback,
        auctionUuid,
      ];
}
