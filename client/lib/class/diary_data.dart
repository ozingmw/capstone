// diary_data.dart

import 'package:flutter/material.dart';

class DiaryData1 with ChangeNotifier {
  String _diary3Text = '';
  String _diary8Text = '';
  int _pagenum = 1;

  String get diary3Text => _diary3Text;
  String get diary8Text => _diary8Text;
  int get pagenum => _pagenum;

  void updateDiary3Text(String text) {
    _diary3Text = text;
    notifyListeners();
  }

  void updateDiary8Text(String text) {
    _diary8Text = text;
    notifyListeners();
  }

  void updatePageNum(int num) {
    _pagenum = num;
    notifyListeners();
  }
}
