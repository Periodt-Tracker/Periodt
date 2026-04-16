import 'package:drift/drift.dart';

class DateOnlyConverter extends TypeConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromSql(String databaseValue) {
    final date = DateTime.parse(databaseValue);

    // Strip time -> YYYY-MM-DD 00:00:00.000
    return DateTime(date.year, date.month, date.day);
  }

  @override
  String toSql(DateTime value) {
    // Strip time completely -> YYYY-MM-DD
    return _formatDate(value);
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
