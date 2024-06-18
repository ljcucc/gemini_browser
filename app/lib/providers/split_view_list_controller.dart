import 'package:flutter/material.dart';
import 'package:gemini_browser/providers/split_view_controller.dart';

/// A controller for SplitBrowserView
class SplitViewListController extends ChangeNotifier {
  List<SplitViewController> splitedView = [];

  SplitViewListController() {
    // generate default layout for testing usage
    splitedView = [
      for (int i = 0; i < 2; i++) SplitViewController(),
    ];
  }

  /// Close a split view with index
  void close(SplitViewController controller) {
    if (splitedView.length == 1) return;

    splitedView.remove(controller);
    notifyListeners();
  }

  void newSplit() {
    splitedView.add(SplitViewController());
    notifyListeners();
  }
}
