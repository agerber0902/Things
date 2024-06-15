import 'package:flutter/material.dart';
import 'package:things_app/models/thing.dart';
import 'package:things_app/widgets/things/thing_view.dart';

class ThingsListView extends StatelessWidget {
  const ThingsListView({
    super.key,
    required this.things, required this.deleteThing, required this.addThing, required this.editThing,
  });

  final List<Thing> things;
  final void Function(Thing thing) deleteThing;
  final void Function(Thing thing) addThing;
  final void Function(Thing thing) editThing;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: things.length,
        itemBuilder: (ctx, index) {
          return ThingView(thing: things[index], deleteThing: deleteThing, addThing: addThing, editThing: editThing,);
        });
  }
}