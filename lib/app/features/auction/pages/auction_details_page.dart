import 'package:flutter/material.dart';
import 'package:flutter_cos_challenge/app/core/widgets/alert_widget.dart';
import 'package:flutter_cos_challenge/app/features/auction/models/vehicle.dart';
import 'package:intl/intl.dart';

class AuctionDetailsPage extends StatelessWidget {
  final Vehicle vehicle;
  final bool isFromCache;

  const AuctionDetailsPage({
    required this.vehicle,
    this.isFromCache = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Auction Details',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 32),
              if (isFromCache) ...[
                const _CacheInfoWidget(),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${vehicle.make} - ${vehicle.model}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  if (vehicle.price != null)
                    Text(
                      '€ ${vehicle.price!.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                ],
              ),
              if (vehicle.containerName != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Container: ${vehicle.containerName}',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
              if (vehicle.valuatedAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Valuated at: ${DateFormat('HH:mm, dd/MM/yyyy').format(vehicle.valuatedAt!)}',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
              if (vehicle.auctionUuid != null)
                Text(
                  'ID: ${vehicle.auctionUuid}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (vehicle.feedback != null &&
                  vehicle.positiveCustomerFeedback != null) ...[
                const SizedBox(height: 16),
                _FeedbackWidget(
                  feedback: vehicle.feedback!,
                  isPositive: vehicle.positiveCustomerFeedback!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackWidget extends StatelessWidget {
  final String feedback;
  final bool isPositive;

  const _FeedbackWidget({
    required this.feedback,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return AlertWidget(
      message: feedback,
      backgroundColor: isPositive
          ? Colors.greenAccent[100]?.withOpacity(0.7)
          : Colors.redAccent[100]?.withOpacity(0.7),
      icon: isPositive ? Icons.info : Icons.warning,
    );
  }
}

class _CacheInfoWidget extends StatelessWidget {
  const _CacheInfoWidget();

  @override
  Widget build(BuildContext context) {
    return AlertWidget(
      message:
          'We had a problem processing your request. You are seeing the last fetched data for the provided VIN which may be outdated.',
      icon: Icons.warning,
      backgroundColor: Colors.amberAccent[100],
    );
  }
}
