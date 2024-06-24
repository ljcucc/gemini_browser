import 'package:flutter/material.dart';

class TabsOverviewIcon extends StatelessWidget {
  const TabsOverviewIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text("12")),
    );
  }
}
