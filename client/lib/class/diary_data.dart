import 'package:flutter/material.dart';

class DiaryData1 with ChangeNotifier {
  String _diaryText = '';
  int _pagenum = 1;

  String get diaryText => _diaryText;
  int get pagenum => _pagenum;

  void updateDiaryText(String text) {
    _diaryText = text;
    notifyListeners();
  }

  void updatePageNum(int num) {
    _pagenum = num;
    notifyListeners();
  }
}
