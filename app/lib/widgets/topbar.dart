import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';
import 'package:gemini_browser/providers/sidebar_controller.dart';
import 'package:gemini_browser/providers/split_view_controller.dart';
import 'package:gemini_browser/providers/split_view_list_controller.dart';
import 'package:gemini_browser/widgets/urlbar.dart';
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

    bool isHover = false;

    final moreMenu = PopupMenuButton(
      popUpAnimationStyle: AnimationStyle.noAnimation,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      enableFeedback: true,
      icon: Icon(Icons.more_vert),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (_) => <PopupMenuEntry>[
        if (listController.splitedView.length > 1)
          PopupMenuItem(
            onTap: () {
              listController.close(controller);
            },
            child: ListTile(
              leading: Icon(Icons.close),
              title: Text("Close window"),
            ),
          ),
        PopupMenuItem(
          onTap: () {
            listController.newSplit();
          },
          child: ListTile(
            leading: RotatedBox(
              quarterTurns: 1,
              child: Icon(Icons.splitscreen),
            ),
            title: Text("New window"),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          onTap: () {},
          child: ListTile(
            leading: Icon(Icons.find_in_page_rounded),
            title: Text("Find in page"),
          ),
        ),
        PopupMenuItem(
          onTap: () {},
          child: ListTile(
            leading: Icon(Icons.code),
            title: Text("Inspector"),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          onTap: () {},
          child: ListTile(
            leading: Icon(Icons.history_rounded),
            title: Text("History"),
          ),
        ),
        PopupMenuItem(
          onTap: () {},
          child: ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text("Settings"),
          ),
        ),
      ],
    );

    final sidebarBtn = IconButton(
      onPressed: () {
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
        moreMenu,
      ],
    );

    return StatefulBuilder(builder: (context, setState) {
      final topbar = MouseRegion(
        onEnter: (event) => setState(() => isHover = true),
        onExit: (event) => setState(() => isHover = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(isHover ? 1 : 01),
              ),
            ),
          ),
          child: body,
        ),
      );

      return topbar;
    });
  }
}
