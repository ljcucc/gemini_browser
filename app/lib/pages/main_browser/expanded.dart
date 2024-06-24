import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:gemini_browser/widgets/prompt/prompt_fab.dart';
import 'package:gemini_browser/widgets/toolbar/address_bar.dart';
import 'package:gemini_browser/widgets/toolbar/loading_indicator.dart';
import 'package:gemini_browser/widgets/toolbar/tabs_overview_icon.dart';
import 'package:provider/provider.dart';

class TopNavigationBar extends StatelessWidget {
  const TopNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SafeArea(
          minimum: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.navigate_before_outlined),
                onPressed: () {
                  final gcp = Provider.of<GeminiConnectionProvider>(context,
                      listen: false);
                  gcp.pop();
                },
              ),
              Gap(8),
              IconButton(
                icon: Icon(Icons.navigate_next_outlined),
                onPressed: () {},
              ),
              Gap(8),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {},
              ),
              Gap(8),
              Expanded(child: AddressBar()),
              Gap(8),
              IconButton(
                icon: TabsOverviewIcon(),
                onPressed: () {},
              ),
              Gap(8),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
        ),
        LoadingIndicator(),
      ],
    );
  }
}

class ExpandedLayout extends StatelessWidget {
  final Widget child;

  const ExpandedLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(children: [
              TopNavigationBar(),
              Expanded(child: child),
            ]),
          ),
          Consumer<GeminiConnectionProvider>(builder: (context, gcp, _) {
            if (gcp.connection.prompt == null) return Container();
            return Positioned.directional(
              bottom: 16,
              end: 16,
              child: PromptFab(),
              textDirection: Directionality.of(context),
            );
          }),
        ],
      ),
    );
  }
}
