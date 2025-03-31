import 'package:flutter/material.dart';
import 'package:gemini_browser/gemini/gemini_browser_view.dart';
import 'package:gemini_browser/pages/main_browser/compact.dart';
import 'package:gemini_browser/pages/main_browser/expanded.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:gemini_browser/providers/tabs_provider.dart';
import 'package:provider/provider.dart';

class MainBrowserLayout extends StatefulWidget {
  const MainBrowserLayout({super.key});

  @override
  State<MainBrowserLayout> createState() => _MainBrowserLayoutState();
}

class _MainBrowserLayoutState extends State<MainBrowserLayout> {
  final tabs = TabsProvider();

  @override
  initState() {
    super.initState();

    final gcp = GeminiConnectionProvider();
    gcp.push(Uri.parse("gemini://gemini.ljcu.cc/project/browser/welcome.gmi"));

    tabs.tabs.add(gcp);
    tabs.setCurrentTab(0);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: tabs),
      ],
      child: Consumer<TabsProvider>(builder: (context, tp, _) {
        if (tp.currentTab == null) {
          return Text("tp.currentTab == null");
        }
        return ChangeNotifierProvider.value(
          value: tp.currentTab,
          child: Builder(builder: (context) {
            if (width < 600) {
              return const CompactLayout(child: GeminiBrowserView());
            }
            return const ExpandedLayout(child: GeminiBrowserView());
          }),
        );
      }),
    );
  }
}
