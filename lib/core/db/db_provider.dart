import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

export 'app_database.dart';

/// Global singleton. Disposed when the ProviderContainer is destroyed.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
