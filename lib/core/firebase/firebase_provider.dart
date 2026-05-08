import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_config.dart';

final databaseProvider = Provider<FirebaseDatabase>((ref) {
  return FirebaseDatabase.instance;
});

final databaseRootProvider = Provider<DatabaseReference>((ref) {
  return FirebaseConfig.dbRoot;
});
