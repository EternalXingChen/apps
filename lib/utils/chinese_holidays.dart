/// 中国节假日数据
class ChineseHolidays {
  /// 获取指定日期的节假日名称
  static String? getHolidayName(DateTime date) {
    final year = date.year;
    // final month = date.month;
    // final day = date.day;

    // 2024-2026年法定节假日
    final holidays = {
      // 2024年
      2024: {
        '元旦': [DateTime(2024, 1, 1)],
        '春节': [DateTime(2024, 2, 10), DateTime(2024, 2, 11), DateTime(2024, 2, 12), DateTime(2024, 2, 13), DateTime(2024, 2, 14), DateTime(2024, 2, 15), DateTime(2024, 2, 16), DateTime(2024, 2, 17)],
        '清明节': [DateTime(2024, 4, 4), DateTime(2024, 4, 5), DateTime(2024, 4, 6)],
        '劳动节': [DateTime(2024, 5, 1), DateTime(2024, 5, 2), DateTime(2024, 5, 3), DateTime(2024, 5, 4), DateTime(2024, 5, 5)],
        '端午节': [DateTime(2024, 6, 10)],
        '中秋节': [DateTime(2024, 9, 15), DateTime(2024, 9, 16), DateTime(2024, 9, 17)],
        '国庆节': [DateTime(2024, 10, 1), DateTime(2024, 10, 2), DateTime(2024, 10, 3), DateTime(2024, 10, 4), DateTime(2024, 10, 5), DateTime(2024, 10, 6), DateTime(2024, 10, 7)],
      },
      // 2025年
      2025: {
        '元旦': [DateTime(2025, 1, 1)],
        '春节': [DateTime(2025, 1, 28), DateTime(2025, 1, 29), DateTime(2025, 1, 30), DateTime(2025, 1, 31), DateTime(2025, 2, 1), DateTime(2025, 2, 2), DateTime(2025, 2, 3), DateTime(2025, 2, 4)],
        '清明节': [DateTime(2025, 4, 4), DateTime(2025, 4, 5), DateTime(2025, 4, 6)],
        '劳动节': [DateTime(2025, 5, 1), DateTime(2025, 5, 2), DateTime(2025, 5, 3), DateTime(2025, 5, 4), DateTime(2025, 5, 5)],
        '端午节': [DateTime(2025, 5, 31), DateTime(2025, 6, 1), DateTime(2025, 6, 2)],
        '中秋节': [DateTime(2025, 10, 6)],
        '国庆节': [DateTime(2025, 10, 1), DateTime(2025, 10, 2), DateTime(2025, 10, 3), DateTime(2025, 10, 4), DateTime(2025, 10, 5), DateTime(2025, 10, 6), DateTime(2025, 10, 7), DateTime(2025, 10, 8)],
      },
      // 2026年
      2026: {
        '元旦': [DateTime(2026, 1, 1), DateTime(2026, 1, 2), DateTime(2026, 1, 3)],
        '春节': [DateTime(2026, 2, 17), DateTime(2026, 2, 18), DateTime(2026, 2, 19), DateTime(2026, 2, 20), DateTime(2026, 2, 21), DateTime(2026, 2, 22), DateTime(2026, 2, 23)],
        '清明节': [DateTime(2026, 4, 4), DateTime(2026, 4, 5), DateTime(2026, 4, 6)],
        '劳动节': [DateTime(2026, 5, 1), DateTime(2026, 5, 2), DateTime(2026, 5, 3), DateTime(2026, 5, 4), DateTime(2026, 5, 5)],
        '端午节': [DateTime(2026, 6, 19), DateTime(2026, 6, 20), DateTime(2026, 6, 21)],
        '中秋节': [DateTime(2026, 9, 25)],
        '国庆节': [DateTime(2026, 10, 1), DateTime(2026, 10, 2), DateTime(2026, 10, 3), DateTime(2026, 10, 4), DateTime(2026, 10, 5), DateTime(2026, 10, 6), DateTime(2026, 10, 7), DateTime(2026, 10, 8)],
      },
    };

    final yearHolidays = holidays[year];
    if (yearHolidays == null) return null;

    for (final entry in yearHolidays.entries) {
      for (final holidayDate in entry.value) {
        if (holidayDate.year == date.year &&
            holidayDate.month == date.month &&
            holidayDate.day == date.day) {
          return entry.key;
        }
      }
    }

    return null;
  }

  /// 判断是否为节假日
  static bool isHoliday(DateTime date) {
    return getHolidayName(date) != null;
  }

  /// 判断是否为工作日（调休）
  static bool isWorkday(DateTime date) {
    // 调休工作日（周末上班）
    final workdays = {
      // 2024年调休
      DateTime(2024, 2, 4), // 春节调休
      DateTime(2024, 2, 18), // 春节调休
      DateTime(2024, 4, 7), // 清明调休
      DateTime(2024, 4, 28), // 劳动节调休
      DateTime(2024, 5, 11), // 劳动节调休
      DateTime(2024, 9, 14), // 中秋调休
      DateTime(2024, 9, 29), // 国庆调休
      DateTime(2024, 10, 12), // 国庆调休
      // 2025年调休
      DateTime(2025, 1, 26), // 春节调休
      DateTime(2025, 2, 8), // 春节调休
      DateTime(2025, 4, 27), // 劳动节调休
      DateTime(2025, 9, 28), // 国庆调休
      DateTime(2025, 10, 11), // 国庆调休
    };

    return workdays.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  /// 判断是否为周末
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  /// 判断是否为休息日
  static bool isRestDay(DateTime date) {
    // 节假日或周末（非调休）都是休息日
    if (isHoliday(date)) return true;
    if (isWorkday(date)) return false;
    return isWeekend(date);
  }
}
