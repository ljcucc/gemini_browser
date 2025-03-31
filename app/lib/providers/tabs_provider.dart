import 'package:flutter/foundation.dart';
import 'package:gemini_browser/providers/gemini_connection_provider.dart';

class TabsProvider extends ChangeNotifier {
  GeminiConnectionProvider? _currentTab;
  List<GeminiConnectionProvider> tabs = [];

  GeminiConnectionProvider get currentTab {
    return _currentTab!;
  }

  setCurrentTab(index) {
    _currentTab = tabs[index];
    notifyListeners();
  }
}
