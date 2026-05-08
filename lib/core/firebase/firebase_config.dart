import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

class FirebaseConfig {
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  static DatabaseReference get dbRoot => FirebaseDatabase.instance.ref();
}
