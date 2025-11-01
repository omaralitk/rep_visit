import 'package:flutter/cupertino.dart';

class BaseProvider extends ChangeNotifier{

  /// For page index in base screen
  int _currentIndex =0;
  int get currentIndex=>_currentIndex;


  setCurrentIndex(int val){
    _currentIndex=val;
    notifyListeners();
  }
}