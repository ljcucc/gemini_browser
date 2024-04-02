import 'package:flutter/material.dart';
import 'package:gemini_browser/gemini/gemini_browser_view.dart';
import 'package:gemini_browser/providers/split_view_list_controller.dart';
import 'package:gemini_browser/widgets/topbar.dart';
import 'package:provider/provider.dart';

class SplitViewListWidget extends StatelessWidget {
  const SplitViewListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplitViewListController>(
      builder: (context, controller, _) {
        return Row(
          children: [
            for (final (index, value) in controller.splitedView.indexed)
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant
                            .withOpacity(index == 0 ? 0 : 1),
                      ),
                    ),
                  ),
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(value: value),
                      ChangeNotifierProvider.value(
                          value: value.connectionProvider),
                    ],
                    child: Column(
                      children: [
                        TopbarWidget(
                          sidebar: index == 0,
                        ),
                        Expanded(
                          child: const GeminiBrowserView(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
