import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:things_app/controllers/notification_controller.dart';
import 'package:things_app/models/reminder.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/providers/category_provider.dart';
import 'package:things_app/providers/filter_provider.dart';
import 'package:things_app/providers/location_provider.dart';
import 'package:things_app/providers/note_provider.dart';
import 'package:things_app/providers/reminder_provider.dart';
import 'package:things_app/providers/search_provider.dart';
import 'package:things_app/providers/thing_provider.dart';
import 'package:things_app/providers/thing_reminder_provider.dart';
import 'package:things_app/screens/things_screen.dart';
import 'package:app_links/app_links.dart';

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
      ChangeNotifierProvider(create: (context) => ThingProvider()),
      ChangeNotifierProvider(create: (context) => ReminderProvider()),
      ChangeNotifierProvider(create: (context) => SearchProvider()),
      ChangeNotifierProvider(create: (context) => FilterProvider()),
      ChangeNotifierProvider(create: (context) => NotesProvider()),
      ChangeNotifierProvider(create: (context) => CategoryProvider()),
      ChangeNotifierProvider(create: (context) => LocationProvider()),
      ChangeNotifierProvider(create: (context) => ThingReminderProvider())
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
  // ignore: unused_field
  late StreamSubscription<String?> _sub;

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
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    // Initialize AppLinks
    final appLinks = AppLinks();

    // Get initial link when the app is started
    final initialLink = await appLinks.getInitialLink();
    if (initialLink != null) {
      String? data = initialLink.queryParameters['data'];
      if (data != null) {
        _handleLink(data);
      }
    }

    // Listen to incoming links
    appLinks.uriLinkStream.listen((uri) {
        String? data = uri.queryParameters['data'];
        if (data != null) {
          _handleLink(data);
        }
    });
  }

  void _handleLink(String data) {
    String decodedJson = Uri.decodeComponent(data);
    Map<String, dynamic> jsonMap = jsonDecode(decodedJson);
    Thing thing = Thing.fromJson(jsonMap['thing']);

    List<Reminder> reminders = [];
    for (Map<String, dynamic> reminderMap in jsonMap['reminders']) {
      Reminder reminder = Reminder.fromJson(reminderMap);
      reminders.add(reminder);
    }

    Provider.of<ThingProvider>(context, listen: false).setThingFromLink(thing);
    Provider.of<ReminderProvider>(context, listen: false)
        .setRemindersFromLink(reminders);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Things + Reminders',
      theme: ThemeData(
        colorScheme: kColorScheme,
        //textTheme: GoogleFonts.robotoCondensedTextTheme(),
        scaffoldBackgroundColor: kColorScheme.onPrimaryContainer,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      //routerConfig: router,
      home: const ThingsScreen(),
    );
  }
}

final router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) {
      return const ThingsScreen();
    },
  ),
  GoRoute(
    path: 'sharedLink',
    builder: (context, state) {
      //TODO: need to handle link
      //TODO: will need to change some things in android
      return const ThingsScreen();
    },
  )
]);
