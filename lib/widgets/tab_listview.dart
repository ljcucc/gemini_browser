import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/tab_list_controller.dart';
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
          SizedBox(
            width: 200,
            child: Card(
              margin: EdgeInsets.zero,
              // shape:
              //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              color:
                  i == index ? Theme.of(context).colorScheme.secondary : null,
              shadowColor: Colors.transparent,
              child: InkWell(
                onTap: () {
                  controller.index = i;
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle_outlined,
                        color: i == index
                            ? Theme.of(context).colorScheme.onSecondary
                            : null,
                      ),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          id,
                          style: TextStyle(
                            color: i == index
                                ? Theme.of(context).colorScheme.onSecondary
                                : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
            const Text("Tabs"),
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
