import 'package:periodt/core/converters/date_only.dart';
import 'package:test/test.dart';

void main() {
  const converter = DateOnlyConverter();

  group('DateOnlyConverter.toSql', () {
    test('formats date as YYYY-MM-DD', () {
      final date = DateTime(2026, 4, 13);

      final result = converter.toSql(date);

      expect(result, '2026-04-13');
    });

    test('strips time component', () {
      final date = DateTime(2026, 4, 13, 15, 42, 10);

      final result = converter.toSql(date);

      expect(result, '2026-04-13');
    });

    test('pads month and day correctly', () {
      final date = DateTime(2026, 1, 5);

      final result = converter.toSql(date);

      expect(result, '2026-01-05');
    });
  });

  group('DateOnlyConverter.fromSql', () {
    test('parses YYYY-MM-DD correctly', () {
      final result = converter.fromSql('2026-04-13');

      expect(result.year, 2026);
      expect(result.month, 4);
      expect(result.day, 13);
    });

    test('returns date at midnight', () {
      final result = converter.fromSql('2026-04-13');

      expect(result.hour, 0);
      expect(result.minute, 0);
      expect(result.second, 0);
    });

    test('strips time if present in ISO string', () {
      final result = converter.fromSql('2026-04-13T15:30:00Z');

      expect(result.year, 2026);
      expect(result.month, 4);
      expect(result.day, 13);
      expect(result.hour, 0);
    });
  });

  group('round trip', () {
    test('date -> sql -> date is stable', () {
      final original = DateTime(2026, 4, 13, 23, 59, 59);

      final sql = converter.toSql(original);
      final result = converter.fromSql(sql);

      expect(result, DateTime(2026, 4, 13));
    });

    test('multiple round trips stay consistent', () {
      var date = DateTime(2026, 12, 31, 23, 59);

      for (int i = 0; i < 5; i++) {
        final sql = converter.toSql(date);
        date = converter.fromSql(sql);
      }

      expect(date, DateTime(2026, 12, 31));
    });
  });

  group('edge cases', () {
    test('handles leap year', () {
      final result = converter.fromSql('2024-02-29');

      expect(result.year, 2024);
      expect(result.month, 2);
      expect(result.day, 29);
    });

    test('end of year boundary', () {
      final result = converter.fromSql('2026-12-31');

      expect(result.year, 2026);
      expect(result.month, 12);
      expect(result.day, 31);
    });

    test('does not shift date due to timezone', () {
      final result = converter.fromSql('2026-04-13T23:00:00Z');

      // Should NOT become 14th
      expect(result, DateTime(2026, 4, 13));
    });
  });
}
