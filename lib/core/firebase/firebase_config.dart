import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

class FirebaseConfig {
  static bool _initialized = false;

  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      // setPersistenceEnabled is not supported on web
      if (!kIsWeb) {
        FirebaseDatabase.instance.setPersistenceEnabled(true);
      }
      _initialized = true;
    } catch (e) {
      if (kDebugMode) debugPrint('[FirebaseConfig] init failed: $e');
      // Firebase is only used for real-time collaboration.
      // App continues without it if initialization fails.
    }
  }

  static bool get isAvailable => _initialized;

  static DatabaseReference get dbRoot => FirebaseDatabase.instance.ref();
}
