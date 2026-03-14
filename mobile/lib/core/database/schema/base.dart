import 'package:drift/drift.dart';

// a base for all tables in periodt's database
//
// TODO: make `updatedAt` update automatically
//
mixin TableBase on Table {
  late final createdAt = dateTime().withDefault(currentDateAndTime)();

  late final updatedAt = dateTime().nullable()();
}
