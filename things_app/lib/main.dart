import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:things_app/screens/things_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

  // This widget is the root of your application.
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