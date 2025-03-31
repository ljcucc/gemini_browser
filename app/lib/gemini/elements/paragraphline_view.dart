import 'package:flutter/material.dart';
import 'package:gemini_browser/widgets/waveline_divider.dart';
import 'package:gemtext/types.dart';

class ParagraphLineView extends StatelessWidget {
  final ParagraphLine content;

  const ParagraphLineView({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    if (content.source.trim().startsWith("--") ||
        content.source.trim().startsWith("==")) {
      return const WavelineDivider();
    }

    return Container(
      // constraints: const BoxConstraints(maxWidth: 500),
      // padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        content.source,
        style: const TextStyle(
          fontSize: 14,
          fontFamilyFallback: ["RobotoFlex"],
        ),
      ),
    );
  }
}
