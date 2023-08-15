import 'dart:convert';
import 'dart:core';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../firebase_options.dart';

//@pragma('vm:entry-point')

class NotificationService {
  Future<void> backgroundMassageHandler(RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }

  Future<void> sendPush() async {
    Map<String, String> getHeaders() {
      return {
        'Content-Type': 'application/json',
        "Authorization":
            'key=AAAArQBl2fA:APA91bHW4h6CnOYtOlJNl6lWmWTUWlFc8XXvDHB7bKwLutnr_mPPNpX-cygj04R_HD9WS4lpSm_t7WckiXtggM5AnF0DENNJwdRX6GkBRlwGngu-EGl2H4k0EJ3_Hr3JY3PM8cgkfmDo'
      };
    }

    Map<String, dynamic> body = {
      "to": "/topics/newTaskNotification",
      "priority": "high",
      "data": {
        "title": "New task was made",
        "message": "Make sure to complete it"
      }
    };
    print(
        '---------------------------------------------------------------------------');
    await http
        .post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
            headers: getHeaders(), body: jsonEncode(body))
        .catchError((err) => print("push"));
    print(
        '---------------------------------------------------------------------------');
  }

  final _messageStreamController = BehaviorSubject<RemoteMessage>();
  String _lastMessage = "";

  Future<void> foregroundMessage() async {
    _messageStreamController.listen((message) {
      if (message.notification != null) {
        _lastMessage = 'Received a notification message:'
            '\nTitle=${message.notification?.title},'
            '\nBody=${message.notification?.body},'
            '\nData=${message.data}';
      } else {
        _lastMessage = 'Received a data message: ${message.data}';
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }
      _messageStreamController.sink.add(message);
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
    });
  }
}
