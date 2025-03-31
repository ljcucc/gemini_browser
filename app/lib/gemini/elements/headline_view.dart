import 'package:flutter/material.dart';
import 'package:gemini_browser/fonts.dart';
import 'package:gemtext/types.dart';

class HeadingLineView extends StatelessWidget {
  final HeadingLine content;
  const HeadingLineView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final style = switch (content.level) {
      1 => const TextStyle(
          fontFamily: "RobotoFlex",
          fontSize: 36,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.5,
          fontVariations: fontVariations,
          // fontFamilyFallback: ["NotoEmoji"],
        ),
      2 => const TextStyle(
          fontFamily: "RobotoFlex",
          fontSize: 24,
          fontWeight: FontWeight.w400,
          fontVariations: fontVariations,
          // fontFamilyFallback: ["NotoEmoji"],
        ),
      3 => const TextStyle(
          fontFamily: "RobotoFlex",
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontVariations: fontVariations,
          // fontFamilyFallback: ["NotoEmoji"],
        ),
      int() => const TextStyle(),
    };

    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 32),
      child: Text.rich(
        TextSpan(
          children: [
            // TextSpan(
            //   text: " ".padLeft(content.level + 1, '#'),
            //   style: style.copyWith(
            //     color: Theme.of(context).colorScheme.outlineVariant,
            //   ),
            // ),
            TextSpan(
              text: content.text.trim(),
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}
