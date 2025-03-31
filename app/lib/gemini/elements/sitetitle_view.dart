import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gemini_browser/gemini/gemtext_view.dart';
import 'package:gemini_browser/widgets/shaped_icon.dart';
import 'package:gemtext/types.dart';

class SiteTitleView extends StatelessWidget {
  final SiteTitle content;
  const SiteTitleView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: ShapedIcon(
              color: Theme.of(context).colorScheme.inverseSurface,
              shape: ShapeTypes.values[
                  content.text.trim().hashCode % ShapeTypes.values.length],
              degree: content.text.hashCode % 9 * 40,
              child: Center(
                child: Text(
                  content.text.trim().characters.first,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontFamily: "RobotoFlex",
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.5,
                    fontVariations: fontVariations,
                    fontFamilyFallback: ["NotoEmoji"],
                  ),
                ),
              ),
            ),
          ),
          Gap(36),
          Text(
            content.text.trim(),
            style: TextStyle(
              fontFamily: "RobotoFlex",
              fontSize: 40,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.5,
              fontVariations: fontVariations,
              // fontFamilyFallback: ["NotoEmoji"],
            ),
            // textAlign: TextAlign.center,
          ),
          // SizedBox(
          //   width: 300,
          //   child: const WavelineDivider(),
          // ),
          // Gap(60),
        ],
      ),
    );
  }
}
