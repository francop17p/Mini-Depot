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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDLFXXRSSY7I5PQTpJE3NmARCA2A8nKtF4',
    appId: '1:953537353019:web:590afd4a1e301b5f54d31e',
    messagingSenderId: '953537353019',
    projectId: 'minidepot-552c8',
    authDomain: 'minidepot-552c8.firebaseapp.com',
    storageBucket: 'minidepot-552c8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDig1mPLJprmB3YNOPVNCt4CQAfARfxjYQ',
    appId: '1:953537353019:android:11366211c034111f54d31e',
    messagingSenderId: '953537353019',
    projectId: 'minidepot-552c8',
    storageBucket: 'minidepot-552c8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNYjBH-v-ymcmIpfk1gS6KBjpnV73ZhTQ',
    appId: '1:953537353019:ios:f4b7a05e9eed76f154d31e',
    messagingSenderId: '953537353019',
    projectId: 'minidepot-552c8',
    storageBucket: 'minidepot-552c8.appspot.com',
    iosBundleId: 'com.tuempresa.minidepot',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBNYjBH-v-ymcmIpfk1gS6KBjpnV73ZhTQ',
    appId: '1:953537353019:ios:e63871162f85a72354d31e',
    messagingSenderId: '953537353019',
    projectId: 'minidepot-552c8',
    storageBucket: 'minidepot-552c8.appspot.com',
    iosBundleId: 'com.franco.minidepot',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDLFXXRSSY7I5PQTpJE3NmARCA2A8nKtF4',
    appId: '1:953537353019:web:a46ee53c8b3a57c054d31e',
    messagingSenderId: '953537353019',
    projectId: 'minidepot-552c8',
    authDomain: 'minidepot-552c8.firebaseapp.com',
    storageBucket: 'minidepot-552c8.appspot.com',
  );

}