import 'package:flutter/material.dart';
import 'package:gemini_browser/fonts.dart';

class StatusCodeWidget extends StatelessWidget {
  final String code;

  const StatusCodeWidget({
    super.key,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: Center(
        child: Text(
          code,
          style: const TextStyle(
            fontFamily: "RobotoFlex",
            fontVariations: fontVariations,
          ),
        ),
      ),
    );
  }
}
