import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Setting FCM
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //Foreground State. - App running.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: ${message.notification}");
      print('Message data: ${message.data}');
      //TODO: (Not have notification) Create local notification.
      if (message.notification != null) {
        print('Show local notification');
      }
    });

    //Background State. - App run background(hide on screen).
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.notification != null) {
        //TODO something.
        print("onMessageOpenedApp: ${message.notification}");
        print('Message data: ${message.data}');
      }
    });

    //Terminated State.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("REMOTE MESSAGE $message");
  await Firebase.initializeApp();
  //TODO something.
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test FCM Firebase'),
      ),
      body: const Center(
        child: Text('Hello world'),
      ),
    );
  }
}
