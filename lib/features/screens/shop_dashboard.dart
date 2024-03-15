import 'package:flutter/material.dart';

class ShopDashboard extends StatelessWidget {
  const ShopDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Dashboard screen",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
