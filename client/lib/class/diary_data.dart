import 'package:flutter/material.dart';

class DiaryData1 with ChangeNotifier {
  String _diaryText = '';
  String _feelingText = '';
  DateTime? _toCreateDiray;
  String _date = '';
  String _daytime = '';
  Color? _feelingColor;
  int _pagenum = 1;

  String get diaryText => _diaryText;
  String get feelingText => _feelingText;
  DateTime? get toCreateDiray => _toCreateDiray;
  String get date => _date;
  String get daytime => _daytime;
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

  void updatetoCreateDiray(DateTime? toCreateDiray) {
    _toCreateDiray = toCreateDiray;
    notifyListeners();
  }

  void updatedate(String date) {
    _date = date;
    notifyListeners();
  }

  void updatedaytime(String date) {
    _daytime = date;
    notifyListeners();
  }

  void reset() {
    _diaryText = '';
    _feelingText = '';
    _toCreateDiray = null;
    _date = '';
    _daytime = '';
    _feelingColor = null;
    _pagenum = 1;

    notifyListeners(); // 상태 변경 알림
  }

}
