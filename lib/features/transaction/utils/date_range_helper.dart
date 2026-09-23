import 'package:flutter/material.dart';

class DateRangeHelper {


  static DateTimeRange getTodayRange(){
    final  now = DateTime.now();
    return DateTimeRange(
        start: DateTime(now.year, now.month, now.day),
        end: DateTime(now.year, now.month, now.day + 1));
  }



  static DateTimeRange getThisWeekRange() {
    final  now = DateTime.now();
    final weekStart = DateTime(
      now.year,
      now.month,
      now.day - (now.weekday - 1),
    );

    return DateTimeRange(
      start: weekStart,
      end: weekStart.add(const Duration(days: 7)),
    );
  }


  static DateTimeRange getThisMonthRange() {
    final  now = DateTime.now();
    return DateTimeRange(
      start: DateTime(now.year, now.month),
      end: DateTime(now.year, now.month + 1),
    );
  }

}