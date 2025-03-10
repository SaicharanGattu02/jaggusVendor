import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodbank_marchantise_app/widgets/authentication.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'controllers/global-controller.dart';
import 'controllers/settings-controller.dart';
import 'translation/language.dart';
import 'firebase_options.dart';

final box = GetStorage();
dynamic langValue = const Locale('en', null);

const AndroidNotificationChannel channelAudio = AndroidNotificationChannel(
  'wave_remote_notifications_priority', // id
  'Wave messages and updates on priority', // title
  description: 'Primary channel for notifications and messages in wave app',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('jaggus_tone'), // No extension
);

final AudioPlayer audioPlayer = AudioPlayer();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (Platform.isAndroid) {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      print("Androidfbstoken:{$token} ");
    });
  } else {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      print("IOSfbstoken:{$token}");
    });
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: false,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: false,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channelAudio);

  const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings());

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
    },
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    print("🔔 Background/Killed Notification Received!");
    print("🔹 Title: ${message.notification?.title}");
    print("🔹 Body: ${message.notification?.body}");
    print("🔹 Data: ${message.data}");
    print("🔹 Full Payload: ${message.toMap()}");
    if (notification != null && android != null) {
      print('A new message received title: ${notification.title}');
      print('A new message received body: ${notification.body}');
      print('RemoteMessage data: ${message.data.toString()}');

      showNotification(notification, android, message.data);
    }

  });

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen((message) {

  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FlutterError.onError = (FlutterErrorDetails details) {
    // Log the error details to a logging service or print them
    print("Errrrrrrrrrr:${details.exceptionAsString()}");
    // Optionally report the error to a remote server
  };

  await GetStorage.init();
  Get.put(SettingsController()).onInit();
  if (box.read('languageCode') != null) {
    langValue = Locale(box.read('languageCode'), null);
  } else {
    langValue = const Locale('en', null);
  }
  runApp(FoodEx());
}

// Function to display local notifications
void showNotification(RemoteNotification notification,
    AndroidNotification android, Map<String, dynamic> data) async {
  await audioPlayer.play(AssetSource('sounds/jaggus_tone.mp3')); // Corrected line
  AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'jaggus_channel_id',
    'jaggus_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    playSound: false,
    icon: '@mipmap/ic_launcher',
  );
  NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    platformChannelSpecifics,
    payload: jsonEncode(data), // Convert payload data to String
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Background/Killed Notification Received!");
  print("🔹 Title: ${message.notification?.title}");
  print("🔹 Body: ${message.notification?.body}");
  print("🔹 Data: ${message.data}");
  print("🔹 Full Payload: ${message.toMap()}");
  print("Handling background message: ${message.messageId}");

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    print('Background/Killed Message received: ${notification.title}');

    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'wave_remote_notifications_priority', // Ensure it matches the channel ID
      'Wave messages and updates on priority',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('jaggus_tone'),
      icon: '@mipmap/ic_launcher',
    );

    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
    );
  }
}

class FoodEx extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Get.put(GlobalController()).onInit();
    return OverlaySupport(
      child: GetMaterialApp(
        locale: langValue,
        translations: Languages(),
        debugShowCheckedModeBanner: false,
        title: "Jaggu's Vendor",
        theme: ThemeData(useMaterial3: false),
        home: Authentication(),
      ),
    );
  }
}
