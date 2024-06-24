import 'package:flutter/material.dart';
import 'package:flutter_cos_challenge/app/features/auction/models/vehicle.dart';
import 'package:flutter_cos_challenge/app/features/auction/navigation/auction_routes.dart';
import 'package:go_router/go_router.dart';

class VehicleSelectionPage extends StatefulWidget {
  final List<Vehicle> vehicles;

  const VehicleSelectionPage({
    required this.vehicles,
    super.key,
  });

  @override
  State<VehicleSelectionPage> createState() => _VehicleSelectionPageState();
}

class _VehicleSelectionPageState extends State<VehicleSelectionPage> {
  late final List<Vehicle> sortedVehicles;

  @override
  void initState() {
    super.initState();

    // Sort the vehicles by similarity in descending order
    sortedVehicles = List.from(widget.vehicles)
      ..sort((a, b) => b.similarity?.compareTo(a.similarity ?? 0) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            children: [
              Text(
                'Vehicle Selection',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'We couldn\'t find an exact match for the provided VIN. Please select one of the vehicles below.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: sortedVehicles.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final vehicle = sortedVehicles[index];
                    return ListTile(
                      title: Text('${vehicle.make} - ${vehicle.model}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (vehicle.similarity != null)
                            Text('Similarity: ${vehicle.similarity!}%'),
                          Text('${vehicle.containerName}',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        context.pushReplacementNamed(
                          AuctionRoutes.details,
                          extra: (vehicle, false),
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
