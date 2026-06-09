import 'package:flutter/cupertino.dart';

class BaseProvider extends ChangeNotifier {
  /// For page index in base screen
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  /// Clear all state (for logout)
  void clearAllState() {
    _currentIndex = 0;

  }
  setCurrentIndex(int val) {
    _currentIndex = val;
    notifyListeners();
  }


}
