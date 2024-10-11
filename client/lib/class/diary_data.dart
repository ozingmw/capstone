import 'package:flutter/material.dart';

class DiaryData1 with ChangeNotifier {
  String _diaryText = '';
  String _feelingText = '';
  Color? _feelingColor;
  int _pagenum = 1;

  String get diaryText => _diaryText;
  String get feelingText => _feelingText;
  int get pagenum => _pagenum;
  Color? get feelingColor => _feelingColor;

  void updateDiaryText(String text) {
    _diaryText = text;
    notifyListeners();
  }

  void updatePageNum(int num) {
    _pagenum = num;
    notifyListeners();
  }

  void updateFeeling(Color color) {
    _feelingColor = color;
    notifyListeners();
  }

  void updatefeelingText(String feelingText) {
    _feelingText = feelingText;
    notifyListeners();
  }
}
