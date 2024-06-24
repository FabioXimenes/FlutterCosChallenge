// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      make: json['make'] as String,
      model: json['model'] as String,
      externalId: json['externalId'] as String,
      containerName: json['containerName'] as String?,
      similarity: (json['similarity'] as num?)?.toInt(),
      valuatedAt: json['valuatedAt'] == null
          ? null
          : DateTime.parse(json['valuatedAt'] as String),
      feedback: json['feedback'] as String?,
      positiveCustomerFeedback: json['positiveCustomerFeedback'] as bool?,
      auctionUuid: json['_fk_uuid_auction'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'make': instance.make,
      'model': instance.model,
      'externalId': instance.externalId,
      'containerName': instance.containerName,
      'similarity': instance.similarity,
      'valuatedAt': instance.valuatedAt?.toIso8601String(),
      'feedback': instance.feedback,
      'positiveCustomerFeedback': instance.positiveCustomerFeedback,
      '_fk_uuid_auction': instance.auctionUuid,
      'price': instance.price,
    };
