import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/tab_list_controller.dart';
import 'package:gemini_browser/widgets/tab_listview/tab_listview_item.dart';
import 'package:provider/provider.dart';

class TabListView extends StatelessWidget {
  const TabListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TabListController>(context);

    final tabs = [
      const Gap(8),
      for (final (int i, String id) in controller.tabs.indexed) ...[
        TabListViewItem(
          indent: 0,
          index: i,
          title: id,
        ),
        const Gap(8),
      ]
    ];

    final appbar = AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      title: Text("Tabs"),
      actions: [
        IconButton(
          onPressed: () {
            controller.newTab("new tab");
          },
          icon: Icon(Icons.add_rounded),
        ),
        Gap(4),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.folder_outlined),
        ),
        Gap(4),
      ],
    );

    final body = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appbar,
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
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
  }
}
