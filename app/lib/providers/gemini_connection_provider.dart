import 'package:flutter/material.dart';
import 'package:gemini_browser/widgets/prompt/prompt_message.dart';
import 'package:gemini_connect/gemini_connection.dart';
import 'package:gemtext/parser.dart';
import 'package:url_launcher/url_launcher.dart';

class BrowserContext extends GeminiConnection {
  late GeminiConnection connection;
  PromptMessage? prompt;
  List? _parsed;

  BrowserContext();

  List get parsed {
    _parsed ??= GemtextParser(body).parsed;
    return _parsed!;
  }
}

class GeminiConnectionProvider extends ChangeNotifier {
  /// The connecting state of this connection provider
  bool connecting = false;

  /// History stack of this connection provider
  late List<BrowserContext> history = [BrowserContext()];

  BrowserContext get connection => history.last;

  /// Make a connection to a gemini site.
  Future<void> push(Uri url) async {
    connecting = true;
    notifyListeners();

    // push history
    final context = BrowserContext();
    try {
      await context.connect(url);

      if (context.header?.status == 10) {
        connection.prompt = PromptMessage(
          title: context.header?.meta ?? "",
          destination: context.uri,
        );
      } else {
        history.add(context);
      }
      print("page loaded");
    } catch (e) {
      if (e is UrlException) {
        launchUrl(url);
      } else {
        throw e;
      }
    } finally {
      connecting = false;
      notifyListeners();
    }
  }

  Future<void> pop() async {
    connecting = true;
    notifyListeners();

    history.removeAt(history.length - 1);

    connecting = false;
    notifyListeners();
  }

  Future<void> stream(Uri url) async {
    connecting = true;
    notifyListeners();

    final context = BrowserContext();
    history.add(context);

    await for (final _ in context.connection.connectStream(url)) {
      notifyListeners();
    }

    connecting = false;
    notifyListeners();
  }
}
