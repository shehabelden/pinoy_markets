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
    apiKey: 'AIzaSyAmn0UaxyC6ruLEGXzlvSq_7xooIRpkAWU',
    appId: '1:903204708278:web:ee615dfa75addfbe046b17',
    messagingSenderId: '903204708278',
    projectId: 'speed-jet-b0326',
    authDomain: 'speed-jet-b0326.firebaseapp.com',
    storageBucket: 'speed-jet-b0326.appspot.com',
    measurementId: 'G-3WPL73D2VW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBYrpgl9zzebqxYPm1NJQiCNYLI1-9OC4',
    appId: '1:903204708278:android:3faec49a2a385967046b17',
    messagingSenderId: '903204708278',
    projectId: 'speed-jet-b0326',
    storageBucket: 'speed-jet-b0326.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCEorTsIe-SAp5rdPzfKCIFA4WFKogvqpU',
    appId: '1:903204708278:ios:d8ae93dfb40e3009046b17',
    messagingSenderId: '903204708278',
    projectId: 'speed-jet-b0326',
    storageBucket: 'speed-jet-b0326.appspot.com',
    iosClientId: '903204708278-tfuvkvsc9mjsdda818fpt2bspl5c8gec.apps.googleusercontent.com',
    iosBundleId: 'com.example.morgancopy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCEorTsIe-SAp5rdPzfKCIFA4WFKogvqpU',
    appId: '1:903204708278:ios:802d3107d4134435046b17',
    messagingSenderId: '903204708278',
    projectId: 'speed-jet-b0326',
    storageBucket: 'speed-jet-b0326.appspot.com',
    iosClientId: '903204708278-9idmg78bb0oetej0ib8qdvgtd8h3ioiq.apps.googleusercontent.com',
    iosBundleId: 'com.example.morgancopy.RunnerTests',
  );
}
