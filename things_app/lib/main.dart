import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:things_app/controllers/notification_controller.dart';
import 'package:things_app/screens/things_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AwesomeNotifications().initialize(
    null, //change this for icon in notification
    [
      NotificationChannel(
        channelGroupKey: 'things_channel_group',
        channelKey: 'reminders_channel',
        channelName: 'Reminder Notifications',
        channelDescription: 'Reminder Notification channel',
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'things_channel_group',
        channelGroupName: 'Things Group',
      ),
    ],
  );

  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(const MyApp());
}

final ColorScheme kColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.blueGrey);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: kColorScheme,
        textTheme: GoogleFonts.robotoCondensedTextTheme(),
        scaffoldBackgroundColor: kColorScheme.onPrimaryContainer,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      home: const ThingsScreen(),
    );
  }
}
