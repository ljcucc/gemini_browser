import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gemini_browser/gemini/gemini_browser_view.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:gemini_browser/gemini/gemtext/gemtext_disp_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GeminiConnectionProvider()),
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
  ColorScheme? customColorScheme;
  @override
  void initState() {
    super.initState();

    _urlInput.text = "gemini://geminispace.info/search?uxn";
  }

  TextEditingController _urlInput = TextEditingController(text: "");

  _sendGeminiRequest() async {
    print("openning request");
    final gcp = Provider.of<GeminiConnectionProvider>(context, listen: false);
    final connection = gcp.connection;
    final text = _urlInput.text;
    var url = (text.contains(" ") || !text.contains("."))
        ? connection.searchResolve(text)
        : connection.resolve(text);

    await gcp.stream(url);

    final customColor =
        gcp.connection.uri.host.toString().hashCode & 0xFFFFFFFF;

    setState(() {
      customColorScheme = ColorScheme.fromSeed(
        brightness: MediaQuery.of(context).platformBrightness,
        seedColor: Color(customColor),
      );
    });

    print("color changed");
  }

  @override
  Widget build(BuildContext context) {
    final moreMenu = PopupMenuButton(itemBuilder: (_) => []);
    final gcp = Provider.of<GeminiConnectionProvider>(context);
    final colorScheme = customColorScheme ?? Theme.of(context).colorScheme;

    return Theme(
      data: ThemeData(
        colorScheme: colorScheme,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            onPressed: () {
              gcp.pop();
            },
            icon: Icon(Icons.arrow_back),
            padding: EdgeInsets.all(8),
          ),
          title: Consumer<GeminiConnectionProvider>(builder: (context, gcp, _) {
            _urlInput.text = gcp.connection.uri.toString();
            return TextField(
              // textAlign: TextAlign.center,
              controller: _urlInput,
              decoration: InputDecoration(border: InputBorder.none),
              onSubmitted: (_) => _sendGeminiRequest(),
            );
          }),
          actions: [
            IconButton(
              onPressed: _sendGeminiRequest,
              icon: const Icon(Icons.search_rounded),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Divider(
              height: 1,
              endIndent: 0,
              indent: 0,
              color: Theme.of(context).colorScheme.outline,
            ),
            Expanded(
              child: GeminiBrowserView(),
            ),
          ],
        ),
      ),
    );
  }
}
