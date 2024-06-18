import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class TabListController extends ChangeNotifier {
  List<String> tabs = [];
  int _index = 0;

  TabListController() {
    for (int i = 0; i < 10; i++) {
      tabs.add(
        faker.lorem.sentence(),
      );
    }
  }

  int get index => _index;
  set index(int value) {
    _index = value;
    notifyListeners();
  }
}
