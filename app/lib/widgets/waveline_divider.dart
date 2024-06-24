import 'package:custom_waveline/custom_waveline.dart';
import 'package:flutter/material.dart';

class WavelineDivider extends StatelessWidget {
  const WavelineDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // constraints: BoxConstraints(maxWidth: 300),
        // padding: const EdgeInsets.all(24),
        child: CustomPaint(
          size: Size.fromHeight(60),
          painter: CustomWaveline(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            strokeWidth: 2,
            curveWidth: 24,
            curveHeight: 4,
          ),
        ),
      ),
    );
  }
}
