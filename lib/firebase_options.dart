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
    apiKey: 'AIzaSyAFDoJfK_M7UYT6EuPQ9JttuuTzW6NjPJw',
    appId: '1:46712804564:web:4f13f06f0d17b943c41741',
    messagingSenderId: '46712804564',
    projectId: 'fir-4-96e5f',
    authDomain: 'fir-4-96e5f.firebaseapp.com',
    storageBucket: 'fir-4-96e5f.appspot.com',
    measurementId: 'G-G14G4DC5RX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBbXkOrUfM0JXZDKviNvZGweFv07gprJSQ',
    appId: '1:46712804564:android:bb051f7b46531d20c41741',
    messagingSenderId: '46712804564',
    projectId: 'fir-4-96e5f',
    storageBucket: 'fir-4-96e5f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCv9Pz1i5NsrHPT8rB6OmI2Lt8EfITD6aY',
    appId: '1:46712804564:ios:733d0934c07d724bc41741',
    messagingSenderId: '46712804564',
    projectId: 'fir-4-96e5f',
    storageBucket: 'fir-4-96e5f.appspot.com',
    iosBundleId: 'com.example.firebase4',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCv9Pz1i5NsrHPT8rB6OmI2Lt8EfITD6aY',
    appId: '1:46712804564:ios:733d0934c07d724bc41741',
    messagingSenderId: '46712804564',
    projectId: 'fir-4-96e5f',
    storageBucket: 'fir-4-96e5f.appspot.com',
    iosBundleId: 'com.example.firebase4',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAFDoJfK_M7UYT6EuPQ9JttuuTzW6NjPJw',
    appId: '1:46712804564:web:2e2505a719f7c66ac41741',
    messagingSenderId: '46712804564',
    projectId: 'fir-4-96e5f',
    authDomain: 'fir-4-96e5f.firebaseapp.com',
    storageBucket: 'fir-4-96e5f.appspot.com',
    measurementId: 'G-KTZPYPGPEJ',
  );
}