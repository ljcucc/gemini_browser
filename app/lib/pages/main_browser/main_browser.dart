import 'package:flutter/material.dart';
import 'package:gemini_browser/gemini/gemini_browser_view.dart';
import 'package:gemini_browser/pages/main_browser/compact.dart';
import 'package:gemini_browser/pages/main_browser/expanded.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';
import 'package:provider/provider.dart';

class MainBrowserLayout extends StatefulWidget {
  const MainBrowserLayout({super.key});

  @override
  State<MainBrowserLayout> createState() => _MainBrowserLayoutState();
}

class _MainBrowserLayoutState extends State<MainBrowserLayout> {
  final gcp = GeminiConnectionProvider();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: gcp),
      ],
      child: Builder(builder: (context) {
        if (width < 600) {
          return const CompactLayout(child: GeminiBrowserView());
        }
        return const ExpandedLayout(child: GeminiBrowserView());
      }),
    );
  }
}
