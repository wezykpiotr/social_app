// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA-aLXY0tfjZZfVFJcQRbk-O29eVQsqQwY',
    appId: '1:756742385073:web:61ed4bf968943ca98d6190',
    messagingSenderId: '756742385073',
    projectId: 'social-app-chatt',
    authDomain: 'social-app-chatt.firebaseapp.com',
    storageBucket: 'social-app-chatt.firebasestorage.app',
    measurementId: 'G-FLQHHY7S14',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBS-97-Oxw8tuV_k4gAFS74iCpFl9E96J4',
    appId: '1:756742385073:android:8b11b304d16dd3b28d6190',
    messagingSenderId: '756742385073',
    projectId: 'social-app-chatt',
    storageBucket: 'social-app-chatt.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDE58lavDbaz7IulZ7682GFo7L6jA2JhQ4',
    appId: '1:756742385073:ios:3aee2b702b318e9d8d6190',
    messagingSenderId: '756742385073',
    projectId: 'social-app-chatt',
    storageBucket: 'social-app-chatt.firebasestorage.app',
    iosBundleId: 'com.piotrwezyk.socialApp',
  );
}
