import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTitles {
  static FlTitlesData getTitlesData() => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_getEmotionLabel(value.toInt())),
              );
            },
            interval: 1,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1, // Y축 간격 조정
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      );

  static String _getEmotionLabel(int index) {
    switch (index) {
      case 0:
        return '기쁨';
      case 1:
        return '당황';
      case 2:
        return '분노';
      case 3:
        return '불안';
      case 4:
        return '상처';
      case 5:
        return '슬픔';
      default:
        return '';
    }
  }
}
