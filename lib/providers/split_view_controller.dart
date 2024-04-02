import 'package:flutter/material.dart';
import 'package:gemini_browser/gemini/gemini_connection_provider.dart';

class SplitViewController extends ChangeNotifier {
  late GeminiConnectionProvider connectionProvider;

  SplitViewController() {
    connectionProvider = GeminiConnectionProvider();
  }
}
