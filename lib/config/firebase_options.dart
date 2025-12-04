import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // You can add logic here for Android/iOS if you ever expand
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAIOOgIQdXQ8w2J278PJum40SGrFvhHM6c",
  authDomain: "union-shop-3d338.firebaseapp.com",
  projectId: "union-shop-3d338",
  storageBucket: "union-shop-3d338.firebasestorage.app",
  messagingSenderId: "1060566522536",
  appId: "1:1060566522536:web:f06f03ae29e8f751ce009d"
  );
}