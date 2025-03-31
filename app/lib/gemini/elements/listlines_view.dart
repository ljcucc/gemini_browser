import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gemini_browser/widgets/shaped_icon.dart';
import 'package:gemtext/types.dart';

class ListLinesView extends StatelessWidget {
  final ListLines content;
  const ListLinesView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          for (final line in content.items)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 25,
                  child: ShapedIcon(
                    degree: line.hashCode % 40 * 40,
                    color: Theme.of(context).colorScheme.outlineVariant,
                    child: Container(),
                    shape: ShapeTypes
                        .values[line.hashCode % ShapeTypes.values.length],
                  ),
                ),
                Gap(24),
                Expanded(
                    child: Text(
                        line.length > 2 ? line.substring(1).trimLeft() : "")),
              ],
            ),
        ],
      ),
    );
  }
}
