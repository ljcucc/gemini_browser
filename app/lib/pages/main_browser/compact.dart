import 'package:flutter/material.dart';
import 'package:gemini_browser/pages/settings.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:gemini_browser/widgets/prompt/prompt_fab.dart';
import 'package:gemini_browser/widgets/toolbar/address_bar.dart';
import 'package:gemini_browser/widgets/toolbar/info_sheet.dart';
import 'package:gemini_browser/widgets/toolbar/loading_indicator.dart';
import 'package:gemini_browser/widgets/toolbar/site_info.dart';
import 'package:gemini_browser/widgets/toolbar/tabs_overview_icon.dart';
import 'package:provider/provider.dart';

class LabeledIconButton extends StatelessWidget {
  final String label;
  final Icon icon;
  final VoidCallback onTap;
  const LabeledIconButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        foregroundColor:
            WidgetStatePropertyAll(Theme.of(context).colorScheme.onSurface),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: icon,
          ),
          Text(label),
        ],
      ),
    );
  }
}

class MoreOptionSheet extends StatelessWidget {
  const MoreOptionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(24),
        child: Wrap(
          spacing: 0,
          children: [
            LabeledIconButton(
              onTap: () {},
              icon: Icon(Icons.share_outlined),
              label: "Share",
            ),
            LabeledIconButton(
              onTap: () {},
              icon: Icon(Icons.refresh_outlined),
              label: "Refresh",
            ),
            LabeledIconButton(
              onTap: () {},
              icon: Icon(Icons.find_in_page),
              label: "Find in page",
            ),
            LabeledIconButton(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return SettingsPage();
                    },
                  ),
                );
              },
              icon: Icon(Icons.settings_outlined),
              label: "Settigns",
            ),
            LabeledIconButton(
              onTap: () {},
              icon: Icon(Icons.help_outline),
              label: "Help",
            ),
          ],
        ),
      ),
    );
  }
}

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
