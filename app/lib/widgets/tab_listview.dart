import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/tab_list_controller.dart';
import 'package:gemini_browser/widgets/tab_listview_item.dart';
import 'package:provider/provider.dart';

class TabListView extends StatelessWidget {
  const TabListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TabListController>(builder: (context, controller, _) {
      int index = controller.index;

      final tabs = [
        const Gap(8),
        for (final (int i, String id) in controller.tabs.indexed) ...[
          TabListviewItem(
            index: i,
            title: id,
            selected: index,
            onSelected: () {
              controller.index = i;
            },
          ),
          const Gap(8),
        ]
      ];

      final body = Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tabs"),
            const Gap(8),
            Expanded(
              child: ListView(
                children: tabs,
              ),
            ),
          ],
        ),
      );

      return Column(
        children: [
          Expanded(child: body),
        ],
      );
    });
  }
}
