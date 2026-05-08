import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    return desktop;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC3Y61w6V4gX5Ib1bYkinaBSeMneuErAxw',
    authDomain: 'solare-fb5c8.firebaseapp.com',
    databaseURL:
        'https://solare-fb5c8-default-rtdb.asia-southeast1.firebasedatabase.app',
    projectId: 'solare-fb5c8',
    storageBucket: 'solare-fb5c8.firebasestorage.app',
    messagingSenderId: '583260150823',
    appId: '1:583260150823:web:8fe10abf896b98c8e64202',
    measurementId: 'G-997YTM162X',
  );

  // Windows desktop uses the same project, no separate app registration needed
  static const FirebaseOptions desktop = FirebaseOptions(
    apiKey: 'AIzaSyC3Y61w6V4gX5Ib1bYkinaBSeMneuErAxw',
    authDomain: 'solare-fb5c8.firebaseapp.com',
    databaseURL:
        'https://solare-fb5c8-default-rtdb.asia-southeast1.firebasedatabase.app',
    projectId: 'solare-fb5c8',
    storageBucket: 'solare-fb5c8.firebasestorage.app',
    messagingSenderId: '583260150823',
    appId: '1:583260150823:web:8fe10abf896b98c8e64202',
  );
}
