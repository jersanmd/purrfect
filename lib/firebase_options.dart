// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyDFIA6ic8kakrU5h95UrPe2GMXyCca00ck',
    appId: '1:290911973040:web:21ade239df2295c49fd575',
    messagingSenderId: '290911973040',
    projectId: 'db-petmanagement-balago',
    authDomain: 'db-petmanagement-balago.firebaseapp.com',
    storageBucket: 'db-petmanagement-balago.appspot.com',
    measurementId: 'G-H9L03PEEZG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDsypy5YKUOCEdnuSlMQ2PznOYXIORXEnc',
    appId: '1:290911973040:android:1cf03c11745c963e9fd575',
    messagingSenderId: '290911973040',
    projectId: 'db-petmanagement-balago',
    storageBucket: 'db-petmanagement-balago.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjBpHA3P4YE3WW-BgCFOjZyX2jaYXonoQ',
    appId: '1:290911973040:ios:9dca160ad8391e8b9fd575',
    messagingSenderId: '290911973040',
    projectId: 'db-petmanagement-balago',
    storageBucket: 'db-petmanagement-balago.appspot.com',
    iosClientId: '290911973040-g10pmtdvkduu0frgf8rcb2u2o7di21q4.apps.googleusercontent.com',
    iosBundleId: 'com.example.purrfect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDjBpHA3P4YE3WW-BgCFOjZyX2jaYXonoQ',
    appId: '1:290911973040:ios:9dca160ad8391e8b9fd575',
    messagingSenderId: '290911973040',
    projectId: 'db-petmanagement-balago',
    storageBucket: 'db-petmanagement-balago.appspot.com',
    iosClientId: '290911973040-g10pmtdvkduu0frgf8rcb2u2o7di21q4.apps.googleusercontent.com',
    iosBundleId: 'com.example.purrfect',
  );
}