import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:jeya_engineering/Controllers/auth_controller.dart';
import 'package:jeya_engineering/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'src/app.dart';

const bool USE_EMULATORS = false;
File? excel;
bool isFirsttime = true;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
  RemoteNotification? notification = message.notification;
  // AndroidNotification? android = message.notification?.android;
  if (notification != null) {
    await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: androidNotificationDetails,
        ));
  }
}

AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
  'notification', // id
  'High Importance Notifications', // title
  channelDescription: 'This channel is used for important notifications.',
  icon: '@mipmap/launcher_icon',
  playSound: true,
  importance: Importance.max,
  sound: const RawResourceAndroidNotificationSound('notification'),
  vibrationPattern: Int64List.fromList([0, 1000, 1500, 1000]),

  // other properties...
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // final cron = Cron();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(Auth());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  if (USE_EMULATORS) {
    await _connectToFirestoreEmulators();
  }
  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
    ),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

Future _connectToFirestoreEmulators() async {
  final localHostString = Platform.isAndroid ? '192.168.108.248' : 'localhost';
  FirebaseFirestore.instance.settings = Settings(
      host: '$localHostString:8080',
      sslEnabled: false,
      persistenceEnabled: false);

  await FirebaseAuth.instance.useAuthEmulator('$localHostString', 9099);
  FirebaseFunctions.instance.useFunctionsEmulator('$localHostString', 5001);
  FirebaseFirestore.instance
      .useFirestoreEmulator('$localHostString', 8080, sslEnabled: false);
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
