import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:things_app/controllers/notification_controller.dart';
import 'package:things_app/providers/category_provider.dart';
import 'package:things_app/providers/notes_provider.dart';
import 'package:things_app/providers/reminders_provider.dart';
import 'package:things_app/providers/thing_reminder_provider.dart';
import 'package:things_app/providers/things_provider.dart';
import 'package:things_app/screens/things_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AwesomeNotifications().initialize(
    null,
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

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThingsProvider()),
      ChangeNotifierProvider(create: (context) => ThingReminderProvider()),
      ChangeNotifierProvider(create: (context) => NotesProvider()),
      ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ChangeNotifierProvider(create: (context) => RemindersProvider())
    ],
    child: const MyApp(),
  ));
}

final ColorScheme kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromRGBO(96, 125, 139, 1));

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

    //call this to set up inital values
    Provider.of<RemindersProvider>(context, listen: false).getReminders();
    Provider.of<ThingsProvider>(context, listen: false).getThings();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
