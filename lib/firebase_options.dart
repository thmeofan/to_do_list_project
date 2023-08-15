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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2M72xegZZVWFalu0KF3GeG3QnHdC_3Oo',
    appId: '1:743036017136:android:2987bcc3a7d22da9cce535',
    messagingSenderId: '743036017136',
    projectId: 'todolistproject-ef74a',
    databaseURL: 'https://todolistproject-ef74a-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'todolistproject-ef74a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBpQIl9JWe89gz6CyEM7LN02KpvX22t8N4',
    appId: '1:743036017136:ios:9acb96687fc8dd50cce535',
    messagingSenderId: '743036017136',
    projectId: 'todolistproject-ef74a',
    databaseURL: 'https://todolistproject-ef74a-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'todolistproject-ef74a.appspot.com',
    iosClientId: '743036017136-un83dsjjd892cru798b18ctrvslvge5h.apps.googleusercontent.com',
    iosBundleId: 'com.example.toDoListProject',
  );
}
