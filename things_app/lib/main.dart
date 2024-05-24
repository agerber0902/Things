import 'package:flutter/material.dart';
import 'package:things_app/screens/things_screen.dart';

void main() {
  runApp(const MyApp());
}
final ColorScheme kColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.blueGrey);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: kColorScheme,
        useMaterial3: true,
      ),
      home: const ThingsScreen(),
    );
  }
}