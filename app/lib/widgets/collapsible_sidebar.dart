import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/sidebar_controller.dart';
import 'package:gemini_browser/widgets/tab_listview/tab_listview.dart';
import 'package:provider/provider.dart';

class CollapsibleSidebarView extends StatelessWidget {
  const CollapsibleSidebarView({super.key});

  @override
  Widget build(BuildContext context) {
    const double width = 300;
    final show = Provider.of<SidebarController>(context).show;

    final overflowHiddenBody = AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubicEmphasized,
      width: show ? width : 0,
      child: const SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: width,
          child: TabListView(),
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: overflowHiddenBody,
    );
  }
}
