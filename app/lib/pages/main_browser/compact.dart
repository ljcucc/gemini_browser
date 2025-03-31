import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:gemini_browser/widgets/prompt/prompt_fab.dart';
import 'package:gemini_browser/widgets/toolbar/address_bar.dart';
import 'package:gemini_browser/widgets/toolbar/info_sheet.dart';
import 'package:gemini_browser/widgets/toolbar/loading_indicator.dart';
import 'package:gemini_browser/widgets/toolbar/more_option/more_option_sheet.dart';
import 'package:gemini_browser/widgets/toolbar/tabs_overview_icon.dart';
import 'package:gemini_browser/widgets/toolbar/tabs_sheet.dart';
import 'package:provider/provider.dart';

class MobileBottomNavigationBar extends StatefulWidget {
  const MobileBottomNavigationBar({
    super.key,
  });

  @override
  State<MobileBottomNavigationBar> createState() =>
      _MobileBottomNavigationBarState();
}

class _MobileBottomNavigationBarState extends State<MobileBottomNavigationBar> {
  PersistentBottomSheetController? infoSheetCtrl, moreMenuCtrl;

  onBack() async {
    final gcp = Provider.of<GeminiConnectionProvider>(context, listen: false);
    gcp.pop();
  }

  onBrowse() async {
    final gcp = Provider.of<GeminiConnectionProvider>(context, listen: false);
    showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      builder: (context) => ChangeNotifierProvider.value(
        value: gcp,
        child: const InfoSheet(),
      ),
      elevation: 2,
      context: context,
    );
  }

  onMore() async {
    showModalBottomSheet(
      elevation: 2,
      enableDrag: true,
      // showDragHandle: true,
      builder: (context) => const MoreOptionSheet(),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      indicatorColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      onDestinationSelected: (index) async {
        switch (index) {
          case 0: // Back
            onBack();
            break;
          case 2:
            onBrowse();
            break;
          case 3:
            openTabsSheet(context);
            break;
          case 4:
            onMore();
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.navigate_before_outlined),
          label: 'Back',
        ),
        NavigationDestination(
          icon: Icon(Icons.navigate_next_outlined),
          label: 'Forwawrd',
          enabled: false,
        ),
        NavigationDestination(
          icon: Icon(Icons.info_outline),
          label: 'Browse',
        ),
        NavigationDestination(
          icon: TabsOverviewIcon(),
          label: 'Tabs',
        ),
        NavigationDestination(
          icon: Icon(Icons.more_vert),
          label: 'More',
        ),
      ],
    );
  }
}

class CompactLayout extends StatefulWidget {
  final Widget child;
  const CompactLayout({super.key, required this.child});

  @override
  State<CompactLayout> createState() => _CompactLayoutState();
}

class _CompactLayoutState extends State<CompactLayout> {
  @override
  Widget build(BuildContext context) {
    final bottomBar = Container(
      padding: const EdgeInsets.all(8),
      child: const AddressBar(),
    );

    final fab = Consumer<GeminiConnectionProvider>(builder: (context, gcp, _) {
      return gcp.connection.prompt != null ? const PromptFab() : Container();
    });

    return Scaffold(
      bottomNavigationBar: Builder(builder: (context) {
        // Builder is make sure showBottomSheet found Scaffold, otherwise an error will thrown.
        return const MobileBottomNavigationBar();
      }),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            SafeArea(child: Container()),
            bottomBar,
            const LoadingIndicator(),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(child: widget.child),
                  Positioned.directional(
                    bottom: 16,
                    end: 16,
                    child: fab,
                    textDirection: Directionality.of(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
