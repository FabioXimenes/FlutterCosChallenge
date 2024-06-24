import 'package:flutter/material.dart';

class VehicleSelectionPage extends StatelessWidget {
  const VehicleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(
          child: Column(children: [Text('Vehicle Selection Page')])),
    );
  }
}
