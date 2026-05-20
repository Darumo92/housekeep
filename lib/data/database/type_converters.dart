import 'package:drift/drift.dart';

class DateTimeMillisecondsConverter extends TypeConverter<DateTime, int> {
  const DateTimeMillisecondsConverter();

  @override
  DateTime fromSql(int fromDb) {
    return DateTime.fromMillisecondsSinceEpoch(fromDb);
  }

  @override
  int toSql(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}
