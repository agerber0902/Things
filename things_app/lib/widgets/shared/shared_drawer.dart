import 'package:flutter/material.dart';
import 'package:things_app/screens/reminders_screen.dart';
import 'package:things_app/screens/things_screen.dart';

class SharedDrawer extends StatelessWidget {
  const SharedDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            ListTile(
              title: const Text('Reminders'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const RemindersScreen()));
              },
            ),
            ListTile(
              title: const Text('Things'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return const ThingsScreen();
                }));
              },
            ),
          ],
        ),
      );
  }
}