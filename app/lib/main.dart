import 'package:flutter/material.dart';
import 'package:gemini_browser/gemini/gemini_browser_view.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';
import 'package:gemini_browser/providers/sidebar_controller.dart';
import 'package:gemini_browser/providers/split_view_list_controller.dart';
import 'package:gemini_browser/providers/tab_list_controller.dart';
import 'package:gemini_browser/widgets/collapsible_sidebar.dart';
import 'package:gemini_browser/widgets/split_view_list.dart';
import 'package:gemini_browser/widgets/topbar.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!(Platform.isIOS || Platform.isAndroid)) {
    await windowManager.ensureInitialized();
    windowManager.setTitle("");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (!(Platform.isIOS || Platform.isAndroid)) {
      windowManager.setTitle("New page");
    }
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => GeminiConnectionProvider()),
        ChangeNotifierProvider(create: (_) => SidebarController()),
        ChangeNotifierProvider(create: (_) => TabListController()),
        ChangeNotifierProvider(create: (_) => SplitViewListController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 170, 223, 35),
            brightness: MediaQuery.of(context).platformBrightness,
          ),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    divider() => Divider(
          height: 1,
          indent: 0,
          endIndent: 0,
          color: Theme.of(context).colorScheme.outlineVariant,
        );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            divider(),
            const Expanded(
              child: Row(
                children: [
                  CollapsibleSidebarView(),
                  Expanded(
                    child: SplitViewListWidget(),
                  ),
                ],
              ),
            ),
            divider(),
          ],
        ),
      ),
    );
  }
}
