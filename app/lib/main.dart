import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gemini_browser/pages/main_browser/main_browser.dart';
import 'package:provider/provider.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!(Platform.isIOS || Platform.isAndroid)) {
    // await windowManager.ensureInitialized();
    // windowManager.setTitle("");
  }

  // make navigation bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarBrightness: Brightness.light, // Dark text for status bar
    ),
  );
  // make flutter draw behind navigation bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (!(Platform.isIOS || Platform.isAndroid)) {
      // windowManager.setTitle("New page");
    }
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      final brightness = MediaQuery.of(context).platformBrightness;
      var color = darkDynamic?.primary ?? Color.fromARGB(255, 170, 223, 35);
      var colorScheme = ColorScheme.fromSeed(
        seedColor: color,
        brightness: brightness,
      );

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: colorScheme,
          useMaterial3: true,
        ),
        home: const MainBrowserLayout(),
      );
    });
  }
}
