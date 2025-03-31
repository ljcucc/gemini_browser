import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/tabs_provider.dart';
import 'package:gemini_browser/widgets/toolbar/tabs_sheet.dart';
import 'package:provider/provider.dart';

class TabsOverviewIcon extends StatelessWidget {
  const TabsOverviewIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TabsProvider>(builder: (context, tp, _) {
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
        child: Center(
          child: Text(tp.tabs.length.toString()),
        ),
      );
    });
  }
}
