class DateCalculations {
  const DateCalculations._();

  static DateTime addMonths(DateTime date, int months) {
    final targetMonthIndex = date.month - 1 + months;
    final targetYear = date.year + targetMonthIndex ~/ 12;
    final targetMonth = targetMonthIndex % 12 + 1;
    final lastTargetDay = DateTime(targetYear, targetMonth + 1, 0).day;
    final targetDay = date.day > lastTargetDay ? lastTargetDay : date.day;

    return DateTime(
      targetYear,
      targetMonth,
      targetDay,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  static int calendarDaysUntil(DateTime target, DateTime now) {
    final targetDate = DateTime(target.year, target.month, target.day);
    final nowDate = DateTime(now.year, now.month, now.day);
    return targetDate.difference(nowDate).inDays;
  }
}
