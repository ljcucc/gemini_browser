import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';
import 'package:gemini_browser/providers/sidebar_controller.dart';
import 'package:gemini_browser/providers/split_view_controller.dart';
import 'package:gemini_browser/providers/split_view_list_controller.dart';
import 'package:gemini_browser/widgets/topbar/topbar_menu_button.dart';
import 'package:gemini_browser/widgets/topbar/urlbar.dart';
import 'package:provider/provider.dart';

class TopbarWidget extends StatelessWidget {
  /// Show sidebar or not
  final bool sidebar;

  const TopbarWidget({
    super.key,
    this.sidebar = true,
  });

  @override
  Widget build(BuildContext context) {
    final gcp = Provider.of<GeminiConnectionProvider>(context);
    final listController = Provider.of<SplitViewListController>(context);
    final controller = Provider.of<SplitViewController>(context);

    /// the screen width is smaller than medium that defined in material you guideline
    final LTMedium = MediaQuery.of(context).size.width < 840;

    final sidebarBtn = IconButton(
      onPressed: () {
        if (LTMedium) {
          Scaffold.of(context).openDrawer();
          return;
        }
        final controller =
            Provider.of<SidebarController>(context, listen: false);
        controller.show = !controller.show;
      },
      icon: RotatedBox(
        quarterTurns: 2,
        child: Icon(Icons.view_sidebar_outlined),
      ),
    );

    final body = Row(
      children: [
        if (sidebar) sidebarBtn,
        const Gap(8),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.refresh),
          padding: EdgeInsets.all(8),
        ),
        const Gap(8),
        IconButton(
          onPressed: () => gcp.pop(),
          icon: Icon(Icons.arrow_back),
          padding: EdgeInsets.all(8),
        ),
        Gap(8),
        IconButton(
          onPressed: null,
          icon: Icon(Icons.arrow_forward),
          padding: EdgeInsets.all(8),
        ),
        Expanded(
          child: UrlBarWidget(),
        ),
        // moreMenu,
        TopbarMenuButton(),
      ],
    );

    return StatefulBuilder(builder: (context, setState) {
      final topbar = Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom:
                BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          ),
        ),
        child: body,
      );

      return topbar;
    });
  }
}
