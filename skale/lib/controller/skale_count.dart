import 'package:flutter/material.dart';

class SkaleCountController extends ChangeNotifier {
  double count = 0;

  void increment(bool notifier) {
    count = double.parse((count + 0.01).toStringAsFixed(2));
    if(notifier) {
      notifyListeners();
    }
  }

  void justNotifier() {
    notifyListeners();
  }
}
