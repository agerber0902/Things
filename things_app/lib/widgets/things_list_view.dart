import 'package:flutter/material.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/widgets/thing_view.dart';

class ThingsListView extends StatelessWidget {
  const ThingsListView({
    super.key,
    required this.things,
  });

  final List<Thing> things;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: things.length,
        itemBuilder: (ctx, index) {
          return ThingView(thing: things[index]);
        });
  }
}