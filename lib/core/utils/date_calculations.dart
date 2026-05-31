class DateCalculations {
  const DateCalculations._();

  static DateTime addMonths(DateTime date, int months) {
    final targetMonthIndex = date.month - 1 + months;
    // Use floor division for the year so negative month offsets are handled
    // correctly. Dart's `~/` truncates toward zero while `%` returns a
    // non-negative remainder, so for a negative `targetMonthIndex` the two
    // disagree and the year ends up one too high (e.g. -25 months).
    final targetYear = date.year + (targetMonthIndex / 12).floor();
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
