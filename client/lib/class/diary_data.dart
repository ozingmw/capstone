import 'package:flutter/material.dart';

class DiaryData1 with ChangeNotifier {
  String _diaryText = '';
  Icon _feeling = const Icon(Icons.filter_vintage, color: Colors.green, size: 150);
  int _pagenum = 1;

  String get diaryText => _diaryText;
  int get pagenum => _pagenum;
  Icon get feeling => _feeling;

  void updateDiaryText(String text) {
    _diaryText = text;
    notifyListeners();
  }

  void updatePageNum(int num) {
    _pagenum = num;
    notifyListeners();
  }

  void updateFeeling(Icon icon) {
    _feeling = icon;
    notifyListeners();
  }
}
