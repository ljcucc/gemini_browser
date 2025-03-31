import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/tabs_provider.dart';
import 'package:provider/provider.dart';

class TabsSheet extends StatelessWidget {
  const TabsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TabsProvider>(builder: (context, tp, _) {
      return Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: tp.tabs.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text("Tab $index"),
                onTap: () {},
              );
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SafeArea(
              minimum: EdgeInsets.all(16),
              child: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add),
              ),
            ),
          ),
        ],
      );
    });
  }
}

openTabsSheet(context) async {
  final tp = Provider.of<TabsProvider>(context, listen: false);
  await showModalBottomSheet(
    showDragHandle: true,
    builder: (context) {
      return ChangeNotifierProvider.value(
        value: tp,
        child: TabsSheet(),
      );
    },
    context: context,
  );
}
