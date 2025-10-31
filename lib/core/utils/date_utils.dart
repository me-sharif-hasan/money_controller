int getRemainingDaysInMonth(DateTime date) {
  final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
  final remaining = lastDayOfMonth.difference(date).inDays;
  return remaining > 0 ? remaining : 1;
}

int getRemainingDaysWithCustomPeriod(DateTime date, int startDay, int endDay) {
  final currentDay = date.day;

  // Calculate the end date for this period
  DateTime periodEnd;

  if (endDay >= startDay) {
    // Same month period (e.g., 1st to 30th)
    if (currentDay >= startDay && currentDay <= endDay) {
      // Currently in the period
      periodEnd = DateTime(date.year, date.month, endDay);
    } else if (currentDay < startDay) {
      // Before period start, calculate for current period
      periodEnd = DateTime(date.year, date.month, endDay);
    } else {
      // After period end, calculate for next period
      periodEnd = DateTime(date.year, date.month + 1, endDay);
    }
  } else {
    // Period spans two months (e.g., 27th to 26th next month)
    if (currentDay >= startDay) {
      // In current month part of period (e.g., Oct 27-31)
      // Period ends on endDay of next month
      periodEnd = DateTime(date.year, date.month + 1, endDay);
    } else if (currentDay <= endDay) {
      // In next month part of period (e.g., Nov 1-26)
      // Period ends on endDay of current month
      periodEnd = DateTime(date.year, date.month, endDay);
    } else {
      // Between periods (e.g., currentDay > endDay and < startDay)
      // Next period ends on endDay of next month
      periodEnd = DateTime(date.year, date.month + 1, endDay);
    }
  }

  final remaining = periodEnd.difference(date).inDays + 1; // +1 to include today
  return remaining > 0 ? remaining : 1;
}

int getTotalDaysInCustomPeriod(int startDay, int endDay) {
  if (endDay >= startDay) {
    return endDay - startDay + 1;
  } else {
    // Spans two months - approximate as 30 days
    return (30 - startDay + 1) + endDay;
  }
}

int getDaysInMonth(DateTime date) {
  return DateTime(date.year, date.month + 1, 0).day;
}

int getCurrentDayOfMonth(DateTime date) {
  return date.day;
}

DateTime getFirstDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month, 1);
}

DateTime getLastDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month + 1, 0);
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

DateTime parseDate(String dateString) {
  return DateTime.parse(dateString);
}

