/// Day-of-week picking for the warm messages.
/// Every warm-message list has 7 lines: index 0 = Monday ... 6 = Sunday.
library;

/// 0 = Monday ... 6 = Sunday, wrapped to the list length.
/// [offset] moves on to the next line for moments that fire more than once a day
/// (beyond, care_30k): pass how many of that moment already fired today.
int weekdayIndex(DateTime day, int length, {int offset = 0}) =>
    length <= 0 ? 0 : (day.weekday - 1 + offset) % length;
