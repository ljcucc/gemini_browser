import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';
import 'package:gemini_browser/providers/sidebar_controller.dart';
import 'package:gemini_browser/widgets/urlbar.dart';
import 'package:provider/provider.dart';

class TopbarWidget extends StatelessWidget {
  const TopbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gcp = Provider.of<GeminiConnectionProvider>(context);

    bool isHover = false;

    final body = Row(
      children: [
        IconButton(
          onPressed: () {
            final controller =
                Provider.of<SidebarController>(context, listen: false);
            controller.show = !controller.show;
          },
          icon: RotatedBox(
            quarterTurns: 2,
            child: Icon(Icons.view_sidebar_outlined),
          ),
        ),
        Gap(8),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.refresh),
          padding: EdgeInsets.all(8),
        ),
        Gap(8),
        IconButton(
          onPressed: () => gcp.pop(),
          icon: Icon(Icons.arrow_back),
          padding: EdgeInsets.all(8),
        ),
        Gap(8),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_forward),
          padding: EdgeInsets.all(8),
        ),
        Expanded(
          child: UrlBarWidget(),
        ),
        IconButton(
          onPressed: () => {},
          icon: const Icon(Icons.more_vert),
        ),
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
