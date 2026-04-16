import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:periodt/core/database/database.dart';
import 'package:periodt/core/database/services/period.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  return AppDatabase();
}

final periodsProvider = StreamProvider<List<Period>>((ref) {
  final database = ref.watch(databaseProvider);

  return database.watchPeriods();
});
