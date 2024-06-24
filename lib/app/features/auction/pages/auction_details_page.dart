import 'package:flutter/material.dart';

class AuctionDetailsPage extends StatelessWidget {
  const AuctionDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(
        child: Column(
          children: [
            Text('Auction Page'),
          ],
        ),
      ),
    );
  }
}
