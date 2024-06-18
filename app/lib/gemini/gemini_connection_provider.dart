import 'package:flutter/material.dart';
import 'package:gemini_browser/gemini/gemini_connection.dart';

class GeminiConnectionProvider extends ChangeNotifier {
  /// The connecting state of this connection provider
  bool connecting = false;

  /// History stack of this connection provider
  List<Uri> history = [];

  GeminiConnection connection = GeminiConnection();

  /// Make a connection to a gemini site.
  Future<void> push(Uri url) async {
    connecting = true;
    notifyListeners();

    await connection.connect(url);
    history.add(url);

    connecting = false;
    notifyListeners();
  }

  Future<void> pop() async {
    connecting = true;
    notifyListeners();

    history.removeAt(history.length - 1);
    final url = history.last;
    await connection.connect(url);

    connecting = false;
    notifyListeners();
  }

  Future<void> stream(Uri url) async {
    connecting = true;
    notifyListeners();

    history.add(url);
    await for (final _ in connection.connectStream(url)) {
      notifyListeners();
    }

    connecting = false;
    notifyListeners();
  }
}
