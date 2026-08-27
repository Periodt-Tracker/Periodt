import 'package:drift/drift.dart';

mixin TableBase on Table {
  late final createdAt = dateTime()
      .named('created_at')
      .withDefault(currentDateAndTime)();

  late final updatedAt = dateTime().named('updated_at').nullable();
}
